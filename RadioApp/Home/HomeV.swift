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
                    HomePlaylistV(
                        playlists: viewModel.playlists,
                        onSelect: viewModel.selectMusic(music:index:)
                    )

                    Spacer().frame(height: 150)
                    Spacer()
                }
                .fullScreenCover(isPresented: $viewModel.displayPlayer) {
                    if let model = viewModel.selectedMusic {
                        PlayerV(
                            viewModel: PlayerVM(
                                model: model,
                                liked: RadioFetcher.shared.favEfirs.contains(
                                    model
                                )
                            ),
                            radioPlayer: RadioPlayer(currentEfir: model),
                            playlist: viewModel.playlists,
                            musicIndex: viewModel.index
                        )

                    }

                }
                .fullScreenCover(isPresented: $searchTapped) {
                    Neuromorphism()
                }

            }.animation(.spring()).edgesIgnoringSafeArea([.horizontal, .bottom])
        }
    }
}

struct HomePlaylistV: View {
    let playlists: [MusicM], onSelect: (MusicM, Int) -> Void
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 0) {
                    ForEach(0..<playlists.count, id: \.self) { i in
                        Button(

                            action: {
                                withAnimation { onSelect(playlists[i], i) }
                            }) {
                                PlaylistV(
                                    model: playlists[i],
                                    name: playlists[i].name,
                                    coverImage: playlists[i].imageUrl
                                )
                            }
                            .padding(.top, 6).padding(.bottom, 40)

                    }
                }.padding(.horizontal, Constants.Sizes.HORIZONTAL_SPACING)
                    .frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.top, 36)
        }.padding(.top, 36)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeV()
    }
}
