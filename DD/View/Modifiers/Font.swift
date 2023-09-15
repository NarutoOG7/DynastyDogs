//
//  Font.swift
//  DD
//
//  Created by Spencer Belton on 5/26/23.
//

import SwiftUI

extension Font {
    
    static func avenirNext(size: Int) -> Font {
        Font.custom("Avenir Next", size: CGFloat(size))
    }
    
    static func avenirNextRegular(size: Int) -> Font {
        Font.custom("AvenirNext-Regular", size: CGFloat(size))
    }
}
