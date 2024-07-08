//
//  LocalInteractor.swift
//  MangaHub
//
//  Created by Felipe Duarte on 28/06/24.
//

import Foundation

let urlDocumentFolder = URL.documentsDirectory.appending(path: "MyMangas.json")

protocol LocalProtocol {
    
    func guardar(array: [MangaModel]) throws
    func cargar() throws -> [MangaModel]
    
}


struct LocalInteractor : LocalProtocol {
    
    func guardar(array: [MangaModel]) throws {

            let encondedData = try JSONEncoder().encode(array)
            try encondedData.write(to: urlDocumentFolder, options: .atomic)

    }
    

    func cargar() throws -> [MangaModel] {
        
        if FileManager.default.fileExists(atPath: urlDocumentFolder.path()) {
            let data = try Data(contentsOf: urlDocumentFolder)
            let decodedMangas = try JSONDecoder().decode([MangaModel].self, from: data)
            return decodedMangas
        } else {
            return []
        }
    }
}



//func cargar() throws -> [MangaModel] {
//    guard FileManager.default.fileExists(atPath: urlDocumentFolder.path()) else {
//        throw PersistenceErrors.loadDataError
//    }
//    
//    guard let data = try? Data(contentsOf: urlDocumentFolder) else {
//        throw PersistenceErrors.fileReadError
//    }
//    
//    guard let decodedMangas = try? JSONDecoder().decode([MangaModel].self, from: data) else {
//        throw PersistenceErrors.decodeError
//    }
//    
//    return decodedMangas
//}
