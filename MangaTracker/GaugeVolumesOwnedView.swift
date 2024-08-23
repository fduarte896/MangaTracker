import SwiftUI

/// `GaugeVolumesOwnedView` es una vista que muestra un indicador de progreso que representa el número de volúmenes de manga comprados
/// en relación con el total de volúmenes disponibles en la colección del usuario.
///
/// La vista incluye un botón que, al ser presionado, muestra un modal con la lista de volúmenes disponibles, permitiendo
/// al usuario marcar los volúmenes que posee. Si la colección está completa, se muestra un mensaje de felicitación.
///
/// - Note: La vista está diseñada para mostrar el progreso de la colección de volúmenes del usuario, con una representación visual clara
///   y una opción para ver y marcar volúmenes específicos.

struct GaugeVolumesOwnedView: View {
    
    @ObservedObject var viewmodel: MyCollectionDetailViewModel
    @State private var showVolumes: Bool = false

    var body: some View {
        Gauge(value: Double(viewmodel.manga.boughtVolumes.count), in: 0...Double(viewmodel.manga.volumes ?? 0)) {
            HStack {
                /// Botón para mostrar los volúmenes si están disponibles
                Button(action: {
                    if viewmodel.manga.volumes != nil {
                        showVolumes = true
                    }
                }) {
                    HStack(spacing: 20) {
                        Text(viewmodel.collectionCompleted ? "Congratulations, collection completed! 🥳" : "Volumes owned")
                            .foregroundStyle(Color.orangeMangaTracker)
                            .font(UIDevice.isIPad ? .title2 : .callout)
                        
                        Text("Show")
                            .frame(width: 70, height: 40)
                            .foregroundStyle(Color.softWhiteBackground)
                            .background(Color.blueMangaTracker)
                            .clipShape(Capsule())
                            .font(UIDevice.isIPad ? .title2 : .callout)
                    }
                }
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal)
            }
        } currentValueLabel: {
            /// Muestra el número de volúmenes comprados
            Text("\(viewmodel.manga.boughtVolumes.count)")
                .foregroundColor(Color.orangeMangaTracker)
        } minimumValueLabel: {
            Text("0")
                .foregroundColor(Color.green)
        } maximumValueLabel: {
            Text("\(viewmodel.manga.volumes ?? 0)")
                .foregroundColor(Color.orangeMangaTracker)
        }
        /// Presenta un modal con la lista de volúmenes si se presiona el botón "Show"
        .sheet(isPresented: $showVolumes) {
            ModalView(viewmodel: viewmodel)
                .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    ZStack {
        Color.softWhiteBackground
            .ignoresSafeArea()
        
        GaugeVolumesOwnedView(viewmodel: MyCollectionDetailViewModel(manga: .preview))
    }
}
