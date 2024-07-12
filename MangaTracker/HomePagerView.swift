
import SwiftUI

struct HomePagerView: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        VStack {
            Button {
                isFirstLaunch = false
            } label: {
                Text("Skip")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 30)
            Spacer()
            Text("First View")
        }
        
//        .toolbar {
//            ToolbarItem(placement: .primaryAction) {
//                Button {
//                    isFirstLaunch = false
//                } label: {
//                    Text("Skip")
//                }
//            }
//        }
    }
}

#Preview {
    NavigationStack {
        HomePagerView(isFirstLaunch: .constant(true))
    }
}