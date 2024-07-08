import Foundation

struct MangaInteractorPreview: MangaProtocol {
    func getAllMangas() async throws -> [MangaModel]{ return [] }
    
    func getAllMangasPaginated(page: Int, mangasPerPage: Int) throws -> [MangaModel] {
        guard let url = Bundle.main.url(forResource: "MangasPreview", withExtension: "json") else { throw LocalErrors.loadError }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.customDateFormatter)
        return try decoder.decode(MangaGeneralDTO.self, from: data).items.map(\.mapToModel)
    }
    
    func getBestMangas(page: Int, mangasPerPage: Int) async throws -> [MangaModel]{ return [] }
    
    
    func getMangaByGenre(genre: String, page: Int) async throws -> [MangaModel]{ return [] }
    func getMangaByTheme(theme: String, page: Int) async throws -> [MangaModel]{ return [] }
    func getMangaByDemographic(demographic: String, page: Int) async throws -> [MangaModel]{ return [] }
    func getMangaByAuthorPaginated(idAuthor: String, page: Int, mangasPerPage: Int) async throws -> [MangaModel]{ return [] }
    
    
    func getGenres() async throws -> [String]{ return [] }
    func getDemographics() async throws -> [String]{ return [] }
    func getThemes() async throws -> [String]{ return [] }
    func getAuthors() async throws -> [Author]{ return [] }
    
    
    func searchMangaContains(text: String, page: Int) async throws -> [MangaModel]{ return [] }
    
}


enum LocalErrors: Error {
    case loadError
}


extension MangaProtocol where Self == MangaInteractorPreview {
    static var preview: Self { MangaInteractorPreview() }
}





