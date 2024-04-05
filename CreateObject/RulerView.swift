//
//  Ruler.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import SwiftUI



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

//struct RotatableRuler: View {
//    @EnvironmentObject var rulerVM: RulerViewModel
//    @State private var rulerAngle = 0.0
//    
//    var body: some View {
//        let rulerFrameSize = rulerVM.getRulerFrameSize()
//        let arrow = rulerAngle == 0 ? "arrow.counterclockwise": "arrow.clockwise"
// 
//            ZStack{
//                ZStack (alignment: .top){
//                    
//                    Ruler()
//                    
//                    Button(action: {
//                        rulerAngle = rulerAngle == 0 ? -90: 0
//                    }) {
//                        Image(systemName: arrow)
//                            .font(.system(size: 100))
//                            .padding(.top)
//                    }
//                }
//                .modifier(ForObjectDrag(frameSize: rulerFrameSize, active: true))
//                .rotationEffect(Angle(degrees: rulerAngle))
//            }
//    }
//}
//struct RotatableRuler: View {
//    @EnvironmentObject var rulerVM: RulerViewModel
//    @State private var rulerAngle = 0.0
//
//    var body: some View {
//        let rulerFrameSize = rulerVM.getRulerFrameSize()
//        let arrow = rulerAngle == 0 ? "arrow.counterclockwise" : "arrow.clockwise"
//        
//
//
//        ZStack {
//            ZStack(alignment: .top) {
//                
//                Ruler()
//                
//                Button(action: {
//                    rulerAngle = rulerAngle == 0 ? -90 : 0
//                }) {
//                    Image(systemName: arrow)
//                        .font(.system(size: 100))
//                        .padding(.top)
//                }
//            }
//            .modifier(ForObjectDrag(frameSize: rulerFrameSize, active: true))
//            
//           
//        }.rotationEffect(Angle(degrees: rulerAngle))    }
//}

struct RightAngleRuler: View {
    @EnvironmentObject var rulerVM: RulerViewModel
    @EnvironmentObject var unitSystemVM: UnitSystemViewModel
   
    var body: some View {
        let rulerFrameSize = rulerVM.getRulerFrameSize()
        let width = rulerVM.width
        var unitSystem: UnitSystem {unitSystemVM.unitSystem}
        ZStack(alignment: .topLeading ){
            Text(unitSystem.rawValue)
                .font(.system(size: 60))
                .padding()
            Ruler()
            Ruler()
                .rotationEffect(Angle(degrees: -90))
                .offset(CGSize(
                    width: (rulerFrameSize.length - width) / 2.0 , 
                    height: (-rulerFrameSize.length + width ) / 2.0))
        }
    
        .modifier(ForObjectDrag(frameSize: rulerFrameSize, active: true))
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

        }
    }
}


