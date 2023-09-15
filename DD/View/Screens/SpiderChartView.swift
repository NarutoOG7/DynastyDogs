//
//  SpiderChartView.swift
//  DD
//
//  Created by Spencer Belton on 5/29/23.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct SpiderChartView: Shape {
    let dataPoints: [Double] // Array of data points for each variable
    let maxValue: Double // Maximum value for scaling the chart

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        // Draw border lines
        path.move(to: CGPoint(x: center.x + radius, y: center.y))
        for index in 1...dataPoints.count {
            let angle = CGFloat(2 * .pi * Double(index) / Double(dataPoints.count))
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.closeSubpath()

        // Draw additional lines
        let intervalCount = 2 // Number of additional lines
        for i in 1...intervalCount {
            let intervalRadius = radius * CGFloat(i) / CGFloat(intervalCount + 1)
            path.move(to: CGPoint(x: center.x + intervalRadius, y: center.y))
            for index in 1...dataPoints.count {
                let angle = CGFloat(2 * .pi * Double(index) / Double(dataPoints.count))
                let x = center.x + intervalRadius * cos(angle)
                let y = center.y + intervalRadius * sin(angle)
                path.addLine(to: CGPoint(x: x, y: y))
            }
            path.closeSubpath()
        }

        return path
    }
}


struct SpiderChartView_Previews: PreviewProvider {

    
    static var previews: some View {
        let dataPoints: [Double] = [0.2, 0.6, 0.9, 0.7, 0.5]
        let maxValue: Double = 1.0
        ZStack {
            
            SpiderChartView(dataPoints: dataPoints, maxValue: maxValue)
                .fill(Color.blue.opacity(0.5))
            SpiderChartView(dataPoints: dataPoints, maxValue: maxValue)
                .stroke(Color.yellow, lineWidth: 1)
                .aspectRatio(contentMode: .fit)
                .padding()

        }
        .aspectRatio(contentMode: .fit)
        .padding()
    }
}
