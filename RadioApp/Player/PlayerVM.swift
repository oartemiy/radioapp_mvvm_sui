//
//  PlayerVM.swift
//  RadioApp
//  Created by B.RF Group on 03.11.2025.
//
import Foundation

final class PlayerVM: ObservableObject {
    var model: MusicM
    @Published var liked = false
    @Published var isPlaying = true
    
    init(model: MusicM) {
        self.model = model
    }
}
