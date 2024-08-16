
import SwiftUI

struct ListByCategoryView: View {
    
    @StateObject var viewmodel = CategoriesViewModel()
    @Binding var pathCategories: NavigationPath
    var category: String
    var type: String
    
    var body: some View {
        
        List(viewmodel.mangasByCategory) { manga in
            NavigationLink(value: manga) {
                CellView(manga: manga, showOwnedVolumes: false, isSearchListView: false)
                    .onAppear {
//                        viewmodel.checkForMoreMangasCat(manga: manga, category: category)
             
                    }
            }
        }
        .onAppear {
            viewmodel.categoryType = type
//            viewmodel.categorySelected(category: category)
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.myErrorSpecific, actions: { error in
            Button("Try again") {
                switch error {
                case .fetchMangasByGenreError : viewmodel.fetchMangasByGenre(genre: category)
                case .fetchMangasByThemeError : viewmodel.fetchMangasByTheme(theme: category)
                case .fetchMangasByDemographicError : viewmodel.fetchMangasByDemographic(demographic: category)
                case .checkForMoreMangasError:
                    return
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
        ListByCategoryView(pathCategories: .constant(NavigationPath()),category: "Action", type: "Genre")
    }
}
