import Foundation

/// `ExploreViewModel` es un viewmodel encargado de manejar la lógica de la vista de exploración en la aplicación.
/// Se encarga de cargar mangas aleatorios para mostrar en el carrusel, así como los Top 10 mangas.
/// Además, gestiona las búsquedas de mangas, incluyendo la paginación y la selección de mangas por autor.
///
/// La vista de exploración es el punto de entrada para la selección de mangas por autor, utilizando un `navigationDestination`
/// en la vista principal, por lo que no se consideró necesario crear un viewmodel separado para esa funcionalidad.
final class ExploreViewModel: ObservableObject {
    
    
    @Published var mangas: [MangaModel] = []

    
    @Published var errorMessage: String = ""
    
    
    @Published var showAlert: Bool = false
    
    /// Último manga visualizado en la lista.
    @Published var theLastManga: MangaModel?
    
    
    @Published var mangasByAuthor: [MangaModel] = []
    
    
    @Published var bestMangasArray: [MangaModel] = []
    
    
    @Published var myError: ExploreViewErrors?
    
    private let interactor: MangaProtocol
    
    var page = 1
    var randomPageAllMangas = Int.random(in: 1...6473)
    var pageTopMangas = 1
    var mangasPerPage = 10
    var pageAuthor = 1
    
    var searchTask: Task<Void, Never>?
    
    @Published var successSearch = true
    @Published var searchedText = ""
    @Published var isSearched = false
    @Published var listNeeded = false
    
    /// Inicializa el `ExploreViewModel` con un interactor para manejar la obtención de datos.
    /// - Parameter interactor: Protocolo que define las funciones para interactuar con la API o base de datos de mangas. Se asigna un valor por defecto.
    init(interactor: MangaProtocol = MangaInteractor()) {
        self.interactor = interactor
        fetchAllMangas()
        fetchBestMangas()
    }
    
    /// Obtiene todos los mangas de manera paginada y aleatoria para mostrarle al usuario diferentes opciones cada vez que accede a la página de exploración.
    /// Los mangas se cargan de manera asíncrona y se añaden a la lista `mangas`.
    func fetchAllMangas() {
        Task {
            do {
                let mangas = try await interactor.getAllMangasPaginated(page: randomPageAllMangas, mangasPerPage: mangasPerPage)
                await MainActor.run {
                    self.mangas += mangas
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    showAlert = true
                    myError = .carrouselMangasError
                    errorMessage = "It was not possible to load the carrousel section:  \(error.errorDescription)"
                }
            } catch {
                showAlert = true
                errorMessage = "Error loading the explore section, check your internet connection"
            }
        }
    }
    
    /// Obtiene los mejores mangas para la sección del Top 10.
    /// Los resultados se agregan a la lista `bestMangasArray`.
    func fetchBestMangas() {
        Task {
            do {
                let mangas = try await interactor.getBestMangas(page: pageTopMangas, mangasPerPage: mangasPerPage)
                await MainActor.run {
                    self.bestMangasArray += mangas
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    showAlert = true
                    myError = .bestMangasError
                    errorMessage = "It was not possible to load the top 10 Mangas section:  \(error.errorDescription)"
                }
            } catch {
                showAlert = true
                errorMessage = "Error loading the explore section, check your internet connection"
            }
        }
    }
    
    /// Verifica si se deben cargar más mangas cuando el usuario llega al final de la lista actual.
    /// - Parameter lastManga: El último manga que ha sido renderizado en la vista.
    func checkForMoreMangas(lastManga: MangaModel) {
        if mangas.last?.id == lastManga.id {
            theLastManga = lastManga
            page += 1
            if isSearched == false {
                fetchAllMangas()
            } else if isSearched == true {
                Task {
                    do {
                        let moreMangas = try await interactor.searchMangaContains(text: searchedText, page: page)
                        await MainActor.run {
                            mangas += moreMangas
                        }
                    } catch {
                        await MainActor.run {
                            errorMessage = "Error loading more mangas"
                            showAlert = true
                            myError = .checkForMoreMangasError
                        }
                    }
                }
            }
        }
    }
    
    /// Verifica si se deben cargar más mangas de un autor al llegar al final de la lista actual.
    /// - Parameter manga: El último manga de un autor en la lista actual.
    /// - Parameter idAuthor: Identificador del autor seleccionado.
    func checkForMoreMangasAuthor(manga: MangaModel, idAuthor: String) {
        if mangasByAuthor.last?.id == manga.id {
            pageAuthor += 1
            fetchMangasByAuthor(idAuthor: idAuthor)
        }
    }

    /// Realiza la búsqueda de mangas basados en un texto ingresado.
    /// Se realiza una pausa de 1 segundo para evitar interferencias en la experiencia de usuario.
    /// - Parameter text: Texto ingresado por el usuario para la búsqueda.
    ///- Important: La búsqueda funciona bien en el simulador, pero al pasar la app al iPhone real arroja la alerta, alguna razón por la cual esto suceda? los errores que arroja se ven relacionados al teclado del iPhone.
    func search(text: String) {
        searchTask?.cancel()
        searchTask = nil
        
        searchTask = Task {
            do {
                try await Task.sleep(for: .milliseconds(800))

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
                        myError = .searchError
                        errorMessage = "Error loading your search"
                        showAlert = true
                        successSearch = false
                    }
                }

            } catch {
                print("Search cancelled")
            }
        }
    }
    
    /// Maneja el cambio de texto en la búsqueda, "reseteando" estados y realizando la búsqueda si aplica.
    func onChangeText() {
        successSearch = true
        listNeeded = true
        if searchedText.isEmpty {
            searchTask?.cancel()
            mangas.removeAll()
            isSearched = false
            page = 1
            fetchAllMangas()
            listNeeded = false
        } else {
            mangas.removeAll()
            isSearched = true
            page = 1
            search(text: searchedText)
        }
    }

    /// Obtiene los mangas de acuerdo al autor seleccionado por el usuario.
    /// - Parameter idAuthor: Identificador del autor seleccionado.
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
}

enum ExploreViewErrors: LocalizedError {
    case carrouselMangasError
    case bestMangasError
    case checkForMoreMangasError
    case searchError
}
