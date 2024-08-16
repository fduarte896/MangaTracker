import SwiftUI

/// `DetailViewiPad` es una vista diseñada para mostrar la información detallada de un manga específico en dispositivos iPad.
///
/// Esta versión sigue la misma estructura que la versión para iPhone (`DetailView`), pero ajusta los tamaños de los botones,
/// las fuentes y el poster para adecuarse a la pantalla más grande del iPad.
///- Note: La vista está optimizada para ofrecer una experiencia adecuada en pantallas grandes como la del iPad.

struct DetailViewiPad: View {
    
    @StateObject var viewmodel: DetailViewModel
    @StateObject var viewmodelBucket = BucketListViewModel()
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @State var isExpanded: Bool = false
    
    var body: some View {
        
        Text(viewmodel.manga.title)
            .font(.largeTitle)
            .bold()
            .foregroundStyle(Color.orangeMangaTracker)
            .multilineTextAlignment(.center)
            .padding(.horizontal)

        /// Muestra la portada del manga con el tamaño adecuado para el iPad.
        PosterView(manga: viewmodel.manga, isCarousel: true, isiPadAndSmall: false)
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
        
        /// Muestra los botones de agregar a la colección o a la Bucket List con tamaños adecuados para iPad.
        HStack(alignment: .center, spacing: 20) {
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
                        .font(.title3)
                    Text(viewmodel.isMyCollectionButtonDisable ? "Added to My collection" : "My Collection")
                        .font(.title3)
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
                            .font(.title3)
                        Text(viewmodel.isMyBucketButtonDisable ? "Added to My Bucket List" : "My Bucket")
                            .font(.title3)
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
            .frame(maxWidth: .infinity)
            .background(Color.grayMangaTracker)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .lineLimit(isExpanded ? nil : 7)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            .multilineTextAlignment(.trailing)
            .font(.title3)
        
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
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.grayMangaTracker)
            .background(RoundedRectangle(cornerRadius: 20)
                .fill(Color.grayMangaTracker)
                .opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    DetailViewiPad(viewmodel: DetailViewModel(manga: .preview))
}
