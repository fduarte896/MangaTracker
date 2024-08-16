
import SwiftUI

struct MyCollectionPagerView: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        VStack{
            
            HStack {

                Image("MyCollectionIMG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 300)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                Text("Effortlessly manage and explore your manga collection").font(.title2)

            }
            
            HStack{
                Image("CollectionDetailIMG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 300)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                
                Text("View detailed information about each manga in your collection, log the volumes you own, and track your reading progress.").font(.title2)
            }

        }        

    }
}

#Preview {
    NavigationStack {
        MyCollectionPagerView(isFirstLaunch: .constant(true))
    }
}
