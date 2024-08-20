import SwiftUI

/// `Gauge2` es una vista que muestra un indicador de progreso relacionado con el número de volúmenes de manga leídos por el usuario
/// en relación con el total de volúmenes disponibles en su colección.
///
/// La vista incluye un `Stepper` que permite al usuario ajustar manualmente el número de volúmenes leídos. Cada vez que se ajusta el valor,
/// se persiste automáticamente el nuevo progreso de lectura. La interfaz está diseñada para adaptarse tanto a iPad como a iPhone,
/// utilizando un diseño responsivo.
///
/// - Note: La vista permite al usuario seguir y ajustar el progreso de su lectura de manera intuitiva, utilizando controles fáciles de entender
///   y una representación visual clara del progreso.

struct Gauge2: View {
    
    @ObservedObject var viewmodel: MyCollectionDetailViewModel
    
    var body: some View {
        Gauge(value: Double(viewmodel.reading), in: 0...Double(viewmodel.manga.volumes ?? 0)) {
            HStack(alignment: .center) {
                /// Texto que muestra "Volumes read"
                Text("Volumes read")
                    .bold()
                    .foregroundStyle(Color.orangeMangaTracker)
                    .font(UIDevice.isIPad ? .title2 : .title3)
                
                /// Stepper para ajustar el número de volúmenes leídos
                Stepper(value: $viewmodel.reading, in: 0...(viewmodel.manga.volumes ?? 0)) {
                    // Sin etiqueta visible
                }
                .background(Color.orangeMangaTracker, in: RoundedRectangle(cornerRadius: 9))
                .labelsHidden()
                .onChange(of: viewmodel.reading) { oldValue, newValue in
                    /// Persistencia del valor actualizado
                    viewmodel.persistReadingVolume()
                    print(viewmodel.manga.readingVolume)
                }
            }
        } currentValueLabel: {
            /// Muestra el número actual de volúmenes leídos
            Text("\(viewmodel.reading)")
                .foregroundColor(Color.orangeMangaTracker)
        } minimumValueLabel: {
            Text("0")
                .foregroundColor(Color.green)
        } maximumValueLabel: {
            Text("\(viewmodel.manga.volumes ?? 0)")
                .foregroundColor(Color.orangeMangaTracker)
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [Color.gradientTopColor, Color.gradientBottomColor], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        
        Gauge2(viewmodel: MyCollectionDetailViewModel(manga: .preview))
    }
}
