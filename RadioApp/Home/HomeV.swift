//
//  HomeV.swift
//  RadioApp
//  Created by B.RF Group on 03.11.2025.
//
import SwiftUI

struct HomeV: View {
    @State var searchTapped: Bool = false
    @StateObject private var viewModel = HomeVM()

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
                    // todo: vertical
                    HomePlaylistV(
                        playlists: viewModel.playlists,
                        onSelect: viewModel.selectMusic(music:)
                    )

                    Spacer().frame(height: 150)
                    Spacer()
                }
                .fullScreenCover(isPresented: $viewModel.displayPlayer) {
                    if let model = viewModel.selectedMusic {
                        PlayerV(viewModel: PlayerVM(model: model), radioPlayer: RadioPlayer(currentEfir: model))
                    }
                }
                .fullScreenCover(isPresented: $searchTapped) {
                    Neuromorphism()
                }

            }.animation(.spring()).edgesIgnoringSafeArea([.horizontal, .bottom])
        }
    }
}

private struct HomePlaylistV: View {
    let playlists: [MusicM], onSelect: (MusicM) -> Void
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 0) {
                    ForEach(0..<playlists.count, id: \.self) { i in
                        Button(
                            action: { onSelect(playlists[i]) },
                            label: {
                                PlaylistV(
                                    name: playlists[i].name,
                                    coverImage: playlists[i].imageUrl
                                )
                            }
                        ).padding(.top, 6).padding(.bottom, 40)

                    }
                }.padding(.horizontal, Constants.Sizes.HORIZONTAL_SPACING).frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.top, 36)
        }.padding(.top, 36)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeV()
    }
}
