import Foundation

/// `MyCollectionListViewModel` es un ViewModel que maneja la lógica de la lista de la colección de mangas del usuario.
/// Este ViewModel permite cargar la colección desde un archivo JSON, modificarla eliminando mangas o reordenándolos,
/// y también filtrar los mangas en la colección utilizando una barra de búsqueda para una navegación más fácil y directa.
final class MyCollectionListViewModel: ObservableObject {
    
    /// Array que almacena los mangas cargados en la colección del usuario.
    @Published var loadedMyCollectionMangas: [MangaModel] = []
    
    /// Consulta de búsqueda utilizada para filtrar los mangas en la colección.
    @Published var searchQueryCollection = ""
    
    /// Mensaje de error que se muestra en caso de fallo en la carga o modificación de la colección.
    @Published var errorMessage: String = ""
    
    /// Indica si la búsqueda fue exitosa.
    @Published var successSearch = true
    
    /// Texto buscado por el usuario.
    @Published var searchedText = ""
    
    /// Indica si se debe mostrar una alerta en la vista.
    @Published var showAlert: Bool = false
    
    private let interactor: LocalProtocol
    
    /// Inicializa el `MyCollectionListViewModel` con un interactor para manejar las operaciones de datos locales.
    /// - Parameter interactor: Protocolo que define las funciones para interactuar con la base de datos local de mangas. Se asigna un valor por defecto.
    init(interactor: LocalProtocol = LocalInteractor()) {
        self.interactor = interactor
    }
    
    /// Carga la colección de mangas del usuario desde un archivo JSON.
    func LoadMyCollectionFromJSON() {
        do {
            loadedMyCollectionMangas = try interactor.load()
        } catch {
            showAlert = true
            errorMessage = "Error loading your collection from disk"
        }
    }
    
    /// Elimina mangas de la colección del usuario y guarda los cambios.
    /// - Parameter indexSet: Índices de los mangas que se van a eliminar.
    func deleteMangas(indexSet: IndexSet) {
        loadedMyCollectionMangas.remove(atOffsets: indexSet)
        saveCollectionMangas()
    }
    
    /// Guarda la colección de mangas del usuario en un archivo.
    func saveCollectionMangas() {
        do {
            try interactor.save(array: loadedMyCollectionMangas)
        } catch let error as CollectionErrors {
            errorMessage = error.errorDescription
            showAlert = true
        } catch {
            errorMessage = CollectionErrors.generalError(error).errorDescription
            showAlert = true
        }
    }

    /// Filtra los mangas en la colección del usuario según la consulta de búsqueda.
    /// - Returns: Un array de `MangaModel` filtrado según el texto de búsqueda.
    var filteredMangas: [MangaModel] {
        loadedMyCollectionMangas
            .filter {
                guard !searchQueryCollection.isEmpty else { return true }
                let searchText = searchQueryCollection.lowercased()
                return $0.title.lowercased().contains(searchText)
            }
    }
    
    /// Realiza una búsqueda en la colección de mangas según el texto ingresado.
    /// - Parameter text: Texto ingresado por el usuario para realizar la búsqueda.
    func search(text: String) {
        print("Se hace una busqueda collection")
        print(text)
        
        // Guarda el texto buscado
        searchedText = text
        
        // Filtra los mangas
        let filtered = loadedMyCollectionMangas.filter {
            $0.title.lowercased().contains(text.lowercased())
        }
        
        // Actualiza la variable para indicar si hubo éxito en la búsqueda
        successSearch = !filtered.isEmpty
        
        if searchedText.isEmpty {
            successSearch = true
        }
    }
}

/// Enum que representa los errores posibles durante la carga o modificación de la colección de mangas.
/// Proporciona descripciones localizadas para cada error.
enum CollectionErrors: LocalizedError {
    case loadDataError(Error)
    case saveDataError(Error)
    case generalError(Error)
    
    var errorDescription: String {
        switch self {
        case .loadDataError:
            return "Failed to load your collection"
        case .saveDataError:
            return "Failed to save your collection"
        case .generalError:
            return "An unknown error occurred"
        }
    }
}
