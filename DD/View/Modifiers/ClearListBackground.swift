//
//  ClearListBackground.swift
//  DD
//
//  Created by Spencer Belton on 6/13/23.
//

import SwiftUI

struct ClearListBackgroundMod: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
            
        }
    }
}
