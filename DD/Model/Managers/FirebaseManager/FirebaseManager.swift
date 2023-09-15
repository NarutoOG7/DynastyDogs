//
//  FirebaseManager.swift
//  DD
//
//  Created by Spencer Belton on 6/11/23.
//

import SwiftUI
import Firebase

class FirebaseManager {
    
    static let instance = FirebaseManager()
    
    var db: Firestore?
    
    init() {
        db = Firestore.firestore()
    }
}
