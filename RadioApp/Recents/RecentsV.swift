//
//  RecentsV.swift
//  RadioApp
//
//  Created by Артемий Образцов on 10.11.2025.
//
import SwiftUI

struct RecentsV: View {
    @StateObject private var viewModel = RecentsVM()
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
                    if (viewModel.playlists.isEmpty) {
                        Text("There are no recents yet🕐").bold().padding(40)
                    } else {
                        HomePlaylistV(
                            playlists: Array(viewModel.playlists.reversed()),
                            onSelect: viewModel.selectMusic(music:index:)
                        )
                    }

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
                        ).onDisappear {
                            viewModel.playlists = RadioFetcher.shared.recEfirs
                        }

                    }

                }
                .fullScreenCover(isPresented: $searchTapped) {
                    Neuromorphism()
                }

            }.animation(.spring()).edgesIgnoringSafeArea([.horizontal, .bottom])
        }.onAppear {
            viewModel.playlists = RadioFetcher.shared.recEfirs
        }
    }
}

struct RecentsV_Previews: PreviewProvider {
    static var previews: some View {
        RecentsV()
    }
}
