
import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            
            Image("MangaSplash")
                .resizable()
                .ignoresSafeArea()

        }
    }
}

#Preview {
    SplashScreen()
}
