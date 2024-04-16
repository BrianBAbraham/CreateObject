//
//  CircleView.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/05/2023.
//

import SwiftUI

//struct OriginView: View {
//    let originDictionary: [String: PositionAsIosAxes]
//    
//
//    var originDictionaryWithCGPointValues: [String: CGPoint] {
//        DictionaryWithValue(originDictionary).asCGPoint()
//    }
//    
//   var keys: [String] {
//        originDictionaryWithCGPointValues.map {$0.key}
//    }
//    var values: [CGPoint] {
//        originDictionaryWithCGPointValues.map {$0.value}
//    }
    

    
//    var body: some View {
        //ForEach(0..<keys.count, id: \.self) {index in
//            MyCircle(fillColor: .black, strokeColor: .black, 10, values)
       // }
//    }
//}

struct MyCircle: View {
    let strokeColor: Color
    let fillColor: Color?
    let dimension: Double
    let position: CGPoint
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    init(fillColor: Color?, strokeColor: Color,  _ dimension: Double, _ position: CGPoint) {
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.dimension = dimension
        self.position = position
    }
    var body: some View {
        ZStack{
            if let fillColorUnwrapped = fillColor {
                ZStack{
                    Circle()
                        .fill(fillColorUnwrapped)
                        .modifier(CircleModifier( dimension: dimension, position: position))
                    Circle()
                        .fill(.black)
                        .modifier(CircleModifier( dimension: 10, position: position))
                        .opacity(0.0001)
                }
            }
            Circle()
                .stroke(self.strokeColor)
                .modifier(CircleModifier( dimension: dimension, position: position))
        }
    }
}

struct CircleModifier: ViewModifier {
    let dimension: Double
    let position: CGPoint
    
    func body(content: Content) -> some View {
        content
            .frame(width: self.dimension, height: self.dimension)
            .position(self.position)
    }
}

//struct CircleView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyCircle()
//    }
//}
