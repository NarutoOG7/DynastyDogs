//
//  Owner.swift
//  DD
//
//  Created by Spencer Belton on 5/29/23.
//

import Foundation

struct Owner: Identifiable, Equatable {
    static func == (lhs: Owner, rhs: Owner) -> Bool {
        lhs.id == rhs.id
    }
    
    
    let id: String
    let username: String
    let displayName: String
    let avatarID: String
    var roster: Roster
    
    init(id: String, username: String, displayName: String, avatarID: String, roster: Roster) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.avatarID = avatarID
        self.roster = roster
    }
    
    init(model: OwnerJSON) {
        self.id = model.id
        self.username = model.username
        self.displayName = model.displayName
        self.avatarID = model.avatarID
        self.roster = Roster()
    }
    
}
