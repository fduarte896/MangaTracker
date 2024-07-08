//
//  MangaSplashScreenView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 1/07/24.
//

import SwiftUI

struct MangaSplashScreenView: View {
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            Text("MangaHub")
                .font(.title)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    MangaSplashScreenView()
}
