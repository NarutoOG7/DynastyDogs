//
//  Player.swift
//  DD
//
//  Created by Spencer Belton on 5/26/23.
//

import Foundation

struct PlayerJSON: Codable {
    
    let first: String?
    let last: String?
    let id: String?
    let age: Int?
    let position: String?
    let experience: Int?
    let depthChartPOS: Int?
    let weight: String?
    let height: String?
    let team: String?
    let college: String?
    let searchRank: Int?
    let status: String?
    
    init(first: String, last: String, id: String, age: Int, position: String, experience: Int, depthChartPOS: Int, weight: String, height: String, team: String, college: String, searchRank: Int, status: String) {
        self.first = first
        self.last = last
        self.id = id
        self.age = age
        self.position = position
        self.experience = experience
        self.depthChartPOS = depthChartPOS
        self.weight = weight
        self.height = height
        self.team = team
        self.college = college
        self.searchRank = searchRank
        self.status = status
    }
    
    
    init(dictionary: [String: Any]) {
        let first = dictionary["first_name"] as? String ?? ""
        let last = dictionary["last_name"] as? String ?? ""
        let id = dictionary["player_id"] as? String ?? ""
        let age = dictionary["age"] as? Int ?? 0
        let position = dictionary["position"] as? String ?? ""
        let experience = dictionary["years_exp"] as? Int ?? 0
        let depthChartPOS = dictionary["depth_chart_position"] as? Int ?? 0
        let weight = dictionary["weight"] as? String ?? ""
        let height = dictionary["height"] as? String ?? ""
        let team = dictionary["team"] as? String ?? ""
        let college = dictionary["college"] as? String ?? ""
        let searchRank = dictionary["search_rank"] as? Int ?? 0
        let status = dictionary["status"] as? String ?? ""

        self.first = first
        self.last = last
        self.id = id
        self.age = age
        self.position = position
        self.experience = experience
        self.depthChartPOS = depthChartPOS
        self.weight = weight
        self.height = height
        self.team = team
        self.college = college
        self.searchRank = searchRank
        self.status = status
    }
    
    enum CodingKeys: String, CodingKey {
        case first = "first_name"
        case last = "last_name"
        case id = "player_id"
        case age = "age"
        case position = "position"
        case experience = "years_exp"
        case depthChartPOS = "depth_chart_position"
        case weight = "weight"
        case height = "height"
        case team = "team"
        case college = "college"
        case searchRank = "search_rank"
        case status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.first = try container.decode(String.self, forKey: .first)
        self.last = try container.decode(String.self, forKey: .last)
        self.id = try container.decode(String.self, forKey: .id)
        self.age = try container.decode(Int.self, forKey: .age)
        self.position = try container.decode(String.self, forKey: .position)
        self.experience = try container.decode(Int.self, forKey: .experience)
        self.depthChartPOS = try container.decodeIfPresent(Int.self, forKey: .depthChartPOS)
        self.weight = try container.decode(String.self, forKey: .weight)
        self.height = try container.decode(String.self, forKey: .height)
        self.team = try container.decodeIfPresent(String.self, forKey: .team)
        self.college = try container.decode(String.self, forKey: .college)
        self.searchRank = try container.decode(Int.self, forKey: .searchRank)
        self.status = try container.decode(String.self, forKey: .status)

    }
}
