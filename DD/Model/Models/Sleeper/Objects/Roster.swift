//
//  Roster.swift
//  DD
//
//  Created by Spencer Belton on 5/29/23.
//

import Foundation

struct Roster {
    
    var id: Int
    var playerIDs: [String]
    var starterIDs: [String]
    var taxiIDs: [String]
    let leagueID: String
    let ownerID: String

    init(id: Int = 0, players: [String] = [], starters: [String] = [], taxi: [String] = [], leagueID: String = "", ownerID: String = "") {
        self.id = id
        self.playerIDs = players
        self.starterIDs = starters
        self.taxiIDs = taxi
        self.leagueID = leagueID
        self.ownerID = ownerID
    }
    
    init(model: RosterJSON) {
        self.id = model.id
        self.playerIDs = model.allPlayersIDs
        self.starterIDs = model.startersAsIDs
        self.taxiIDs = model.taxiIDs
        self.leagueID = model.leagueID
        self.ownerID = model.ownerID
    }
    
    func getPlayersFromIDs(withCompletion completion: @escaping([PlayerJSON]) -> Void) {
        
        // Firebase get player fromID (need to populate firebase first)
    }
}
