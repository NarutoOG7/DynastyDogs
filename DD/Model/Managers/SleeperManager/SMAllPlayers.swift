//
//  SMAllPlayers.swift
//  DD
//
//  Created by Spencer Belton on 6/1/23.
//

import Foundation

extension SleeperManager {

    //   WARNING   //  API CALL TO BE CALLED ONLY ONCE PER DAY  //   WARNING   //
    
    //MARK: - All Players (This API to be called only once per day)

    func getAllPlayersInfo(withCompletion completion: @escaping([PlayerJSON]?, Error?) -> Void) {
        
        if let url = URL(string: "https://api.sleeper.app/v1/players/nfl") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                }
                if let data = data {
//                    do {
//                        let decoder = JSONDecoder()
//                        decoder.keyDecodingStrategy = .custom { keys -> CodingKey in
//                            let key = keys.last!
//                            return PlayerJSON.CodingKeys(rawValue: key.stringValue) ?? key
//                        }
//                        print(data)
//                        let playersDict = try decoder.decode([String: PlayerJSON].self, from: data)
//                        let values = playersDict.values
//                        let arrayOfValues = Array(values)
//                        print(arrayOfValues)
//                        completion(arrayOfValues, nil)
//
//                    } catch {
//                        print(error.localizedDescription)
//                        completion(nil, error)
//                    }
                    
                    do {
                        var players: [PlayerJSON] = []
                        
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : [String:Any]] {

                        
//                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: [String:Any]]] {
                            for dict in jsonArray {
                                let player = PlayerJSON(dictionary: dict.value)
                                players.append(player)
                            }
                        }
                        completion(players, nil)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        }
    }
}
