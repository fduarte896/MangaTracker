import SwiftUI

/// `PagerView` es una vista que muestra una serie de pantallas de introducción en formato de paginación.
/// Los usuarios pueden deslizar hacia abajo para omitir la introducción.
struct PagerView: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        TabView {
            /// Primer contenido: Introducción a la sección de exploración de mangas.
            ContentUnavailableView(label: {
                VStack{
                    HStack{
                        Image("ExploreViewIMG")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 480)
                            .border(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.bottom)
                    }
                }
            }, description: {
                Label("Discover a vast collection of mangas, including various categories that cater to your unique tastes", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
                    .font(UIDevice.isIPad ? /*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/ : .headline)
                Label("Browse the top 10 most popular mangas", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
                    .font(UIDevice.isIPad ? /*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/ : .headline)
            }, actions: {
                Label("Swipe down to skip", systemImage: "lightbulb.max")
                    .frame(width: 300)
                    .background(Color.orangeMangaTracker)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(Color.grayMangaTracker)
                    .font(UIDevice.isIPad ? /*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/ : .headline)
            })
            
            /// Segundo contenido: Introducción a la gestión de la colección de mangas del usuario.
            ContentUnavailableView(label: {
                HStack{
                    Image("MyCollectionIMG")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 480)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }, description: {
                Label("Effortlessly manage and explore your manga collection", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
                    .font(UIDevice.isIPad ? /*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/ : .headline)
            }, actions: {
                Label("Swipe down to skip", systemImage: "lightbulb.max")
                    .frame(width: 300)
                    .background(Color.orangeMangaTracker)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(Color.grayMangaTracker)
                    .font(UIDevice.isIPad ? /*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/ : .headline)
            })
            
            /// Tercer contenido: Introducción a los detalles de la colección y el seguimiento del progreso de lectura.
            ContentUnavailableView(label: {
                Image("CollectionDetailIMG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 480)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }, description: {
                Label("View detailed information about each manga in your collection, log the volumes you own, and track your reading progress.", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
                    .font(UIDevice.isIPad ? /*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/ : .headline)
            }, actions: {
                Label("Swipe down to skip", systemImage: "lightbulb.max")
                    .frame(width: 300)
                    .background(Color.orangeMangaTracker)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(Color.grayMangaTracker)
                    .font(UIDevice.isIPad ? /*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/ : .headline)
            })
            
        }
        .padding(.horizontal)
        .foregroundStyle(Color.orangeMangaTracker)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(Color.gray.opacity(0.7))
    }
}

#Preview {
    PagerView(isFirstLaunch: .constant(true))
}
