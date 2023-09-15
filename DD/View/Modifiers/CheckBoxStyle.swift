//
//  CheckBoxStyle.swift
//  DD
//
//  Created by Spencer Belton on 6/10/23.
//

import SwiftUI

struct CheckBoxStyle: ToggleStyle {
    
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        // 1
        Button(action: {

            // 2
            configuration.isOn.toggle()

        }, label: {
            HStack {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(color)
                configuration.label
            }
        })
    }
}
