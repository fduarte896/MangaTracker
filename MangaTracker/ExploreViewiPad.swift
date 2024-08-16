import SwiftUI

/// `ExploreViewiPad` es una vista adaptada para iPad que muestra una interfaz de exploración de mangas.
/// Incluye un carrusel de mangas, estadísticas de la colección y bucket list del usuario, y acceso a diferentes categorías.
struct ExploreViewiPad: View {
    
    @StateObject var viewmodelExplore = ExploreViewModel()
    @StateObject var viewmodelColl = MyCollectionListViewModel()
    @StateObject var viewmodelBucket = BucketListViewModel()
    
    /// Array de categorías disponibles.
    var arrayCats: [String] = ["Genres", "Demographics", "Themes"]

    @State private var path = NavigationPath()
    @State private var currentIndex = 0
    
    /// Temporizador para el carrusel de mangas.
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    /// Configuración del grid específico para iPad.
    let gridMangasiPad: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            /// Fondo con gradiente.
            LinearGradient(colors: [Color.gradientTopColor, Color.gradientBottomColor], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Group {
                /// Mensaje de "No Mangas Found" cuando no se encuentran resultados en la búsqueda.
                if viewmodelExplore.successSearch == false {
                    ContentUnavailableView("No Mangas Found", systemImage: "popcorn", description: Text("We couldn't find any manga called \(viewmodelExplore.searchedText)"))
                        .foregroundStyle(Color.grayMangaTracker)
                } else {
                    ZStack {
                        /// Muestra una lista de mangas cuando hay una búsqueda activa.
                        if viewmodelExplore.isList {
                            List(viewmodelExplore.mangas) { manga in
                                NavigationLink(value: manga) {
                                    CellView(manga: manga, showOwnedVolumes: false, isSearchListView: true)
                                        .onAppear {
                                            viewmodelExplore.checkForMoreMangas(lastManga: manga)
                                        }
                                }
                                .listRowBackground(Color.clear)
                            }
                        } else {
                            ScrollView {
                                /// Sección con estadísticas de la colección y bucket list del usuario.
                                HStack(spacing: 40) {
                                    HStack {
                                        Text("Your Collection:")
                                        Text(" \(viewmodelColl.loadedMyCollectionMangas.count)")
                                    }
                                    HStack {
                                        Text("Your Bucket List:")
                                        Text(" \(viewmodelBucket.filteredBucketMangas.count)")
                                    }
                                }
                                .foregroundStyle(Color.orangeMangaTracker)
                                .bold()
                                .font(.title2)
                                
                                /// Carrusel de mangas.
                                TabView(selection: $currentIndex) {
                                    ForEach(viewmodelExplore.mangas.indices, id: \.self) { index in
                                        NavigationLink(value: viewmodelExplore.mangas[index]) {
                                            PosterView(manga: viewmodelExplore.mangas[index], isCarousel: true, isiPadAndSmall: false)
                                                .tag(index)
                                        }
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                .frame(width: 400, height: 550)
                                .onReceive(timer) { _ in
                                    if viewmodelExplore.mangas.count > 0 {
                                        withAnimation {
                                            currentIndex = (currentIndex + 1) % viewmodelExplore.mangas.count
                                        }
                                    } else {
                                        currentIndex = 0
                                    }
                                }

                                /// Sección de categorías.
                                ZStack {
                                    Color.gray.opacity(0.3)
                                    VStack {
                                        Divider()
                                        HStack(spacing: 30) {
                                            ForEach(arrayCats, id: \.self) { category in
                                                NavigationLink(value: category) {
                                                    if category == "Genres" {
                                                        VStack {
                                                            Image(systemName: "books.vertical")
                                                            Text(category)
                                                                .bold()
                                                        }
                                                    } else if category == "Demographics" {
                                                        VStack {
                                                            Image(systemName: "person.3")
                                                            Text(category)
                                                                .bold()
                                                        }
                                                    } else if category == "Themes" {
                                                        VStack {
                                                            Image(systemName: "tag")
                                                            Text(category).bold()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .tint(Color.orangeMangaTracker)
                                        .padding(.top)
                                        Divider()
                                    }
                                }
                                
                                /// Sección de top 10 mangas.
                                VStack(alignment: .center) {
                                    Text("**Top 10 Mangas**")
                                        .foregroundStyle(Color.grayMangaTracker)
                                        .padding(.horizontal)
                                        .font(.title)
                                    LazyVGrid(columns: gridMangasiPad, spacing: 20) {
                                        ForEach(Array(viewmodelExplore.bestMangasArray.enumerated()), id: \.offset) { (index, manga) in
                                            NavigationLink(value: manga) {
                                                VStack {
                                                    HStack {
                                                        TopMangaPosterView(manga: manga, topIndex: index)
                                                    }
                                                    Text("Score: \(manga.score.formatted())")
                                                        .foregroundColor(Color.grayMangaTracker)
                                                        .bold()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .onAppear {
            viewmodelColl.LoadMyCollectionFromJSON()
            viewmodelBucket.loadMyBucketFromJSON()
        }
        .navigationDestination(for: String.self) { category in
            NewCategoriesView(category: category)
        }
        .navigationDestination(for: MangaModel.self) { manga in
            DetailView(viewmodel: DetailViewModel(manga: manga))
        }
        .navigationDestination(for: Author.self) { author in
            ListByAuthorView(path: $path, author: author)
        }
        .onChange(of: viewmodelExplore.searchedText) {
            viewmodelExplore.onChangeText()
        }
        .alert("Something went wrong", isPresented: $viewmodelExplore.showAlert, presenting: viewmodelExplore.myError, actions: { error in
            Button("Try again") {
                switch error {
                case .carrouselMangasError: viewmodelExplore.fetchAllMangas()
                case .bestMangasError: viewmodelExplore.fetchBestMangas()
                case .checkForMoreMangasError:
                    if let lastManga = viewmodelExplore.theLastManga {
                        viewmodelExplore.checkForMoreMangas(lastManga: lastManga)
                    }
                default:
                    viewmodelExplore.fetchAllMangas()
                    viewmodelExplore.fetchBestMangas()
                }
            }
            Button {
                viewmodelExplore.showAlert = false
            } label: {
                Text("Cancel")
            }
        }, message: { error in
            switch error {
            case .carrouselMangasError: Text(viewmodelExplore.errorMessage)
            case .bestMangasError: Text(viewmodelExplore.errorMessage)
            case .checkForMoreMangasError: Text(viewmodelExplore.errorMessage)
            case .searchError: Text(viewmodelExplore.errorMessage)
            case .none: Text(viewmodelExplore.errorMessage)
            }
        })
        .searchable(text: $viewmodelExplore.searchedText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search any manga"))
        .autocorrectionDisabled()
        .navigationTitle("Explore")
    }
}

#Preview {
    ExploreViewiPad()
}
