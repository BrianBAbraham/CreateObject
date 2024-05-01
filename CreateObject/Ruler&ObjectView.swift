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
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    @GestureState private var fingerLocation: CGPoint? = nil
    @State private var location = CGPoint (x: 200, y: 200)
   
    
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom = 0.2
    private var maximimumZoom = 0.5
    
    let preTiltFourCornerPerKeyDic: CornerDictionary
    let dictionaryForScreen: CornerDictionary

    
    var defaultScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject()
    }
    
    var measurementScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject()
    }
    
    let uniquePartNames: [String]
//    let uniqueArcPointNames: [String]
   // let uniqueStaticPointNames: [String]
    
    var objectName: String {
        objectPickVM.getCurrentObjectName()
    }
    
    let objectFrameSize: Dimension
    
    var zoom: CGFloat {
        getZoom()
    }
   
    let movement: Movement
    
    
    
    init(
        _ partNames: [String],
//        _ arcPointNames: [String],
      //  _ staticPointNames: [String],
        _ preTiltFourCornerPerKeyDic: CornerDictionary,
        _ dictionaryForScreen: CornerDictionary,
        _ objectFrameSize: Dimension,
        _ movement: Movement
    ) {
        uniquePartNames = partNames
//        uniqueArcPointNames = arcPointNames
       // uniqueStaticPointNames = staticPointNames
        self.preTiltFourCornerPerKeyDic = preTiltFourCornerPerKeyDic
        self.dictionaryForScreen = dictionaryForScreen
        self.objectFrameSize = objectFrameSize
        self.movement = movement
      
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
//                uniqueArcPointNames,
              //  uniqueStaticPointNames,
                preTiltFourCornerPerKeyDic,
                dictionaryForScreen,
                objectFrameSize,
                movement
             
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


struct ObjectRulerRecenterX: View {
    @EnvironmentObject var recenterVM: RecenterViewModel
    var body: some View {
        
                        Button(action: {
                            recenterVM.setRecenterState()
                        }) {
                            Text("center ruler & object")
                                .font(.system(size: 10))
                                .foregroundColor(.blue)
                            
                        }
                        .buttonStyle(.plain )
 
        
    }
}

struct ObjectRulerRecenterY: View {
    @EnvironmentObject var recenterVM: RecenterViewModel
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            // Toggle the effect only while the button is being pressed
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
            }
            recenterVM.setRecenterState()

            // Reset the state after a slight delay, if needed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    isPressed = false
                }
            }
        }) {
            Text("center ruler & object")
                .font(.system(size: 10))
                .foregroundColor(.blue)
                .scaleEffect(isPressed ? 2.0 : 1) // Apply scale effect based on the isPressed state
        }
        .buttonStyle(.plain)
    }
}




struct ObjectRulerRecenter: View {
    @EnvironmentObject var recenterVM: RecenterViewModel
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            // Start the button press animation
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
            }

            // Schedule the recenter action and the reset of the button state after the animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                // Execute the recenter function after the initial animation
                recenterVM.setRecenterState()

                // Then, with a slight delay, reset the button state with another animation
                withAnimation(.easeInOut(duration: 0.4)) {
                    isPressed = false
                }
            }
        }) {
            Text("Center Ruler & Object")
                .font(.system(size: 10))
                .foregroundColor(.blue)
                .scaleEffect(isPressed ? 2.0 : 1) // Apply scale effect based on the isPressed state
        }
        .buttonStyle(.plain)
    }
}
