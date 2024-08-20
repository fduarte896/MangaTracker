import SwiftUI

/// `CircularGaugeView` es una vista que muestra un indicador circular que representa la puntuación de un manga,
/// normalizando el valor de la puntuación dentro del rango de 0 a 1, adecuado para su uso en un `Gauge`.
///
/// La vista utiliza un degradado de colores para indicar visualmente el rango de la puntuación, y puede ser escalada
/// para ajustarse a diferentes tamaños de presentación. La puntuación se muestra en el centro del indicador, junto con
/// un texto adicional que dice "Score".
///
/// - Parameters:
///   - isSmall: Un booleano que determina si la vista se muestra en tamaño pequeño o grande.
///   - manga: Una instancia de `MangaModel` que contiene la información del manga, incluyendo su puntuación.
///   - gradient: Un `Gradient` que define los colores utilizados para el indicador circular. El valor predeterminado incluye
///     colores de rojo a verde, pasando por amarillo.
///
/// - Note: La vista está diseñada para ser reutilizable en diferentes contextos donde se necesite mostrar la puntuación
///   de un manga de manera visual y atractiva.

struct CircularGaugeView: View {
    
    var isSmall = true
    var manga: MangaModel
    var gradient = Gradient(colors: [.red, .yellow, .green])
    
    /// Score normalizado para que entre en el rango de los `Gauge` de 0 a 1.
    var normalizedScore: Double {
        return min(max(manga.score / 10.0, 0.0), 1.0)
    }
    
    var body: some View {
        Gauge(value: normalizedScore) {
            Text("\(manga.score.formatted())")
                .foregroundStyle(Color.grayMangaTracker)
        }
        .gaugeStyle(.accessoryCircular)
        .scaleEffect(isSmall ? 1 : 4)
        .tint(gradient)
        .overlay(alignment: .center) {
            Text("Score")
                .font(.footnote)
                .bold()
                .foregroundStyle(Color.grayMangaTracker)
        }
    }
}

#Preview {
    CircularGaugeView(manga: .preview)
}
