//
//  MangaCategoriesView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/06/24.
//

import SwiftUI

struct MangaCategoriesView: View {
    
    @StateObject var viewmodel = MangaCategoriesViewModel()
    @Binding var pathCategories: NavigationPath
    var category: String
    var type: String
    
    var body: some View {
        
        List(viewmodel.mangasByCategory) { manga in
            NavigationLink(value: manga) {
                MangaCellView(manga: manga)
                    .onAppear {
                        viewmodel.isLastItemCategories(manga: manga, category: category)
                    }
            }
        }
        .onAppear {
            viewmodel.categoryType = type
            viewmodel.categorySelected(category: category)
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.myErrorSpecific, actions: { error in
            Button("Try again") {
                switch error {
                case .fetchMangasByGenre : viewmodel.fetchMangasByGenre(genre: category)
                case .fetchMangasByTheme : viewmodel.fetchMangasByTheme(theme: category)
                case .fetchMangasByDemographic : viewmodel.fetchMangasByDemographic(demographic: category)
                }
            }
            Button {
                viewmodel.showAlert = false
            } label: {
                Text("Cancel")
            }
        }, message: {
            Text($0.errorDescription)
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    pathCategories = NavigationPath()
                }) {
                    Text("Back to home")
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        MangaCategoriesView(pathCategories: .constant(NavigationPath()),category: "Action", type: "Genre")
    }
}
