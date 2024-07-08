//
//  HomePageView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 1/07/24.
//

import SwiftUI

struct HomePageView: View {
    
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
        HomePageView(isFirstLaunch: .constant(true))
    }
}
