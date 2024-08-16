//
//import SwiftUI
//
//struct ListAndGridView: View {
//    
//    @StateObject var viewmodel = ExploreViewModel()
//    
//    @State private var path = NavigationPath()
//    
//    let gridMangas: [GridItem] = [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    
//    let gridMangasiPad: [GridItem] = [
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    
//    let deviceType = UIDevice.current.userInterfaceIdiom
//    
//    //fetchmangas, fetchbest, onchangetext, showBestMangas,
//    
//    var body: some View {
//        
//        NavigationStack(path: $path) {
//            Group {
//                if viewmodel.successSearch == false {
//                    ContentUnavailableView("No Mangas Found", systemImage: "popcorn", description: Text("We couldn't find any manga called \(viewmodel.searchedText)"))
//                } else {
//                    if viewmodel.isList {
//                        List(viewmodel.mangas) { manga in
//                            NavigationLink(value: manga) {
//                                CellView(manga: manga, showOwnedVolumes: false)
//                                    .onAppear {
//                                        viewmodel.checkForPagination(manga1: manga)
//                                    }
//                            }
//                        }
//                    } else {
//                        ScrollView {
//                            LazyVGrid(columns: deviceType == .pad ? gridMangasiPad : gridMangas, spacing: 20) {
//                                ForEach(viewmodel.mangas) { manga in
//                                    NavigationLink(value: manga) {
//                                        VStack {
//                                            PosterView(manga: manga, isCarrousel: false)
//                                            
//                                            Text(manga.title)
//                                                .font(.title2)
//                                                .bold()
//                                                .foregroundColor(.primary)
//                                            
//                                            Text("\(manga.authors.first?.firstName ?? "") \(manga.authors.first?.lastName ?? "")")
//                                                .font(.footnote)
//                                                .foregroundColor(.secondary)
//                                            
//                                            Text("Score: \(manga.score.formatted())")
//                                                .foregroundColor(.primary)
//                                            
//                                            Text(manga.formattedStartDate)
//                                                .foregroundColor(.primary)
//                                        }
//                                    }
//                                    .onAppear {
//                                        viewmodel.checkForPagination(manga1: manga)
//                                    }
//                                }
//                            }
//                            .padding()
//                        }
//                    }
//                }
//            }
//            .navigationDestination(for: MangaModel.self) { manga in
//                DetailView(viewmodel: DetailViewModel(manga: manga))
//            }
//            .navigationDestination(for: Author.self) { author in
//                ListByAuthorView(path: $path, author: author)
//            }
//            .onChange(of: viewmodel.searchedText) {
//                viewmodel.onChangeText()
//            }
////            .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.myError, actions: { error in
////                Button("Try again") {
////                    switch error {
////                    case .carrouselMangasError: viewmodel.fetchAllMangas()
////                    case .bestMangasError: viewmodel.fetchBestMangas()
////                
////                }
////                Button {
////                    viewmodel.showAlert = false
////                } label: {
////                    Text("Cancel")
////                }
////                }, message: { error in
////                    switch error {
////                    case .carrouselMangasError: Text("Error loading mangas")
////                    case .bestMangasError: Text("Error loading best mangas")
////                        
////                        
////                    })
////                }
//            
//            .searchable(text: $viewmodel.searchedText)
//            .navigationTitle("Mangas")
//            .toolbar {
//                ToolbarItemGroup(placement: .secondaryAction) {
//                    Button(action: {
//                        viewmodel.showBestMangas()
//                    }) {
//                        Label("Best Mangas", systemImage: "star.fill")
//                    }
//                    Button(action: {
//                        viewmodel.resetAllMangas()
//                    }) {
//                        Label("Reset All Mangas", systemImage: "arrow.circlepath")
//                    }
//                    Button(action: {
//                        viewmodel.isList.toggle()
//                    }) {
//                        Label(viewmodel.isList ? "Change to Grid" : "Change to List", systemImage: viewmodel.isList ? "rectangle.grid.2x2" : "rectangle.grid.1x2")
//                    }
//                }
//            }
//        }
//    }
//}
//                   
//
//#Preview("PREVIEW DATA") {
//    ListAndGridView(viewmodel: ExploreViewModel(interactor: .preview))
//}
//
//
////#Preview("PRODUCTION DATA") {
////    MangaListView()
////}
//
