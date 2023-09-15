//
//  Owner.swift
//  DD
//
//  Created by Spencer Belton on 5/28/23.
//

import Foundation

struct OwnerJSON: Codable {
    
    let id: String
    let username: String
    let displayName: String
    let avatarID: String
    
    init(dictionary: [String:Any]) {
        self.id = dictionary["user_id"] as? String ?? ""
        self.username = dictionary["usrname"] as? String ?? ""
        self.displayName = dictionary["display_name"] as? String ?? ""
        self.avatarID = dictionary["avatar"] as? String ?? ""
    }
    
    private enum Key: String, CodingKey {
      case id = "user_id"
        case displayName = "display_name"
        case username
        case avatar
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.avatarID = try container.decode(String.self, forKey: .avatar)
        self.displayName = try container.decode(String.self, forKey: .displayName)
    }
}
