
import SwiftUI

struct AllCategoriesView: View {
    
    @StateObject var viewmodel = MangaCategoriesViewModel()
    @State private var pathCategories = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $pathCategories) {
            List(viewmodel.categories, id: \.self) { category in
                NavigationLink(value: category) {
                    VStack {
                        Text(category)
                    }
                }
            }
            .navigationDestination(for: String.self) { category in
                MangasByCategoryView(pathCategories: $pathCategories, category: category, type: viewmodel.categoryType)
            }
            .navigationDestination(for: MangaModel.self) { manga in
                MangaDetailView(vmData: MangaDetailViewModel(manga: manga))
            }
            .navigationDestination(for: Author.self) { author in
                MangaByAuthorView(path: $pathCategories, author: author)
            }
            Button("Genres") {
                viewmodel.fetchGenres()
                viewmodel.categoryType = "Genres"
            }
            .padding()
            
            Button("Demographics") {
                viewmodel.fetchDemographics()
                viewmodel.categoryType = "Demographics"
            }
            .padding()
            
            Button("Themes") {
                viewmodel.fetchThemes()
                viewmodel.categoryType = "Themes"
            }
            .padding()
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.myError) { error in
            Button("Try again") {
                switch error {
                case .fetchGenres : viewmodel.fetchGenres()
                case .fetchThemes : viewmodel.fetchThemes()
                case .fetchDemographics : viewmodel.fetchDemographics()
                }
            }
            Button {
                viewmodel.showAlert = false
            } label: {
                Text("Cancel")
            }
        } message: {
            Text($0.errorDescription)
//            error in
//            switch error {
//            case .fetchGenres : Text("Error loading genres")
//            case .fetchThemes : Text("Error loading themes")
//            case .fetchDemographics : Text("Error loading demographics")
            }
        }

    }


#Preview {
    NavigationStack{
        AllCategoriesView()
    }
}
