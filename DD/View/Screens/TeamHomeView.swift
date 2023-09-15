//
//  TeamHomeView.swift
//  DD
//
//  Created by Spencer Belton on 5/26/23.
//

import SwiftUI

class TeamHomeLogic: ObservableObject {
    let ETN = Player(model: PlayerJSON(first: "Travis", last: " Etienne", id: "1", age: 24, position: "RB", experience: 2, depthChartPOS: 1, weight: "215", height: "5'10", team: "JAX", college: "Clemson Tigers", searchRank: 1, status: "Active"))
    let TLAW = Player(model: PlayerJSON(first: "Trevor", last: "Lawrence", id: "2", age: 23, position: "QB", experience: 2, depthChartPOS: 1, weight: "215", height: "5'10", team: "JAX", college: "Clemson Tigers", searchRank: 1, status: "Active"))
    let GIBSON = Player(model: PlayerJSON(first: "Antonio", last: "Gibson", id: "3", age: 23, position: "RB", experience: 2, depthChartPOS: 1, weight: "215", height: "5'10", team: "JAX", college: "Clemson Tigers", searchRank: 1, status: "Active"))
    let WADDLE = Player(model: PlayerJSON(first: "Jaylen ", last: "Waddle", id: "4", age: 23, position: "WR", experience: 2, depthChartPOS: 1, weight: "215", height: "5'10", team: "JAX", college: "Clemson Tigers", searchRank: 1, status: "Active"))
    let JSN = Player(model: PlayerJSON(first: "Jaxon ", last: "Smith-Njigba", id: "5", age: 23, position: "WR", experience: 2, depthChartPOS: 1, weight: "215", height: "5'10", team: "JAX", college: "Clemson Tigers", searchRank: 1, status: "Active"))
    let NJOKU = Player(model: PlayerJSON(first: "David ", last: "Njoku", id: "6", age: 23, position: "TE", experience: 2, depthChartPOS: 1, weight: "215", height: "5'10", team: "JAX", college: "Clemson Tigers", searchRank: 1, status: "Active"))
    let DENVER = Player(model: PlayerJSON(first: "Denver ", last: "Broncos", id: "7", age: 23, position: "DEF", experience: 2, depthChartPOS: 1, weight: "215", height: "5'10", team: "JAX", college: "Clemson Tigers", searchRank: 1, status: "Active"))
    let GAY = Player(model: PlayerJSON(first: "Matt ", last: "Gay", id: "8", age: 23, position: "K", experience: 2, depthChartPOS: 1, weight: "215", height: "5'10", team: "JAX", college: "Clemson Tigers", searchRank: 1, status: "Active"))
    let DRE = Player(model: PlayerJSON(first: "Dre ", last: "Greenlaw", id: "9", age: 23, position: "IDP", experience: 2, depthChartPOS: 1, weight: "215", height: "5'10", team: "JAX", college: "Clemson Tigers", searchRank: 1, status: "Active"))
    static let instance = TeamHomeLogic()
    @Published var selectedLeague: League?
    @Published var selectedOwner: Owner?
    @Published var owners: [Owner]?
    
}

struct TeamHomeView: View {
    
    @ObservedObject var leagueSyncVM = LeagueSyncViewModel.instance
    @ObservedObject var teamHomeLogic = TeamHomeLogic.instance

    var sleeperLogic = SleeperManager.instance
    
