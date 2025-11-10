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
    
    init(model: MusicM, liked: Bool) {
        self.model = model
        self.liked = liked
        RadioFetcher.shared.addRecItem(efir: model)
        RadioFetcher.shared.saveRec(RadioFetcher.shared.recEfirs)
    }
    
    func update(model: MusicM) {
        self.model = model
        RadioFetcher.shared.addRecItem(efir: model)
        RadioFetcher.shared.saveRec(RadioFetcher.shared.recEfirs)
    }
}
