//
//  AnimatedGraphPath.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 27.03.2024.
//

import SwiftUI

struct AnimatedGraphPath: Shape {
    var progress: CGFloat
    var points:  [CGPoint]
    var animatableData: CGFloat{
        get{ return progress }
        set{ progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    }
}
