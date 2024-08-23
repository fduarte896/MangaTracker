import SwiftUI

/// `TabItem` es una estructura que define los elementos de la barra de navegación o tab bar de la aplicación.
struct TabItem {
    let title: String
    let systemImage: String
    let destination: AnyView
}

/// `tabItems` es un array que contiene los elementos de la tab bar.
let tabItems = [
    TabItem(title: "Explore", systemImage: "magnifyingglass", destination: AnyView(ExploreView())),
    TabItem(title: "My Collection", systemImage: "magazine", destination: AnyView(MyCollectionListView())),
    TabItem(title: "Bucket List", systemImage: "bookmark", destination: AnyView(BucketListView()))
]

/// `MainTabItemView` es la vista principal que maneja la interfaz de navegación de la aplicación.
/// Muestra una barra lateral en modo paisaje para iPad y una barra inferior de pestañas en modo retrato o en iPhone.
struct MainTabItemView: View {
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    var body: some View {
        Group {
            if UIDevice.isIPad {
                // Landscape: Mostrar barra lateral
                NavigationSplitView {
                    ZStack {
                        Color.softWhiteBackground
                            .ignoresSafeArea()
                        
                        VStack(alignment: .leading) {
                            /// Se utiliza `ForEach` para generar dinámicamente los enlaces de navegación en la barra lateral.
                            ForEach(tabItems, id: \.title) { item in
                                NavigationLink(destination: item.destination) {
                                    VStack(alignment: .leading) {
                                        Divider()
                                        Label(item.title, systemImage: item.systemImage)
                                            .listRowBackground(Color.clear)
                                            .padding(10)
                                    }
                                }
                            }
                            .foregroundStyle(Color.orangeMangaTracker)
                            .font(.title3)
                            .bold()
                            Divider()
                            Spacer()
                        }
                        .background(Color.clear)
                    }
                    .navigationTitle("Sections")
                    .navigationSplitViewColumnWidth(200)
                } detail: {
                    /// Vista inicial que se muestra en el detalle cuando la app comienza en iPad en modo paisaje.
                    ExploreView()
                }
            } else {
                // Portrait: Mostrar barra inferior
                TabView {
                    ExploreView()
                        .tabItem {
                            Label("Explore", systemImage: "magnifyingglass")
                        }
                    
                    MyCollectionListView()
                        .tabItem {
                            Label("My Collection", systemImage: "magazine")
                        }
                    
                    BucketListView()
                        .tabItem {
                            Label("Bucket List", systemImage: "bookmark")
                        }
                }
                .foregroundStyle(Color.blueMangaTracker)
            }
        }
    }
}

#Preview {
    MainTabItemView()
}
