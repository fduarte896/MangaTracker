//
//  MangaDataViewModel.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 15/06/24.
//

import Foundation

final class MangaDataViewModel: ObservableObject {
    
    var manga: MangaModel
    
    var savedFavouriteMangas : [MangaModel] = []
    
    @Published var isDisable = false
    
    @Published var errorMessage: String = ""
    
    @Published var showAlert: Bool = false
    
    private let interactor : LocalProtocol
    
    init(interactor: LocalProtocol = LocalInteractor(), manga: MangaModel) {
        self.interactor = interactor
        self.manga = manga
        try? loadData()
    }
    
    func loadData() throws {
        savedFavouriteMangas = try interactor.cargar()
    }
    
    func saveFavourite() {
        
        do{
            try loadData()
            
            if !savedFavouriteMangas.contains(where: { $0.id == manga.id }) {
                savedFavouriteMangas.append(manga)
            }
            try interactor.guardar(array: savedFavouriteMangas)
        } catch {
            showAlert = true
            myError = .saveFavourite
        }
        
        
        
    }
    
    func checkFavourite() {
        do {
            try loadData()
            if savedFavouriteMangas.contains(where: { $0.id == manga.id }) {
                isDisable = true
            }
        } catch {
            showAlert = true
            myError = .checkFavourite
        }
    }

    
    @Published var myError : detailErrors?
    
}

//enum de errores con case guardar y case checkfav.



enum detailErrors : LocalizedError {
    case saveFavourite
    case checkFavourite
    //    case generalError
    
    var errorDescription: String {
        switch self {
        case .saveFavourite:
            "Error saving manga"
        case .checkFavourite:
            "Error loading favourites"
            //        case .generalError:
            //            "Unexpected general error"
        }
    }
}
