//
//  OriginPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 06/07/2024.
//

import Foundation
import Combine
import SwiftUI

class OriginPickerViewModel: 
    PropertyEditBase,
    SharedOriginPropertyToEdit,
    SharedEditableOrignExist {
    
    var originPropertyBinding: Binding<PartTag> {
        Binding<PartTag>(
            get: { self.originPropertyToEdit },
            set: { self.setOriginPropertyToEdit($0) }
        )
    }
    
    @Published var originPropertyToEdit = ObjectEditService.shared.originPropertyToEdit
    
    @Published var editableOriginExist = false
    
    @Published var editableOrigin: [PartTag] = []
    
   internal var cancellables: Set<AnyCancellable> = []
    
    override init() {
            super.init()
        subscribeToOriginPropertyToEditDataService()
    }
    
    
    override func handlePartToEditChange(_ newData: Part) {
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
