//
//  DimensionStepperView.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/07/2024.
//

import SwiftUI



struct DimensionStepperView: View {
    
    @EnvironmentObject var dimensionStepperVM: DimensionStepperViewModel
 
    var body: some View {
        let notPresent =
            dimensionStepperVM.getPartNotPresent()
        
        let boundStepperValue =
            Binding(
                get: {
                    dimensionStepperVM.getInitialSliderValue()
                }
                ,
                set: {
                    newValue in
                    dimensionStepperVM.setValueForBilateralPartInUserEditedDic(
                                newValue
                                )
                    dimensionStepperVM.modifyObjectByCreatingFromName()
                                } )

                Stepper("", value: boundStepperValue, step: 10.0)
                .colorScheme(.light)
                .fixedSize()
            .disabled(notPresent)
    }
}