    @State var players: [Player] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                leagueTitle
                HStack {
                    avatar
                    name
                }
                listOfPlayers
                Spacer()
                fetchAllPLayersButton
                    .padding()
            }
            
            .task {
                getRosters()
                //            getPlayersForTeam()
            }
        }
    }
    
    private var leagueTitle: some View {
        Text((teamHomeLogic.selectedLeague?.name ?? "Arce Champion's League").uppercased())
    }
    
    private var avatar: some View {
        Text(teamHomeLogic.selectedOwner?.avatarID ?? "")
    }
    
    private var name: some View {
        Text(teamHomeLogic.selectedOwner?.displayName ?? "")
    }
    
    private var listOfPlayers: some View {
        let players = [teamHomeLogic.TLAW,
                       teamHomeLogic.ETN,
                       teamHomeLogic.GIBSON,
                       teamHomeLogic.WADDLE,
                       teamHomeLogic.JSN,
                       teamHomeLogic.NJOKU,
                       teamHomeLogic.GAY,
                       teamHomeLogic.DENVER,
                       teamHomeLogic.DRE
        ]
        let sorted = self.players.sorted(by: { $0.position.sortValue < $1.position.sortValue })
        let sortedTwice = sorted.sorted(by: { $0.height > $1.height })
        let _ = print(self.players)
        return ForEach(sorted, id: \.self) { player in
            CellForPlayer(player: player)
        }
    }
    
    private func getRosters() {
        if let id = leagueSyncVM.selectedLeague?.id {
            sleeperLogic.getRostersFromLeagueID(id) { rosters, error in
                self.handleError(error)
                if let rosters = rosters {
                    var ownersWithRosters: [Owner] = []
                    for owner in teamHomeLogic.owners ?? [] {
                        if let roster = rosters.first(where: { $0.ownerID == owner.id }) {
                            var ownerWRoster = owner
                            ownerWRoster.roster = roster
                            
                            if owner.id == teamHomeLogic.selectedOwner?.id {
                                DispatchQueue.main.async {
                                    teamHomeLogic.selectedOwner = ownerWRoster
                                }
                            }
                            
                            ownersWithRosters.append(ownerWRoster)
                        }
                    }
                    DispatchQueue.main.async {
                        teamHomeLogic.owners = ownersWithRosters
                        self.getPlayersForTeam()
                    }
                }
            }
        }
    }
    
    private func handleError(_ error: Error?) {
        
    }
    
    private var fetchAllPLayersButton: some View {
        Button {
            sleeperLogic.getAllPlayersInfo { players, error in
                self.handleError(error)
                if let players = players {
                    FirebaseManager.instance.addPlayersToFirestore(players) { error in
                        if let error = error {
                            self.handleError(error)
                        }
                    }
                }
            }
        } label: {
            Text("FETCH ALL PLAYERS")
        }
        .disabled(true)

    }
    
    private func getPlayersForTeam() {
        if let team = teamHomeLogic.selectedOwner {
            FirebaseManager.instance.getPlayersFromFirestoreFromPlayerIDs(team.roster.playerIDs) { players, error in
                self.handleError(error)
                if let players = players {
                    self.players = players
                }
            }
        }
    }

    
}

struct TeamHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TeamHomeView()
    }
}

struct CellForPlayer: View {
   
    let player: Player
    
    var body: some View {
        HStack {
            squareForPlayerPosition(player.position)
            Text(player.name)
            Spacer()
            HStack { // change to geo
                height
                weight
                Text("\(player.searchRank)")
            }
        }
        .padding(.horizontal)
    }
    
    var height: some View {
        Text(player.height)
    }
    
    var weight: some View {
        Text(player.weight)
    }
    
    private func squareForPlayerPosition(_ position: Position) -> some View {
        Rectangle()
            .fill(position.color)
            .frame(width: 40, height: 30)
            .overlay(
                Text(position.rawValue.uppercased())
                    .foregroundColor(position.isIDP ? .white : .black))
    }
    
    
    private func positionRectangle(_ position: Position) -> some View {
        ZStack {
             Rectangle()
                 .fill(Color.red)
                 .cornerRadius(20)
             Rectangle()
                 .fill(Color.blue)
                 .cornerRadius(20)
                 .offset(x: -100)
            Rectangle()
                .fill(Color.green)
                .offset(x: -40)
                .frame(width: 100)
            
         }
         .frame(width: 200, height: 200)
    }
}
