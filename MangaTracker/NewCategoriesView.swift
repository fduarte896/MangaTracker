import SwiftUI

/// `NewCategoriesView` es una vista que muestra las categorías de mangas como géneros, demografías y temas,
/// junto con los mangas asociados a cada subcategoría.
///
/// Esta vista permite al usuario explorar mangas organizados por categorías y subcategorías, presentando los
/// resultados en un formato horizontal con desplazamiento. La vista también maneja la paginación, cargando más mangas
/// al final de cada lista de subcategorías según sea necesario.
///
/// - Note: La vista incluye un fondo de gradiente, un indicador de carga mientras se obtienen los datos y manejo de errores con alertas.

struct NewCategoriesView: View {
    @StateObject var viewmodel = CategoriesViewModel()
    var category: String
    
    var body: some View {
        ZStack {
            /// Fondo con gradiente.
            LinearGradient(colors: [Color.gradientTopColor, Color.gradientBottomColor], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                /// Muestra el título de la categoría seleccionada.
                Text(category)
                    .font(.title)
                    .padding(.bottom, -10)
                    .foregroundStyle(Color.orangeMangaTracker)
                    .onAppear {
                        /// Carga los datos correspondientes a la categoría seleccionada.
                        switch category {
                        case "Genres":
                            viewmodel.fetchGenres()
                        case "Demographics":
                            viewmodel.fetchDemographics()
                        case "Themes":
                            viewmodel.fetchThemes()
                        default:
                            return
                        }
                    }
                
                /// Itera sobre las subcategorías y muestra los mangas asociados a cada una.
                /// Se presenta en un formato horizontal con desplazamiento para cada subcategoría. La paginación también está activada.
                ForEach(viewmodel.subCategories, id: \.self) { subCategory in
                    LazyVStack(alignment: .leading) {
                        Section(header: Text(subCategory).font(.title).foregroundStyle(Color.orangeMangaTracker)) {
                            ScrollView(.horizontal) {
                                LazyHStack {
                                    if let mangas = viewmodel.mangasByCategory2[subCategory] {
                                        ForEach(mangas.indices, id: \.self) { index in
                                            let manga = mangas[index]
                                            NavigationLink(value: manga) {
                                                VStack {
                                                    PosterView(manga: manga, isCarousel: false, isiPadAndSmall: true)
                                                    Text(manga.title)
                                                        .font(.headline)
                                                        .frame(maxWidth: 200, maxHeight: 100)
                                                        .foregroundStyle(Color.orangeMangaTracker)
                                                        .lineLimit(2)
                                                }
                                                .onAppear {
                                                    /// Verifica si es necesario cargar más mangas al llegar al final de la lista.
                                                    if mangas.last?.id == manga.id {
                                                        viewmodel.checkForMoreMangasCat(manga: manga, subCategory: subCategory, category: category)
                                                        viewmodel.currentSubCategory = subCategory
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .font(.title2)
                }
            }
            .scrollIndicators(.hidden)
            .padding()

            /// Alerta para errores generales en la carga de categorías.
            .alert(isPresented: $viewmodel.showAlert, content: {
                Alert(title: Text("Something went wrong with the categories"),
                      message: {
                    switch viewmodel.myError {
                    case .fetchDemographics:
                        return Text(viewmodel.errorMessage)
                    case .fetchGenres:
                        return Text("Error trying to load Genres")
                    case .fetchThemes:
                        return Text("Error trying to load Themes")
                    case .none:
                        return Text("Error trying to load any category")
                    }
                }(),
                      primaryButton: .default(Text("Load again"), action: {
                    switch viewmodel.myError {
                    case .fetchDemographics:
                        viewmodel.fetchDemographics()
                    case .fetchGenres:
                        viewmodel.fetchGenres()
                    case .fetchThemes:
                        viewmodel.fetchThemes()
                    case .none:
                        break
                    }
                }),
                      secondaryButton: .cancel(Text("Cancel"), action: {
                    viewmodel.showAlert = false
                })
                )
            })
            
            /// Alerta para errores específicos en la carga de subcategorías.
            .alert(isPresented: $viewmodel.showAlert, content: {
                Alert(title: Text("Something went wrong with the sub-categories"),
                      message: {
                    switch viewmodel.myErrorSpecific {
                    case .fetchMangasByGenreError:
                        return Text(viewmodel.errorMessage)
                    case .fetchMangasByDemographicError:
                        return Text(viewmodel.errorMessage)
                    case .fetchMangasByThemeError:
                        return Text(viewmodel.errorMessage)
                    case .checkForMoreMangasError:
                        return Text(viewmodel.errorMessage)
                    case .none:
                        return Text("Error trying to load the subcategory")
                    }
                    
                }(),
                      primaryButton: .default(Text("Try again"), action: {
                    switch viewmodel.myErrorSpecific {
                    case .fetchMangasByGenreError:
                        if let subGenre = viewmodel.currentSubCategory {
                            viewmodel.fetchMangasByGenre(genre: subGenre)
                        }
                        
                    case .fetchMangasByDemographicError:
                        if let subDemographic = viewmodel.currentSubCategory {
                            viewmodel.fetchMangasByDemographic(demographic: subDemographic)
                        }
                        
                    case .fetchMangasByThemeError:
                        if let subTheme = viewmodel.currentSubCategory {
                            viewmodel.fetchMangasByTheme(theme: subTheme)
                        }
                    case .checkForMoreMangasError:
                        if let lastManga = viewmodel.theLastManga, let currentSubCat = viewmodel.currentSubCategory {
                            viewmodel.checkForMoreMangasCat(manga: lastManga, subCategory: currentSubCat, category: category)
                        }
                    case .none:
                        break
                    }
                }),
                      secondaryButton: .cancel(Text("Cancel"), action: {
                    viewmodel.showAlert = false
                })
                )
            })
            
            /// Muestra un indicador de carga mientras se obtienen los datos.
            if viewmodel.isLoading {
                LinearGradient(colors: [Color.gradientTopColor, Color.gradientBottomColor], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            Text("Loading " + category)
                                .font(.title)
                                .foregroundStyle(Color.grayMangaTracker)
                            ProgressView()
                                .controlSize(.extraLarge)
                                .tint(Color.orangeMangaTracker)
                        }
                            .padding()
                    )
            }
        }
    }
}

#Preview {
    NavigationStack {
        NewCategoriesView(category: "Genres")
    }
}
