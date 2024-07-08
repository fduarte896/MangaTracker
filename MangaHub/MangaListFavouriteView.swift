
import SwiftUI

struct MangaListFavouriteView: View {
    
    @StateObject var viewmodel = MangaListFavouriteViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewmodel.loadedFavouriteMangas.isEmpty {
                    ContentUnavailableView("No Mangas Found", systemImage: "star.slash", description: Text("You have not added any manga yet"))
                } else {
                    List {
                        ForEach(viewmodel.filteredMangas) { manga in
                            NavigationLink(value: manga) {
                                MangaCellView(manga: manga)
                            }
                        }
                        .onDelete(perform: viewmodel.deleteMangas)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    EditButton()
                }
            }
            .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
                Text(viewmodel.errorMessage)
            }
            .searchable(text: $viewmodel.searchFavManga, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search Favourite Manga"))
            .onAppear {
                viewmodel.showFavourites()
            }
            .navigationDestination(for: MangaModel.self) { manga in
                MangaDetailFavouriteView(viewmodel: MangaDetailFavouriteViewModel(manga: manga))
            }
            .navigationTitle("My Favorite Mangas")
        }
    }
}



#Preview {
    MangaListFavouriteView()
}



