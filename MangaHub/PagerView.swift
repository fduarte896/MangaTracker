
import SwiftUI

struct PagerView: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        TabView {
            HomePageView(isFirstLaunch: $isFirstLaunch)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            CategoriesPageView(isFirstLaunch: $isFirstLaunch)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Categories")
                }
            FavouritesPageView(isFirstLaunch: $isFirstLaunch)
                .tabItem {
                    Image(systemName: "star")
                    Text("Favorites")
                }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    PagerView(isFirstLaunch: .constant(true))
}
