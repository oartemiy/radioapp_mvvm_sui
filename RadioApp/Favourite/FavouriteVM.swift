//
//  FavouriteVM.swift
//  RadioApp
//
//  Created by Артемий Образцов on 09.11.2025.
//
import SwiftUI
import Combine

final class FavouriteVM: ObservableObject {
    @Published private(set) var headerStr = "Liked"
    @Published var playlists = RadioFetcher.shared.favEfirs
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
