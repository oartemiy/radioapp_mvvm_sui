//
//  ContentV.swift
//  RadioApp
//
//  Created by Артемий Образцов on 09.11.2025.
//
import SwiftUI

struct ContentV: View {
    var body: some View {
        TabView {
            HomeV().tabItem {
                Text("Radio")
                Image(systemName: "antenna.radiowaves.left.and.right")
            }
            FavouriteV().tabItem {
                Text("Liked")
                Image(systemName: "heart.fill")
            }
        }
    }
}


struct ContentV_Previews: PreviewProvider {
    static var previews: some View {
        ContentV()
    }
}
