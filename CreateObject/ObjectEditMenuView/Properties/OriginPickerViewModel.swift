//
//  OriginPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 06/07/2024.
//

import Foundation
import Combine
import SwiftUI

class OriginPickerViewModel: ObservableObject,
    SharedOriginPropertyToEdit,
    SharedEditableOrignExistFuncOnly,
    SharedNoSidesPresentFuncOnly,
    SharedSidesPresentGivenPossibleUserEditFuncOnly,
    SharedScopeOfEditForSideFunc,
    SharedChoiceOfEditForSide,
    SharedObjectType,
    SharedPartToEditFunc {
    
    var originPropertyBinding: Binding<PartTag> {
        Binding<PartTag>(
            get: { self.originPropertyToEdit },
            set: { self.setOriginPropertyToEdit($0) }
        )
    }
    
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
    @Published var originPropertyToEdit = ObjectEditService.shared.originPropertyToEdit
    
    @Published var editableOriginExist = false
    
    @Published var editableOrigin: [PartTag] = []
    
    @Published var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    
    var objectType = ObjectDataService.shared.objectType
    
   @Published var disabled: Bool = true
    
   internal var cancellables: Set<AnyCancellable> = []
    
 
    init() {
        (self as SharedObjectType).subscribeToService()
        
        (self as SharedPartToEditFunc).subscribeToService()
    
        (self as SharedOriginPropertyToEdit).subscribeToService()
        
        (self as SharedScopeOfEditForSideFunc).subscribeToService()
        
        (self as SharedChoiceOfEditForSide).subscribeToService()
        

    }
    

    func handlePartToEditChange(_ newData: Part) {
        //ensure that the previous option not applied to new part
        setDefaultPropertyToEditOnPartChange()
        getIfAnyEditableOrigin()
    }
    
    
    func setOriginPropertyToEdit(_ value: PartTag){
        ObjectEditService.shared.setOriginPropertyToEdit(value)
    }
    
    
    func setDefaultPropertyToEditOnPartChange() {
        switch partToEdit {
        case .assistantFootLever, .fixedWheelAtRearWithPropeller:
            setOriginPropertyToEdit(.xOrigin)
            
        default:
            break
        }
    }
    
}



