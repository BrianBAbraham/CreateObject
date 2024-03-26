//
//  Ruler.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import SwiftUI

//struct Ruler2: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//
//    let cornerRadius = 2.0
//    let opacity = 0.05
//    let lineWidth = 1.0
//    var body: some View {
//        let scale = 0.5//objectPickVM.getScale()
//        let scaleX = 200.0
//        let scaleY = 2000.0
//        let rectanglePoints: [CGPoint] = [
//            CGPoint(x: 0, y: 0),
//            CGPoint(x: scaleX, y: 0),
//            CGPoint(x: scaleX, y: scaleY),
//            CGPoint(x: 0, y: scaleY)]
//
//        ZStack{
//            LocalOutlineRectangle.path(corners: rectanglePoints, .black, cornerRadius, opacity, lineWidth)
//                
//            Line(width: scaleX, height: scaleY)
//            
//        }
//
//    }
//}


struct Line: View {
    
   let tertiaryMarkElement: CornerDictionary
   var dictionaryElementIn: DictionaryElementIn {
        DictionaryElementIn(
            tertiaryMarkElement,
            Array(tertiaryMarkElement.keys)[0]
        )
    }
    
    var partCorners: [CGPoint] {
        dictionaryElementIn.cgPointsOut2()
    }
   
    var body: some View {
        
        Path { path in
            path.move(to: CGPoint(x: partCorners[0].x, y: partCorners[0].y))
            path.addLine(to: CGPoint(x: partCorners[1].x, y: partCorners[1].y))
        }
        .stroke(Color.red, lineWidth: 1)
    }
}




struct Ruler: View {
    @EnvironmentObject var rulerVM: RulerViewModel

    let cornerRadius = 0.0
    let opacity = 0.05
    let lineWidth = 0.1
    var body: some View {
        let rulerDictionary = rulerVM.getDictionaryForScreen()
        let rulerMarksDictionary = rulerVM.getRulerMarks()
        let rulerNumberDictionary = rulerVM.getNumberDictionary()
        
        ZStack{
            PartView(
                uniquePartName: "",
                preTiltFourCornerPerKeyDic: rulerDictionary,
                postTiltObjectToFourCornerPerKeyDic:  rulerDictionary,
                color: .black,
                cornerRadius: 0.0,
                opacity: 0.08,
                lineWidth: 0.5
            )
            
            ForEach(rulerMarksDictionary.map { key, value in (key, value) }, id: \.0) { key, value in
                Line(tertiaryMarkElement: [key: value])
                
            }
            
            ForEach(rulerNumberDictionary.map { key, value in (key, value) }, id: \.0) { key, value in
                Text(key)
                    .font(.system(size: 50))
                    .position(x: value.x, y: value.y)
                
            }
            //.border(.blue)
//            Text("2000")
//                .font(.system(size: 60))
//                .rotationEffect(.degrees(-90))
//                .position(CGPoint(x: 100.0, y: 500))
        }
    }
}
