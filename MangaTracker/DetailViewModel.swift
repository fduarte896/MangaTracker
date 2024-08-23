import Foundation

/// `DetailViewModel` es un viewmodel que maneja la lógica detrás de la vista de detalle de un manga en particular.
/// Se encarga de la carga de datos del manga seleccionado, así como de gestionar las acciones del usuario para agregar
/// el manga a su colección o a su Bucket List. Además, maneja la lógica para desactivar botones en caso de que el manga
/// ya esté en una de estas listas.
final class DetailViewModel: ObservableObject {
    
    
    var manga: MangaModel

    var savedMyCollectionMangas: [MangaModel] = []

    var savedBucketMangas: [MangaModel] = []
    
    /// Indica si el botón para añadir a la colección debería estar deshabilitado.
    @Published var isMyCollectionButtonDisable = false
    
    /// Indica si el botón para añadir a la Bucket List debería estar deshabilitado.
    @Published var isMyBucketButtonDisable = false

    @Published var errorMessage: String = ""
    
    @Published var showAlert: Bool = false
    
    @Published var isPressed: Bool = false
        
    @Published var myError: DetailViewErrors?
    
    private let interactor: LocalProtocol
    
    /// Inicializa el `DetailViewModel` con un manga específico seleccionado por el usuario y un interactor.
    /// - Parameters:
    ///   - interactor: Protocolo que define las funciones para interactuar con la base de datos local de mangas. Se asigna un valor por defecto.
    ///   - manga: El modelo de manga que se mostrará en la vista de detalles.
    init(interactor: LocalProtocol = LocalInteractor(), manga: MangaModel) {
        self.interactor = interactor
        self.manga = manga
        try? loadDataCollection()
    }

    /// Carga los mangas guardados en la colección del usuario.
    /// - Throws: Lanza un error si la carga de la colección falla.
    func loadDataCollection() throws {
        savedMyCollectionMangas = try interactor.load()
    }
    
    /// Carga los mangas guardados en la Bucket List.
    /// - Throws: Lanza un error si la carga de la Bucket List falla.
    func loadDataBucket() throws {
        savedBucketMangas = try interactor.loadBucketMangas()
    }
    
    /// Añade el manga a la colección del usuario. Si el manga ya está presente en la Bucket List, lo elimina de allí.
    func addToMyCollection() {
        do {
            try loadDataCollection()
            try loadDataBucket()
            
            // Elimina de la Bucket List si el manga existe allí.
            if let index = savedBucketMangas.firstIndex(where: { $0.id == manga.id }) {
                savedBucketMangas.remove(at: index)
                try interactor.saveBucketMangas(array: savedBucketMangas)
            }

            // Añade a la colección si no existe ya.
            if !savedMyCollectionMangas.contains(where: { $0.id == manga.id }) {
                savedMyCollectionMangas.append(manga)
            }
            try interactor.save(array: savedMyCollectionMangas)
        } catch {
            showAlert = true
            myError = .saveToMyCollection
        }
    }
    
    /// Añade el manga a la Bucket List del usuario. Si el manga ya está presente en la colección, lo elimina de allí.
    func addToMyBucket() {
        do {
            try loadDataBucket()
            try loadDataCollection()
            
            // Elimina de la colección si el manga existe allí.
            if let index = savedMyCollectionMangas.firstIndex(where: { $0.id == manga.id }) {
                savedMyCollectionMangas.remove(at: index)
                try interactor.save(array: savedMyCollectionMangas)
            }

            // Añade a la Bucket List si no existe ya.
            if !savedBucketMangas.contains(where: { $0.id == manga.id }) {
                savedBucketMangas.append(manga)
            }
            try interactor.saveBucketMangas(array: savedBucketMangas)
        } catch {
            showAlert = true
            myError = .saveToBucket
        }
    }
    
    /// Verifica si el manga ya está en la Bucket List y desactiva el botón correspondiente si es así.
    func checkMyBucket() {
        do {
            try loadDataBucket()
            if savedBucketMangas.contains(where: { $0.id == manga.id }) {
                isMyBucketButtonDisable = true
            }
        } catch {
            showAlert = true
            myError = .checkBucket
        }
    }
    
    /// Verifica si el manga ya está en la colección y desactiva el botón correspondiente si es así.
    func checkMyCollection() {
        do {
            try loadDataCollection()
            if savedMyCollectionMangas.contains(where: { $0.id == manga.id }) {
                isMyCollectionButtonDisable = true
            }
        } catch {
            showAlert = true
            myError = .checkMyCollection
        }
    }

    /// Formatea los detalles del manga para mostrarlos en la vista, incluyendo fechas, volúmenes, géneros y demografía.
    /// - Returns: Una cadena de texto con los detalles formateados del manga.
    func formatMangaDetails() -> String {
        var details = "\(manga.formattedStartDate)-\(manga.formattedEndDate)"

        if let volumes = manga.volumes {
            details += " • \(volumes) volumes"
        }
        
        if let genre = manga.genres.first?.genre, !genre.isEmpty {
            details += " • \(genre)"
        }
        if let theme = manga.themes.first?.theme, !theme.isEmpty {
            details += ", \(theme)"
        }
        if let demographic = manga.demographics.first?.demographic, !demographic.isEmpty {
            details += ", \(demographic)"
        }

        return details
    }
}

enum DetailViewErrors: LocalizedError {
    case saveToMyCollection
    case checkMyCollection
    case saveToBucket
    case checkBucket

    var errorDescription: String? {
        switch self {
        case .saveToMyCollection:
            return "Error saving manga into your collection"
        case .checkMyCollection:
            return "Error loading your collection"
        case .saveToBucket:
            return "Error saving manga to your bucket list"
        case .checkBucket:
            return "Error loading your bucket"
        }
    }
}
