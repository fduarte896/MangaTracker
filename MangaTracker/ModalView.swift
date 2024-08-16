import SwiftUI

/// `ModalView` es una vista que permite al usuario realizar un seguimiento puntual de los volúmenes que posee en su colección,
/// marcándolos de manera intuitiva desde un modal.
///
/// La vista presenta los volúmenes en un grid flexible, permitiendo al usuario seleccionar los volúmenes que tiene en su colección.
/// Al seleccionar un volumen, la vista persiste esta información y verifica si la colección está completa.


struct ModalView: View {

    @ObservedObject var viewmodel: MyCollectionDetailViewModel
    
    /// Configuración de las columnas del grid para mostrar los volúmenes.
    let flexibleColumns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            /// Fondo con gradiente.
            LinearGradient(colors: [Color.gradientTopColor, Color.gradientBottomColor], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                /// Título de la vista.
                Text("Select the volumes you own")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.grayMangaTracker)
                
                /// Verifica si el manga tiene volúmenes disponibles.
                if let volumes = viewmodel.manga.volumes {
                    /// Muestra los volúmenes en un grid flexible.
                    LazyVGrid(columns: flexibleColumns) {
                        ForEach(1...volumes, id: \.self) { volumen in
                            Button {
                                /// Persiste la selección del volumen y verifica si la colección está completa.
                                viewmodel.persistBoughtVolumes(volume: volumen)
                                viewmodel.checkCompletedCollection()
                            } label: {
                                Text(String(volumen))
                                    .foregroundStyle(.white)
                                    .frame(width: 50, height: 50)
                                    .background(viewmodel.volumes.contains(volumen) ? Color.orangeMangaTracker : Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            /// Muestra una alerta en caso de error al persistir la selección.
                            .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
                                Button("Try again") {
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
}


#Preview {
    ModalView(viewmodel: MyCollectionDetailViewModel(manga: .preview))
}
