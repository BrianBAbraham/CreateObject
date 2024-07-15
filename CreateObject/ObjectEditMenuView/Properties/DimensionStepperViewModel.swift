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
    SharedInitialSliderValueFuncOnly,
    SharedDimensionPropertyToEdit,
    SharedSetValueForBilateralPartFuncOnly,
    SharedModifyObjectByCreatingFromNameFuncOnly,
    SharedObectTypeAndUserEditedDictionaries,
    SharedChoieAndScopeOfEditForSideFunc,
    SharedPartDataDic {
    
    var objectType = ObjectDataService.shared.objectType
    
    var partDataDic: [Part : PartData] = ObjectDataService.shared.partDataDic
    
    var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    var disabled: Bool = true
    
    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
    
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
        subscribeToServices()
        subscribeToDimensionPropertyToEditDataService()
        (self as SharedChoieAndScopeOfEditForSideFunc) .subscribeToServie()
        (self as SharedPartDataDic).subScribeToService()

    }

}

