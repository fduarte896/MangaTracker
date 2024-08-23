import SwiftUI

@main
struct MangaTrackerApp: App {
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @State private var showSplash = true
    @State private var showOnboarding = false
    let uiColorGrayMangaTracker = UIColor(red: 204/255, green: 210/255, blue: 224/255, alpha: 1.0)
    let uiColorDarkGrayMangaTracker = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    
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
        
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = uiColorDarkGrayMangaTracker
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: uiColorDarkGrayMangaTracker]

        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}
