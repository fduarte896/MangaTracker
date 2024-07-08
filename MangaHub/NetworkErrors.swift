//
//  NetworkErrors.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 4/06/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case noHTTP
    case statuscode(Int)
    case general(Error)
    
    case genresError
    case demographicsError
    case themesErrors
    
    var errorDescription: String {
        switch self {
        case .noHTTP:
            return "No HTTP"
        case .statuscode(let code):
            return "Error code"
        case .general(let error):
            return "Unknown error"
            
        case .genresError:
            return "No Genres Found"
        case .demographicsError:
            return "No Demographics Found"
        case .themesErrors:
            return "No Themes Found"
        }
    }
}

