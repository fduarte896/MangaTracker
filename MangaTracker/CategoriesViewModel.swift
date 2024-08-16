import Foundation

/// `CategoriesViewModel` es un ViewModel que maneja la lógica de las categorías de mangas en la aplicación.
/// Permite gestionar cada categoría por separado, incluyendo sus subcategorías, y facilita la paginación de los mangas
/// dentro de cada subcategoría conforme el usuario realiza scroll.
/// Este ViewModel permite una navegación fluida y eficiente a través de los distintos géneros, temas y demografías de mangas.
final class CategoriesViewModel: ObservableObject {
    
    /// Lista de subcategorías cargadas para la categoría seleccionada.
    @Published var subCategories: [String] = []
    
    /// Subcategoría actualmente seleccionada por el usuario.
    @Published var currentSubCategory: String?
    
    /// Diccionario que mapea cada subcategoría a su lista de mangas correspondiente.
    @Published var mangasByCategory2: [String: [MangaModel]] = [:]
    
    /// Diccionario que mapea cada subcategoría a la página actual de paginación.
    @Published var pageCategories: [String: Int] = [:]
    
    /// Tipo de categoría actualmente seleccionada (e.g., "Genres", "Themes", "Demographics").
    @Published var categoryType = ""
    
    /// Mensaje de error que se muestra en caso de fallo en la carga de datos.
    @Published var errorMessage: String = ""
    
    /// Indica si se debe mostrar una alerta en la vista.
    @Published var showAlert: Bool = false
    
    /// Último manga renderizado en la lista.
    @Published var theLastManga: MangaModel?
    
    /// Indica si la vista está en estado de carga.
    @Published var isLoading = true
    
    private let interactor: MangaProtocol
    
    /// Variable que almacena el tipo de error general ocurrido durante la carga de categorías.
    @Published var myError: CategoriesListError?
    
    /// Variable que almacena el tipo de error específico ocurrido durante la carga de subcategorías.
    @Published var myErrorSpecific: CategoriesSpecificError?
    
    /// Inicializa el `CategoriesViewModel` con un interactor para manejar las peticiones de datos.
    /// - Parameter interactor: Protocolo que define las funciones para interactuar con la API o base de datos de mangas. Se asigna un valor por defecto.
    init(interactor: MangaProtocol = MangaInteractor()) {
        self.interactor = interactor
    }
    
    /// Verifica si se deben cargar más mangas de una subcategoría específica al llegar al final de la lista actual.
    /// - Parameters:
    ///   - manga: El último manga renderizado.
    ///   - subCategory: La subcategoría a la que pertenece el manga.
    ///   - category: La categoría principal de la que es parte la subcategoría.
    func checkForMoreMangasCat(manga: MangaModel, subCategory: String, category: String) {
        if let mangasInCategory = mangasByCategory2[subCategory], mangasInCategory.last?.id == manga.id {
            // Incrementa el contador de página para la subcategoría correspondiente
            theLastManga = manga
            pageCategories[subCategory, default: 1] += 1
            
            // Llama a la función de fetch correspondiente según el tipo de categoría
            switch category {
            case "Demographics":
                fetchMangasByDemographic(demographic: subCategory)
            case "Themes":
                fetchMangasByTheme(theme: subCategory)
            case "Genres":
                fetchMangasByGenre(genre: subCategory)
            default:
                break
            }
        }
    }
    
