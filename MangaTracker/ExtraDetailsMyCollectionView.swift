import SwiftUI

/// `ExtraDetailsMyCollectionView` es una vista que muestra detalles adicionales sobre un manga específico en la colección del usuario.
///
/// Esta es la versión para iPhone, diseñada para mostrar información como el título en diferentes idiomas, sinopsis, puntuación, géneros,
/// demografías y temas asociados al manga. Si la vista se está ejecutando en un iPad, se cargará la versión específica para iPad (`ExtraDetailsMyCollectioniPad`).
///
/// - Note: La vista organiza la información en secciones con divisores para facilitar la lectura. Incluye scrolls horizontales para mostrar
///   géneros, demografías y temas cuando hay múltiples elementos disponibles.
struct ExtraDetailsMyCollectionView: View {
    
    @StateObject var viewmodel: MyCollectionDetailViewModel
    
    var body: some View {
        if UIDevice.isIPhone {
            VStack(alignment: .leading) {
                
                /// Título de la sección de detalles del manga.
                Text("Details about \(viewmodel.manga.title)")
                    .font(.title)
                
                Divider().background(Color.orangeMangaTracker)
                
                /// Muestra el título en inglés si está disponible.
                VStack(alignment: .leading) {
                    Text("English Title")
                        .bold()
                    Text(viewmodel.manga.titleEnglish ?? "No specific English Title available")
                }
                
                Divider().background(Color.orangeMangaTracker)
                
                /// Muestra el título en japonés si está disponible.
                VStack(alignment: .leading) {
                    Text("Japanese title")
                        .bold()
                    Text(viewmodel.manga.titleJapanese ?? "No Japanese title available")
                }
                
                Divider().background(Color.orangeMangaTracker)
                
                /// Muestra la sinopsis del manga.
                Text("Synopsis")
                    .bold()
                Text(viewmodel.manga.sypnosis ?? "No Synopsis available")
                
                Divider().background(Color.orangeMangaTracker)
                
                /// Muestra la puntuación del manga.
                Text("**Score**")
                Text(String(viewmodel.manga.score.formatted()))
                
                Divider().background(Color.orangeMangaTracker)
                
                /// Muestra los géneros asociados al manga si están disponibles.
                if !viewmodel.manga.genres.isEmpty {
                    Text("Genres:")
                        .bold()
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewmodel.manga.genres, id: \.self) { genre in
                                Text("•")
                                Text(genre.genre)
                                    .font(.callout)
                            }
                        }
                    }
                }
                
                Divider().background(Color.orangeMangaTracker)
                
                /// Muestra las demografías asociadas al manga si están disponibles.
                if !viewmodel.manga.demographics.isEmpty {
                    Text("Demographics:")
                        .bold()
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewmodel.manga.demographics, id: \.self) { demographic in
                                Text("•")
                                Text(demographic.demographic)
                            }
                        }
                    }
                }
                
                Divider().background(Color.orangeMangaTracker)
                
                /// Muestra los temas asociados al manga si están disponibles.
                if !viewmodel.manga.themes.isEmpty {
                    Text("Themes")
                        .bold()
                        .font(.title2)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewmodel.manga.themes, id: \.self) { theme in
                                Text("•")
                                Text(theme.theme)
                            }
                        }
                    }
                }
                
            }
        } else if UIDevice.isIPad {
            /// Carga la vista específica para iPad si el dispositivo es un iPad.
            ExtraDetailsMyCollectioniPad(viewmodel: viewmodel)
        }
    }
}

#Preview {
    ScrollView{
        ExtraDetailsMyCollectionView(viewmodel: MyCollectionDetailViewModel(manga: .preview))
    }
}
