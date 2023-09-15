//
//  League.swift
//  DD
//
//  Created by Spencer Belton on 5/29/23.
//

import Foundation

struct League: Identifiable, Equatable {
    
    let id: String
    let teamCount: Int
    let name: String
    let avatarID: String
    
    init(id: String, teamCount: Int, name: String, avatarID: String) {
        self.id = id
        self.teamCount = teamCount
        self.name = name
        self.avatarID = avatarID
    }
    
    init(model: LeagueJSON) {
        self.id = model.id
        self.teamCount = model.teamCount
        self.name = model.name
        self.avatarID = model.avatarID

    }

}