    /// Obtiene todas las categorías de tipo "Géneros" y carga los mangas correspondientes para cada subcategoría.
    func fetchGenres() {
        mangasByCategory2.removeAll()
        Task {
            do {
                let genres = try await interactor.getGenres()
                await MainActor.run {
                    self.subCategories = genres
                    fetchMangasForAllSubGenres()
                }
            } catch {
                await MainActor.run {
                    showAlert = true
                    myError = .fetchGenres
                }
            }
            try await Task.sleep(nanoseconds: 2000000000)
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    /// Carga los mangas correspondientes a cada subcategoría de "Géneros".
    func fetchMangasForAllSubGenres() {
        for subCategory in subCategories {
            fetchMangasByGenre(genre: subCategory)
        }
    }
    
    /// Obtiene los mangas para un género específico de manera paginada.
    /// - Parameter genre: El género para el cual se están cargando los mangas.
    func fetchMangasByGenre(genre: String) {
        let page = pageCategories[genre, default: 1]
        Task {
            do {
                let mangas = try await interactor.getMangaByGenre(genre: genre, page: page)
                await MainActor.run {
                    if self.mangasByCategory2[genre] == nil {
                        self.mangasByCategory2[genre] = mangas
                    } else {
                        self.mangasByCategory2[genre]! += mangas
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = "We could not load mangas from \(genre)"
                    showAlert = true
                    myErrorSpecific = .fetchMangasByGenreError
                }
            }
        }
    }
    
    /// Obtiene todas las categorías de tipo "Demographics" y carga los mangas correspondientes para cada subcategoría.
    func fetchDemographics() {
        mangasByCategory2.removeAll()
        Task {
            do {
                let demographics = try await interactor.getDemographics()
                await MainActor.run {
                    self.subCategories = demographics
                    self.fetchMangasForAllSubDemographics()
                }
            } catch {
                await MainActor.run {
                    showAlert = true
                    myError = .fetchDemographics
                }
            }
            try await Task.sleep(nanoseconds: 2000000000)
            await MainActor.run {
                isLoading = false
            }
        }
    }

    /// Carga los mangas correspondientes a cada subcategoría de "Demographics".
    func fetchMangasForAllSubDemographics() {
        for category in subCategories {
            fetchMangasByDemographic(demographic: category)
        }
    }
    
    /// Obtiene los mangas para una demografía específica de manera paginada.
    /// - Parameter demographic: La demografía para la cual se están cargando los mangas.
    func fetchMangasByDemographic(demographic: String) {
        let page = pageCategories[demographic, default: 1]
        Task {
            do {
                let mangas = try await interactor.getMangaByDemographic(demographic: demographic, page: page)
                await MainActor.run {
                    if self.mangasByCategory2[demographic] == nil {
                        self.mangasByCategory2[demographic] = mangas
                    } else {
                        self.mangasByCategory2[demographic]! += mangas
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = "We could not load mangas from \(demographic)"
                    showAlert = true
                    myErrorSpecific = .fetchMangasByDemographicError
                }
            }
        }
    }
    
    /// Obtiene todas las categorías de tipo "Themes" y carga los mangas correspondientes para cada subcategoría.
    func fetchThemes() {
        mangasByCategory2.removeAll()
        Task {
            do {
                let themes = try await interactor.getThemes()
                await MainActor.run {
                    self.subCategories = themes
                    self.fetchMangasForAllSubThemes()
                }
            } catch {
                await MainActor.run {
                    showAlert = true
                    myError = .fetchThemes
                }
            }
            try await Task.sleep(nanoseconds: 2000000000)
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    /// Carga los mangas correspondientes a cada subcategoría de "Themes".
    func fetchMangasForAllSubThemes() {
        for category in subCategories {
            fetchMangasByTheme(theme: category)
        }
    }
    
    /// Obtiene los mangas para un tema específico de manera paginada.
    /// - Parameter theme: El tema para el cual se están cargando los mangas.
    func fetchMangasByTheme(theme: String) {
        let page = pageCategories[theme, default: 1]
        Task {
            do {
                let mangas = try await interactor.getMangaByTheme(theme: theme, page: page)
                await MainActor.run {
                    if self.mangasByCategory2[theme] == nil {
                        self.mangasByCategory2[theme] = mangas
                    } else {
                        self.mangasByCategory2[theme]! += mangas
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = "We could not load mangas from \(theme)"
                    showAlert = true
                    myErrorSpecific = .fetchMangasByThemeError
                }
            }
        }
    }
}

/// Enum que representa los errores generales que pueden ocurrir durante la carga de categorías.
/// Proporciona descripciones localizadas para cada error.
enum CategoriesListError: LocalizedError {
    case fetchGenres
    case fetchThemes
    case fetchDemographics
    
    var errorDescription: String {
        switch self {
        case .fetchGenres:
            return "Error loading genres"
        case .fetchThemes:
            return "Error loading themes"
        case .fetchDemographics:
            return "Error loading demographics"
        }
    }
}

/// Enum que representa los errores generales que pueden ocurrir durante la carga de subcategorías.
/// Proporciona descripciones localizadas para cada error.
enum CategoriesSpecificError: LocalizedError {
    case fetchMangasByGenreError
    case fetchMangasByDemographicError
    case fetchMangasByThemeError
    case checkForMoreMangasError
    
    var errorDescription: String {
        switch self {
        case .fetchMangasByDemographicError:
            return "Error loading mangas by demographic"
        case .fetchMangasByGenreError:
            return "Error loading mangas by genre"
        case .fetchMangasByThemeError:
            return "Error loading mangas by theme"
        case .checkForMoreMangasError:
            return "Error loading more mangas"
        }
    }
}
