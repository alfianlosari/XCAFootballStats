//
//  StandingsTabItemView.swift
//  XCAFootbalStats
//
//  Created by Alfian Losari on 25/06/23.
//

import SwiftUI
import XCAFootballDataClient

struct StandingsTabItemView: View {
    
    @State var selectedCompetition: Competition?
    
    var body: some View {
        NavigationSplitView {
            List(Competition.defaultCompetitions, id: \.self, selection: $selectedCompetition) {
                Text($0.name)
            }.navigationTitle("XCA ⚽️ Standings")
        } detail: {
            if let selectedCompetition {
                StandingsTableView(competition: selectedCompetition)
                    .id(selectedCompetition)
            } else {
                Text("Select a competition")
            }
        }
    }
}

#Preview {
    StandingsTabItemView()
}
