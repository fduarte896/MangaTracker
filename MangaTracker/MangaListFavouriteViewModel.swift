import Foundation


final class MangaListFavouriteViewModel : ObservableObject {
    
    @Published var loadedFavouriteMangas : [MangaModel] = []
    
    @Published var containsFavourites = false
    
    @Published var searchFavManga = ""
    
    @Published var errorMessage: String = ""
    
    @Published var showAlert: Bool = false

    
    private let interactor : LocalProtocol
    
    init(interactor: LocalProtocol = LocalInteractor()) {
        self.interactor = interactor
    }
    
    func showFavourites() {
        do {
            loadedFavouriteMangas = try interactor.cargar()
            //        containsFavourites = !loadedFavouriteMangas.isEmpty
        } catch let error as PersistenceErrors {
//            loadedFavouriteMangas = []
            errorMessage = error.errorDescription
            showAlert = true
        } catch {
            errorMessage = PersistenceErrors.generalError(error).errorDescription
            showAlert = true
        }
    }
    
    func deleteMangas(indexSet: IndexSet) {
        loadedFavouriteMangas.remove(atOffsets: indexSet)
        do {
            try interactor.guardar(array: loadedFavouriteMangas)
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
        loadedFavouriteMangas
            .filter {
                guard !searchFavManga.isEmpty else { return true }
                let searchText = searchFavManga.lowercased()
                return $0.title.lowercased().contains(searchText)
            }
    }
    
}
