
import SwiftUI

struct VolumesStatisticsView: View {

    @ObservedObject var viewmodel: MangaDetailFavouriteViewModel
    
    let flexibleColumns : [GridItem] = [GridItem(.flexible()) , GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            Text("Select the volumes you have bought")
            if let volumes = viewmodel.manga.volumes {
                LazyVGrid(columns: flexibleColumns) {
                    ForEach(1...volumes, id: \.self) { volumen in
                        Button {
                            viewmodel.persistBoughtVolumes(volume: volumen)
                        } label: {
                            Text(String(volumen))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 50, height: 50)
                        .background(viewmodel.volumes.contains(volumen) ? Color.green : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
                            Button("Try again"){
                                viewmodel.persistBoughtVolumes(volume: volumen)
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
                .padding()
            }
        }


    }
}

#Preview {
    VolumesStatisticsView(viewmodel: MangaDetailFavouriteViewModel(manga: .preview))
}

