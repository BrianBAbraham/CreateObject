//
//  MovementEditMenuContainerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 27/06/2024.
//

import Foundation
import SwiftUI





struct MovementEditMenuContainerView: View {
    @EnvironmentObject var movementEditScreenVM: EditScreenViewModel
    var body: some View {
        //Edit Menu
        VStack(spacing: 5 ){

            MovementPickerView()
            
            HStack {
                MovementAnglePickerView()
                   
                MovementAngleStepperView()
                Spacer()
            }
            .opacity(movementEditScreenVM.isNotTurning ? 0.3: 1.0)
            .disabled(movementEditScreenVM.isNotTurning)
            
            HStack{
                Spacer()
            
                Text("turn tightness")
                    .foregroundColor(movementEditScreenVM.isNotTurning ? .gray: .primary)
                    .colorScheme(.light)
                
                MovementOriginStepperView()
                
                Spacer()
            }
            .disabled(movementEditScreenVM.isNotTurning)
        }
        .backgroundModifier()
        .transition(.move(edge: .bottom))
    }
}
