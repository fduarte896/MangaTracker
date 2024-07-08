
import SwiftUI

struct MangaSplashScreenView: View {
    var body: some View {
        ZStack {
            
            Image("MangaSplash")
                .resizable()
                .ignoresSafeArea()
            
//            Color.black
//                .edgesIgnoringSafeArea(.all)
//            
//            Text("MangaTracker")
//                .font(.title)
//                .foregroundStyle(.white)
        }
    }
}

#Preview {
    MangaSplashScreenView()
}
