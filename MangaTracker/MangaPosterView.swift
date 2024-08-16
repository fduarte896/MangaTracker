//
//import SwiftUI
//
//struct MangaPosterView: View {
//    
//    var manga: MangaModel
//    
//    var body: some View {
//        AsyncImage(url: manga.mainPictureURL) { image in
//            image
//                .resizable()
//                .scaledToFit()
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//                .frame(width: 200, height: 200)
//                
//        } placeholder: {
//            ProgressView()
//                .controlSize(.extraLarge)
//                .scaledToFit()
//                .frame(width: 200, height: 200)
//        }
//    }
//}
//
//#Preview {
//    MangaPosterView(manga: .preview)
//}
//
