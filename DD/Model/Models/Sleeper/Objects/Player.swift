//
//  Player.swift
//  DD
//
//  Created by Spencer Belton on 5/29/23.
//

import Foundation

struct Player: Hashable, Identifiable {
    
    let name: String
    let id: String
    let age: Int
    let position: Position
    let experience: Int
    let depthChartPOS: Int
    let weight: String
    let height: String
    let team: String
    let college: String
    let searchRank: Int
    
    init(name: String, id: String, age: Int, position: Position, experience: Int, depthChartPOS: Int, weight: String, height: String, team: String, college: String, searchRank: Int) {
        self.name = name
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
    }
    
    init(model: PlayerJSON) {
        self.name = (model.first ?? "") + " " + (model.last ?? "")
        self.id = model.id ?? ""
        self.age = model.age ?? 0
        self.position = Position(from: model.position ?? "qb") ?? .qb
        self.experience = model.experience ?? 0
        self.depthChartPOS = model.depthChartPOS ?? 0
        self.weight = model.weight ?? ""
        self.height = model.height ?? ""
        self.team = model.team ?? ""
        self.college = model.college ?? ""
        self.searchRank = model.searchRank ?? 0
    }
    
    init(dictionary: [String: Any]) {
        let name = dictionary["name"] as? String ?? ""
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

        self.name = name
        self.id = id
        self.age = age
        self.position = Position(from: position) ?? .qb
        self.experience = experience
        self.depthChartPOS = depthChartPOS
        self.weight = weight
        self.height = height
        self.team = team
        self.college = college
        self.searchRank = searchRank
    }
    
    func projections(withCompletion completion: @escaping(Projections) -> Void) {
        // TODO Connect to sleeper projections api
    }
}
