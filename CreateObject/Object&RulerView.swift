//
//  Ruler&Object.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//
import SwiftUI

struct ObjectAndRulerView: View {

    @EnvironmentObject var movementDataVM: ObjectAndRulerViewModel

    @GestureState private var fingerLocation: CGPoint? = nil
    @State private var location = CGPoint (x: 100, y: 500)
   
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom = 0.1
    private var maximimumZoom = 0.4
    
    var defaultScale: Double {
        Screen.smallestDimension /
        movementDataVM.maximumnDimensionOfMotion
    }
    
    var measurementScale: Double {
        Screen.smallestDimension /
        movementDataVM.maximumnDimensionOfMotion
    }
    
    var zoom: CGFloat {
        getZoom()
    }

    let displayStyle: ObjectDisplayStyle
    
    init( _ displayStyle: ObjectDisplayStyle) {
        self.displayStyle = displayStyle
        }
    
    

    
    func getZoom() -> CGFloat {
        let zoom =
        limitZoom( (0.2 + currentZoom + lastCurrentZoom) * defaultScale/measurementScale)
        return zoom
        
        func limitZoom (_ zoom: CGFloat) -> CGFloat {
            max(min(zoom, maximimumZoom),minimumZoom)
        }
    }
    
    var body: some View {
       
        ZStack {
            ObjectWithArcView(
                displayStyle: displayStyle
            )
            .position(x: 1000.0, y: 0.0)
            
            RightAngleRulerView()
            
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



