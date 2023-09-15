//
//  Team.swift
//  DD
//
//  Created by Spencer Belton on 5/26/23.
//

import Foundation

struct RosterJSON {
    
    var startersAsIDs: [String]
    var allPlayersIDs: [String]
    var taxiIDs: [String]
    var id: Int
    let leagueID: String
    let ownerID: String

    
    
    init(startersAsIDs: [String] = [],
         allPlayersIDs: [String] = [],
         taxiIDs: [String] = [],
         id: Int = 0,
         leagueID: String = "",
         ownerID: String = "") {
        
        self.startersAsIDs = startersAsIDs
        self.allPlayersIDs = allPlayersIDs
        self.taxiIDs = taxiIDs
        self.id = id
        self.leagueID = leagueID
        self.ownerID = ownerID
    }
    
    init(dictionary: [String:Any]) {
        self.startersAsIDs = dictionary["starters"] as? [String] ?? []
        self.allPlayersIDs = dictionary["players"] as? [String] ?? []
        self.taxiIDs = dictionary["taxi"] as? [String] ?? []
        self.id = dictionary["roster_id"] as? Int ?? 0
        self.leagueID = dictionary["league_id"] as? String ?? ""
        self.ownerID = dictionary["owner_id"] as? String ?? ""
    }
}
