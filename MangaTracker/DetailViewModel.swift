import Foundation

final class DetailViewModel: ObservableObject {
    
    var manga: MangaModel
    
    var savedFavouriteMangas : [MangaModel] = []
    var savedBucketMangas : [MangaModel] = []
    
    @Published var isMyCollectionButtonDisable = false
    @Published var isMyBucketButtonDisable = false
    
    @Published var errorMessage: String = ""
    
    @Published var showAlert: Bool = false
    
    @Published var isPressed : Bool = false //To make the button bigger if pressed.
    
    private let interactor : LocalProtocol
    
    init(interactor: LocalProtocol = LocalInteractor(), manga: MangaModel) {
        self.interactor = interactor
        self.manga = manga
        try? loadData()
    }
    
    deinit {
        print("Cerrado correctamente")
    }
    
    
    func loadData() throws {
        savedFavouriteMangas = try interactor.load()
    }
    
    func addToMyCollection() {
        
        do{
            try loadData()
            try loadData2()
            
            // Eliminar de bucket si existe
            if let index = savedBucketMangas.firstIndex(where: { $0.id == manga.id }) {
                savedBucketMangas.remove(at: index)
                try interactor.saveBucketMangas(array: savedBucketMangas)
            }

            // Añadir a la colección si no existe ya
            if !savedFavouriteMangas.contains(where: { $0.id == manga.id }) {
                savedFavouriteMangas.append(manga)
            }
            try interactor.save(array: savedFavouriteMangas)
        } catch {
            showAlert = true
            myError = .saveToMyCollection
        }
        
    }
    
    func loadData2() throws {
        savedBucketMangas = try interactor.loadBucketMangas()
    }
    
    func addToMyBucket() {
        do {
            try loadData2()
            try loadData()
            
            print(savedBucketMangas.count)
            // Eliminar de la colección si existe
            if let index = savedFavouriteMangas.firstIndex(where: { $0.id == manga.id }) {
                savedFavouriteMangas.remove(at: index)
                try interactor.save(array: savedFavouriteMangas)
            }

            // Añadir al bucket si no existe ya
            if !savedBucketMangas.contains(where: { $0.id == manga.id }) {
                savedBucketMangas.append(manga)
            }
            try interactor.saveBucketMangas(array: savedBucketMangas)
        } catch {
            showAlert = true
            myError = .saveToBucket
        }
    }
    
    func checkMyBucket() {
        do {
            try loadData2()
            if savedBucketMangas.contains(where: { $0.id == manga.id }) {
                isMyBucketButtonDisable = true
            }
        } catch {
            showAlert = true
            myError = .checkBucket
        }
    }
    
    func checkMyCollection() {
        do {
            try loadData()
            if savedFavouriteMangas.contains(where: { $0.id == manga.id }) {
                isMyCollectionButtonDisable = true
            }
        } catch {
            showAlert = true
            myError = .checkMyCollection
        }
    }

    
    @Published var myError : DetailViewErrors?
    
}

//enum de errores con case guardar y case checkfav.



enum DetailViewErrors : LocalizedError {
    case saveToMyCollection
    case checkMyCollection
    case saveToBucket
    case checkBucket
    //    case generalError
    
    var errorDescription: String {
        switch self {
        case .saveToMyCollection:
            "Error saving manga into your collection"
        case .checkMyCollection:
            "Error loading your collection"
            //        case .generalError:
            //            "Unexpected general error"
        case .saveToBucket: "Error saving manga to your bucket list"
        case .checkBucket: "Error loading your bucket"
        }
    
    }
}


