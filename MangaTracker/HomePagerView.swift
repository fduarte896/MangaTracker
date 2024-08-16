
import SwiftUI

struct HomePagerView: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        
        
        VStack{
            Text("Dive into the fascinating world of manga").font(.largeTitle).multilineTextAlignment(.center)
            
            HStack (alignment: .top) {
                VStack  {
                    
                    Image("ExploreViewIMG")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 240)
                    
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Text("Seamless navigation through a vast collection of mangas")
                        .foregroundStyle(Color(Color.orangeMangaTracker))
                        .font(.title2)
                }
                
                
                VStack {
                    
                    Image("Top10IMG")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 240)
                    
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    
                    Text("Discover various categories that cater to your unique tastes. ")
                        .font(.title2)
                        .foregroundStyle(Color(Color.orangeMangaTracker))
                    
                }
            }
            
            
            HStack{
                Image("CategoriesIMG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 240)
                
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("Browse the top 10 most popular mangas")
                    .font(.title2)
                    .foregroundStyle(Color(Color.orangeMangaTracker))
            }
            
            
        }              
        
        
        
        
        
    }
}
    



#Preview {
    NavigationStack {
        HomePagerView(isFirstLaunch: .constant(true))
    }
}
