//
//  NetworkManager.swift
//  DD
//
//  Created by Spencer Belton on 6/12/23.
//

import SwiftUI
import Network

class NetworkManager: ObservableObject {
    
    static let instance = NetworkManager()
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    @Published private(set) var connected: Bool = false
    
    init() {
        checkConnection()
    }
    
    func checkConnection() {
        
        monitor.pathUpdateHandler = { path in
            
            DispatchQueue.main.async {
                
                if path.status == .satisfied {
                    
                    self.connected = true
                    
                } else {
                    
                    self.connected = false
                }
            }
        }
        
        monitor.start(queue: queue)
    }
    
}

