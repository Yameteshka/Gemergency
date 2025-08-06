import Foundation
import Speech
import AVFoundation
import Combine

@MainActor
final class SpeechRecognitionController: ObservableObject {
    
    @Published var resultingText: String = ""
    @Published var isRecording: Bool = false
    @Published var authoriationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    @Published var errorMessage: String?
    @Published var speechRecognitionError: Bool = false
    
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer: SFSpeechRecognizer?
    
    init(locale: Locale = .current) {
        self.speechRecognizer = SFSpeechRecognizer(locale: locale)
        requestAuthorization()
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.authoriationStatus = status
                
                if status != .authorized {
                    self?.errorMessage = "[Fatal error]: couldn't get a recognition status!"
                }
            }
        }
    }
    
    func startRecording() {
        guard authoriationStatus == .authorized else {
            speechRecognitionError.toggle()
            print("[Fatal error]: not authorized for speec recognition")
            return
        }
        
        guard
            let recognizer = speechRecognizer,
            recognizer.isAvailable
        else {
            speechRecognitionError.toggle()
            print("[Fatal error]: speech recognizer is not avaialble")
            return
        }
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            speechRecognitionError.toggle()
            print("[Fatal error]: unable to create recognition request")
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            speechRecognitionError.toggle()
            errorMessage = "Audio session setup failed: \(error.localizedDescription)"
            return
        }
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else {
                return
            }
            
            if let result = result {
                self.resultingText = result.bestTranscription.formattedString
            }
            
            if let error = error {
                // speechRecognitionError.toggle()
                self.errorMessage = "Recognition error: \(error.localizedDescription)"
                self.stopRecording()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        do {
            audioEngine.prepare()
            try audioEngine.start()
            isRecording = true
            errorMessage = nil
        } catch {
            speechRecognitionError.toggle()
            errorMessage = "Audio engine couldn't start: \(error.localizedDescription)"
            
        }
    }
    
    func stopRecording() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isRecording = false
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    deinit {
        Task {
            await stopRecording()
        }
    }
}
