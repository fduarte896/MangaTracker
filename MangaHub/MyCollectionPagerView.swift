
import SwiftUI

struct MyCollectionPagerView: View {
    
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
        MyCollectionPagerView(isFirstLaunch: .constant(true))
    }
}
