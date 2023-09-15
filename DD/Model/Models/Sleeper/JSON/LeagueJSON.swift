//
//  League.swift
//  DD
//
//  Created by Spencer Belton on 5/27/23.
//

import Foundation

struct LeagueJSON: Codable {
    
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
    
    init(dictionary: [String:Any]) {
        self.id = dictionary["league_id"] as? String ?? ""
        self.teamCount = dictionary["total_rosters"] as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
        self.avatarID = dictionary["avatar"] as? String ?? ""

    }
    
    private enum Key: String, CodingKey {
      case id = "league_id"
        case teamCount = "total_rosters"
        case name
        case avatar
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.teamCount = try container.decode(Int.self, forKey: .teamCount)
        self.avatarID = try container.decode(String.self, forKey: .avatar)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
