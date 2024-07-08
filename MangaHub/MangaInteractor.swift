//
//  MangaInteractor.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 4/06/24.
//

//noHTTP y statuscode son los errores que vienen de la genérica

import Foundation

protocol MangaProtocol {

    func getAllMangas() async throws -> [MangaModel]
    func getAllMangasPaginated(page: Int, mangasPerPage: Int) async throws -> [MangaModel]
    func getBestMangas(page: Int, mangasPerPage: Int) async throws -> [MangaModel]
    
    
    func getMangaByGenre(genre: String, page: Int) async throws -> [MangaModel]
    func getMangaByTheme(theme: String, page: Int) async throws -> [MangaModel]
    func getMangaByDemographic(demographic: String, page: Int) async throws -> [MangaModel]
    func getMangaByAuthorPaginated(idAuthor: String, page: Int, mangasPerPage: Int) async throws -> [MangaModel]

    func getGenres() async throws -> [String]
    func getDemographics() async throws -> [String]
    func getThemes() async throws -> [String]
    func getAuthors() async throws -> [Author]
    
    
    func searchMangaContains(text: String, page: Int) async throws -> [MangaModel]
    
}


struct MangaInteractor: MangaProtocol {

    func getAllMangas() async throws -> [MangaModel] {
        return try await getDataGeneric(request: .allMangasURL, type: MangaGeneralDTO.self).items.map(\.mapToModel)
    }
    
    func getBestMangas(page: Int = 1, mangasPerPage: Int = 10) async throws -> [MangaModel] {
        return try await getDataGeneric(request: .bestMangasURL(page: page), type: MangaGeneralDTO.self).items.map(\.mapToModel)
    }
    
    func getAllMangasPaginated(page: Int = 1, mangasPerPage: Int = 10) async throws -> [MangaModel] {
        return try await getDataGeneric(request: .allMangasPaginatedURL(page: page, mangasPerPage: mangasPerPage), type: MangaGeneralDTO.self).items.map(\.mapToModel)
    }
    
    
    func getMangaByGenre(genre: String, page: Int) async throws -> [MangaModel] {
        return try await getDataGeneric(request: .mangaByGenreURL(genre: genre, page: page), type: MangaGeneralDTO.self).items.map(\.mapToModel)
    }
    
    func getMangaByTheme(theme: String, page: Int) async throws -> [MangaModel] {
        return try await getDataGeneric(request: .mangaByThemeURL(theme: theme, page: page), type: MangaGeneralDTO.self).items.map(\.mapToModel)
    }
    
    func getMangaByDemographic(demographic: String, page: Int) async throws -> [MangaModel] {
        return try await getDataGeneric(request: .mangaByDemographicsURL(demographic: demographic, page: page), type: MangaGeneralDTO.self).items.map(\.mapToModel)
    }
    
    func getMangaByAuthorPaginated(idAuthor: String, page: Int = 1, mangasPerPage: Int = 10) async throws -> [MangaModel] {
        return try await getDataGeneric(request: .mangaByAuthorURL(authorID: idAuthor, page: page, mangasPerPage: mangasPerPage), type: MangaGeneralDTO.self).items.map(\.mapToModel)
    }
    
    
    
    
    func getGenres() async throws -> [String] {
        return try await getDataGeneric(request: .genresURL, type: [String].self)
    }
    
    func getDemographics() async throws -> [String] {
        return try await getDataGeneric(request: .demographicsURL, type: [String].self)
    }
    
    func getThemes() async throws -> [String] {
        return try await getDataGeneric(request: .themesURL, type: [String].self)
    }
    
    func getAuthors() async throws -> [Author] {
        return try await getDataGeneric(request: .authorsURL, type: [Author].self)
    }
    
    
    
    func searchMangaContains(text: String, page: Int) async throws -> [MangaModel] {
        return try await getDataGeneric(request: .searchContainsURL(text: text, page: page), type: MangaGeneralDTO.self).items.map(\.mapToModel)
    }
}
