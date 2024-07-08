//
//  MangaDetailView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 8/06/24.
//

import SwiftUI

struct MangaDetailView: View {
    
    @StateObject var vmData: MangaDataViewModel
    
    @State var isExpanded: Bool = false
    @State private var showVolumes : Bool = false
    
    let flexibleColumns : [GridItem] = [GridItem(.flexible()) , GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            AsyncImage(url: vmData.manga.mainPictureURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(Rectangle())
            } placeholder: {
                ProgressView()
                    .controlSize(.extraLarge)
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
            .padding()
            
            Text(vmData.manga.title)
                .font(.title)
                .bold()
            Text(vmData.manga.sypnosis ?? "")
                .multilineTextAlignment(.leading)
                .lineLimit(isExpanded ? nil : 5)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                Text(isExpanded ? "Show Less" : "Read More")
            }
            
            Link("Go to manga website", destination: vmData.manga.validURL)
            
            Button {
                vmData.saveFavourite()
                vmData.isDisable = true
            } label: {
                Label(vmData.isDisable ? "Added to Favourites" : "Make me Favourite", systemImage: vmData.isDisable ? "checkmark.circle" : "star")
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .padding()
            .disabled(vmData.isDisable)
            
            HStack{
                Text("Authors").bold().font(.title2)
                    .padding(.leading)
                Spacer()
            }
            ScrollView(.horizontal){
                HStack(alignment: .center) {
                    ForEach(vmData.manga.authors) { author in
                        NavigationLink(value: author) {
                            
                            Text(author.authorCompleteName)
                                .padding(.leading)
                                .padding(.bottom)
                        }
                    }
                }
            }
        }
        .navigationTitle(vmData.manga.title)
        .onAppear {
            vmData.checkFavourite()
        }
        .alert("Something went wrong", isPresented: $vmData.showAlert, presenting: vmData.myError, actions: { error in
            Button("Try again") {
                switch error {
                case .checkFavourite: vmData.checkFavourite()
                case .saveFavourite: vmData.saveFavourite()
                    
                }
            }
            Button {
                vmData.showAlert = false
            } label: {
                Text("Cancel")
            }
            
        }, message: {
            Text($0.errorDescription)
        }
        )
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: vmData.manga.validURL ) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MangaDetailView(vmData: MangaDataViewModel(manga: .preview))
    }
}


