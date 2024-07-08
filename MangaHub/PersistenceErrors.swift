//
//  PersistenceErrors.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 2/07/24.
//

import Foundation

enum PersistenceErrors: LocalizedError {
    case loadDataError(Error)
    case saveDataError(Error)
    case generalError(Error)
    
    var errorDescription: String {
        switch self {
        case .loadDataError:
            return "Failed to load data"
        case .saveDataError:
            return "Failed to save data"
        case .generalError:
            return "An unknown error occurred"
        }
    }
}
