import Foundation

/// `MyCollectionDetailViewModel` es un ViewModel que maneja la lógica de los detalles de un manga en la colección del usuario.
/// A diferencia de la vista de detalle en la zona de exploración, esta vista está diseñada específicamente para que el usuario pueda hacer
/// un seguimiento detallado de los volúmenes que ha adquirido y de la lectura que está llevando a cabo.
/// Incluye funcionalidades para verificar si la colección está completa, mostrar el volumen que está leyendo, y guardar el progreso de lectura.
final class MyCollectionDetailViewModel: ObservableObject {
    
    /// El manga que está siendo mostrado en la vista de detalles.
    var manga: MangaModel
    
    /// Array que almacena los mangas favoritos guardados por el usuario.
    var savedFavouriteMangas: [MangaModel] = []
    
    /// El volumen actual que el usuario está leyendo.
    @Published var reading: Int = 0
    
    /// Array que almacena los volúmenes comprados por el usuario.
    @Published var volumes: [Int] = []
    
    /// Mensaje de error que se muestra en caso de fallo en la carga o modificación de la colección.
    @Published var errorMessage: String = ""
    
    /// Indica si se debe mostrar una alerta en la vista.
    @Published var showAlert: Bool = false
    
    /// Indica si la colección del manga está completa.
    @Published var collectionCompleted = false
    
    private let interactor: LocalProtocol
    
    /// Inicializa el `MyCollectionDetailViewModel` con un interactor y un manga específico.
    /// - Parameters:
    ///   - interactor: Protocolo que define las funciones para interactuar con la base de datos local de mangas. Se asigna un valor por defecto.
    ///   - manga: El manga específico que se mostrará en la vista de detalles.
    init(interactor: LocalProtocol = LocalInteractor(), manga: MangaModel) {
        self.interactor = interactor
        self.manga = manga
        showReadingValue()
        showBoughtVolumes()
        checkCompletedCollection()
        /// Las últimas tres funciones se llaman en el `init` para mostrar desde que se abre la vista el tracking de la lectura y colección del usuario.
    }
    
    /// Formatea los detalles del manga para mostrarlos en la vista.
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
    
    /// Verifica si la colección del manga está completa, comparando los volúmenes comprados con el total de volúmenes disponibles.
    func checkCompletedCollection() {
        if manga.boughtVolumes.count == manga.volumes {
            manga.isCompleted = true
            collectionCompleted = true
        } else {
            collectionCompleted = false
        }
    }
    
    /// Carga la colección de mangas del usuario desde un archivo.
    /// - Throws: Lanza un error si la carga de la colección falla.
    func loadData() throws {
        do {
            savedFavouriteMangas = try interactor.load()
        } catch {
            throw MyCollectionDetailError.loadDataError
        }
    }
    
    /// Muestra el volumen actual que el usuario está leyendo.
    func showReadingValue() {
        reading = manga.readingVolume
    }
    
    /// Muestra los volúmenes que el usuario ha comprado.
    func showBoughtVolumes() {
        volumes = manga.boughtVolumes
    }
    
    /// Guarda el volumen actual de lectura del manga en la colección del usuario.
    func persistReadingVolume() {
        do {
            try loadData()
            manga.readingVolume = reading
            if let index = savedFavouriteMangas.firstIndex(where: { $0.id == manga.id }) {
                savedFavouriteMangas[index] = manga
            }
            try interactor.save(array: savedFavouriteMangas)
        } catch let error as MyCollectionDetailError {
            errorMessage = error.errorDescription ?? "An unknown error occurred."
            showAlert = true
        } catch {
            errorMessage = MyCollectionDetailError.saveDataError.errorDescription ?? "An unexpected error occurred. Please try again."
            showAlert = true
        }
    }
    
    /// Guarda los volúmenes comprados del manga en la colección del usuario.
    /// - Parameter volume: El volumen específico que se ha comprado o eliminado de la colección.
    func persistBoughtVolumes(volume: Int) {
        do {
            try loadData()
            if volumes.contains(volume) {
                volumes.removeAll { $0 == volume }
            } else {
                volumes.append(volume)
            }
            manga.boughtVolumes = volumes
            if let index = savedFavouriteMangas.firstIndex(where: { $0.id == manga.id }) {
                savedFavouriteMangas[index] = manga
            }
            try interactor.save(array: savedFavouriteMangas)
        } catch let error as MyCollectionDetailError {
            errorMessage = error.errorDescription ?? "An unknown error occurred."
            showAlert = true
        } catch {
            errorMessage = MyCollectionDetailError.volumeTrackingError.errorDescription ?? "An unexpected error occurred. Please try again."
            showAlert = true
        }
    }
    
    /// Enum que representa los errores posibles durante la carga o modificación de los detalles del manga.
    /// Proporciona descripciones localizadas para cada error.
    enum MyCollectionDetailError: LocalizedError {
        case loadDataError
        case saveDataError
        case volumeTrackingError
        
        var errorDescription: String? {
            switch self {
            case .loadDataError:
                return "Failed to load your collection."
            case .saveDataError:
                return "Failed to save your collection."
            case .volumeTrackingError:
                return "Error tracking your manga volumes."
            }
        }
    }
}
