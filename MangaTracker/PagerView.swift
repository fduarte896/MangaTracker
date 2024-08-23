import SwiftUI

/// `PagerView` es una vista que muestra una serie de pantallas de introducción en formato de paginación.
/// Los usuarios pueden deslizar hacia abajo para omitir la introducción.
struct PagerView: View {
    
    @Binding var isFirstLaunch: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        TabView {
            /// Primer contenido: Introducción a la sección de exploración de mangas.
            ContentUnavailableView(label: {
                VStack {
                    Button("Skip") {
                        dismiss()
                    }.font(.footnote).foregroundStyle(Color.blueMangaTracker)
                    Text("Explore View")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.bottom)

                    Image("ExploreViewIMG")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIDevice.isIPad ? 300 : 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom)
                }
            }, description: {
                Label("Discover a vast collection of mangas, including various categories that cater to your unique tastes, and the famous top 10.", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
                    .font(UIDevice.isIPad ? /*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/ : .headline)
                
            }, actions: {

            })
            
            
            /// Segundo contenido: Introducción a la gestión de la colección de mangas del usuario.
            ContentUnavailableView(label: {
                Button("Skip") {
                    dismiss()
                }.font(.footnote).foregroundStyle(Color.blueMangaTracker)
                    Text("My Collection/Bucket List")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.bottom)
                    Image("MyCollectionIMG")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIDevice.isIPad ? 300 : 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom)
                
            }, description: {
                Label("Effortlessly manage and explore your **manga collection** and **bucket list**: search, reorganize and delete your mangas", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
                    .font(UIDevice.isIPad ? /*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/ : .headline)
                
            }, actions: {

            })
            
            /// Tercer contenido: Introducción a los detalles de la colección y el seguimiento del progreso de lectura.
            ContentUnavailableView(label: {
                Button("Skip") {
                    dismiss()
                }.font(.footnote).foregroundStyle(Color.blueMangaTracker)
                Text("My Collection View")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding(.bottom)
                Image("CollectionDetailIMG")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIDevice.isIPad ? 300 : 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom)
                
            }, description: {
                Label("View detailed information about each manga in your collection, log the volumes you own, and track your reading progress.", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
                    .font(UIDevice.isIPad ? /*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/ : .headline)
            }, actions: {

            })
            
        }
        //        .padding(.horizontal)
        .foregroundStyle(Color.darkGrayMangaTracker)
        .bold()
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(Color.softWhiteBackground.opacity(0.5))

    }
}

#Preview {
    PagerView(isFirstLaunch: .constant(true))
}
