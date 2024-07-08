
import SwiftUI

struct CategoriesPageView: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Second View")
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    isFirstLaunch = false
                } label: {
                    Text("Skip")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesPageView(isFirstLaunch: .constant(true))
    }
}
