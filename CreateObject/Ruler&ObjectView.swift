//
//  Ruler&Object.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//
import SwiftUI

struct ObjectAndRulerView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var rulerVM: RulerViewModel
    @EnvironmentObject var recenter: RecenterViewModel
    @GestureState private var fingerLocation: CGPoint? = nil
    @State private var location = CGPoint (x: 200, y: 200)
   // @Binding var moveRulerAndObjectInY: CGFloat
    
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom = 0.1
    private var maximimumZoom = 1.0
    
    
    var postTiltOneCornerPerKeyDic: PositionDictionary {
        objectPickVM.getPostTiltOneCornerPerKeyDic()
    }
    
    var defaultScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject(postTiltOneCornerPerKeyDic)
    }
    
    var measurementScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject(postTiltOneCornerPerKeyDic)
    }
    
    var zoom: CGFloat {
        getZoom()
    }
    
    var uniquePartNames: [String]
    
    var objectName: String {
        objectPickVM.getCurrentObjectName()
    }
    
    let objectManipulationIsActive: Bool
    
    var preTiltFourCornerPerKeyDic: CornerDictionary {
        objectPickVM.getPreTiltFourCornerPerKeyDic()
    }
    
    
    
    init(
        _ names: [String],
        _ objectManipulationIsActive: Bool = false
      
    ) {
            uniquePartNames = names
            self.objectManipulationIsActive = objectManipulationIsActive
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
            uniquePartNames,
            objectManipulationIsActive
            )
            .alignmentGuide(VerticalAlignment.top) { d in d[VerticalAlignment.top] }
            
            RightAngleRuler()
            
            
        }
        
        .scaleEffect(zoom)
        .background(Color.green.opacity(0.0001))
        .frame(maxWidth: .infinity)
        .gesture(MagnificationGesture()
            .onChanged { value in
                currentZoom = value - 1
            }
            .onEnded { value in
                lastCurrentZoom += currentZoom
                currentZoom = 0.0
            }
        )
        
    }
}


struct ObjectRulerRecenter: View {
    @EnvironmentObject var recenterVM: RecenterViewModel
    var body: some View {
        
                        Button(action: {
                            recenterVM.setRecenterState()
                        }) {
                            Text("center")
                                .font(.system(size: 15))
                        }
 
        
    }
}
