import SwiftUI

/// `TopMangaPosterView` es una vista que muestra la portada de un manga junto con su posición en una lista de los mejores mangas, si se proporciona un índice.
///
/// Esta vista utiliza `PosterView` para mostrar la portada del manga y opcionalmente superpone el índice de clasificación del manga en la parte superior izquierda de la portada.
/// Está diseñada para mostrar mangas destacados en listas donde se indica la posición de cada manga.
///
/// - Parameters:
///   - manga: Una instancia de `MangaModel` que contiene la información del manga que se va a mostrar.
///   - topIndex: Un entero opcional que indica la posición del manga en una lista de los mejores mangas. Si se proporciona, se muestra superpuesto en la portada.
///
/// - Note: La vista está diseñada para ser utilizada en carruseles y secciones donde se destacan los mejores mangas, mostrando la portada junto con su posición en la lista.

import SwiftUI

struct TopMangaPosterView: View {
    var manga: MangaModel
    var topIndex: Int? = nil
    
    var body: some View {
        VStack {
            Spacer()
            PosterView(manga: manga, isCarousel: false, isiPadAndSmall: true)
                .overlay {
                    if let index = topIndex {
                        ZStack {
                            // Contorno simulando con varias capas de texto desplazadas
                            Text(String(index + 1))
                                .font(.system(size: 100, weight: .medium))
                                .foregroundColor(.softWhiteBackground)
                                .offset(x: 2, y: 2)
                            Text(String(index + 1))
                                .font(.system(size: 100, weight: .medium))
                                .foregroundColor(.softWhiteBackground)
                                .offset(x: -2, y: -2)
                            Text(String(index + 1))
                                .font(.system(size: 100, weight: .medium))
                                .foregroundColor(.softWhiteBackground)
                                .offset(x: -2, y: 2)
                            Text(String(index + 1))
                                .font(.system(size: 100, weight: .medium))
                                .foregroundColor(.softWhiteBackground)
                                .offset(x: 2, y: -2)

                            // Texto principal
                            Text(String(index + 1))
                                .font(.system(size: 100, weight: .medium))
                                .foregroundStyle(Color.blueMangaTracker)
                        }
                        .padding([.top, .leading], 10)
                        .offset(x: -70, y: 50)
                    }
                }
        }
        .offset(x: 10)
    }
}

#Preview("Preview3") {
    TopMangaPosterView(manga: .preview, topIndex: 2)
}
