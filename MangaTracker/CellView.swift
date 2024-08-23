import SwiftUI

/// `CellView` es una vista que muestra una celda con la información de un manga, comúnmente para las listas, adaptándose según si se está utilizando en un iPad o iPhone.
///
/// La vista muestra el título del manga, el progreso de los volúmenes que el usuario posee (si está habilitado), y un puntaje circular
/// si el manga tiene una puntuación diferente de cero. La presentación de estos elementos varía entre iPad y iPhone:
/// - En iPad, se carga una vista específica (`CellViewiPad`).
/// - En iPhone, se utiliza un `HStack` para organizar los elementos en una fila.
///
/// - Parameters:
///   - manga: Una instancia de `MangaModel` que contiene la información del manga que se va a mostrar.
///   - showOwnedVolumes: Un booleano que indica si se debe mostrar el progreso de los volúmenes que posee el usuario.
///   - isSearchListView: Un booleano que indica si la vista se está utilizando en una lista de búsqueda, afectando el límite de líneas del título.
///
/// - Note: La vista adapta su diseño automáticamente según el dispositivo en el que se esté ejecutando y las opciones proporcionadas por los parámetros.

struct CellView: View {
    var manga: MangaModel
    var showOwnedVolumes: Bool
    var isSearchListView: Bool
    
    var body: some View {
        if UIDevice.isIPad {
            /// Vista específica para iPad
            CellViewiPad(manga: manga, showOwnedVolumes: showOwnedVolumes, isSearchListView: isSearchListView)
        } else if UIDevice.isIPhone {
            /// Vista para iPhone, con un diseño HStack
            HStack {
                VStack(alignment: .leading) {
                    /// Título del manga
                    Text(manga.title)
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .lineLimit(isSearchListView ? 4 : 2)
                        .foregroundStyle(Color.darkGrayMangaTracker)
                    
                    /// Progreso de la colección del usuario (si se habilita y se dispone de los volúmenes).
                    if showOwnedVolumes, let numberMangas = manga.volumes {
                        ProgressView(value: manga.collectionProgress) {
                            Text("Owned volumes: ")
                                .foregroundStyle(Color.darkGrayMangaTracker)
                        } currentValueLabel: {
                            Text("\(manga.boughtVolumes.count) out of \(numberMangas)")
                                .foregroundStyle(Color.darkGrayMangaTracker)
                        }
                    } else if showOwnedVolumes {
                        ProgressView(value: manga.collectionProgress) {
                            Text("No volumes reported").foregroundStyle(Color.darkGrayMangaTracker)
                        } currentValueLabel: {
                            Text("Volumes tracking not available")
                                .foregroundStyle(Color.darkGrayMangaTracker)
                        }
                    }
                    

                        GaugeScoreView(manga: manga)
                            .padding(.leading, 50)

                }
                Spacer()
                PosterView(manga: manga, isCarousel: false, isiPadAndSmall: true)
            }
        }
    }
}

#Preview("Collection View") {
    CellView(manga: .preview, showOwnedVolumes: true, isSearchListView: false)
}

#Preview("Search List View") {
    CellView(manga: .preview, showOwnedVolumes: false, isSearchListView: true)
}
