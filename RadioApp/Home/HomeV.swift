import Combine
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

            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    HomeHeaderV(
                        headerStr: viewModel.headerStr,
                        onTapSearch: { searchTapped.toggle() }
                    )
                    Spacer()
                    if searchTapped {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)

                            TextField("Find radio", text: $viewModel.query)
                                .textFieldStyle(PlainTextFieldStyle())

                            if !viewModel.query.isEmpty {
                                Button(action: {
                                    viewModel.query = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(
                            .horizontal,
                            Constants.Sizes.HORIZONTAL_SPACING
                        )
                        .transition(.opacity)
                    }
                    // Playlists
                    HomePlaylistV(
                        playlists: viewModel.filteredPlaylists,  // draw only filtered
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

            }.animation(.spring()).edgesIgnoringSafeArea([.horizontal, .bottom])
                .searchable(text: $viewModel.query, prompt: "Search radio")
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
                                onSelect(playlists[i], i)
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
