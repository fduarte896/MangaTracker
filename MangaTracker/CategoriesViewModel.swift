import Foundation

final class CategoriesViewModel: ObservableObject {
    
    @Published var subCategories: [String] = []
    @Published var mangasByCategory: [MangaModel] = []
    @Published var mangasByCategory2: [String: [MangaModel]] = [:]
    @Published var pageCategories: [String: Int] = [:]
    
    @Published var categoryType = ""
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    @Published var isLoading = true
    
    private let interactor: MangaProtocol
    
    @Published var arrayCats: [String] = ["Genres", "Demographics", "Themes"]
    
    var mangasPerPage = 10
    
    init(interactor: MangaProtocol = MangaInteractor()) {
        self.interactor = interactor
    }
    
    func isLastItemCategories(manga: MangaModel, subCategory: String, category: String) {
        if let mangasInCategory = mangasByCategory2[subCategory], mangasInCategory.last?.id == manga.id {
            // Incrementar el contador de página para el tipo correspondiente
            pageCategories[subCategory, default: 1] += 1
            
            // Llamar a la función de fetch correspondiente según el tipo de categoría
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
    
    func fetchGenres() {
        mangasByCategory2.removeAll()
        Task {
            do {
                let genres = try await interactor.getGenres()
                await MainActor.run {
                    self.subCategories = genres
                    fetchMangasForAllCategoriesGenres()
                }
            } catch {
                await MainActor.run {
                    errorMessage = NetworkError.genresError.errorDescription
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
    
    func fetchMangasForAllCategoriesGenres() {
        for category in subCategories {
            fetchMangasByGenre(genre: category)
        }
    }
    
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
                    errorMessage = "No Mangas By Genre Found"
                    showAlert = true
                    myErrorSpecific = .fetchMangasByGenre
                }
            }
        }
    }
    
    func fetchDemographics() {
        mangasByCategory2.removeAll()
        Task {
            do {
                let demographics = try await interactor.getDemographics()
                await MainActor.run {
                    self.subCategories = demographics
                    self.fetchMangasForAllCategoriesDemos()
                }
            } catch {
                await MainActor.run {
                    errorMessage = NetworkError.demographicsError.errorDescription
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
    
    func fetchMangasForAllCategoriesDemos() {
        for category in subCategories {
            fetchMangasByDemographic(demographic: category)
        }
    }
    
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
                    errorMessage = "No Mangas By Demographics Found"
                    showAlert = true
                    myErrorSpecific = .fetchMangasByDemographic
                }
            }
        }
    }
    
    func fetchThemes() {
        mangasByCategory2.removeAll()
        Task {
            do {
                let themes = try await interactor.getThemes()
                await MainActor.run {
                    self.subCategories = themes
                    self.fetchMangasForAllCategoriesThemes()
                }
            } catch {
                await MainActor.run {
                    errorMessage = NetworkError.themesErrors.errorDescription
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
    
    func fetchMangasForAllCategoriesThemes() {
        for category in subCategories {
            fetchMangasByTheme(theme: category)
        }
    }
    
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
                    errorMessage = "No Mangas By Themes Found"
                    showAlert = true
                    myErrorSpecific = .fetchMangasByTheme
                }
            }
        }
    }
    
    @Published var myError: categoriesListError?
    @Published var myErrorSpecific: categoriesSpecificError?
}

enum categoriesListError: LocalizedError {
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

enum categoriesSpecificError: LocalizedError {
    case fetchMangasByGenre
    case fetchMangasByDemographic
    case fetchMangasByTheme
    
    var errorDescription: String {
        switch self {
        case .fetchMangasByDemographic:
            return "Error loading mangas by demographic"
        case .fetchMangasByGenre:
            return "Error loading mangas by genre"
        case .fetchMangasByTheme:
            return "Error loading mangas by theme"
        }
    }
}
