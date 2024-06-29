//
//  MovementMenuView.swift
//  CreateObject
//
//  Created by Brian Abraham on 27/06/2024.
//

import Foundation
import SwiftUI


struct MovementMenuView: View {
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
    @EnvironmentObject var movementDataGetterVM: MovementDataViewModel
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    @EnvironmentObject var movementDataProcessorVM: MovementDataProcessorViewModel
    @EnvironmentObject var recenterVM: RecenterViewModel
    var recenterPosition: CGPoint = CGPoint(x: 100, y: 350)
    @State private var uniqueKey = 0
    
    var body: some View {
        let movementName = movementPickVM.getMovementType().rawValue
        
        var preTiltFourCornerPerKeyDic: CornerDictionary {
            //provides height (z) info of equipment before tilt
            movementDataGetterVM.preTiltObjectToPartFourCornerPerKeyDic
        }

        var objectFrameSize: Dimension {
            movementDataProcessorVM.onScreenMovementFrameSize
        }
        
        var movement: Movement {
            movementPickVM.getMovementType()
        }
        var startAngle: Double {
            movementPickVM.startAngle
        }
        
        
        VStack {
            //Object Menu
            VStack{
                ObjectRulerRecenter()
                
                ObjectAndRulerView(
                  //  movementDataGetterVM.uniquePartNames,
                    preTiltFourCornerPerKeyDic,
                    movementDataProcessorVM.movementDictionaryForScreen,
                    objectFrameSize,
                    movement,
                    DisplayStyle.movement
                )
                .position(recenterPosition)
                .onChange(of: recenterVM.getRecenterState()) {
                    uniqueKey += 1
                }
                .id(uniqueKey)//ensures redraw
            }
           
            
            //Edit Menu
            VStack(spacing: 5 ){
                MovementPickerView(movementName)
                
                HStack {
                    AnglePickerView()
                       
                    AngleSetter(setAngle: movementPickVM.setObjectAngle)
                    Spacer()
                }
                .opacity(!movementPickVM.getObjectIsTurning() ? 0.3: 1.0)
                .disabled(!movementPickVM.getObjectIsTurning())
                
                HStack{
                    Spacer()
                
                    Text("turn tightness")
                        .foregroundColor(movement == .turn ? .primary : .gray)
                        .colorScheme(.light)
                    
                    OriginSetter(
                        setValue: movementPickVM.modifyStaticPointUpdateInX,
                        label: "origin X"
                    )
                    
                    Spacer()
                }
                .disabled(!movementPickVM.getObjectIsTurning())
            }
            .backgroundModifier()
            .transition(.move(edge: .bottom))
        }
    }
}

