//
//  OriginSetter.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import SwiftUI

struct OriginSetter: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    var setValue: (Double) -> Void  // Closure to set the stepper
    var label: String
    var body: some View {
        let boundStepperValue =
        Binding(
            get: {0.0}
            ,
            set: {
                newValue in
                self.setValue(newValue)
            }
        )
        HStack{
            Stepper("", value: boundStepperValue, step: 10.0)
                .colorScheme(.light)
        }
    }
}

