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
                    Button(action: {
                        viewModel.clearPlaylists()
                    }, label: {
                        HStack {
                            Image(systemName: "trash").foregroundStyle(viewModel.playlists.isEmpty ? Color.gray : Color.red)
                            Text("Clear recents").foregroundColor(Color.black)
                        }.padding(.leading, 20).padding(.top, 10)
                    }).disabled(viewModel.playlists.isEmpty)
                    Spacer()
                    if searchTapped {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)

                            TextField("Find recent radio", text: $viewModel.query)
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
                    if (viewModel.playlists.isEmpty) {
                        Text("There are no recents yet🤷‍♂️").bold().padding(40)
                    } else {
                        HomePlaylistV(
                            playlists: viewModel.filteredPlaylists.reversed(),
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
                                ),
                                isRecent: true
                            ),
                            radioPlayer: RadioPlayer(currentEfir: model),
                            playlist: viewModel.playlists.reversed(),
                            musicIndex: viewModel.index
                        ).onDisappear {
                            viewModel.playlists = RadioFetcher.shared.recEfirs
                        }
                    }
                }
            }.animation(.spring()).edgesIgnoringSafeArea([.horizontal, .bottom])
        }.onAppear {
            if RadioFetcher.shared.getRecents() != nil {
                RadioFetcher.shared.recEfirs = RadioFetcher.shared.getRecents()!
            }
            viewModel.playlists = RadioFetcher.shared.recEfirs
            
        }
    }
}

struct RecentsV_Previews: PreviewProvider {
    static var previews: some View {
        RecentsV()
    }
}
