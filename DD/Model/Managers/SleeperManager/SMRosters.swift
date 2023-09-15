//
//  SMRosters.swift
//  DD
//
//  Created by Spencer Belton on 5/28/23.
//

import Foundation

extension SleeperManager {
    
    //MARK: - Rosters
    
    func getRostersFromLeagueID(_ leagueID: String, withCompletion completion: @escaping([Roster]?, Error?) -> Void) {
        
        if let url = URL(string: "https://api.sleeper.app/v1/league/\(leagueID)/rosters") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                }
                if let data = data {
                    do {
                        if let results = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                            
                            var rosters: [Roster] = []
                            
                            for result in results {
                                let model = RosterJSON(dictionary: result)
                                let roster = Roster(model:  model)
                                rosters.append(roster)
                            }
                            
                            completion(rosters, nil)
                        }
                    } catch {
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        }
    }
}
