//
//  RadioPlayer.swift
//  MusicApp
//  Created by B.RF Group on 03.11.2025.
//
import AVKit
import Foundation

final class RadioPlayer: ObservableObject {
    var player = AVPlayer()
    
    @Published var isPlaying = true
    @Published var efir: MusicM? = nil
    
    init(currentEfir: MusicM? = nil) {
        self.efir = currentEfir
        self.initPlayer(url: efir?.streamUrl)
        self.play()
    }
    
    func initPlayer(url: String?) {
        guard let url = URL(string: url!) else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    }

    func play() {
        isPlaying = true
        player.play()
    }
    
    func stop() {
        isPlaying = false
        player.pause()
    }
}
