import SwiftUI

/// Vista que muestra una lista de mangas asociados a un autor específico, es una vista simple con una lista que muestra el título del manga, el score quie tiene y un poster pequeño.
struct ListByAuthorView: View {
    
    @StateObject var viewmodel = ExploreViewModel()
    @Binding var path: NavigationPath
    
    var author: Author
    
    var body: some View {
        ZStack {
            /// Fondo con gradiente.
            LinearGradient(colors: [Color.gradientTopColor, Color.gradientBottomColor], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    /// Muestra una lista de mangas asociados al autor.
                    ForEach(viewmodel.mangasByAuthor) { manga in
                        NavigationLink(value: manga) {
                            CellView(manga: manga, showOwnedVolumes: false, isSearchListView: false)
                                .onAppear {
                                    /// Comprueba si es necesario cargar más mangas al llegar al final de la lista.
                                    viewmodel.checkForMoreMangasAuthor(manga: manga, idAuthor: author.id)
                                }
                                .listRowBackground(Color.clear)
                        }
                    }
                }
                .background(Color.clear)
                .onAppear {
                    /// Carga los mangas asociados al autor al aparecer la vista.
                    viewmodel.fetchMangasByAuthor(idAuthor: author.id)
                }
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
            
            /// Título de la vista con el nombre del autor.
            .navigationTitle("Author: \(author.firstName)")

        }
    }
}

#Preview {
    NavigationStack {
        ListByAuthorView(path: .constant(NavigationPath()), author: Author(id: "AC7020D1-D99F-4846-8E23-9C86181959AF", role: "Story & Art", firstName: "Masashi", lastName: "Kishimoto"))
    }
}
