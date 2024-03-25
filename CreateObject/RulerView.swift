//
//  Ruler.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import SwiftUI

struct Ruler: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel

    let cornerRadius = 2.0
    let opacity = 0.05
    let lineWidth = 1.0
    var body: some View {
        let scale = 0.5//objectPickVM.getScale()
        let scaleX = 200.0
        let scaleY = 2000.0
        let rectanglePoints: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: scaleX, y: 0),
            CGPoint(x: scaleX, y: scaleY),
            CGPoint(x: 0, y: scaleY)]

        ZStack{
            LocalOutlineRectangle.path(corners: rectanglePoints, .black, cornerRadius, opacity, lineWidth)
                
            Line(width: scaleX, height: scaleY)
            
        }

    }
}


struct Line: View {
    let width: Double
    let height: Double
    var body: some View {
        Path { path in
            let startPoint = CGPoint(x: 0, y:   height/2)
            path.move(to: startPoint)
            let endPoint = CGPoint(x: width/3, y: height/2)
            path.addLine(to: endPoint)
        }
        .stroke(Color.black, lineWidth: 5)
    }
}


#Preview {
    Ruler()
}
