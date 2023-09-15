//
//  UserStore.swift
//  DD
//
//  Created by Spencer Belton on 6/11/23.
//

import SwiftUI

class UserStore: ObservableObject {
    
    static let instance = UserStore()
        
    var adminKey = ""
    
    @Published var isSignedIn = UserDefaults.standard.bool(forKey: "signedIn")
    @Published var selectedLocationDistanceToUser: Double = 0
    @Published var user = User()
    @Published var leagues: [League] = []

    
    @Published var userSigningOut: Bool?
}
