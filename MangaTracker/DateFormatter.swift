///Formateador de la fecha dado que el formato que viene de la respuesta de red no es óptimo para el uso dentro de la app.

import Foundation

extension DateFormatter {
    
    static let customDateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
}
