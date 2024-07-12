import Foundation

extension URLQueryItem {
    static func getPage(pageNumber: Int) -> URLQueryItem {
        URLQueryItem(name: "page", value: String(pageNumber))
    }
}
