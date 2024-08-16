
import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            
            Image("SplashScreen2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

        }
    }
}

#Preview {
    SplashScreen()
}
