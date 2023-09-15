//
//  SleeperManagerOwners.swift
//  DD
//
//  Created by Spencer Belton on 5/28/23.
//

import Foundation

extension SleeperManager {
    
    //MARK: - Owners
    
    func getOwnersFromLeagueID(_ leagueID: String, withCompletion completion: @escaping([Owner]?, Error?) -> Void) {
        
        if let url = URL(string: "https://api.sleeper.app/v1/league/\(leagueID)/users") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                }
                if let data = data {
                    do {
                        if let results = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                            
                            var owners: [Owner] = []
                            
                            for result in results {
                                let model = OwnerJSON(dictionary: result)
                                let owner = Owner(model: model)
                                owners.append(owner)
                            }
                            
                            completion(owners, nil)
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
