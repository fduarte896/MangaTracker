//
//  MangaModelDTO.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 4/06/24.
//

import Foundation

struct MangaGeneralDTO: Codable {
    
    let metadata: Metadata
    let items: [MangaDTO]
    
}

struct Metadata: Codable {
    let page: Int
    let per: Int
    let total: Int
}


struct MangaDTO: Codable {
    let score: Double
    let sypnosis: String?
    let demographics: [Demographic]
    let status: String // Revisar posibilidad de convertir más adelante a enum
    let background: String?
    let startDate: Date?
    let url: String
    let endDate: Date?
    let id: Int
    let genres: [Genre]
    let titleEnglish: String?
    let title: String
    let mainPicture: String
    let authors: [Author]
    let chapters: Int?
    let volumes: Int?
    let titleJapanese: String?
    let themes: [Theme]
    
    var mapToModel: MangaModel {
        MangaModel(
            score: score,
            sypnosis: sypnosis,
            demographics: demographics,
            status: status,
            background: background,
            startDate: startDate,
            url: url,
            endDate: endDate,
            id: id,
            genres: genres,
            titleEnglish: titleEnglish,
            title: title,
            mainPicture: mainPicture,
            authors: authors,
            chapters: chapters,
            volumes: volumes,
            titleJapanese: titleJapanese,
            themes: themes,
            boughtVolumes: [],
            readingVolume: 0,
            isCompleted: false
        )
    }
    
}


struct Demographic: Codable, Hashable {
    let id: String
    let demographic: String
}


struct Genre: Codable, Hashable {
    let id: String
    let genre: String
}


struct Author: Codable, Hashable, Identifiable {
    let id: String
    let role: String
    let firstName: String
    let lastName: String
    
    var authorCompleteName : String {
        return firstName + " " + lastName
    }
}


struct Theme: Codable, Hashable {
    let id: String
    let theme: String
}
