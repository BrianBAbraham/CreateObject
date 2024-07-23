//
//  MovementMenuView.swift
//  CreateObject
//
//  Created by Brian Abraham on 27/06/2024.
//

import Foundation
import SwiftUI


struct MovementMenuView: View {
    @EnvironmentObject var recenterVM: RecenterViewModel
    @EnvironmentObject var movementMenuVM: MovementMenuViewModel

    var recenterPosition: CGPoint = CGPoint(x: 100, y: 350)
    @State private var uniqueKey = 0
    
    var body: some View {
        
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
                       
                    MovementAngleStepperView()
                    Spacer()
                }
                .opacity(movementMenuVM.isNotTurning ? 0.3: 1.0)
                .disabled(movementMenuVM.isNotTurning)
                
                HStack{
                    Spacer()
                
                    Text("turn tightness")
                        .foregroundColor(movementMenuVM.movementType == .turn ? .primary : .gray)
                        .colorScheme(.light)
                    
                    MovementOriginStepperView()
                    
                    Spacer()
                }
                .disabled(movementMenuVM.isNotTurning)
            }
            .backgroundModifier()
            .transition(.move(edge: .bottom))
        }
    }
}

