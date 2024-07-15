//
//  OriginStepperViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine
import SwiftUI


class OriginStepperViewModel: 
    PropertyEditBase, 
    SharedOriginPropertyToEdit,
    SharedEditableOrignExistFuncOnly, 
    SharedInitialSliderValueFuncOnly,
    SharedSetValueForBilateralPartFuncOnly,
    SharedModifyObjectByCreatingFromNameFuncOnly,
    SharedObectTypeAndUserEditedDictionaries,
    SharedChoieAndScopeOfEditForSideFunc,
    SharedPartDataDic{
    
    var objectType = ObjectDataService.shared.objectType

    
    var partDataDic: [Part : PartData] = ObjectDataService.shared.partDataDic
    
    var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    var disabled: Bool = true
    
    @Published var editableOriginExist = false
    
    @Published var editableOrigin: [PartTag] = []
    
    var userEditedSharedDics = UserEditedDictionariesService.shared.userEditedSharedDics
    
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
    
    var originPropertyToEdit = ObjectEditService.shared.originPropertyToEdit
    
    internal var cancellables: Set<AnyCancellable> = []
    
    override init() {
            super.init()
        subscribeToServices()
        (self as SharedOriginPropertyToEdit).subscribeToService()
        (self as SharedChoieAndScopeOfEditForSideFunc) .subscribeToServie()
        (self as SharedPartDataDic).subScribeToService()

    }
    
    override func handlePartToEditChange(
        _ newData: Part
    ) {
        //ensure that the previous option not applied to new part
        getIfAnyEditableOrigin()
    }
}




