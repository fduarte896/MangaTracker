import SwiftUI

/// `DetailView` es una vista que muestra la información detallada de un manga específico.
///
/// Esta vista está diseñada para ser utilizada tanto en dispositivos iPhone como iPad, ajustándose
/// al tamaño y orientación de la pantalla del dispositivo. Muestra detalles como el título, la portada,
/// los autores, la sinopsis y permite al usuario agregar el manga a su colección o a la Bucket List.
///
/// La vista también maneja la posibilidad de compartir el manga o acceder a su URL válida.
///
///
/// - Note: La vista cambia de diseño dependiendo si se ejecuta en un iPhone o iPad.

struct DetailView: View {
    
    @StateObject var viewmodel: DetailViewModel
    @StateObject var viewmodelBucket = BucketListViewModel()

    @State var isExpanded: Bool = false

    var body: some View {
        
        ScrollView {
            
            if UIDevice.isIPhone {

                Text(viewmodel.manga.title)
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.orangeMangaTracker)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                /// Muestra la portada del manga con el tamaño adecuado para el iPhone.
                PosterView(manga: viewmodel.manga, isCarousel: true, isiPadAndSmall: true)
                    .padding(.top, -30)

                /// Muestra los detalles formateados del manga.
                Text(viewmodel.formatMangaDetails())
                    .font(.footnote)
                    .foregroundStyle(Color.grayMangaTracker)

                /// Muestra los autores del manga.
                Text("by")
                    .font(.caption)
                    .padding(.vertical, 1)
                    .foregroundStyle(Color.grayMangaTracker)
                
                ScrollView(.horizontal) {
                    HStack(alignment: .center) {
                        ForEach(viewmodel.manga.authors) { author in
                            NavigationLink(value: author) {
                                if viewmodel.manga.authors.count > 2 {
                                    Text(author.authorCompleteName)
                                        .padding(.leading)
                                        .foregroundStyle(Color.orangeMangaTracker)
                                } else {
                                    Text(author.authorCompleteName)
                                        .frame(width: UIScreen.main.bounds.width / CGFloat(viewmodel.manga.authors.count) - 20)
                                        .foregroundStyle(Color.orangeMangaTracker)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom)
                }
                .scrollIndicators(.hidden)

                /// Muestra los botones de agregar a la colección o a la Bucket List los cuales son dinámicos y cambian al ser presionados.
                HStack(alignment: .center, spacing: 20){
                    CircularGaugeView(manga: viewmodel.manga)
                    
                    Button {
                        withAnimation {
                            viewmodel.isPressed = true
                        }
                        viewmodel.addToMyCollection()
                        viewmodel.isMyCollectionButtonDisable = true
                    } label: {
                        VStack {
                            Image(systemName: viewmodel.isMyCollectionButtonDisable ? "checkmark" : "plus")
                                .foregroundStyle(Color.orangeMangaTracker)
                            Text(viewmodel.isMyCollectionButtonDisable ? "Added to My collection" : "My Collection")
                                .font(.footnote)
                        }
                    }
                    .disabled(viewmodel.isMyCollectionButtonDisable)
                    .animation(.easeInOut(duration: 0.3), value: viewmodel.isPressed)
                    .foregroundStyle(Color.grayMangaTracker)
                    .bold()

                    if !viewmodel.isMyCollectionButtonDisable {
                        Button {
                            viewmodel.addToMyBucket()
                            viewmodel.isMyBucketButtonDisable = true
                        } label: {
                            VStack {
                                Image(systemName: viewmodel.isMyBucketButtonDisable ? "checkmark" : "plus")
                                    .foregroundStyle(Color.orangeMangaTracker)
                                Text(viewmodel.isMyBucketButtonDisable ? "Added to My Bucket List" : "My Bucket")
                                    .font(.footnote)
                            }
                        }
                        .disabled(viewmodel.isMyBucketButtonDisable)
                        .foregroundStyle(Color.grayMangaTracker)
                        .bold()
                    }
                }
                .padding(.bottom)
                
                /// Muestra la sinopsis del manga, con opción de expandir o colapsar.
                Text(viewmodel.manga.sypnosis ?? "")
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(width: 400)
                    .background(Color.grayMangaTracker)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .lineLimit(isExpanded ? nil : 7)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                    .multilineTextAlignment(.trailing)
                
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    Text(isExpanded ? "Show Less" : "Read More")
                }

                /// Muestra los detalles adicionales del manga.
                ExtraDetailsView(viewmodel: viewmodel)
                    .padding()
                    .frame(width: 400)
                    .foregroundStyle(Color.grayMangaTracker)
                    .background(RoundedRectangle(cornerRadius: 20)
                        .fill(Color.grayMangaTracker)
                        .opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            } else if UIDevice.isIPad {
                /// Carga la vista específica para iPad.
                DetailViewiPad(viewmodel: viewmodel)
            }
        }
        .background(
            LinearGradient(colors: [Color.gradientTopColor, Color.gradientBottomColor], startPoint: .top, endPoint: .bottom)
        )
        .onAppear {
            /// Comprueba si el manga está en la colección o en la lista de deseos al aparecer la vista.
            viewmodel.checkMyCollection()
            viewmodel.checkMyBucket()
            print(viewmodel.isMyBucketButtonDisable)
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.myError, actions: { error in
            Button("Try again") {
                switch error {
                case .checkMyCollection: viewmodel.checkMyCollection()
                case .saveToMyCollection: viewmodel.addToMyCollection()
                case .checkBucket: viewmodel.checkMyBucket()
                case .saveToBucket: viewmodel.addToMyBucket()
                }
            }
            Button {
                viewmodel.showAlert = false
            } label: {
                Text("Cancel")
            }
        }, message: {
            Text($0.errorDescription ?? "Error loading your Mangas")
        })
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: viewmodel.manga.validURL) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Link(destination: viewmodel.manga.validURL, label: {
                    Image(systemName: "globe")
                })
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(viewmodel: DetailViewModel(manga: .preview))
    }
}
