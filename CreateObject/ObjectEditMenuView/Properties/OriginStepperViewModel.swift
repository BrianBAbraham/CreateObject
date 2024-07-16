//
//  OriginStepperViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine
import SwiftUI


class OriginStepperViewModel: ObservableObject,
    SharedOriginPropertyToEdit,
    SharedEditableOrignExistFuncOnly, 
    SharedInitialSliderValueFuncOnly,
    SharedSetValueForBilateralPartFuncOnly,
    SharedModifyObjectByCreatingFromNameFuncOnly,
    SharedObjectTypeAndUserEditedDictionaries,
    SharedChoiceAndScopeOfEditForSideFunc,
    SharedPartDataDic,
    SharedPartToEditFunc{
    
    var stepperValueBinding: Binding<Double> {
        Binding<Double>(
            get: {
                self.getInitialSliderValue(
                    self.partToEdit,
                    self.originPropertyToEdit
                )
            },
            set: {                     newValue in
                self.setValueForBilateralPartInUserEditedDic(
                    self.partToEdit,
                    self.originPropertyToEdit,
                            newValue
                            )
                self.modifyObjectByCreatingFromName() }
        )
    }
    
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
    @Published var editableOriginExist = false
    
    @Published var editableOrigin: [PartTag] = []
    
    
    var objectType = ObjectDataService.shared.objectType

    var partDataDic: [Part : PartData] = ObjectDataService.shared.partDataDic
    
    var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    var disabled: Bool = true
    
    var userEditedSharedDics = UserEditedDictionariesService.shared.userEditedSharedDics
    
    var originPropertyToEdit = ObjectEditService.shared.originPropertyToEdit
    
    internal var cancellables: Set<AnyCancellable> = []

        init() {

        (self as SharedPartToEditFunc).subscribeToService()
        subscribeToServices()
        
        (self as SharedOriginPropertyToEdit).subscribeToService()
       
        (self as SharedChoiceAndScopeOfEditForSideFunc) .subscribeToService()
        
        (self as SharedPartDataDic).subScribeToService()

    }

    
    func handlePartToEditChange(
    _ newData: Part
    ) {
        //ensure that the previous option not applied to new part
        partToEdit = newData
        getIfAnyEditableOrigin()
    }
}
