//
//  RankedPlayer.swift
//  DD
//
//  Created by Spencer Belton on 6/8/23.
//

import Foundation

struct RankedPlayer: Identifiable {
    
    let id: Int
    let age: Int
    let byeWeek: Int
    let ecrVsADP: String
    let name: String
    let positionRank: String
    let strengthOfSchedule: String
    let team: String
    let tier: Int
    
    init(dictionary: [String:Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.age = dictionary["AGE"] as? Int ?? 0
        self.byeWeek = dictionary["BYE WEEK"] as? Int ?? 0
        self.ecrVsADP = dictionary["ECR VS ADP"] as? String ?? ""
        self.name = dictionary["PLAYER NAME"] as? String ?? ""
        self.positionRank = dictionary["POS"] as? String ?? ""
        self.strengthOfSchedule = dictionary["SOS SEASON"] as? String ?? ""
        self.team = dictionary["TEAM"] as? String ?? ""
        self.tier = dictionary["TIERS"] as? Int ?? 0
    }
    
}
