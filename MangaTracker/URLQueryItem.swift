import Foundation

///Esta función nos permite indicar a modo de query item la página que se va a usar en los llamados a red.
extension URLQueryItem {
    static func getPage(pageNumber: Int) -> URLQueryItem {
        URLQueryItem(name: "page", value: String(pageNumber))
    }
}
