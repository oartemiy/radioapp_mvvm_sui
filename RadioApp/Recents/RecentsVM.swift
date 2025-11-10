//
//  RecentsVM.swift
//  RadioApp
//
//  Created by Артемий Образцов on 10.11.2025.
//
import SwiftUI

final class RecentsVM: ObservableObject {
    @Published private(set) var headerStr = "Recents"
    @Published var playlists = RadioFetcher.shared.recEfirs
    @Published var displayPlayer = false
    @Published private(set) var selectedMusic: MusicM? = nil
    @Published var index = 0
    
    private let fetcher = RadioFetcher.shared
    
    init() { }
    
    func selectMusic(music: MusicM, index: Int) {
        selectedMusic = music
        displayPlayer = true
        self.index = index
    }
}
