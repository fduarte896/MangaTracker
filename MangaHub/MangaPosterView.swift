//
//  MangaPosterView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 1/07/24.
//

import SwiftUI

struct MangaPosterView: View {
    
    var manga: MangaModel
    
    var body: some View {
        AsyncImage(url: manga.mainPictureURL) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(Rectangle())
        } placeholder: {
            ProgressView()
                .controlSize(.extraLarge)
                .scaledToFit()
                .frame(width: 120, height: 120)
        }
    }
}

#Preview {
    MangaPosterView(manga: .preview)
}
