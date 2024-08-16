import SwiftUI

/// `CellViewiPad` es una vista diseñada específicamente para iPad que muestra una celda con la información de un manga,
/// optimizada para pantallas más grandes.
///
/// Esta vista sigue la misma estructura que `CellView` en iPhone, pero con modificaciones para aprovechar el espacio adicional
/// disponible en iPad. La vista muestra el título del manga, el progreso de los volúmenes que el usuario posee (si está habilitado),
/// y un puntaje circular si el manga tiene una puntuación diferente de cero.
///
/// - Parameters:
///   - manga: Una instancia de `MangaModel` que contiene la información del manga que se va a mostrar.
///   - showOwnedVolumes: Un booleano que indica si se debe mostrar el progreso de los volúmenes que posee el usuario.
///   - isSearchListView: Un booleano que indica si la vista se está utilizando en una lista de búsqueda, afectando el límite de líneas del título.
///
/// - Note: La vista está optimizada para iPad, utilizando mayor espacio horizontal y fuentes más grandes según el contexto
///   (colección o lista de búsqueda).

struct CellViewiPad: View {
    
    var manga: MangaModel
    var showOwnedVolumes : Bool
    var isSearchListView : Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                /// Muestra el título del manga.
                Text(manga.title)
                    .font(isSearchListView ? .title : .title3)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .lineLimit(isSearchListView ? 4 : 2)
                    .foregroundStyle(Color.orangeMangaTracker)
                
                /// Muestra el progreso de la colección de volúmenes del usuario si está habilitado.
                if showOwnedVolumes {
                    ProgressView(value: manga.collectionProgress, label: {
                        Text("Owned volumes: ")
                            .foregroundStyle(Color.grayMangaTracker)
                    }, currentValueLabel: {
                        if let numberMangas = manga.volumes {
                            Text("\(manga.boughtVolumes.count) out of " + String(numberMangas))
                                .foregroundStyle(Color.grayMangaTracker)
                        } else {
                            Text("Volume tracking is not available yet for this manga, sorry.")
                                .foregroundStyle(Color.grayMangaTracker)
                        }
                    })
                }
                
                /// Muestra un puntaje circular si el manga tiene una puntuación diferente de 0.
                if manga.score != 0 {
                    CircularGaugeView(manga: manga)
                        .padding(.leading, 50)
                }
            }
            Spacer()
            /// Muestra la portada del manga.
            PosterView(manga: manga, isCarousel: false, isiPadAndSmall: true)
        }
        .padding(.horizontal, 50)
    }
}

#Preview("Collection View") {
    CellViewiPad(manga: .preview, showOwnedVolumes: true, isSearchListView: false)
}

#Preview("Search List View") {
    CellViewiPad(manga: .preview, showOwnedVolumes: false, isSearchListView: true)
}
