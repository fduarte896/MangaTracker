
import SwiftUI

struct FavouritesPageView: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        VStack {
            Text("Third View")
            
            Button {
                isFirstLaunch = false
            } label: {
                Text("Continue to the App")
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavouritesPageView(isFirstLaunch: .constant(true))
    }
}
