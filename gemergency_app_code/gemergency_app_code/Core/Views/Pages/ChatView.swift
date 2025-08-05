import SwiftUI
import AVKit
import Combine

public struct ChatView: View {
    
    @StateObject private var speechRecognitionController: SpeechRecognitionController = .init()
    
    @EnvironmentObject var llamaState: LlamaState
    
    private static let player = createPlayer()
    
    @State private var userInput: String = ""
    @State private var isMenuExpanded: Bool = false
    @State private var isNearBottom: Bool = false
    
    public var body: some View {
        ZStack {
            if !UIApplication.shared.isCurrentDeviceiPad {
                ChatBackgroundView(player: Self.player)
                    .ignoresSafeArea()
            }
             
            ZStack {
                Rectangle()
                    .fill(.background.opacity(0.5))
                
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .compositingGroup()
            .ignoresSafeArea()
            .onTapGesture {
                hideKeyboard()
                
                if isMenuExpanded {
                    withAnimation(.smooth) {
                        isMenuExpanded = false
                    }
                }
            }
            
            ScrollViewReader { proxy in
                if llamaState.messages.isEmpty {
                    ContentUnavailableView(
                        "Need help?",
                        systemImage: "cross.case.fill",
                        description: Text("If you urgently strive to get help, then start a conversation with Google Gemma 3n using your voice or text!")
                    )
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(llamaState.messages) { message in
                                ChatBubbleSubview(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(.top, UIApplication.shared.isCurrentDeviceiPad ? 24 : 8)
                    }
                    .contentMargins(.top, 50)
                    .contentMargins(.bottom, 180)
                    .scrollIndicators(.hidden)
                    .onChange(of: llamaState.messages.count) { _, _ in
                        withAnimation {
                            proxy.scrollTo(llamaState.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
            .onTapGesture {
                hideKeyboard()
                
                if isMenuExpanded {
                    withAnimation(.smooth) {
                        isMenuExpanded = false
                    }
                }
            }
            
            VStack(spacing: 12) {
                ChatHeaderSubview(isMenuExpanded: $isMenuExpanded)
                    .onTapGesture {
                        hideKeyboard()
                    }
                    .padding(.top, UIApplication.shared.isCurrentDeviceiPad ? 25 : 0)
                
                Spacer(minLength: 0)
                
                if !UIApplication.shared.isCurrentDeviceiPad {
                    ChatInputFieldSubview(userPrompt: $userInput)
                        .padding(.horizontal, 25)
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: UIApplication.shared.isCurrentDeviceiPad ? 0 : 20) {
            HStack(spacing: 10) {
                if UIApplication.shared.isCurrentDeviceiPad {
                    ChatInputFieldSubview(userPrompt: $userInput)
                    
                    Button {
                        HapticsController.shared.handleInteractionFeedback(of: .soft)
                        
                        if speechRecognitionController.isRecording {
                            hideKeyboard()
                            speechRecognitionController.stopRecording()
                            userInput = speechRecognitionController.resultingText
                        } else {
                            hideKeyboard()
                            speechRecognitionController.startRecording()
                        }
                    } label: {
                        Image(systemName: speechRecognitionController.isRecording ? "stop.fill" : "microphone.fill")
                            .font(.title3)
                            .foregroundStyle(speechRecognitionController.isRecording ? Color.black : Color.white)
                            .frame(width: 56, height: 56)
                            .background {
                                if speechRecognitionController.isRecording {
                                    Circle()
                                        .fill(.white)
                                }
                            }
                    }
                    .buttonStyle(SquishyButtonStyle(squishDimensions: 1.3))
                    .disabled(llamaState.isCurrentlyGenerating)
                    
                    Button {
                        HapticsController.shared.handleInteractionFeedback(of: .soft)
                        
                        if llamaState.isCurrentlyGenerating {
                            llamaState.stop()
                        } else {
                            if !userInput.isEmpty {
                                hideKeyboard()
                                
                                if let service = userInput.getDestinationPlace() {
                                    llamaState.routeRequest.send(service)
                                }
                                
                                Task {
                                    await llamaState.complete(text: userInput)
                                    userInput = ""
                                }
                            }
                        }
                    } label: {
                        Image(systemName: llamaState.isCurrentlyGenerating ? "stop.fill" : "location.north.fill")
                            .rotationEffect(.degrees(llamaState.isCurrentlyGenerating ? 180 : 85))
                            .font(.title3)
                            .foregroundStyle(llamaState.isCurrentlyGenerating ? Color.black : Color.white)
                            .frame(width: 56, height: 56)
                            .background {
                                if llamaState.isCurrentlyGenerating {
                                    Circle()
                                        .fill(.white)
                                }
                            }
                    }
                    .buttonStyle(SquishyButtonStyle(squishDimensions: 1.3))
                    .disabled(speechRecognitionController.isRecording)
                } else {
                    Spacer(minLength: 0)
                    
                    Button {
                        HapticsController.shared.handleInteractionFeedback(of: .soft)
                        
                        if speechRecognitionController.isRecording {
                            hideKeyboard()
                            speechRecognitionController.stopRecording()
                            userInput = speechRecognitionController.resultingText
                        } else {
                            hideKeyboard()
                            speechRecognitionController.startRecording()
                        }
                    } label: {
                        Image(systemName: speechRecognitionController.isRecording ? "stop.fill" : "microphone.fill")
                            .font(.title3)
                            .foregroundStyle(speechRecognitionController.isRecording ? Color.black : Color.white)
                            .frame(width: 56, height: 56)
                            .background {
                                if speechRecognitionController.isRecording {
                                    Circle()
                                        .fill(.white)
                                }
                            }
                    }
                    .buttonStyle(SquishyButtonStyle(squishDimensions: 1.3))
                    .disabled(llamaState.isCurrentlyGenerating)
                    
                    Button {
                        HapticsController.shared.handleInteractionFeedback(of: .soft)
                        
                        if llamaState.isCurrentlyGenerating {
                            llamaState.stop()
                        } else {
                            if !userInput.isEmpty {
                                hideKeyboard()
                                
                                if let service = userInput.getDestinationPlace() {
                                    llamaState.routeRequest.send(service)
                                }
                                
                                Task {
                                    await llamaState.complete(text: userInput)
                                    userInput = ""
                                }
                            }
                        }
                    } label: {
                        Image(systemName: llamaState.isCurrentlyGenerating ? "stop.fill" : "location.north.fill")
                            .rotationEffect(.degrees(llamaState.isCurrentlyGenerating ? 180 : 85))
                            .font(.title3)
                            .foregroundStyle(llamaState.isCurrentlyGenerating ? Color.black : Color.white)
                            .frame(width: 56, height: 56)
                            .background {
                                if llamaState.isCurrentlyGenerating {
                                    Circle()
                                        .fill(.white)
                                }
                            }
                    }
                    .buttonStyle(SquishyButtonStyle(squishDimensions: 1.3))
                    .disabled(speechRecognitionController.isRecording)
                }
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 15)
            .background(.clear)
        }
        .overlay {
            if speechRecognitionController.speechRecognitionError {
                ChatAudioRecognitionErrorSubview(speechRecognitionError: $speechRecognitionController.speechRecognitionError)
            }
        }
        .onAppear {
            Self.player.play()
        }
        .onDisappear {
            Self.player.pause()
        }
        .onReceive(speechRecognitionController.$resultingText) { latest in
            if speechRecognitionController.isRecording {
                userInput = latest
            }
        }
    }
}

fileprivate func createPlayer() -> AVPlayer {
    guard let url = Bundle.main.url(forResource: "a", withExtension: "mp4") else {
        fatalError("Video file a.mp4 not found in bundle.")
    }
    
    let player = AVPlayer(url: url)
    player.isMuted = true
    player.actionAtItemEnd = .none
    
    NotificationCenter.default.addObserver(
        forName: .AVPlayerItemDidPlayToEndTime,
        object: player.currentItem,
        queue: .main
    ) { _ in
        player.seek(to: .zero)
        player.play()
    }
    
    return player
}
