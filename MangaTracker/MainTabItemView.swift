
import SwiftUI

struct MainTabItemView: View {
    
    var body: some View {
        TabView {
            MangaListView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            AllCategoriesView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Categories")
                }
            MyCollectionView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Favorites")
                }
        }
        .navigationTitle("Mangas")
    }
}

#Preview {
    MainTabItemView()
}
