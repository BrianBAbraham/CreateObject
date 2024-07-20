//
//  AngleSetter.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import SwiftUI



struct MovementAngleSetterView: View {
    @EnvironmentObject var movementPickerVM: MovementPickerViewModel
    var setAngle: (Double) -> Void  // Closure to set the angle
    var body: some View {
        let boundStepperValue =
        Binding(
            get: {0.0}
            ,
            set: {
                newValue in
                self.setAngle(newValue)
            }
        )
        HStack{
            Stepper("", value: boundStepperValue, step: 10.0)
                .colorScheme(.light)
        }
    }
}






enum WhichAngle: String, CaseIterable {
    case end  = "end"
    case start = "start"
    case startAndEnd = "both"
}
