//
//  CineMatesApp.swift
//  CineMates
//
//  Created by Marco Agizza on 11/05/23.
//

import SwiftUI

@main
struct CineMatesApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                DiscoverView()
                    .tabItem {
                        Image(systemName: "popcorn")
                    }
                FavouritesView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                    }
            }
            .attachPartialSheetToRoot()
        }
    }
}
