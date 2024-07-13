//
//  DimensionStepperViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/07/2024.
//

import Foundation
import Combine
import SwiftUI


class DimensionStepperViewModel:
    PropertyEditBase,
    SharedInitialSliderValue,
    SharedDimensionPropertyToEdit,
    SharedSetValueForBilateralPart,
    SharedModifyObjectByCreatingFromName
{
    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
    
    //var objectType: ObjectTypes = ObjectDataService.shared.objectType
    
    
    var dimensionPropertyToEdit = ObjectEditService.shared.dimensionPropertyToEdit
    
    internal var cancellables: Set<AnyCancellable> = []
  
    var stepperValueBinding: Binding<Double> {
        Binding<Double>(
            get: {
                self.getInitialSliderValue(
                    self.partToEdit,
                    self.dimensionPropertyToEdit
                )
            },
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
        subscribeTServices()
        subscribeToDimensionPropertyToEditDataService()
    }

}

