//
//  MangaByAuthorView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 18/06/24.
//

import SwiftUI

struct MangaByAuthorView: View {
    
    @StateObject var viewmodel = MangaListViewModel()
    @Binding var path: NavigationPath
    
    var author: Author
    
    var body: some View {
        
        List(viewmodel.mangasByAuthor) { manga in
            NavigationLink(value: manga) {
                MangaCellView(manga: manga)
                    .onAppear {
                        viewmodel.isLastItemAuthor(manga: manga, idAuthor: author.id)
                    }
            }
        }
        .onAppear {
            viewmodel.fetchMangasByAuthor(idAuthor: author.id)
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert, actions: {
            Button("Try again") {
                viewmodel.fetchMangasByAuthor(idAuthor: author.id)
            }
            Button {
                viewmodel.showAlert = false
            } label: {
                Text("Cancel")
            }
        }, message: {
            Text(viewmodel.errorMessage)
        })
        .navigationTitle(author.firstName)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    path = NavigationPath()
                } label: {
                    Text("Back to home")
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        MangaByAuthorView(path: .constant(NavigationPath()), author: Author(id: "AC7020D1-D99F-4846-8E23-9C86181959AF", role: "Story & Art", firstName: "Masashi", lastName: "Kishimoto"))
    }
}
