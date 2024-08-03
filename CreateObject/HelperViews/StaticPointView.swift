//
//  StaticPointView.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/07/2024.
//

import Foundation
import SwiftUI


struct StaticPointView: View {
    let position: [PositionAsIosAxes]
    var body: some View {
        MyCircle(fillColor: .black, strokeColor: .black, dimension
                         :40, position: CGPoint(x: position[0].x ,y: position[0].y))
        MyCircle(fillColor: .white, strokeColor: .black, dimension
                         :20, position: CGPoint(x: position[0].x ,y: position[0].y))
    }
}

