//
//  FavouriteV.swift
//  RadioApp
//
//  Created by Артемий Образцов on 09.11.2025.
//

import SwiftUI

struct FavouriteV: View {
    @StateObject var viewModel = FavouriteVM()
    @State var searchTapped: Bool = false
    
    var body: some View {
        ZStack {
            Color.primary_color.edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    HomeHeaderV(
                        headerStr: viewModel.headerStr,
                        onTapSearch: { searchTapped.toggle() }
                    )
                    // Playlists
                    if viewModel.playlists.isEmpty {
                        Text("There are no favourites yet❤️").bold().padding(40)
                    } else {
                        HomePlaylistV(
                            playlists: viewModel.playlists,
                            onSelect: viewModel.selectMusic(music:index:)
                        )
                    }

                    Spacer().frame(height: 150)
                    Spacer()
                }
            }.animation(.spring()).edgesIgnoringSafeArea([.horizontal, .bottom])
        }.onAppear {
            viewModel.playlists = RadioFetcher.shared.favEfirs
        }.fullScreenCover(isPresented: $viewModel.displayPlayer) {
            if let model = viewModel.selectedMusic {
                PlayerV(viewModel: PlayerVM(model: model, liked: viewModel.playlists.contains(model)), radioPlayer: RadioPlayer(currentEfir: model), playlist: viewModel.playlists, musicIndex: viewModel.index).onDisappear {
                    viewModel.playlists = RadioFetcher.shared.favEfirs
                }
            }
            
        }
        .fullScreenCover(isPresented: $searchTapped) {
            Neuromorphism()
        }
    }
}
