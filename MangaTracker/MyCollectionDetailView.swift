import SwiftUI

/// `MyCollectionDetailView` es una vista que muestra los detalles de un manga específico en la colección del usuario.
///
/// Esta vista permite al usuario ver información detallada sobre el manga, incluyendo los autores, volúmenes disponibles, y otros detalles
/// relevantes. La vista también proporciona herramientas para gestionar la colección del manga, como marcar volúmenes como leídos
/// y compartir o visitar el sitio web del manga.
///
/// - Note: La vista incluye una barra de herramientas con opciones para compartir el manga o visitar su página web.
///   Además, maneja el seguimiento de los volúmenes y muestra mensajes de felicitaciones si la colección está completa.
///

struct MyCollectionDetailView: View {
    
    @StateObject var viewmodel: MyCollectionDetailViewModel
    
    var body: some View {
        ScrollView {
            /// Muestra el título del manga.
            Text(viewmodel.manga.title)
                .font(.title)
                .bold()
                .foregroundStyle(Color.orangeMangaTracker)
                .multilineTextAlignment(.center)
                .padding(.top, 0)
            
            /// Muestra los autores del manga.
            HStack(alignment: .center) {
                ForEach(viewmodel.manga.authors) { author in
                    if viewmodel.manga.authors.count > 2 {
                        Text(author.authorCompleteName)
                            .padding(.leading)
                            .foregroundStyle(Color.grayMangaTracker)
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
            
            /// Muestra la portada del manga con un tamaño llamativo y protagonista.
            PosterView(manga: viewmodel.manga, isCarousel: true, isiPadAndSmall: false)
                .padding(.top, -30)
            
            /// Muestra detalles formateados del manga.
            Text(viewmodel.formatMangaDetails())
                .font(.footnote)
                .foregroundStyle(Color.grayMangaTracker)
            
            if viewmodel.manga.volumes != nil {
                /// Muestra un `GaugeView` si el manga tiene volúmenes.
                /// Este `GaugeView` permite al usuario marcar los volúmenes que tiene en su colección y refleja el progreso en la vista.
                GaugeView(viewmodel: viewmodel)
                    .padding(.horizontal)
                
                Divider()
                    .background(Color.grayMangaTracker)
                
                /// Muestra un segundo `GaugeView` para que el usuario lleve la cuenta de la lectura del manga.
                Gauge2(viewmodel: viewmodel)
                    .padding(.horizontal)
            } else {
                /// Muestra un mensaje si no hay volúmenes disponibles para el manga.
                VStack {
                    Image(systemName: "x.circle")
                        .foregroundStyle(Color.orangeMangaTracker)
                        .font(.title)
                    Text("No volume tracking available for this manga")
                        .foregroundStyle(Color.grayMangaTracker)
                }
                .frame(width: 300, height: 100)
                .background(RoundedRectangle(cornerRadius: 9.0)
                    .fill(Color.grayMangaTracker)
                    .opacity(0.3))
            }
            
            /// Muestra detalles adicionales del manga.
            ExtraDetailsMyCollectionView(viewmodel: viewmodel)
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
                .ignoresSafeArea()
        )
        /// Configura una barra de herramientas con opciones para compartir y navegar al sitio web del manga.
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
        /// Muestra una alerta si ocurre un error al guardar el progreso de lectura.
        .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
            Button("Try again") {
                viewmodel.persistReadingVolume()
            }
            Button {
                viewmodel.showAlert = false
            } label: {
                Text("Cancel")
            }
        } message: {
            Text(viewmodel.errorMessage)
        }
    }
}

#Preview {
    NavigationStack {
        MyCollectionDetailView(viewmodel: MyCollectionDetailViewModel(manga: .preview))
    }
}
