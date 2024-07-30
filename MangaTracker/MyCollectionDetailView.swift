
import SwiftUI

struct MyCollectionDetailView: View {
    
    @StateObject var viewmodel: MyCollectionDetailViewModel
    
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
                    
                        
                        /*
                         
                         GAUGE!!
                         
                         @State private var current = 67.0
                         @State private var minValue = 50.0
                         @State private var maxValue = 170.0
                         
                         
                         var body: some View {
                         Gauge(value: current, in: minValue...maxValue) {
                         Image(systemName: "heart.fill")
                         .foregroundColor(.red)
                         } currentValueLabel: {
                         Text("\(Int(current))")
                         .foregroundColor(Color.green)
                         } minimumValueLabel: {
                         Text("\(Int(minValue))")
                         .foregroundColor(Color.green)
                         } maximumValueLabel: {
                         Text("\(Int(maxValue))")
                         .foregroundColor(Color.red)
                         }
                         .gaugeStyle(.circular)
                         */
                    
                    Text(viewmodel.collectionCompleted ? "Congratulations, you now own all \(viewmodel.manga.volumes ?? 0) volumes and have completed the collection!" : "Bought volumes: \(viewmodel.manga.boughtVolumes.count) of \(viewmodel.manga.volumes ?? 0)")

                    
                    
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
            

            
        }
        .sheet(isPresented: $showVolumes) {
            ModalView(viewmodel: viewmodel)
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
        MyCollectionDetailView(viewmodel: MyCollectionDetailViewModel(manga: .preview))
    }
}
