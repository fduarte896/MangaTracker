
import SwiftUI

struct BucketPagerView: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        VStack (spacing: 80){
            HStack {
                
                Image("BucketListIMG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 300)
                
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                Text("Plan ahead you next reading with the bucket list section!").font(.title2)

            }
            HStack{

                Image("BucketListIMG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 300)
                
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                Text("Add the mangas to your collection later on").font(.title2)
            }
            
        }
//        .toolbar(content: {
//            ToolbarItem(placement: .automatic) {
//                
//                Button("Skip") {
//                    isFirstLaunch = false
//                }
//            }
//        })

    }

}


#Preview {
    NavigationStack {
        BucketPagerView(isFirstLaunch: .constant(true))
    }
}
