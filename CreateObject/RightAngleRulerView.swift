//
//  RightAngleRulerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import SwiftUI






struct RightAngleRulerView: View {
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
            
            RulerView()
            RulerView()
                .rotationEffect(Angle(degrees: -90))
                .offset(CGSize(
                    width: (rulerFrameSize.length - width) / 2.0 , 
                    height: (-rulerFrameSize.length + width ) / 2.0))
        }
    
        .modifier(ForObjectDrag(frameSize: rulerFrameSize, active: true))
        }
}



struct RulerView: View {
    @EnvironmentObject var rulerVM: RulerViewModel
    var body: some View {
        let rulerDictionary = rulerVM.getDictionaryForScreen()
        let rulerMarksDictionary = rulerVM.getRulerMarks()
        let rulerNumberDictionary = rulerVM.getNumberDictionary()

        
        ZStack{
           
            RulerAllPartView(
               // uniquePartName: "",
                preTiltFourCornerPerKeyDic: rulerDictionary,
                dictionaryForScreen:  rulerDictionary//,
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


struct RulerAllPartView: View {
    
//    let partToEdit: Part
    //let uniquePartName: String
    var preTiltFourCornerPerKeyDic: CornerDictionary
    var postTiltObjectToFourCornerPerKeyDic: CornerDictionary
    
    var dictionaryElementIn: DictionaryElementIn {
        DictionaryElementIn(
            postTiltObjectToFourCornerPerKeyDic,
            ""//uniquePartName
        )
    }
    
    var partCorners: [CGPoint] {
        dictionaryElementIn.cgPointsOut()
    }
    
//    var zPosition: Double {
//        //ensures objects drawn in order of height
//        dictionaryElementIn.maximumHeightOut()
//    }

    let color: Color = Color("rulerEdges")
    init(
      //  uniquePartName: String,
        preTiltFourCornerPerKeyDic: CornerDictionary,
        dictionaryForScreen: CornerDictionary//,
 
    ){
        //self.uniquePartName = uniquePartName
        self.preTiltFourCornerPerKeyDic = preTiltFourCornerPerKeyDic
        self.postTiltObjectToFourCornerPerKeyDic = dictionaryForScreen
    }
    

    
    var body: some View {

        RulerPartView(
            corners: partCorners,
            color: color
        )
        .zIndex(
            
            1000
        )
//        .onTapGesture {
//            partEditVM.setCurrentPartToEditName(uniquePartName)
//        }
    }
}


struct RulerPartView: View {
    let corners: [CGPoint]
    let color: Color
    static let opacity: Double = 0.08
    static let lineWidth: Double = 5.0
    @StateObject var vm: RulerPartViewModel
    init (corners: [CGPoint], color: Color
    ) {
        self.corners = corners
        self.color = color
      
        _vm = StateObject(wrappedValue: RulerPartViewModel(corners: corners, color: color, opacity: Self.opacity, lineWidth: Self.lineWidth))
    }

    var body: some View {
        ZStack {
            vm.path()
                .fill(color)
                .opacity(Self.opacity)
            
            vm.path()
                .stroke(Color.black, lineWidth: Self.lineWidth)
        }
    }
}


class RulerPartViewModel: ObservableObject, 
    PartRectangle {
    var corners: [CGPoint]
    var color: Color
    var opacity: Double
    var lineWidth: Double
    let cornerRadius = 0.0

    init(
        corners: [CGPoint],
        color: Color = .white,
        opacity: Double,
        lineWidth: Double
    ) {
        self.corners = corners
        self.color = color
        self.opacity = opacity
        self.lineWidth = lineWidth
        
    }
}

