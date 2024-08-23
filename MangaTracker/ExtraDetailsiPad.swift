import SwiftUI

/// `ExtraDetailsiPad` es una vista que muestra información adicional sobre un manga,
/// incluyendo títulos en diferentes idiomas, sinopsis, puntuación, géneros, demografías y temas.
///
/// Esta vista sigue la misma estructura que la versión para iPhone (`ExtraDetailsView`),
/// pero ajusta los tamaños de las fuentes y la disposición para adecuarse a la pantalla más grande del iPad.
/// - Note: La vista organiza la información en secciones con divisores para facilitar la lectura en dispositivos iPad.

struct ExtraDetailsiPad: View {
    @StateObject var viewmodel: DetailViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            /// Título de la sección de detalles.
            Text("Details about \(viewmodel.manga.title)")
                .font(.title)
                .foregroundStyle(Color.darkGrayMangaTracker)
                .bold()
            
            Divider().background(Color.orangeMangaTracker)
            
            /// Muestra el título en inglés si está disponible, con un tamaño de fuente adecuado para iPad.
            VStack(alignment: .leading) {
                Text("English Title")
                    .bold()
                    .font(.title2)
                Text(viewmodel.manga.titleEnglish ?? "No specific English Title available")
                    .font(.title2)
            }
            
            Divider().background(Color.orangeMangaTracker)
            
            /// Muestra el título en japonés si está disponible, con un tamaño de fuente adecuado para iPad.
            VStack(alignment: .leading) {
                Text("Japanese title")
                    .bold()
                    .font(.title2)
                Text(viewmodel.manga.titleJapanese ?? "No Japanese title available")
                    .font(.title2)
            }
            
            Divider().background(Color.orangeMangaTracker)
            
            /// Muestra la sinopsis del manga, con un tamaño de fuente adecuado para iPad.
            Text("Synopsis")
                .bold()
                .font(.title2)
            Text(viewmodel.manga.sypnosis ?? "No Synopsis available")
                .font(.title2)
            
            Divider().background(Color.orangeMangaTracker)
            
            /// Muestra la puntuación del manga, con un tamaño de fuente adecuado para iPad.
            Text("**Score**")
                .font(.title2)
            Text(String(viewmodel.manga.score.formatted()))
                .font(.title2)
            
            Divider().background(Color.orangeMangaTracker)
            
            /// Muestra los géneros asociados al manga.
            if !viewmodel.manga.genres.isEmpty {
                Text("Genres:")
                    .bold()
                    .font(.title2)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewmodel.manga.genres, id: \.self) { genre in
                            Text("•")
                            Text(genre.genre)
                                .font(.title2)
                        }
                    }
                }
            }
            
            Divider().background(Color.orangeMangaTracker)
            
            /// Muestra las demografías asociadas al manga.
            if !viewmodel.manga.demographics.isEmpty {
                Text("Demographics:")
                    .bold()
                    .font(.title2)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewmodel.manga.demographics, id: \.self) { demographic in
                            Text("•")
                            Text(demographic.demographic)
                                .font(.title2)
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
                                .font(.title2)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ExtraDetailsiPad(viewmodel: DetailViewModel(manga: .preview))
}
