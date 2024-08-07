
import SwiftUI

struct BucketPagerView: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        VStack (spacing: 80){
            HStack {

                Image("CategoriesIMG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 300)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                


            }
            
            Text("Hola")

    
        }
        

    }
}

#Preview {
    NavigationStack {
        BucketPagerView(isFirstLaunch: .constant(true))
    }
}
