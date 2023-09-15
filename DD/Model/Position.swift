//
//  Position.swift
//  DD
//
//  Created by Spencer Belton on 5/26/23.
//

import SwiftUI

enum Position: String {
    case qb, rb, wr, te, k, def, lb, db, dl
    
    var color: Color {
        let k = K.PositionColors.self
        switch self {
            
        case .qb:
            return k.qb
        case .rb:
            return k.rb
        case .wr:
            return k.wr
        case .te:
            return k.te
        case .k:
            return k.k
        case .def:
            return k.def
        case .lb:
            return k.idp
        case .db:
            return k.idp
        case .dl:
            return k.idp
        }
    }
    
    
     init?(from positionString: String) {
         let lowercasedPositionString = positionString.lowercased()
         guard let position = Position(rawValue: lowercasedPositionString) else {
             return nil
         }
         self = position
     }
    
    var sortValue: Int {
        switch self {
            
        case .qb:
            return 1
        case .rb:
            return 2
        case .wr:
            return 3
        case .te:
            return 4
        case .k:
            return 5
        case .def:
            return 6
        case .lb:
            return 7
        case .db:
            return 8
        case .dl: return 9
        }
    }
    
    var isIDP: Bool {
        switch self {
        case .lb, .db, .dl:
            return true
        default: return false
        }
    }
}
