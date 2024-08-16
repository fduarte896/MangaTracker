import Foundation

// URLs base:
let URLBaseList: URL = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/list")!
let URLBaseSearch: URL = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/search")!
let URLBaseUsers: URL = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/users")!
let URLBaseCollection: URL = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/collection")!

///Endpoints específicos para el llamado a red necesario para la situación. Los `print` sirven como guía para saber qué endpoint se está llamando en cada situación.
extension URL {

    static let allMangasURL: URL = URLBaseList.appending(path: "mangas")
    static let bestMangasURL: URL = URLBaseList.appending(path: "bestMangas")
    
    static let genresURL: URL = URLBaseList.appending(path: "genres")
    static let authorsURL: URL = URLBaseList.appending(path: "authors")
    static let demographicsURL: URL = URLBaseList.appending(path: "demographics")
    static let themesURL: URL = URLBaseList.appending(path: "themes")
    
    
    static func searchContainsURL(text: String, page: Int) -> URL {
        let url = URLBaseSearch.appending(path: "mangasContains").appending(path: text)
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
    static func allMangasPaginatedURL(page: Int, mangasPerPage: Int = 10) -> URL {
        let url = allMangasURL
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
    static func bestMangasURL(page: Int, mangasPerPage: Int = 10) -> URL {
        let url = bestMangasURL
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
    
    static func mangaByAuthorURL(authorID: String, page: Int, mangasPerPage: Int = 10) -> URL {
        let url = URLBaseList.appending(path: "mangaByAuthor/\(authorID)")
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
    
    static func mangaByGenreURL(genre: String, page: Int) -> URL {
        let url = URLBaseList.appending(path: "mangaByGenre/\(genre)")
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
   
    static func mangaByDemographicsURL(demographic: String, page: Int) -> URL {
        let url = URLBaseList.appending(path: "mangaByDemographic/\(demographic)")
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
    
    static func mangaByThemeURL(theme: String, page: Int) -> URL {
       let url = URLBaseList.appending(path: "mangaByTheme/\(theme)")
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
}



