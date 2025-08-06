import SwiftUI
import UserNotifications

@main
struct DemoProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var directionsViewModel: DirectionsViewModel = .init()
    @StateObject private var locationController: LocationController = .init()
    @StateObject private var llamaState: LlamaState = .init()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if llamaState.isModelReadyToUse { 
                    RootView()
                        .environmentObject(directionsViewModel)
                        .environmentObject(locationController)
                        .environmentObject(llamaState)
                        .overlay {
                            if UIApplication.shared.hasDynamicIsland {
                                GeometryReader { proxy in
                                    CustomNotificationSubview(size: proxy.size)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                }
                                .ignoresSafeArea()
                            }
                        }
                } else {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(.black.opacity(0.467))
                        
                        VStack(spacing: 16) {
                            ProgressView()
                            
                            Text("Preparing Google Gemma 3n for use...")
                                .font(.callout)
                                .foregroundStyle(Color.primary)
                        }
                    }
                    .ignoresSafeArea()
                }
            }
            .task {
                await llamaState.prepare()
            }
            .animation(.easeInOut, value: llamaState.isModelReadyToUse)
            .preferredColorScheme(.dark)
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        if UIApplication.shared.hasDynamicIsland {
            NotificationCenter.default.post(
                name: .init("NOTIFY"),
                object: CustomNotification(
                    title: notification.request.content.title,
                    description: notification.request.content.body
                )
            )
            
            return []
        } else {
            return [.sound, .banner]
        }
    }
}
