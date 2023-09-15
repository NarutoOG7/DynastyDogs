//
//  SleeperManager.swift
//  DD
//
//  Created by Spencer Belton on 5/27/23.
//

import Foundation

class SleeperManager {
    static let instance = SleeperManager()
    
    //MARK: - League Info
    
    func getUserIDFromUsername(_ username: String, withCompletion completion: @escaping(String?, Error?) -> Void) {
        if let url = URL(string: "https://api.sleeper.app/v1/user/\(username)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                }
                if let data = data {
                    do {
                        if let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            let userID = result["user_id"] as? String ?? ""
                            completion(userID, nil)
                        }
                    } catch {
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getLeaguesFromUsername(_ username: String,  withCompletion completion: @escaping([League]?, Error?) -> Void) {
        self.getUserIDFromUsername(username) { userID, error in
            if let error = error {
                completion(nil, error)
            }
            if let userID = userID {
                if let url = URL(string: "https://api.sleeper.app/v1/user/\(userID)/leagues/nfl/2023") {
                    print(url.absoluteString)
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        if let error = error {
                            completion(nil, error)
                        }
                        if let data = data {
                            self.parsLeagueInfoJSONasArray(data) { leagues, error in
                                if let error = error {
                                    completion(nil, error)
                                }
                                if let leagues = leagues {
                                    completion(leagues, nil)
                                }
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
    }
    
    func getLeagueFromID(_ id: String, withCompletion completion: @escaping(League?, Error?) -> Void) {
        if let url = URL(string: "https://api.sleeper.app/v1/league/\(id)") {
            sessionForLeagueInfoWithURL(url) { league, error in
                if let error = error {
                    completion(nil, error)
                }
                if let league = league {
                    completion(league, nil)
                }
            }
        }
    }
    
    private func sessionForLeagueInfoWithURL(_ url: URL, withCompletion completion: @escaping(League?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            if let data = data {
                self.parsLeagueInfoJSON(data) { leagueModel, error in
                    if let error = error {
                        completion(nil, error)
                    }
                    if let leagueModel = leagueModel {
                        let league = League(model: leagueModel)
                        completion(league, nil)
                    }
                }
            }
        }
        task.resume()
        
    }
    
    private func parsLeagueInfoJSONasArray(_ data: Data, withCompletion completion: @escaping([League]?, Error?) -> Void) {
        do {
            
//            let leagues = try JSONDecoder().decode([League].self, from: data)
            var leagues: [League] = []
            if let results = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:Any]] {
                
                for result in results {
                    let leagueModel = LeagueJSON(dictionary: result)
                    let league = League(model: leagueModel)
                    leagues.append(league)
                }
                
                //             let results = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                
                //            if let results = results {
                //                var leagues: [League] = []
                //                for result in results {
                //                    let league = League(dictionary: result)
                //                    leagues.append(league)
                //                }
                completion(leagues, nil)
                //            }
            }
        } catch {
            completion(nil, error)
        }
    }
    
    private func parsLeagueInfoJSON(_ data: Data, withCompletion completion: @escaping(LeagueJSON?, Error?) -> Void) {
        do {
            if let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                let league = LeagueJSON(dictionary: result)
                completion(league, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
}
