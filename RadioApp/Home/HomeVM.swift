//
//  HomeVM.swift
//  RadioApp
//  Created by B.RF Group on 03.11.2025.
//
import Foundation
import SwiftUI

public class RadioFetcher: ObservableObject {
    static let shared = RadioFetcher()
    
    @Published var isLoading = true
    @Published var efirs = [MusicM]()
    @Published var favEfirs = [MusicM]()
    
    private let favouritesKey = "favourites"
    
    init() {
        load()
    }
    
    private func load() {
        isLoading = true
        guard let url = URL(string: "https://de1.api.radio-browser.info/json/stations/bycodec/aac?limit=60&order=clocktrend&hidebroken=true") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let data = data {
                    let decodedLists = try JSONDecoder().decode([MusicM].self, from: data)
                    DispatchQueue.main.async {
                        print("decodedLists = \(decodedLists)")
                        print("\n\n\n\n\n\n")
                        self.efirs = decodedLists.filter { !$0.name.isEmpty && $0.imageUrl.absoluteString != "https://i.postimg.cc/dVhrFLff/temp-Image-Ox-S6ie.avif" }
                        print(self.efirs)
                        self.isLoading = false
                        _ = self.getFavourites()
                    }
                } else {
                    print("no data.")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            } catch {
                print("error.")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
    
    // Сохранение массива названий избранных станций в UserDefaults
    func saveFavourites(_ favEfirs: [MusicM]) { // UUID
        let favStrArr = favEfirs.map({ $0.name })
        UserDefaults.standard.set(favStrArr, forKey: favouritesKey)
        UserDefaults.standard.synchronize()
    }
        
    // Получение массива избранных названий станций из UserDefaults
    private func getFavourites() -> [MusicM] {
        let favStrArr = UserDefaults.standard.array(forKey: favouritesKey) as? [String] ?? []
        let efirsStrArr = self.efirs.map({ $0.name })
        let newFavStrArr = favStrArr.filter { efirsStrArr.contains($0) }
        let newfavArr = efirs.filter { newFavStrArr.contains($0.name) }
        self.favEfirs = newfavArr
        return newfavArr
    }
    
    func favAdd(efir: MusicM) {
        favEfirs.append(efir)
    }

    func favDel(efir: MusicM) {
        favEfirs.removeAll() { $0 == efir }
    }
}

final class HomeVM: ObservableObject {
    @Published private(set) var headerStr = "Radios"
    @Published private(set) var playlists = [MusicM]()
    @Published private(set) var recentlyPlayed = [MusicM]()
    @Published var displayPlayer = false
    @Published private(set) var selectedMusic: MusicM? = nil
    @Published var index = 0
    
    
    var fetcher = RadioFetcher.shared
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.fetchPlaylist()
        }
    }
    
    private func fetchPlaylist() {
        playlists = fetcher.efirs
    }
    
    func selectMusic(music: MusicM, index: Int) {
        selectedMusic = music
        displayPlayer = true
        self.index = index
    }
}
