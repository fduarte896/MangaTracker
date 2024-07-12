
import SwiftUI

@main
struct MangaTrackerApp: App {
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                if showSplash {
                    MangaSplashScreenView()
                        .transition(.opacity)
                } else {
                    
                    if isFirstLaunch {
                        PagerView(isFirstLaunch: $isFirstLaunch)
                    } else {
                        MainTabItemView()
                    }
                }
            }
            .onAppear {
                Task {
                    try? await Task.sleep(for: .milliseconds(1000))
                    withAnimation(.easeOut(duration: 1)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
    
    
    
