//
//  FirebaseManager.swift
//  DD
//
//  Created by Spencer Belton on 6/1/23.
//

import Foundation
import Firebase


extension FirebaseManager {
    
    func addPlayersToFirestore(_ players: [PlayerJSON], withcCompletion completion: @escaping(Error?) -> Void) {
        
        guard let db = db else { return }
        
        for player in players {
            if let id = player.id {
                let name = (player.first ?? "") + " " + (player.last ?? "")
                db.collection("Players").document(id)
                    .setData( [
                        "name" : name as Any,
                        "id" : player.id as Any,
                        "age" : player.age as Any,
                        "position" : player.position as Any,
                        "experience" : player.experience as Any,
                        "depthChartPOS" : player.depthChartPOS as Any,
                        "weight" : player.weight as Any,
                        "height" : player.height as Any,
                        "team" : player.team as Any,
                        "college" : player.college as Any,
                        "searchRank" : player.searchRank as Any
                    ]) { error in
                        
                        if let error = error {
                            print(error.localizedDescription)
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
            }
        }
    }
    
    func getPlayersFromFirestoreFromPlayerIDs(_ playerIDs: [String], withCompletion completion: @escaping([Player]?, Error?) -> Void) {
        
        guard let db = db else { return }
        let group = DispatchGroup()
        var players: [Player] = []
        
        for playerID in playerIDs {
            group.enter()
            let playerRef = db.collection("Players")
                .whereField("id", isEqualTo: playerID)
            
            playerRef.getDocuments { snapshot, error in
                
                if let error = error {
                    completion(nil, error)
                }
                if let snapshot = snapshot {
                    for doc in snapshot.documents {
                        let dict = doc.data()
                        let player = Player(dictionary: dict)
                        players.append(player)
                    }
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(players, nil)
        }
    }
    
    
    func getAllPlayerRankings(withCompletion completion: @escaping([RankedPlayer]?, Error?) -> Void) {
        
        let ref = Database.database().reference().child("FPAll2023")
        ref.getData { error, snapshot in
            if let error = error {
                completion(nil, error)
            }
            if let snapshot = snapshot {
                
                if snapshot.childrenCount > 0 {
                    
                    if let objects = snapshot.children.allObjects as? [DataSnapshot] {
                        
                        var players: [RankedPlayer] = []
                        
                        for object in objects {
                            
                            if let data = object.value as? [String : Any] {
                                                                
                                let rankedPlayer = RankedPlayer(dictionary: data)
                                
                                players.append(rankedPlayer)
                                
                            }
                        }
                        completion(players, nil)
                    }
                }
            }
        }
    }
    
    func getTopTenPlayerRankings(withCompletion completion: @escaping([RankedPlayer]?, Error?) -> Void) {
        
        let ref = Database.database()
            .reference().child("FPAll2023")
            .queryLimited(toFirst: 10)
        ref.getData { error, snapshot in
            if let error = error {
                completion(nil, error)
            }
            if let snapshot = snapshot {
                
                if snapshot.childrenCount > 0 {
                    
                    if let objects = snapshot.children.allObjects as? [DataSnapshot] {
                        
                        var players: [RankedPlayer] = []
                        
                        for object in objects {
                            
                            if let data = object.value as? [String : Any] {
                                                                
                                let rankedPlayer = RankedPlayer(dictionary: data)
                                
                                players.append(rankedPlayer)
                                                                
                            }
                        }

                        completion(players, nil)
                    }
                }
            }
        }
    }
    
    func getTopAmountAtPosition(_ amount: Int, _ position: Position, withCompletion completion: @escaping([RankedPlayer]?, Error?) -> Void) {
        
        let ref = Database.database()
            .reference().child("FPAll2023")
//            .queryOrdered(byChild: "POS")
            .queryLimited(toFirst: UInt(amount))
//            .queryEnding(atValue: "WR5")
//            .queryEqual(toValue: "WR")
        ref.getData { error, snapshot in
            if let error = error {
                completion(nil, error)
            }
            if let snapshot = snapshot {
                
                if snapshot.childrenCount > 0 {
                    
                    if let objects = snapshot.children.allObjects as? [DataSnapshot] {
                        
                        var players: [RankedPlayer] = []
                        
                        for object in objects {
                            
                            if let data = object.value as? [String : Any] {
                                                                
                                let rankedPlayer = RankedPlayer(dictionary: data)
                                
                                players.append(rankedPlayer)
                                                                
                            }
                        }

                        completion(players, nil)
                    }
                }
            }
        }
    }
}

