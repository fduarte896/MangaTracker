import SwiftUI

@main
struct MangaTrackerApp: App {
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @State private var showSplash = true
    @State private var showOnboarding = false

    init() {
        customizeTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabItemView()
                    .onAppear {
                        if isFirstLaunch {
                            showOnboarding = true
                        }
                    }
                    .sheet(isPresented: $showOnboarding, onDismiss: {
                        isFirstLaunch = false
                    }) {
                        PagerView(isFirstLaunch: $isFirstLaunch)
                    }
                
                if showSplash {
                    SplashScreen()
                        .transition(.opacity)
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
    
    private func customizeTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.orange
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.orange]

        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}
