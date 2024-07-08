import Foundation

final class MangaCategoriesViewModel: ObservableObject {
    
    @Published var categories: [String] = []
    @Published var mangasByCategory: [MangaModel] = []
    @Published var categoryType = ""
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    private let interactor: MangaProtocol
    
    var pageCategories = 1
    var mangasPerPage = 10
    
    init(interactor: MangaProtocol = MangaInteractor()) {
        self.interactor = interactor
    }
    
    func categoryTypeSelected(category: String) {
        switch categoryType {
        case "Genres":
            fetchMangasByGenre(genre: category)
        case "Demographics":
            fetchMangasByDemographic(demographic: category)
        case "Themes":
            fetchMangasByTheme(theme: category)
        default:
            return
        }
    }
    
    
    func categorySelected(category: String) {
        categoryTypeSelected(category: category)
    }
    
    func isLastItemCategories(manga: MangaModel, category: String) {
        if mangasByCategory.last?.id == manga.id {
            pageCategories += 1
            categorySelected(category: category)
        }
    }
    
    
    func fetchGenres() {
        mangasByCategory.removeAll()
        Task {
            do {
                let genres = try await interactor.getGenres()
                await MainActor.run {
                    self.categories = genres
                }
            } catch {
                await MainActor.run {
                    errorMessage = NetworkError.genresError.errorDescription
                    showAlert = true
                    myError = .fetchGenres
                }
            }
        }
    }
    
    
    func fetchMangasByGenre(genre: String) {
        Task {
            do {
                let mangas = try await interactor.getMangaByGenre(genre: genre, page: pageCategories)
                await MainActor.run {
                    self.mangasByCategory += mangas
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
        mangasByCategory.removeAll()
        Task {
            do {
                let demographics = try await interactor.getDemographics()
                await MainActor.run {
                    self.categories = demographics
                }
            } catch {
                await MainActor.run {
                    errorMessage = NetworkError.demographicsError.errorDescription
                    showAlert = true
                    myError = .fetchDemographics
                }
            }
        }
    }
    
    func fetchMangasByDemographic(demographic: String) {
        Task {
            do {
                let mangas = try await interactor.getMangaByDemographic(demographic: demographic, page: pageCategories)
                await MainActor.run {
                    self.mangasByCategory += mangas
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
        mangasByCategory.removeAll()
        Task {
            do {
                let themes = try await interactor.getThemes()
                await MainActor.run {
                    self.categories = themes
                }
            } catch {
                await MainActor.run {
                    errorMessage = NetworkError.themesErrors.errorDescription
                    showAlert = true
                    myError = .fetchThemes
                }
            }
        }
    }
    
    func fetchMangasByTheme(theme: String) {
        Task {
            do {
                let mangas = try await interactor.getMangaByTheme(theme: theme, page: pageCategories)
                await MainActor.run {
                    self.mangasByCategory += mangas
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
    @Published var myError : categoriesListError?
    @Published var myErrorSpecific : categoriesSpecificError?
}

enum categoriesListError : LocalizedError {
    case fetchGenres
    case fetchThemes
    case fetchDemographics

    
    var errorDescription: String {
        switch self {
        case .fetchGenres:
            "Error loading genres"
        case .fetchThemes:
            "Error loading themes"
        case .fetchDemographics:
            "Error loading demographics"

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
            "Error loading mangas by demographic"
        case .fetchMangasByGenre:
            "Error loading mangas by genre"
        case .fetchMangasByTheme:
            "Error loading mangas by theme"
        }
    }
}
    
