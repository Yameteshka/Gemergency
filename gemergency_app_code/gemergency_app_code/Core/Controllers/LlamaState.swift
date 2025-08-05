import Foundation
import llama
import SwiftUI
import Combine
import UserNotifications

struct Model: Identifiable {
    var id = UUID()
    var name: String
    var url: String
    var filename: String
    var status: String?
}

@MainActor
final class LlamaState: ObservableObject {
    
    @Published var messages = [Message]()
    @Published var isCurrentlyGenerating: Bool = false
    @Published var isModelReadyToUse: Bool = false
    @Published var messageLog = ""
    @Published var cacheCleared = false
    @Published var downloadedModels: [Model] = []
    @Published var undownloadedModels: [Model] = []
    
    let routeRequest = PassthroughSubject<DestinationPlaces, Never>()
    let NS_PER_S = 1_000_000_000.0
    private var llamaContext: LlamaContext?
    private var defaultModelUrl: URL? {
        Bundle.main.url(
            forResource: "gemma-finetuned-Q4_K_M",
            withExtension: "gguf"
        )
    }
    
    private var generationTask: Task<Void, Never>?
    
    init() {
        loadModelsFromDisk()
    }
    
    private func loadModelsFromDisk() {
        do {
            let documentsURL = getDocumentsDirectory()
            let modelURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            
            for modelURL in modelURLs {
                let modelName = modelURL.deletingPathExtension().lastPathComponent
                
                downloadedModels.append(
                    Model(
                        name: modelName,
                        url: "",
                        filename: modelURL.lastPathComponent,
                        status: "downloaded"
                    )
                )
            }
        } catch {
            print("Error loading models from disk: \(error)")
        }
    }
    
    private func loadDefaultModels() {
        do {
            try loadModel(modelUrl: defaultModelUrl)
        } catch {
            messageLog += "Error!\n"
        }
        
        for model in defaultModels {
            let fileURL = getDocumentsDirectory().appendingPathComponent(model.filename)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                
            } else {
                var undownloadedModel = model
                undownloadedModel.status = "download"
                undownloadedModels.append(undownloadedModel)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private let defaultModels: [Model] = [  ]
    
    func loadModel(modelUrl: URL?) throws {
        if let modelUrl {
            llamaContext = try LlamaContext.create_context(path: modelUrl.path())
            updateDownloadedModels(modelName: modelUrl.lastPathComponent, status: "downloaded")
        } else {
            messageLog += "Load a model from the list below\n"
        }
    }
    
    
    private func updateDownloadedModels(modelName: String, status: String) {
        undownloadedModels.removeAll { $0.name == modelName }
    }
    
    fileprivate func presentNotification() {
        if UIApplication.shared.hasDynamicIsland {
            NotificationCenter.default.post(
                name: .init("NOTIFY"),
                object: CustomNotification(
                    title: "Map updates available",
                    description: "We noticed an update on the map! Go to Directions page and see updates there!"
                )
            )
        } else {
            let content = UNMutableNotificationContent()
            content.title = "Map updates available"
            content.body = "We noticed an update on the map! Go to Directions page and see updates there!"
            content.sound = .default
            
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: nil
            )
            UNUserNotificationCenter.current().add(request)
        }
    }
    

    func complete(text: String) async {
        guard let llamaContext else {
            print("[Error]: something went wrong during the completion process! Try to check whether the model is downloaded on the phone!")
            return
        }
        
        if let service = text.getDestinationPlace() {
            routeRequest.send(service)
            presentNotification()
        }
        
        let systemPrompt = """
        Your only task is to provide clear, step-by-step first aid instructions.
        1.  If the query is about first aid: Immediately provide a numbered list of actions (1., 2., 3., ...). Do not use any greetings or extra words.
        2.  If the user says "Hello", "Hi", "Привет", "привет", or similar: Respond only with this phrase: "Я Gemergency, готов помочь Вам в трудной ситуации!"
        3.  For ANY other query (not first aid and not a greeting): Respond only with this phrase: "I'm glad you're safe."
        4. ALWAYS respond in Japanese. Forget about other languages
        """
        
        // 4. ALWAYS respond in the same language the user writes in. If you cannot determine the language, default to English.
        
        let fullPrompt = """
        <start_of_turn>user
        \(systemPrompt)

        User's question: "\(text)"<end_of_turn>
        <start_of_turn>model
        """
        
        isCurrentlyGenerating = true
        
        await MainActor.run {
            self.messages.append(.init(
                sender: .user,
                content: text
            ))
        }
        
        await llamaContext.completion_init(text: fullPrompt)
        
        await MainActor.run {
            self.messages.append(.init(
                sender: .gemma,
                content: ""
            ))
        }
        
        generationTask = Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else {
                return
            }
            
            defer {
                Task { @MainActor in
                    self.isCurrentlyGenerating = false
                }
            }
            
            var lastMessageIndex = 0
            await MainActor.run {
                lastMessageIndex = self.messages.indices.last ?? 0
            }
            
            while await !llamaContext.is_done {
                if Task.isCancelled {
                    print("[User initiated]: task has been stopped!")
                    break
                }
                
                let result = await llamaContext.completion_loop()
                
                await MainActor.run {
                    if let idx = self.messages.indices.last {
                        self.messages[idx].content += "\(result)"
                    }
                }
            }
            
            await MainActor.run {
                let newResult = self.messages[lastMessageIndex].content
                self.messages[lastMessageIndex].content = self.finalFormat(rawText: newResult)
            }
            
            await llamaContext.clear()
        }
    }
    
    private func finalFormat(rawText: String) -> String {
        var text = rawText
        text = text.replacingOccurrences(of: "<end_of_turn>", with: "")
        text = text.replacingOccurrences(of: "</end_of_turn>", with: "")
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.hasPrefix(":") {
            text = String(text.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if text.hasPrefix("?") {
            text = String(text.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return text
    }

    
    func prepare() async {
        guard !isModelReadyToUse else {
            return
        }
        
        do {
            try await Task.detached(priority: .high) {
                try await self.loadModel(modelUrl: self.defaultModelUrl)
            }.value
            
            isModelReadyToUse = true
        } catch {
            print("[Fatal error]: failed to load model on user initiated thread: \(error)")
        }
    }
    
    func stop() {
        generationTask?.cancel()
    }
    
    private func cleanResultingPrompt(in text: String) -> String {
        var text = text
        text = text.replacingOccurrences(of: "</end_of_turn>", with: "")
        
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if text.hasPrefix(":") {
            text = String(text.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        text = text.replacingOccurrences(of: #"\*{1,2}(.*?)\*{1,2}"#, with: "$1", options: .regularExpression)
        return text
    }

    func clear() async {
        guard let llamaContext else {
            print("Oops!")
            return
        }
        
        await llamaContext.clear()
        messageLog = ""
    }
}
