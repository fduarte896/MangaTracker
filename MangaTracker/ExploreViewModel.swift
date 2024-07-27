import Foundation

final class ExploreViewModel: ObservableObject {
    
    @Published var mangas: [MangaModel] = []
    @Published var mangasPrueba: [MangaModel] = []
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    @Published var mangasByAuthor: [MangaModel] = []
    

    
    @Published var bestMangasArray: [MangaModel] = []
    
    @Published var myError : ExploreViewErrors?
    
    private let interactor: MangaProtocol
    
    var page = 1
    var pageTopMangas = 1
    var mangasPerPage = 10
    var pageAuthor = 1
    
    var searchTask: Task<Void, Never>?
    
    @Published var successSearch = true
    
    @Published var searchedText = ""
    @Published var isSearched = false
    @Published var isBestMangaSelected = false
    @Published var isList = false
    
    init(interactor: MangaProtocol = MangaInteractor()) {
        self.interactor = interactor
        fetchAllMangas()
        fetchBestMangas()
    }
    
    func fetchAllMangas() {
        Task {
            do {
                let mangas = try await interactor.getAllMangasPaginated(page: page, mangasPerPage: mangasPerPage)
                await MainActor.run {
                    self.mangas += mangas
                }
            } catch {
                await MainActor.run {
                    errorMessage = "No Mangas"
                    showAlert = true
                    myError = .carrouselMangasError
                }
            }
        }
    }
    
    
    func fetchBestMangas() {
        Task {
            do {
                let mangas = try await interactor.getBestMangas(page: pageTopMangas, mangasPerPage: mangasPerPage)
                await MainActor.run {
                    self.bestMangasArray += mangas
                    print(bestMangasArray.count)
                }
            } catch {
                await MainActor.run {
                    errorMessage = "No Best Mangas"
                    showAlert = true
                    myError = .bestMangasError
                }
            }
        }
    }
    
    
    
    func isLastItem(manga1: MangaModel) {
        if mangas.last?.id == manga1.id {
            page += 1
            if isSearched == false && isBestMangaSelected == false {
                fetchAllMangas()
            } else if isSearched == true && isBestMangaSelected == false || isSearched == true && isBestMangaSelected == true {
                Task {
                    do {
                        let manguitas = try await interactor.searchMangaContains(text: searchedText, page: page)
                        await MainActor.run {
                            mangas += manguitas
                        }
                    } catch {
                        await MainActor.run {
                            errorMessage = "Scroll Error"
                            showAlert = true
                        }
                    }
                }
            }
            else if isSearched == false && isBestMangaSelected == true {
                fetchBestMangas()
            }
        }
    }
    
    func isLastItemTopMangas(manga: MangaModel) {
        if bestMangasArray.last?.id == manga.id {
            pageTopMangas += 1
            fetchBestMangas()

        }
    }
        
        func search(text: String) {
            searchTask?.cancel()
            searchTask = nil
            print("se ejecuta esto")
            print(text)
            
            searchTask = Task {
                do {
                    
                    try await Task.sleep(for: .milliseconds(1000))
                    
                    do {
                        let searchedMangas = try await interactor.searchMangaContains(text: text, page: page)
                        await MainActor.run {
                            mangas.removeAll()
                            mangas = searchedMangas
                            if mangas.isEmpty {
                                successSearch.toggle()
                            }
                        }
                    } catch {
                        await MainActor.run {
                            errorMessage = "No Found"
                            showAlert = true
                        }
                    }
                } catch {
                    print("Búsqueda cancelada")
                }
            }
        }
        
        func onChangeText() {
            successSearch = true
            isList = true
            if searchedText.isEmpty {
                searchTask?.cancel()
                mangas.removeAll()
                isSearched = false
                isBestMangaSelected = false
                page = 1
                fetchAllMangas()
                isList = false
            } else {
                mangas.removeAll()
                isSearched = true
                page = 1
                search(text: searchedText)
            }
        }
        
        func showBestMangas() {
            mangas.removeAll()
            page = 1
            isBestMangaSelected = true
            fetchBestMangas()
        }
        
        func resetAllMangas() {
            mangas.removeAll()
            page = 1
            isSearched = false
            isBestMangaSelected = false
            fetchAllMangas()
        }
        
    

        
        func fetchMangasByAuthor(idAuthor: String) {
            Task {
                do {
                    let mangas = try await interactor.getMangaByAuthorPaginated(idAuthor: idAuthor, page: pageAuthor, mangasPerPage: mangasPerPage)
                    await MainActor.run {
                        mangasByAuthor += mangas
                    }
                } catch {
                    await MainActor.run {
                        errorMessage = "Error loading mangas by this author"
                        showAlert = true
                    }
                }
            }
        }
        
        func isLastItemAuthor(manga: MangaModel, idAuthor: String) {
            if mangasByAuthor.last?.id == manga.id {
                pageAuthor += 1
                fetchMangasByAuthor(idAuthor: idAuthor)
            }
        }
        

        
    }
    
    enum ExploreViewErrors : LocalizedError {
        case carrouselMangasError
        case bestMangasError

    }

