import Foundation

///Esta es la función genérica que se amolda a todos los llamados a red que hay en la aplicación. Tiene la flexibilidad de pasarle una URL y un tipo para ser manejado.
func getDataGeneric<TYPE>(request: URL, type: TYPE.Type) async throws -> TYPE where TYPE: Codable {
    
    let (data, response) = try await URLSession.shared.data(from: request)

    guard let responseHTTP = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
    
    guard responseHTTP.statusCode == 200 else { throw NetworkError.statuscode(responseHTTP.statusCode) }
    
    let decoder = JSONDecoder()
    
    ///Dentro de la decodificación está incluido el formateo de la fecha que viene dentro de la respuesta, ya que es necesario un formato legible para ser mostrado al usuario. Este `formatter` se encuentra en la carpeta de extensiones.
    decoder.dateDecodingStrategy = .formatted(.customDateFormatter)
    
    return try decoder.decode(type, from: data)
    
}
