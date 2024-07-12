//
//  DimensionStepperViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/07/2024.
//

import Foundation
import Combine
import SwiftUI


class DimensionStepperViewModel: PropertyEditBase {
  
    
    var stepperValueBinding: Binding<Double> {
        Binding<Double>(
            get: { self.getInitialSliderValue(self.partToEdit,self.dimensionPropertyToEdit) },
            set: {                     newValue in
                self.setValueForBilateralPartInUserEditedDic(
                    self.partToEdit,
                    self.dimensionPropertyToEdit,
                            newValue
                            )
                self.modifyObjectByCreatingFromName() }
        )
    }
    
    
    override init() {
            super.init()

    }

}

