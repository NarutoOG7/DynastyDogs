//
//  LeagueSyncViewModel.swift
//  DD
//
//  Created by Spencer Belton on 5/28/23.
//

import SwiftUI

class LeagueSyncViewModel: ObservableObject {
    static let instance = LeagueSyncViewModel()
    
    @Published var usernameInput = "" //"SlowMoJo23"
    @Published var leagueIDInput = "" // "916916617538433024"
    
    
    @Published var selectedLeague: League?
    @Published var leagues: [League]?
    @Published var owners: [Owner]?
    @Published var selectedOwner: Owner?
//    @Published var isSearchingByUsername = false
    @Published var moveToChooseTeam = false
    @Published var moveToChooseLeague = false
    @Published var moveToTeamHomeView = false
    
    @Published var leagueIDErrorMessage = ""
    @Published var shouldShowLeagueIDError = false
    
    @Published var usernameErrorMessage = ""
    @Published var shouldShowUsernameError = false
    
    var aFieldIsFilled: Bool {
        usernameInput != "" || leagueIDInput != ""
    }
    
    func submitTapped(withCompletion completion: @escaping(Bool) -> Void) {
        // TODO: maybe find a better way to do this (code below)
        if leagueIDInput != "" {
            self.getSleeperLeagueFromID(withCompletion: completion)
        } else if usernameInput != "" {
            self.getSleeperLeagueFromUsername(withCompletion: completion)
        }
    }
    
    
    func getSleeperLeagueFromID(withCompletion completion: @escaping(Bool) -> Void) {
        SleeperManager.instance.getLeagueFromID(leagueIDInput) { league, error in
            
            if let error = error {
                self.leagueIDErrorHandle(error)
                completion(false)
            }
            if let league = league {
                
                DispatchQueue.main.async {
//                    self.moveToChooseTeam = true
                    self.leagues = [league]
                    self.selectedLeague = league
                    completion(true)
                    
                }
            }
        }
    }
    
    func getSleeperLeagueFromUsername(withCompletion completion: @escaping(Bool) -> Void) {
        SleeperManager.instance.getLeaguesFromUsername(usernameInput) { leagues, error in
            
            if let error = error {
                self.usernameErrorHandle(error)
                completion(false)
            }
            
            if let leagues = leagues {
            
                DispatchQueue.main.async {
//                    self.moveToChooseLeague = true
                    self.leagues = leagues
                    completion(true)

                }
            }
        }
    }
    
    private func usernameErrorHandle(_ error: Error) {
            DispatchQueue.main.async {
                self.usernameErrorMessage = K.ErrorHelper.Messages.Sleeper.usernameNotRecognized.rawValue
                self.shouldShowUsernameError = true
            }
    }
    
    private func leagueIDErrorHandle(_ error: Error) {
            DispatchQueue.main.async {
                self.leagueIDErrorMessage = K.ErrorHelper.Messages.Sleeper.leagueIdNotRecognized.rawValue
                self.shouldShowLeagueIDError = true
            }
        
    }
}

