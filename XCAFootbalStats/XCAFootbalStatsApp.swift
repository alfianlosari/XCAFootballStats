//
//  XCAFootbalStatsApp.swift
//  XCAFootbalStats
//
//  Created by Alfian Losari on 24/06/23.
//

import SwiftUI

// Get free api key from https://www.football-data.org
let apiKey = "PUT_API_KEY"

@main
struct XCAFootbalStatsApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                StandingsTabItemView()
                    .tabItem { Label("Standings", systemImage: "table.fill") }
                
                TopScorersTabItemView()
                    .tabItem { Label("Top Scorers", systemImage: "soccerball.inverse") }
            }
        }
    }
}
