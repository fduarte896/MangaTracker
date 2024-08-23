import SwiftUI

/// `ExtraDetailsView` es una vista que muestra información adicional sobre un manga,
/// incluyendo títulos en diferentes idiomas, sinopsis, puntuación, géneros, demografías y temas.
///
/// Esta vista está diseñada para funcionar tanto en iPhone como en iPad, ajustándose al dispositivo en el que se muestra.
/// Si se utiliza en un iPhone, la vista mostrará todos los detalles de manera vertical, mientras que en un iPad,
/// se cargará una vista específica para ese dispositivo (`ExtraDetailsiPad`).
/// - Note: La vista organiza la información en secciones con divisores para facilitar la lectura.

struct ExtraDetailsView: View {
    
    @StateObject var viewmodel: DetailViewModel
    
    var body: some View {
        if UIDevice.isIPhone {
            VStack(alignment: .leading) {
                
                /// Título de la sección de detalles.
                Text("Details about \(viewmodel.manga.title)")
                    .font(.title3)
                    .foregroundStyle(Color.darkGrayMangaTracker)
                    .bold()
                
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
                
                /// Muestra los géneros asociados al manga.
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
                
                /// Muestra las demografías asociadas al manga.
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
                
                /// Muestra los temas asociados al manga.
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
            /// Carga la vista específica para iPad.
            ExtraDetailsiPad(viewmodel: viewmodel)
        }
    }
}

#Preview {
    ExtraDetailsView(viewmodel: DetailViewModel(manga: .preview))
}
