//
//  ErrorManager.swift
//  DD
//
//  Created by Spencer Belton on 6/12/23.
//

import SwiftUI

class ErrorManager: ObservableObject {
    
    static let instance = ErrorManager()
    
    @Published var message = ""
    @Published var shouldDisplay = false
    
    
    func handleError(_ error: Error) {
        self.message = error.localizedDescription
        self.shouldDisplay = true
    }
    
    func handleError(_ error: String) {
        self.message = error
        self.shouldDisplay = true
    }
}

