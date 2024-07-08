//
//  MangaCellView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 7/06/24.
//

import SwiftUI

struct MangaCellView: View {
    
    var manga: MangaModel
    
    var body: some View {
        HStack {
 
            MangaPosterView(manga: manga)
                        
            VStack(alignment: .leading) {
                Text(manga.title)
                    .font(.title2)
                    .bold()
                Text("\(manga.authors.first?.firstName ?? "") \(manga.authors.first?.lastName ?? "")")
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
                Text("Score: \(manga.score.formatted())")
                Text(manga.formattedStartDate)

            }
        }
    }
}

#Preview {
    MangaCellView(manga: .preview)
}




