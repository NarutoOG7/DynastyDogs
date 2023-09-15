//
//  RankingsView.swift
//  DD
//
//  Created by Spencer Belton on 6/8/23.
//

import SwiftUI

struct RankingsView: View {
    
    @State var rankedPlayers: [RankedPlayer] = []
    
    var body: some View {
        list
        
            .task {
                self.getPlayerRanks()
            }
    }
    
    private var list: some View {
        List(self.rankedPlayers) { player in
            Text(player.name)
                .foregroundColor(.white)
        }
    }
    
    private func getPlayerRanks() {
        FirebaseManager.instance.getAllPlayerRankings { players, error in
            handleError(error)
            if let players = players {
                self.rankedPlayers = players
            }
        }
    }
    
    private func handleError(_ error: Error?) {
        
        
    }
}

struct RankingsView_Previews: PreviewProvider {
    static var previews: some View {
        RankingsView()
    }
}
