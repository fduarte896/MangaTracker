import Foundation

/// `BucketListViewModel` es un ViewModel que maneja la lógica de la lista de deseos (bucket list) de mangas del usuario.
/// Similar a la lista de la colección, este ViewModel permite manipular la Bucket List (lista de deseos), incluyendo la eliminación de mangas
/// y su reordenamiento. También proporciona funcionalidades para filtrar y buscar mangas dentro de la lista.
final class BucketListViewModel: ObservableObject {
    
    /// Array que almacena los mangas en la lista de deseos del usuario.
    @Published var loadedBucketMangas: [MangaModel] = []
    
    /// Consulta de búsqueda utilizada para filtrar los mangas en la lista de deseos.
    @Published var searchBucketManga = ""
    
    /// Mensaje de error que se muestra en caso de fallo en la carga o modificación de la lista de deseos.
    @Published var errorMessage: String = ""
    
    /// Indica si la búsqueda fue exitosa.
    @Published var successSearch = true
    
    /// Texto buscado por el usuario.
    @Published var searchedText = ""
    
    /// Indica si se debe mostrar una alerta en la vista.
    @Published var showAlert = false
    
    private let interactor: LocalProtocol
    
    /// Inicializa el `BucketListViewModel` con un interactor para manejar las operaciones de datos locales.
    /// - Parameter interactor: Protocolo que define las funciones para interactuar con la base de datos local de mangas. Se asigna un valor por defecto.
    init(interactor: LocalProtocol = LocalInteractor()) {
        self.interactor = interactor
    }
    
    /// Carga la lista de deseos de mangas del usuario desde un archivo JSON.
    func loadMyBucketFromJSON() {
        do {
            loadedBucketMangas = try interactor.loadBucketMangas()
        } catch let error as BucketErrors {
            errorMessage = error.errorDescription
            showAlert = true
        } catch {
            errorMessage = BucketErrors.generalError(error).errorDescription
            showAlert = true
        }
    }
    
    /// Elimina mangas de la lista de deseos y guarda los cambios.
    /// - Parameter indexSet: Índices de los mangas que se van a eliminar.
    func deleteBucketMangas(indexSet: IndexSet) {
        loadedBucketMangas.remove(atOffsets: indexSet)
        saveBucketMangas()
    }
    
    /// Guarda la lista de deseos de mangas del usuario en un archivo.
    func saveBucketMangas() {
        do {
            try interactor.saveBucketMangas(array: loadedBucketMangas)
        } catch let error as BucketErrors {
            errorMessage = error.errorDescription
            showAlert = true
        } catch {
            errorMessage = BucketErrors.generalError(error).errorDescription
            showAlert = true
        }
    }
    
    /// Filtra los mangas en la lista de deseos según la consulta de búsqueda.
    /// - Returns: Un array de `MangaModel` filtrado según el texto de búsqueda.
    var filteredBucketMangas: [MangaModel] {
        loadedBucketMangas.filter {
            guard !searchBucketManga.isEmpty else { return true }
            let searchText = searchBucketManga.lowercased()
            return $0.title.lowercased().contains(searchText)
        }
    }
    
    /// Realiza una búsqueda en la lista de deseos según el texto ingresado.
    /// - Parameter text: Texto ingresado por el usuario para realizar la búsqueda.
    func search(text: String) {
        // Guarda el texto buscado
        searchedText = text
        
        // Filtra los mangas
        let filtered = loadedBucketMangas.filter {
            $0.title.lowercased().contains(text.lowercased())
        }
        
        // Actualiza la variable para indicar si la búsqueda fue exitosa
        successSearch = !filtered.isEmpty || searchedText.isEmpty
    }
}

/// Enum para manejar errores relacionados con la lista de deseos del usuario.
/// Proporciona descripciones localizadas para cada error.
enum BucketErrors: LocalizedError {
    case loadDataError(Error)
    case saveDataError(Error)
    case generalError(Error)
    
    var errorDescription: String {
        switch self {
        case .loadDataError:
            return "Failed to load bucket mangas"
        case .saveDataError:
            return "Failed to save the manga in your bucket"
        case .generalError:
            return "An unknown error occurred"
        }
    }
}
