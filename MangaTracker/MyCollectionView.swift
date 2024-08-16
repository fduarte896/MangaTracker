import SwiftUI

/// `MyCollectionListView` es una vista que muestra la lista de mangas en la colección del usuario,
/// permitiendo buscar, eliminar y reorganizar los mangas. La vista también proporciona una interfaz de búsqueda para filtrar mangas en la colección.
///
///
/// - Note: La vista incluye un fondo de gradiente, un mensaje de aviso cuando no se encuentran mangas o la colección está vacía,
///   y un botón de edición para eliminar o mover mangas en la lista.

struct MyCollectionListView: View {
    
    @StateObject var viewmodelCollection = MyCollectionListViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                /// Fondo con gradiente.
                LinearGradient(colors: [Color.gradientTopColor, Color.gradientBottomColor], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Group {
                    /// Muestra un mensaje si no se encuentran mangas en la búsqueda.
                    if viewmodelCollection.successSearch == false {
                        ContentUnavailableView("No Mangas Found", systemImage: "popcorn", description: Text("We couldn't find any manga called \(viewmodelCollection.searchedText)"))
                            .foregroundStyle(Color.grayMangaTracker)
                    } else {
                        /// Muestra un mensaje si la colección está vacía.
                        if viewmodelCollection.loadedMyCollectionMangas.isEmpty {
                            ContentUnavailableView("Your collection is empty", systemImage: "magazine", description: Text("Go to the explore section and add some exciting mangas to your collection!"))
                                .foregroundStyle(Color.grayMangaTracker)
                        } else {
                            /// Muestra la lista de mangas en la colección.
                            List {
                                ForEach(viewmodelCollection.filteredMangas) { manga in
                                    NavigationLink(value: manga) {
                                        CellView(manga: manga, showOwnedVolumes: true, isSearchListView: true)
                                    }
                                    .listRowBackground(Color.clear)
                                }
                                /// Permite eliminar mangas de la colección.
                                .onDelete(perform: viewmodelCollection.deleteMangas)
                                /// Permite reorganizar los mangas en la lista.
                                .onMove { source, destination in
                                    viewmodelCollection.loadedMyCollectionMangas.move(fromOffsets: source, toOffset: destination)
                                    viewmodelCollection.saveCollectionMangas()
                                }
                            }
                            .refreshable(action: {
                                /// Recarga los datos de la colección y la lista de deseos.
                                viewmodelCollection.LoadMyCollectionFromJSON()
                            })
                            /// Muestra el número total de mangas en la colección.
                            .safeAreaInset(edge: .bottom) {
                                Text("Total: \(viewmodelCollection.loadedMyCollectionMangas.count)")
                                    .foregroundStyle(Color.white)
                                    .bold()
                                    .padding(.horizontal)
                                    .background(Color.gray.opacity(0.9))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(content: {
                                        RoundedRectangle(cornerRadius: 10).stroke(Color.orangeMangaTracker, lineWidth: 2)
                                    })
                                    .frame(width: 100)
                                    .padding(.bottom, 5)
                            }
                        }
                    }
                }
            }
            /// Botón para editar la lista (eliminar o mover elementos).
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    EditButton()
                }
            }
            /// Alerta en caso de que ocurra un error con la colección.
            .alert("Something went wrong with your collection", isPresented: $viewmodelCollection.showAlert) {
                Text(viewmodelCollection.errorMessage)
            }
            /// Barra de búsqueda para filtrar la colección.
            .searchable(text: $viewmodelCollection.searchQueryCollection, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search in your collection"))
            .onChange(of: viewmodelCollection.searchQueryCollection) { oldValue, newValue in
                viewmodelCollection.search(text: newValue)
            }
            /// Carga inicial de datos al aparecer la vista.
            .onAppear {
                viewmodelCollection.LoadMyCollectionFromJSON()
            }
            /// Navega a la vista de detalles de un manga al seleccionarlo.
            .navigationDestination(for: MangaModel.self) { manga in
                MyCollectionDetailView(viewmodel: MyCollectionDetailViewModel(manga: manga))
            }
            .navigationTitle("My Collection")
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    TabView {
        NavigationStack {
            MyCollectionListView()
        }
    }
}
