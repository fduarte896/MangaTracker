import SwiftUI

/// `BucketListView` es una vista que muestra la lista de deseos (bucket list) de mangas del usuario.
/// Permite al usuario buscar, reorganizar, eliminar y navegar a los detalles de los mangas en su lista de deseos.
/// La vista se adapta a las condiciones del contenido, mostrando mensajes personalizados cuando la lista está vacía o cuando no se encuentran mangas que coincidan con la búsqueda.
struct BucketListView: View {
    @StateObject var viewmodelBucket = BucketListViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo degradado para la vista.
                LinearGradient(colors: [Color.gradientTopColor, Color.gradientBottomColor], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Group {
                    // Condicional para mostrar "No Mangas Found" cuando no hay resultados de búsqueda.
                    if viewmodelBucket.successSearch == false {
                        ContentUnavailableView("No Mangas Found", systemImage: "popcorn", description: Text("We couldn't find any manga called \(viewmodelBucket.searchedText)"))
                            .foregroundStyle(Color.grayMangaTracker)
                    } else {
                        // Condicional para mostrar "Your Bucket List is empty" cuando la lista de deseos está vacía.
                        if viewmodelBucket.loadedBucketMangas.isEmpty {
                            ContentUnavailableView("Your Bucket List is empty", systemImage: "bookmark.slash", description: Text("Go to the explore section and add some exciting mangas to your bucket list"))
                                .foregroundStyle(Color.grayMangaTracker)
                        } else {
                            // Lista que muestra los mangas en la lista de deseos.
                            List {
                                ForEach(viewmodelBucket.filteredBucketMangas) { manga in
                                    NavigationLink(value: manga) {
                                        CellView(manga: manga, showOwnedVolumes: false, isSearchListView: true)
                                    }
                                    .listRowBackground(Color.clear)
                                }
                                .onMove { source, destination in
                                    viewmodelBucket.loadedBucketMangas.move(fromOffsets: source, toOffset: destination)
                                    viewmodelBucket.saveBucketMangas()
                                }
                                .onDelete(perform: viewmodelBucket.deleteBucketMangas(indexSet:))
                            }
                            .refreshable {
                                viewmodelBucket.loadMyBucketFromJSON()
                            }
                            .listStyle(.inset)
                            .safeAreaInset(edge: .bottom) {
                                // Muestra el total de mangas en la lista.
                                Text("Total: \(viewmodelBucket.loadedBucketMangas.count)")
                                    .foregroundStyle(Color.white)
                                    .bold()
                                    .padding(.horizontal)
                                    .background(Color.gray.opacity(0.9))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10).stroke(Color.orangeMangaTracker, lineWidth: 2)
                                    }
                                    .frame(width: 100)
                                    .padding(.bottom, 5)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bucket List")
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    EditButton()
                }
            }
            .searchable(text: $viewmodelBucket.searchBucketManga, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search in your bucket list")
            .onChange(of: viewmodelBucket.searchBucketManga) { oldValue, newValue in
                viewmodelBucket.search(text: newValue)
            }
            .onAppear {
                viewmodelBucket.loadMyBucketFromJSON()
            }
            .navigationDestination(for: MangaModel.self) { manga in
                BucketListDetailView(viewmodel: DetailViewModel(manga: manga))
            }
        }
    }
}

#Preview {
    BucketListView()
}
