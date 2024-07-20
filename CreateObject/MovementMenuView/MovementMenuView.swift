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
    @EnvironmentObject var movementPickerVM: MovementPickerViewModel
    @EnvironmentObject var movementDataProcessorVM: MovementDataProcessorViewModel
    @EnvironmentObject var recenterVM: RecenterViewModel
    var recenterPosition: CGPoint = CGPoint(x: 100, y: 350)
    @State private var uniqueKey = 0
    
    var body: some View {
        
        var movement: Movement {
            movementPickerVM.getMovementType()
        }
        var startAngle: Double {
            movementPickerVM.startAngle
        }
        
        VStack {
            //Object Menu
            VStack{
                ObjectRulerRecenterView()
                
                ObjectAndRulerView(
                    ObjectDisplayStyle.movement
                )
                .position(recenterPosition)
                .onChange(of: recenterVM.getRecenterState()) {
                    uniqueKey += 1
                }
                .id(uniqueKey)//ensures redraw
            }
           
            //Edit Menu
            VStack(spacing: 5 ){

                MovementPickerView()
                
                HStack {
                    MovementAnglePickerView()
                       
                    MovementAngleSetterView(setAngle: movementPickerVM.setObjectAngle)
                    Spacer()
                }
                .opacity(!movementPickerVM.getObjectIsTurning() ? 0.3: 1.0)
                .disabled(!movementPickerVM.getObjectIsTurning())
                
                HStack{
                    Spacer()
                
                    Text("turn tightness")
                        .foregroundColor(movement == .turn ? .primary : .gray)
                        .colorScheme(.light)
                    
                    MovementOriginStepperView(
//                        setValue: movementPickerVM.modifyStaticPointUpdateInX
                    )
                    
                    Spacer()
                }
                .disabled(!movementPickerVM.getObjectIsTurning())
            }
            .backgroundModifier()
            .transition(.move(edge: .bottom))
        }
    }
}

