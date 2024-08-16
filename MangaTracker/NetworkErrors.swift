import Foundation

enum NetworkError: Error {
    case noHTTP
    case statuscode(Int)
    case general(Error)

    
    var errorDescription: String {
        switch self {
        case .noHTTP:
            return "We did not get any response from the server, check your internet connection and try again."
        case .statuscode(let code):
            return "Error \(code)"
        case .general(let error):
            return "Unknown \(error)"

        }
    }
}

