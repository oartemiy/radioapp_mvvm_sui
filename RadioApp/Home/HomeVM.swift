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
    @Published var volume: Float = 1.0
    // recEfirs is stack
    @Published var recEfirs = [MusicM]()

    private let favouritesKey = "favourites"
    private let recentsKey = "recents"

    init() {
        load()
        // load volume
        if let volumeOld = getVolume() {
            self.volume = volumeOld
        } else {
            self.volume = 1.0
        }
        // load recents
        if let recentsData = getRecents() {
            self.recEfirs = recentsData
        } else {
            self.recEfirs = []
        }
    }

    private func load() {
        isLoading = true
        guard
            let url = URL(
                string:
                    "https://de1.api.radio-browser.info/json/stations/bycodec/aac?limit=60&order=clocktrend&hidebroken=true"
            )
        else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let data = data {
                    let decodedLists = try JSONDecoder().decode(
                        [MusicM].self,
                        from: data
                    )
                    DispatchQueue.main.async {
                        print("decodedLists = \(decodedLists)")
                        print("\n\n\n\n\n\n")
                        self.efirs = decodedLists.filter {
                            !$0.name.isEmpty
                                && $0.imageUrl.absoluteString
                                    != "https://i.postimg.cc/dVhrFLff/temp-Image-Ox-S6ie.avif"
                        }
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
    func saveFavourites(_ favEfirs: [MusicM]) {  // UUID
        let favStrArr = favEfirs.map({ $0.name })
        UserDefaults.standard.set(favStrArr, forKey: favouritesKey)
        UserDefaults.standard.synchronize()
    }

    func saveVolume(_ volume: Float) {
        UserDefaults.standard.set(volume, forKey: "volume")
    }

    func getVolume() -> Float? {
        if UserDefaults.standard.object(forKey: "volume") != nil {
            return UserDefaults.standard.float(forKey: "volume")
        }
        return nil
    }

    // Получение массива избранных названий станций из UserDefaults
    private func getFavourites() -> [MusicM] {
        let favStrArr =
            UserDefaults.standard.array(forKey: favouritesKey) as? [String]
            ?? []
        let efirsStrArr = self.efirs.map({ $0.name })
        let newFavStrArr = favStrArr.filter { efirsStrArr.contains($0) }
        let newfavArr = efirs.filter { newFavStrArr.contains($0.name) }
        self.favEfirs = newfavArr
        return newfavArr
    }

    func favAdd(efir: MusicM) {
        favEfirs.append(efir)
    }

    func addRecItem(efir: MusicM) {
        recEfirs.removeAll { $0 == efir }
        recEfirs.append(efir)
    }

    func saveRec(_ recEfirs: [MusicM]) {
        let recStrArr = recEfirs.map({ $0.name })
        UserDefaults.standard.set(recStrArr, forKey: recentsKey)
        UserDefaults.standard.synchronize()
    }

    func getRecents() -> [MusicM]? {
        let recStrArr =
            UserDefaults.standard.array(forKey: recentsKey) as? [String] ?? []
        let efirsStrArr = self.efirs.map({ $0.name })
        let newRecStrArr = recStrArr.filter { efirsStrArr.contains($0) }
        let newrecArr = efirs.filter({ newRecStrArr.contains($0.name) })
        self.recEfirs = newrecArr
        return newrecArr
    }

    func favDel(efir: MusicM) {
        favEfirs.removeAll { $0 == efir }
    }
}

final class HomeVM: ObservableObject {
    @Published private(set) var headerStr = "Radios📻"
    @Published private(set) var playlists = [MusicM]()
    @Published private(set) var recentlyPlayed = [MusicM]()
    @Published var displayPlayer = false
    @Published private(set) var selectedMusic: MusicM? = nil
    @Published var index = 0
    @Published var query = ""

    var filteredPlaylists: [MusicM] {
        if query.isEmpty {
            return playlists
        } else {
            return playlists.filter { playlist in
                playlist.name.localizedCaseInsensitiveContains(query)
            }
        }
    }

    let fetcher = RadioFetcher.shared

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
