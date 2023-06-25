//
//  StandingsTableView.swift
//  XCAFootbalStats
//
//  Created by Alfian Losari on 24/06/23.
//

import SwiftUI
import SVGImageSwiftUI
import XCAFootballDataClient

struct StandingsTableView: View {
    
    let competition: Competition
    @Bindable var vm = StandingsTableObservable()
    
    var body: some View {
        Table(of: TeamStandingTable.self) {
            
            TableColumn("Club") { club in
                HStack {
                    Text(club.positionText).fontWeight(.bold).frame(minWidth: 20)
                    
                    if let crest = club.team.crest, crest.hasSuffix("svg") {
                        SVGImage(url: URL(string: crest)!, size: .init(width: 40, height: 40))
                            .frame(width: 40, height: 40)
                            .cornerRadius(20)
                    } else {
                        AsyncImage(url: URL(string: club.team.crest ?? "")) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable()
                            default: Circle().foregroundStyle(Color.gray.opacity(0.5))
                            }
                            
                        }
                        .frame(width: 40, height: 40)
                    }
                    
                    Text(club.team.name)
                }
            }
            .width(min: 264)
            
            TableColumn("W") { Text($0.wonText).frame(minWidth: 40) }
                .width(40)
            
            TableColumn("D") { Text($0.drawText).frame(minWidth: 40) }
                .width(40)
            
            TableColumn("L") { Text($0.lostText).frame(minWidth: 40) }
                .width(40)
            
            TableColumn("GF") { Text($0.goalsForText).frame(minWidth: 40) }
                .width(40)
            
            TableColumn("GA") { Text($0.goalsAgainstText).frame(minWidth: 40) }
                .width(40)
            
            TableColumn("GD") { Text($0.goalDifferenceText).frame(minWidth: 40) }
                .width(40)
            
            TableColumn("Pts") { Text($0.pointsText).frame(minWidth: 40) }
                .width(40)
            
            TableColumn("Last 5") { club in
                HStack(spacing: 4) {
                    if let formArray = club.formArray, !formArray.isEmpty {
                        ForEach(formArray, id: \.self) { form in
                            switch form {
                            case "W":
                                Image(systemName: "checkmark.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.white, Color.green)
                            case "L":
                                Image(systemName: "xmark.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.white, Color.red)
                                
                            default:
                                Image(systemName: "minus.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.white, Color.white.opacity(0.5))
                            }
                            
                        }
                    } else {
                        Text("-").frame(width: 120, alignment: .center)
                    }
                }
            }.width(120)
            
        } rows: {
            ForEach(vm.standings ?? []) {
                TableRow($0)
            }
        }
        .overlay {
            switch vm.fetchPhase {
            case .fetching: ProgressView()
            case .failure(let error): Text(error.localizedDescription).font(.headline)
            default: EmptyView()
            }
        }
        .foregroundStyle(Color.primary)
        .navigationTitle(competition.name + " standings")
        .task(id: vm.selectedFilter.id) {
            await vm.fetchStandings(competition: competition)
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                Picker("Filter Options", selection: $vm.selectedFilter) {
                    ForEach(vm.filterOptions, id: \.self) { season in
                        Text(" \(season.text) ")
                    }
                }.pickerStyle(.segmented)
            }
        }
    }
}

#Preview {
    NavigationStack {
        StandingsTableView(competition: .defaultCompetitions[1])
    }
}
