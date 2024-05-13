//
//  AngleSetter.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import SwiftUI



struct AngleSetter: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
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


struct AnglePickerView: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    
    let menuItems = WhichAngle.allCases.map {
        $0.rawValue
    }
    
    
    var body: some View {
        HStack {
            ZStack {
                Picker(
                    "",
                    selection: $movementPickVM.objectAngleName
                ) {
                    ForEach(
                        menuItems,
                        id: \.self
                    ) { item in
                        Text(
                            item
                        )
                    }
                }
                //Start work around: removes grey background from iPhone 13 mini
                //physical device
                .opacityAndScaleToHidePickerLabel()
                
                DuplicatePickerText(name: movementPickVM.objectAngleName)
            }
            //End work around

            Text("angle")
                .colorScheme(.light)
        }
    }
}



enum WhichAngle: String, CaseIterable {
    case end  = "end"
    case start = "start"
    case startAndEnd = "both"
}
