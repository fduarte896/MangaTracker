import SwiftUI

/// `ExploreView` es la vista principal para la exploración de mangas. Muestra una lista de los mejores mangas, permite la navegación entre diferentes categorías y ofrece un carrusel de mangas aleatorios en la parte superior.
struct ExploreView: View {
    
    @StateObject var viewmodelExplore = ExploreViewModel()
    @StateObject var viewmodelColl = MyCollectionListViewModel()
    @StateObject var viewmodelBucket = BucketListViewModel()
    
    /// Array de categorías disponibles para explorar.
    var arrayCats: [String] = ["Genres", "Demographics", "Themes"]

    @State private var path = NavigationPath()
    @State private var currentIndex = 0
    
    /// Temporizador para el carrusel de mangas.
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    /// Configuración del grid para mostrar mangas en una cuadrícula.
    let gridMangas: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]

    /// Identificación del tipo de dispositivo (iPhone o iPad).
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        NavigationStack(path: $path) {
            
            if UIDevice.isIPad {
                /// Vista específica para iPad.
                ExploreViewiPad()
            } else {
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
                                    /// Vista principal con carrusel, estadísticas y categorías.
                                    ScrollView {
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
                                        .frame(height: 300)
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
                                            LazyVGrid(columns: gridMangas, spacing: 20) {
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
                .navigationBarTitleDisplayMode(.automatic)
            }
        }
    }
}

#Preview("PREVIEW DATA") {
    ExploreView(viewmodelExplore: ExploreViewModel(interactor: MangaInteractor()))
}
