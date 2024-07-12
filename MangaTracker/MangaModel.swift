import Foundation

struct MangaModel: Codable, Identifiable, Hashable {
    let score: Double
    let sypnosis: String?
    let demographics: [Demographic]
    let status: String
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
    
    // Nuevas propiedades para mi modelo de presentación:
    var boughtVolumes: [Int]
    var readingVolume: Int
    var isCompleted: Bool
    
    var formattedStartDate: String {
        startDate?.formatted(date: .abbreviated, time: .omitted) ?? "No Date Registered"
    }
    
    var formattedEndDate: String {
        endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Currently Active"
    }
    
    var mainPictureURL: URL {
        let urlString = mainPicture.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        return URL(string: urlString)!
    }
    
    var validURL: URL {
        let urlString = url.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        return URL(string: urlString)!
    }
}
