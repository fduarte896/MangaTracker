//
//  CategoriesPageView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 1/07/24.
//

import SwiftUI

struct CategoriesPageView: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Second View")
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    isFirstLaunch = false
                } label: {
                    Text("Skip")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesPageView(isFirstLaunch: .constant(true))
    }
}
