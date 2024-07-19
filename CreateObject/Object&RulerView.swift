//
//  Ruler&Object.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//
import SwiftUI

struct ObjectAndRulerView: View {
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
    @EnvironmentObject var movementDataGetterVM: MovementDataViewModel
    @EnvironmentObject var rulerVM: RulerViewModel
    
   // @EnvironmentObject var movementPickVM: MovementDataViewModel
    @GestureState private var fingerLocation: CGPoint? = nil
    @State private var location = CGPoint (x: 100, y: 500)
   
    
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom = 0.1
    private var maximimumZoom = 0.4
    
    let preTiltFourCornerPerKeyDic: CornerDictionary
    let dictionaryForScreen: CornerDictionary

    
    var defaultScale: Double {
        Screen.smallestDimension /
        movementDataGetterVM.maximumnDimensionOfMotion
        
    }
    
    var measurementScale: Double {
        Screen.smallestDimension /
        movementDataGetterVM.maximumnDimensionOfMotion
       
    }
    
    var objectName: String {
        rulerVM.objectName
    }
    
    let objectFrameSize: Dimension
    
    var zoom: CGFloat {
        getZoom()
    }
   
    let movement: Movement
    let displayStyle: DisplayStyle
    
    
    
    init(
     //   _ partNames: [String],
        _ preTiltFourCornerPerKeyDic: CornerDictionary,
        _ dictionaryForScreen: CornerDictionary,
        _ objectFrameSize: Dimension,
        _ movement: Movement,
        _ displayStyle: DisplayStyle
    ) {
      //  uniquePartNames = partNames
        self.preTiltFourCornerPerKeyDic = preTiltFourCornerPerKeyDic
        self.dictionaryForScreen = dictionaryForScreen
        self.objectFrameSize = objectFrameSize
        self.movement = movement
        self.displayStyle = displayStyle
      
        }
    
    
    func limitZoom (_ zoom: CGFloat) -> CGFloat {
        max(min(zoom, maximimumZoom),minimumZoom)
    }
    
    func getZoom() -> CGFloat {
        let zoom =
        limitZoom( (0.2 + currentZoom + lastCurrentZoom) * defaultScale/measurementScale)
        return zoom
    }
    
    var body: some View {
        ZStack {
            ObjectView(
            //    uniquePartNames,
                preTiltFourCornerPerKeyDic,
                dictionaryForScreen,
                objectFrameSize,
                movement,
                displayStyle
            )
            .position(x: 1000.0, y: 0.0)
            
            RightAngleRuler()
            
        }
        .scaleEffect(zoom)
        .gesture(MagnificationGesture()
            .onChanged { value in
                currentZoom = (value - 1) * 0.3 //sensitivity
            }
            .onEnded { value in
                lastCurrentZoom += currentZoom
                currentZoom = 0.0
            }
        )
    }
}



