import SwiftUI

/// `BucketListDetailViewiPad` es una vista que muestra los detalles de un manga específico en la lista de deseos del usuario, optimizada para iPad.
/// Permite al usuario ver detalles adicionales del manga, agregarlo a su colección, y compartir su información.
struct BucketListDetailViewiPad: View {
    
    @StateObject var viewmodel: DetailViewModel
    @State var isExpanded: Bool = false
    
    var body: some View {
        ScrollView {
            /// Título del manga, centrado en la parte superior de la vista.
            Text(viewmodel.manga.title)
                .font(.title)
                .bold()
                .foregroundStyle(Color.orangeMangaTracker)
                .multilineTextAlignment(.center)
            
            /// Desplazamiento horizontal para mostrar los autores del manga.
            ScrollView(.horizontal) {
                HStack(alignment: .center) {
                    ForEach(viewmodel.manga.authors) { author in
                        if viewmodel.manga.authors.count > 2 {
                            Text(author.authorCompleteName)
                                .padding(.leading)
                                .foregroundStyle(Color.orangeMangaTracker)
                        } else {
                            Text(author.authorCompleteName)
                                .frame(width: UIScreen.main.bounds.width / CGFloat(viewmodel.manga.authors.count) - 20)
                                .foregroundStyle(Color.grayMangaTracker)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom)
            }
            .scrollIndicators(.hidden)

            /// Vista del póster del manga.
            PosterView(manga: viewmodel.manga, isCarousel: true, isiPadAndSmall: false)
                .padding(.top, -30)

            /// Detalles del manga formateados.
            Text(viewmodel.formatMangaDetails())
                .font(.footnote)
                .foregroundStyle(Color.grayMangaTracker)
        
            /// Botón para agregar el manga a la colección del usuario.
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
                        .font(.title3)
                    Text(viewmodel.isMyCollectionButtonDisable ? "Added to My collection" : "My Collection")
                        .font(.title3)
                }
            }
            .foregroundStyle(Color.grayMangaTracker)
            .padding(.vertical)
            
            /// Descripción extendida del manga, con opción de expandir o contraer el texto.
            Text(viewmodel.manga.background ?? "")
                .multilineTextAlignment(.leading)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.grayMangaTracker)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .lineLimit(isExpanded ? .max : 2)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                .font(.title3)
                .multilineTextAlignment(.trailing)
            
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                Text(isExpanded ? "Show Less" : "Read More")
            }
            
            /// Vista adicional con detalles extra del manga.
            ExtraDetailsView(viewmodel: viewmodel)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.grayMangaTracker)
                .background(RoundedRectangle(cornerRadius: 20)
                    .fill(Color.grayMangaTracker)
                    .opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
        .background(
            LinearGradient(colors: [Color.gradientTopColor, Color.gradientBottomColor], startPoint: .top, endPoint: .bottom)
        )
        .onAppear {
            viewmodel.checkMyCollection()
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.myError, actions: { error in
            Button("Try again") {
                switch error {
                case .checkMyCollection: viewmodel.checkMyCollection()
                case .saveToMyCollection: viewmodel.addToMyCollection()
                case .checkBucket:
                    break
                case .saveToBucket:
                    break
                }
            }
            Button {
                viewmodel.showAlert = false
            } label: {
                Text("Cancel")
            }
        }, message: {
            Text($0.errorDescription ?? "Error loading your mangas.")
        })
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                /// Botón para compartir el manga.
                ShareLink(item: viewmodel.manga.validURL) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }

            ToolbarItem(placement: .primaryAction) {
                /// Botón para compartir el manga (repetido para iPad, puede ser eliminado si no es necesario).
                ShareLink(item: viewmodel.manga.validURL ) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}

#Preview {
    BucketListDetailViewiPad(viewmodel: DetailViewModel(manga: .preview))
}
