//
//  DateFormatter.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 4/06/24.
//

import Foundation

extension DateFormatter {
    
    static let customDateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
}
