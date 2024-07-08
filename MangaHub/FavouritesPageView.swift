//
//  FavouritesPageView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 1/07/24.
//

import SwiftUI

struct FavouritesPageView: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        VStack {
            Text("Third View")
            
            Button {
                isFirstLaunch = false
            } label: {
                Text("Continue to the App")
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavouritesPageView(isFirstLaunch: .constant(true))
    }
}
