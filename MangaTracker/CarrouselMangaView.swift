import SwiftUI

struct CarrouselMangaView: View {
    var xDistance: Int = 150
    
    @State private var snappedItem = 0.0
    @State private var draggingItem = 1.0
    @State private var activeIndex: Int = 0
    
    var views: [Manga] // Usamos tu modelo de datos de mangas

    var body: some View {
        ZStack {
            ForEach(views.indices, id: \.self) { index in
                CarrouselPosterView(manga: views[index])
                    .scaleEffect(1.0 - abs(distance(index)) * 0.2)
                    .opacity(1.0 - abs(distance(index)) * 0.3)
                    .offset(x: getOffset(index), y: 0)
                    .zIndex(1.0 - abs(distance(index)) * 0.1)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    draggingItem = snappedItem + value.translation.width / 100
                }
                .onEnded { value in
                    withAnimation {
                        draggingItem = snappedItem + value.predictedEndTranslation.width / 100
                        draggingItem = round(draggingItem).remainder(dividingBy: Double(views.count))
                        snappedItem = draggingItem
                        self.activeIndex = views.count + Int(draggingItem)
                        if self.activeIndex > views.count || Int(draggingItem) >= 0 {
                            self.activeIndex = Int(draggingItem)
                        }
                    }
                }
        )
    }
    
    func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item).remainder(dividingBy: Double(views.count)))
    }
    
    func getOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(views.count) * distance(item)
        return sin(angle) * Double(xDistance)
    }
}

// Modelo de datos para Manga
struct Manga: Identifiable {
    var id = UUID()
    var title: String
    // Añade más propiedades según sea necesario
}

// Ejemplo de uso
struct ContentView: View {
    let mangas = [
        Manga(title: "Manga 1"),
        Manga(title: "Manga 2"),
        Manga(title: "Manga 3")
        // Añade más mangas según sea necesario
    ]
    
    var body: some View {
        CarouselView(views: mangas)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
