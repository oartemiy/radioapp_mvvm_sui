//
//  PlayerV.swift
//  RadioApp
//  Created by B.RF Group on 03.11.2025.
//
import SwiftUI

private let HORIZONTAL_SPACING: CGFloat = 24

struct PlayerV: View {
    @Environment(\.presentationMode) var presentationMode:
        Binding<PresentationMode>
    @ObservedObject var viewModel: PlayerVM
    @ObservedObject var radioPlayer: RadioPlayer
    @State var playlist: [MusicM]
    @State var musicIndex: Int

    private var volumeIconName: String {
        switch radioPlayer.volume {
        case 0.0:
            return "speaker.slash"  // Звук выключен
        case ...0.3:
            return "speaker.wave.1"  // Низкая громкость
        case ...0.6:
            return "speaker.wave.2"  // Средняя громкость
        default:
            return "speaker.wave.3"  // Высокая громкость
        }
    }

    var body: some View {
        ZStack {
            Color.primary_color.edgesIgnoringSafeArea(.all)

            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image.close.resizable().frame(width: 20, height: 20)
                            .padding(8).background(Color.primary_color)
                            .cornerRadius(20).modifier(NeuShadow())
                    }
                    Spacer()
//                    Button(action: {}) {
//                        Image.options.resizable().frame(width: 16, height: 16)
//                            .padding(12).background(Color.primary_color)
//                            .cornerRadius(20).modifier(NeuShadow())
//                    }
                }.padding(.horizontal, HORIZONTAL_SPACING).padding(.top, 12)

                PlayerDiscV(coverImage: viewModel.model.imageUrl)

                Text(viewModel.model.name).foregroundColor(.text_primary)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.top, 12)

                Spacer()

                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: volumeIconName).resizable().frame(
                        width: 20,
                        height: 20
                    ).bold().animation(.default, value: volumeIconName)
                    Slider(
                        value: $radioPlayer.player.volume,
                        in: 0...1,
                        onEditingChanged: { isEditing in
                            if !isEditing {
                                radioPlayer.volume = radioPlayer.player.volume
                            }
                        }
                    )
                    .accentColor(.main_white)
                    Button(
                        action: {
                            viewModel.liked.toggle()
                            if viewModel.liked {
                                RadioFetcher.shared.favAdd(
                                    efir: viewModel.model
                                )
                                RadioFetcher.shared.saveFavourites(
                                    RadioFetcher.shared.favEfirs
                                )
                            } else {
                                RadioFetcher.shared.favDel(
                                    efir: viewModel.model
                                )
                                RadioFetcher.shared.saveFavourites(
                                    RadioFetcher.shared.favEfirs
                                )
                            }

                        },
                        label: {
                            (viewModel.liked ? Image.heart_filled : Image.heart)
                                .resizable().frame(width: 20, height: 20)
                        }
                    )

                }.padding(.horizontal, 45)

                Spacer()

                HStack(alignment: .center) {
                    Button(action: { minusOneMusic() }) {
                        Image.next.resizable().frame(width: 18, height: 18)
                            .rotationEffect(Angle(degrees: 180))
                            .padding(24).background(Color.primary_color)
                            .cornerRadius(40).modifier(NeuShadow())
                    }
                    Spacer()
                    Button(action: { playPause() }) {
                        (viewModel.isPlaying ? Image.pause : Image.play)
                            .resizable().frame(width: 28, height: 28)
                            .padding(50).background(Color.main_color)
                            .cornerRadius(70).modifier(NeuShadow())
                    }
                    Spacer()
                    Button(action: { plusOneMusic() }) {
                        Image.next.resizable().frame(width: 18, height: 18)
                            .padding(24).background(Color.primary_color)
                            .cornerRadius(40).modifier(NeuShadow())
                    }
                }.padding(.horizontal, 32)
            }.padding(.bottom, HORIZONTAL_SPACING).animation(.spring())
        }.onDisappear {
            RadioFetcher.shared.volume = radioPlayer.player.volume
            RadioFetcher.shared.saveVolume(RadioFetcher.shared.volume)
        }
    }

    private func playPause() {
        viewModel.isPlaying.toggle()
        if !radioPlayer.isPlaying {
            radioPlayer.play()
        } else {
            radioPlayer.stop()
        }
    }

    private func plusOneMusic() {
        self.musicIndex += 1
        self.musicIndex = (self.musicIndex + playlist.count) % playlist.count
        self.viewModel.update(model: playlist[musicIndex])
//        print(playlist[musicIndex].name, musicIndex)
        self.radioPlayer.stop()
        let oldVolume = self.radioPlayer.player.volume
        self.radioPlayer.initPlayer(url: viewModel.model.streamUrl)
        self.radioPlayer.player.volume = oldVolume
        RadioFetcher.shared.volume = self.radioPlayer.player.volume
        self.viewModel.liked = RadioFetcher.shared.favEfirs.contains(
            viewModel.model
        )
        self.radioPlayer.play()
    }

    private func minusOneMusic() {
        self.musicIndex -= 1
        self.musicIndex = (self.musicIndex + playlist.count) % playlist.count
        self.viewModel.update(model: playlist[musicIndex])
//        print(playlist[musicIndex].name, musicIndex)
        self.radioPlayer.stop()
        let oldVolume = self.radioPlayer.player.volume
        self.radioPlayer.initPlayer(url: viewModel.model.streamUrl)
        self.radioPlayer.player.volume = oldVolume
        RadioFetcher.shared.volume = self.radioPlayer.player.volume
        self.viewModel.liked = RadioFetcher.shared.favEfirs.contains(
            viewModel.model
        )
        self.radioPlayer.play()

    }
}
