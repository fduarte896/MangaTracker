import Foundation


func getDataGeneric<TYPE>(request: URL, type: TYPE.Type) async throws -> TYPE where TYPE: Codable {
    
    let (data, response) = try await URLSession.shared.data(from: request) //URL
    //        let (data, response) = try await URLSession.shared.data(for: request) //URLRequest
    
    guard let responseHTTP = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
    
    guard responseHTTP.statusCode == 200 else { throw NetworkError.statuscode(responseHTTP.statusCode) }
    
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .formatted(.customDateFormatter)
    
    return try decoder.decode(type, from: data)
    
}
