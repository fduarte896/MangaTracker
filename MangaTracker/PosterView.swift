import SwiftUI

/// `PosterView` es una vista que muestra la portada de un manga en diferentes tamaños y contextos,
/// como en carruseles o secciones de mangas destacados.
///
/// La vista adapta automáticamente el tamaño del póster en función del dispositivo y el estado de `isCarrousel`
/// y `isiPadAndSmall`, asegurando que se vea bien en todas las vistas donde se utiliza.
///
/// - Note: La vista utiliza `AsyncImage` para cargar la imagen del póster de manera asíncrona, y muestra un `ProgressView`
///   mientras la imagen se carga.
///
/// - Important: La vista ajusta el tamaño del póster dependiendo de la clase de tamaño horizontal (`horizontalSizeClass`)
///   y de los parámetros `isCarrousel` y `isiPadAndSmall`.
struct PosterView: View {
    var manga: MangaModel
    let isCarousel: Bool
    let isiPadAndSmall: Bool
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        /// Determina el ancho y alto del póster según el dispositivo y el estado de `isCarrousel`, buscando adaptarse a los diferentes espacios donde se usan los posters (es decir, en todas las vistas).
        let posterSize = horizontalSizeClass == .compact || isiPadAndSmall
            ? CGSize(width: 200, height: CGFloat(isCarousel ? PosterHeight.carrousel.rawValue : PosterHeight.topMangasSection.rawValue))
            : CGSize(width: 500, height: 500)
        
        AsyncImage(url: manga.mainPictureURL) { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: posterSize.width, height: posterSize.height)
                .padding(.top, horizontalSizeClass == .regular ? 16 : 0)
        } placeholder: {
            ProgressView()
                .controlSize(.extraLarge)
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
    }
}

/// `PosterHeight` define las alturas predefinidas para los pósters dependiendo del contexto en el que se muestran.
enum PosterHeight: Int {
    case carrousel = 350
    case topMangasSection = 200
}

#Preview {
    PosterView(manga: .preview, isCarousel: false, isiPadAndSmall: true)
}
