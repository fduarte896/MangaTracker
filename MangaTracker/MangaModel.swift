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
    
    /// Explicación de las nuevas propiedades del modelo de presentación:
    var boughtVolumes: [Int] ///Esta variable se usa para que el usuario pueda llevar la cuenta de los volúmenes comprados.
    var readingVolume: Int /// Esta variable permite al usuario llevar la cuenta del volumen que ha leído.
    var isCompleted: Bool ///Variable que permite saber si el usuario ha completado la colección.
    var collectionProgress : Float { ///Variable que permite al usuario saber, por medio de un `progressview`, su progreso. Esta está basada en `boughtVolumes`.
        if let totalVolumes = volumes {
            return Float(boughtVolumes.count) / Float(totalVolumes)
        } else {
            return 0.0
        }
    }
    
    ///Variables calculadas: En general, buscan cambiar el formato ya sea de fechas o de la escritura de las URL mencionadas para su correcto funcionamiento en los llamados.
    
    var formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return startDate.map { formatter.string(from: $0) } ?? "19XX"
    }
    
    var formattedEndDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return endDate.map { formatter.string(from: $0) } ?? "2024"
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
