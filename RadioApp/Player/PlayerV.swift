//
//  PlayerV.swift
//  RadioApp
//  Created by B.RF Group on 03.11.2025.
//
import SwiftUI

fileprivate let HORIZONTAL_SPACING: CGFloat = 24

struct PlayerV: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: PlayerVM
    @StateObject var radioPlayer: RadioPlayer
    
    var body: some View {
        ZStack {
            Color.primary_color.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center) {
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Image.close.resizable().frame(width: 20, height: 20)
                            .padding(8).background(Color.primary_color)
                            .cornerRadius(20).modifier(NeuShadow())
                    }
                    Spacer()
                    Button(action: {  }) {
                        Image.options.resizable().frame(width: 16, height: 16)
                            .padding(12).background(Color.primary_color)
                            .cornerRadius(20).modifier(NeuShadow())
                    }
                }.padding(.horizontal, HORIZONTAL_SPACING).padding(.top, 12)
                
                 PlayerDiscV(coverImage: viewModel.model.imageUrl)
                
                Text(viewModel.model.name).foregroundColor(.text_primary)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.top, 12)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 12) {
                    Text("01:34").foregroundColor(.text_primary)
                        .bold()
                    Slider(value: $radioPlayer.player.volume, in: 0...1)
                        .accentColor(.main_white)
                    Button(action: { viewModel.liked.toggle() }) {
                        (viewModel.liked ? Image.heart_filled : Image.heart)
                            .resizable().frame(width: 20, height: 20)
                    }
                }.padding(.horizontal, 45)
                
                Spacer()
                
                HStack(alignment: .center) {
                    Button(action: {  }) {
                        Image.next.resizable().frame(width: 18, height: 18)
                            .rotationEffect(Angle(degrees: 180))
                            .padding(24).background(Color.primary_color)
                            .cornerRadius(40).modifier(NeuShadow())
                    }
                    Spacer()
                    Button(action: { playPause(efir: viewModel.model) }) {
                        (viewModel.isPlaying ? Image.pause : Image.play)
                            .resizable().frame(width: 28, height: 28)
                            .padding(50).background(Color.main_color)
                            .cornerRadius(70).modifier(NeuShadow())
                    }
                    Spacer()
                    Button(action: {  }) {
                        Image.next.resizable().frame(width: 18, height: 18)
                            .padding(24).background(Color.primary_color)
                            .cornerRadius(40).modifier(NeuShadow())
                    }
                }.padding(.horizontal, 32)
            }.padding(.bottom, HORIZONTAL_SPACING).animation(.spring())
        }
    }
    
    private func playPause(efir: MusicM) {
        viewModel.isPlaying.toggle()
        if efir != radioPlayer.efir {
            radioPlayer.initPlayer(url: efir.streamUrl)
            radioPlayer.play(efir)
        } else if !radioPlayer.isPlaying {
            radioPlayer.play(efir)
        } else {
            radioPlayer.stop()
        }
    }
}
