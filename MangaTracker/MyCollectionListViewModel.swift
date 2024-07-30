import Foundation


final class MyCollectionListViewModel : ObservableObject {
    
    @Published var loadedMyCollectionMangas : [MangaModel] = []
    
    @Published var containsFavourites = false
    
    @Published var searchQueryCollection = ""
    
    @Published var errorMessage: String = ""
    
    @Published var successSearch = true
    @Published var searchedText = ""
    
    @Published var showAlert: Bool = false
    
    var searchTask: Task<Void, Never>?
    @Published var isSearched = false
    var page = 1
    
    //    @Published var progress : Float = 0.0
    
    private let interactor : LocalProtocol
    
    init(interactor: LocalProtocol = LocalInteractor()) {
        self.interactor = interactor
    }
    
    
    
    func LoadMyCollectionFromJSON() {
        do {
            loadedMyCollectionMangas = try interactor.load()
            //        containsFavourites = !loadedFavouriteMangas.isEmpty
        } catch {
            showAlert = true
            errorMessage = "Error loading your collection from disk"
        }
    }
    
    func deleteMangas(indexSet: IndexSet) {
        loadedMyCollectionMangas.remove(atOffsets: indexSet)
        do {
            try interactor.save(array: loadedMyCollectionMangas)
            //        containsFavourites = !loadedFavouriteMangas.isEmpty
        } catch let error as PersistenceErrors {
            errorMessage = error.errorDescription
            showAlert = true
        } catch {
            errorMessage = PersistenceErrors.generalError(error).errorDescription
            showAlert = true
        }
    }
    
    var filteredMangas: [MangaModel] {
        loadedMyCollectionMangas
            .filter {
                guard !searchQueryCollection.isEmpty else { return true }
                let searchText = searchQueryCollection.lowercased()
                return $0.title.lowercased().contains(searchText)
            }
    }
    

    
    func search(text: String) {
        searchTask?.cancel()
        searchTask = nil
        print("Se hace una busqueda collection")
        print(text)
        
        // Guardamos el texto buscado
        searchedText = text
        
        // Filtramos los mangas
        let filtered = loadedMyCollectionMangas.filter {
            $0.title.lowercased().contains(text.lowercased())
        }
        
        // Actualizamos la variable para decir que hay éxito en la búsqueda
        
        if filtered.isEmpty {
            successSearch = false
        }
        
        if searchedText.isEmpty {
            successSearch = true
        }
    }
}
