//
//  PlayerVM.swift
//  RadioApp
//  Created by B.RF Group on 03.11.2025.
//
import Foundation

final class PlayerVM: ObservableObject {
    @Published var model: MusicM
    @Published var liked = false
    @Published var isPlaying = true
    @Published var isRecent: Bool = false
    
    init(model: MusicM, liked: Bool, isRecent: Bool = false) {
        self.model = model
        self.liked = liked
        self.isRecent = isRecent
        if !isRecent {
            RadioFetcher.shared.addRecItem(efir: model)
            RadioFetcher.shared.saveRec(RadioFetcher.shared.recEfirs)
        }
    }
    
    func update(model: MusicM) {
        self.model = model
        // when we listen to music in recents we mustn't changed recents
        if !isRecent {
            RadioFetcher.shared.addRecItem(efir: model)
            RadioFetcher.shared.saveRec(RadioFetcher.shared.recEfirs)
        }
    }
}
