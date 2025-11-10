//
//  RecentsVM.swift
//  RadioApp
//
//  Created by Артемий Образцов on 10.11.2025.
//
import SwiftUI

final class RecentsVM: ObservableObject {
    @Published private(set) var headerStr = "Recents🕐"
    @Published var playlists = RadioFetcher.shared.recEfirs
    @Published var displayPlayer = false
    @Published private(set) var selectedMusic: MusicM? = nil
    @Published var index = 0
    @Published var query = ""
    
    var filteredPlaylists: [MusicM] {
        if query.isEmpty {
            return playlists
        } else {
            return playlists.filter {playlist in
                playlist.name.localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    func clearPlaylists() {
        playlists.removeAll()
        RadioFetcher.shared.recEfirs.removeAll()
        RadioFetcher.shared.saveRec(RadioFetcher.shared.recEfirs)
    }
    
    private let fetcher = RadioFetcher.shared
    
    init() { }
    
    func selectMusic(music: MusicM, index: Int) {
        selectedMusic = music
        displayPlayer = true
        self.index = index
    }
}
