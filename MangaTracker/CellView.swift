
import SwiftUI

struct CellView: View {
    
    var manga: MangaModel
    var showOwnedVolumes : Bool
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Text(manga.title)
                    .font(.title2)
                    .bold()
                if showOwnedVolumes {
                    ProgressView(value: manga.collectionProgress, label: {
                        Text("Owned volumes: ")
                    }, currentValueLabel: {
                        if let numberMangas = manga.volumes {
                            Text("\(manga.boughtVolumes.count) out of " + String(numberMangas))
                        } else {
                            Text("Volume tracking is not available yet for this manga, sorry.")
                        }

                    })
                }

                
            }
            MangaPosterView(manga: manga)
        }
    }
}

#Preview {
    
        CellView(manga: .preview, showOwnedVolumes: true)

}




