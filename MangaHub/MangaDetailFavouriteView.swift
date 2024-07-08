
import SwiftUI

struct MangaDetailFavouriteView: View {
    
    @StateObject var viewmodel: MangaDetailFavouriteViewModel
    
    @State var isExpanded: Bool = false
    @State private var showVolumes : Bool = false
    
    var body: some View {
        ScrollView {
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
            .padding()
            
            Text(viewmodel.manga.title)
                .font(.title)
                .bold()
            Text(viewmodel.manga.sypnosis ?? "")
                .multilineTextAlignment(.leading)
                .lineLimit(isExpanded ? nil : 5)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                Text(isExpanded ? "Show Less" : "Read More")
            }
            
            Link("Go to manga website", destination: viewmodel.manga.validURL)
            
            HStack{
                Text("Authors").bold().font(.title2)
                    .padding(.leading)
                Spacer()
            }
            ScrollView(.horizontal){
                HStack(alignment: .center){
                    ForEach(viewmodel.manga.authors) { author in
                        Text(author.authorCompleteName)
                            .padding(.leading)
                            .padding(.bottom)
                            .foregroundStyle(Color.primary)
                    }
                }
            }
            
            HStack {
                VStack {
                    Stepper(value: $viewmodel.reading, in: 0...(viewmodel.manga.volumes ?? 0)) {
                        Text("Reading volume: \(viewmodel.reading)")
                    }
                    
                    Button("Guardar Cambios") {
                        viewmodel.persistReadingVolume()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .foregroundColor(.white)
                    .background(LinearGradient(colors: [Color.purple, Color.cyan], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    
                    
                    
                    Text("Bought volumes: \(viewmodel.manga.boughtVolumes.count) of \(viewmodel.manga.volumes ?? 0)")
                    
                    Button("Show") {
                        if viewmodel.manga.volumes != nil {
                            showVolumes = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .foregroundColor(.white)
                    .background(LinearGradient(colors: [Color.purple, Color.cyan], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    
                }
            }
        }
        .navigationTitle(viewmodel.manga.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: viewmodel.manga.validURL ) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            
            //            ToolbarItem(placement: .secondaryAction) {
            //                Button {
            //                    // Función para guardar cambios
            //                } label: {
            //                    Image(systemName: "square.and.arrow.down")
            //                }
            //            }
            
        }
        .sheet(isPresented: $showVolumes) {
            VolumesStatisticsView(viewmodel: viewmodel)
                .presentationDetents([.medium, .large])
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
            Button("Try again"){
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
        MangaDetailFavouriteView(viewmodel: MangaDetailFavouriteViewModel(manga: .preview))
    }
}
