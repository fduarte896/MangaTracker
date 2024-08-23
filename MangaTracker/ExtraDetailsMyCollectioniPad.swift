import SwiftUI

/// `ExtraDetailsMyCollectioniPad` es una vista que muestra detalles adicionales sobre un manga específico en la colección del usuario,
/// diseñada específicamente para pantallas de iPad.
///
/// Esta vista sigue la misma estructura que la versión para iPhone (`ExtraDetailsMyCollectionView`),
/// pero con ajustes en los tamaños de fuente y disposición para aprovechar mejor la pantalla más grande del iPad.
///
/// - Note: La vista organiza la información en secciones con divisores para facilitar la lectura, utilizando fuentes más grandes
///   y un diseño optimizado para la pantalla del iPad.
///
struct ExtraDetailsMyCollectioniPad: View {
    
    @StateObject var viewmodel: MyCollectionDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            /// Título de la sección de detalles del manga.
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
            
            /// Muestra los géneros asociados al manga si están disponibles, con un tamaño de fuente adecuado para iPad.
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
            
            /// Muestra las demografías asociadas al manga si están disponibles, con un tamaño de fuente adecuado para iPad.
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
            
            /// Muestra los temas asociados al manga si están disponibles, con un tamaño de fuente adecuado para iPad.
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
    ExtraDetailsMyCollectioniPad(viewmodel: MyCollectionDetailViewModel(manga: .preview))
}
