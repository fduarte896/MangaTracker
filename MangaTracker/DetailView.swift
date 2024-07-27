
import SwiftUI

struct DetailView: View {
    
    @StateObject var viewmodel: MangaDetailViewModel
    @StateObject var viewmodelBucket = BucketListViewModel()
    
    @State var isExpanded: Bool = false

    var body: some View {
        ScrollView() {
            
            /*Hacer que los botones no desaparezcan con el scroll*/
            HStack {
                ///My Collection Button
                Button {
                    withAnimation {
                        viewmodel.isPressed = true
                    }
                    viewmodel.addToMyCollection()
                    viewmodel.isMyCollectionButtonDisable = true
                    
                } label: {
                    Label(viewmodel.isMyCollectionButtonDisable ? "Added to My collection" : "Add to My Collection", systemImage: viewmodel.isMyCollectionButtonDisable ? "checkmark.circle" : "magazine")
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .frame(maxWidth: viewmodel.isPressed ? .infinity : nil)
                .disabled(viewmodel.isMyCollectionButtonDisable)
                .animation(.easeInOut(duration: 0.3), value: viewmodel.isPressed)
                
                ///Bucket Button
                if viewmodel.isMyCollectionButtonDisable == false{
                    Button {
                        viewmodel.addToMyBucket()
                        viewmodel.isMyBucketButtonDisable = true
                    } label: {
                        Label(viewmodel.isMyBucketButtonDisable ? "Added to My Bucket List" : "Add to my Bucket List", systemImage: viewmodel.isMyBucketButtonDisable ? "checkmark.circle" : "bookmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                    .disabled(viewmodel.isMyBucketButtonDisable)
                } else {
                    
                }
            }

            AsyncImage(url: viewmodel.manga.mainPictureURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(Rectangle())
            } placeholder: {
                ProgressView()
                    .controlSize(.extraLarge)
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
//            .padding()
            
            Text(viewmodel.manga.title)
                .font(.largeTitle)
                .bold()

            
            ScrollView(.horizontal){
                HStack(alignment: .center) {
                    ForEach(viewmodel.manga.authors) { author in
                        NavigationLink(value: author) {
                            
                            Text(author.authorCompleteName)
                                .padding(.leading)
                            
                        }
                    }
                }
            }.scrollIndicators(.hidden)
            
            Text(viewmodel.manga.sypnosis ?? "")
                .multilineTextAlignment(.leading)
                .lineLimit(isExpanded ? nil : 5)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                .multilineTextAlignment(.trailing)
            
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                Text(isExpanded ? "Show Less" : "Read More")
            }
            
            Link("Go to manga website", destination: viewmodel.manga.validURL)


        }
//        .navigationTitle(viewmodel.manga.title)
        .onAppear {
            viewmodel.checkMyCollection()
            viewmodel.checkMyBucket()
            print(viewmodel.isMyBucketButtonDisable)
            
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.myError, actions: { error in
            Button("Try again") {
                switch error {
                case .checkMyCollection: viewmodel.checkMyCollection()
                case .saveToMyCollection: viewmodel.addToMyCollection()
                case .checkBucket:
                    viewmodel.checkMyBucket()
                case .saveToBucket:
                    viewmodel.addToMyBucket()
                }
            }
            Button {
                viewmodel.showAlert = false
            } label: {
                Text("Cancel")
            }
            
        }, message: {
            Text($0.errorDescription)
        }
        )
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: viewmodel.manga.validURL ) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(viewmodel: MangaDetailViewModel(manga: .preview))
    }
}


