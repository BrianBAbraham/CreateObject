//
//  Ruler&Object.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import SwiftUI

struct RulerObject: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom = 0.1
    private var maximimumZoom = 3.0
    @State private var initialOrigin: CGPoint?
    let objectManipulationIsActive: Bool
    var uniquePartNames: [String]
    
    
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
    
    
    init(
        _ names: [String],
        _ objectManipulationIsActive: Bool = false,
        initialOrigin: Binding<CGPoint?>) {
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
        let frameSize =
            objectPickVM.getObjectOnScreenFrameSize()
        ZStack{
            Ruler()
            ObjectView(
                uniquePartNames,
                objectManipulationIsActive,
                initialOrigin: $initialOrigin)
            .offset(CGSize(width: 0, height: objectPickVM.getOffsetToKeepObjectOriginStaticInLengthOnScreen()))
        }
        .modifier(
                ForObjectDrag (
                    frameSize: frameSize, active: objectManipulationIsActive)
                )
        //.offset(CGSize(width: 0, height: objectPickVM.getOffsetToKeepObjectOriginStaticInLengthOnScreen()))
        .scaleEffect(zoom)
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

