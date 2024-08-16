//
//  PruebaDinamica.swift
//  MangaTracker
//
//  Created by Felipe Duarte on 8/08/24.
//

import SwiftUI

struct PruebaDinamica: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        
        if horizontalSizeClass == .compact {
            Color.gray
        } else {
            Color.red
        }
        
    }
}

#Preview {
    PruebaDinamica()
}
