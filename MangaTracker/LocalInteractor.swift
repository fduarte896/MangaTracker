///Este interactor se encarga del manejo de datos a nivel local, tanto de los mangas que van a la colección, como los de la Bucket List.

import Foundation

let urlMyMangasDocumentFolder = URL.documentsDirectory.appending(path: "MyMangas.json")
let urlBucketMangasFolder = URL.documentsDirectory.appending(path: "BucketMangas.json")

protocol LocalProtocol {
    
    func save(array: [MangaModel]) throws
    func load() throws -> [MangaModel]
    func saveBucketMangas(array: [MangaModel]) throws
    func loadBucketMangas() throws -> [MangaModel]
}


struct LocalInteractor : LocalProtocol {
    
    ///Esta función permite el guardado de un array de mangas en el archivo (específico para mangas de la colección).
    func save(array: [MangaModel]) throws {
        let encondedData = try JSONEncoder().encode(array)
        try encondedData.write(to: urlMyMangasDocumentFolder, options: .atomic)
        
    }
    
    ///Esta función carga los archivos para decodificar los mangas y devolverlos dentro de un array (específico para mangas de la colección).
    func load() throws -> [MangaModel] {
        
        if FileManager.default.fileExists(atPath: urlMyMangasDocumentFolder.path()) {
            let data = try Data(contentsOf: urlMyMangasDocumentFolder)
            let decodedMangas = try JSONDecoder().decode([MangaModel].self, from: data)
            return decodedMangas
        } else {
            return []
        }
    }
    
    ///Esta función permite el guardado de un array de mangas en el archivo (específico para mangas de la Bucket List).
    func saveBucketMangas(array: [MangaModel]) throws {
        let encondedData = try JSONEncoder().encode(array)
        try encondedData.write(to: urlBucketMangasFolder, options: .atomic)
    }
    
    ///Esta función carga los archivos para decodificar los mangas y devolverlos dentro de un array (específico para mangas de la Bucket List).
    func loadBucketMangas() throws -> [MangaModel]{
        if FileManager.default.fileExists(atPath: urlBucketMangasFolder.path()) {
            let data = try Data(contentsOf: urlBucketMangasFolder)
            let decodedBucketMangas = try JSONDecoder().decode([MangaModel].self, from: data)
            return decodedBucketMangas
        } else {
            return []
        }
    }
    
}


