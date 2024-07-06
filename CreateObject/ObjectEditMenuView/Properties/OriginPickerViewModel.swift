//
//  OriginPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 06/07/2024.
//

import Foundation
import Combine
import SwiftUI

class OriginPickerViewModel: DimensionBaseViewModel {
    var originPropertyBinding: Binding<PartTag> {
        Binding<PartTag>(
            get: { self.originPropertyToEdit },
            set: { self.setOriginPropertyToEdit($0) }
        )
    }
    
    @Published var originPropertyToEdit = ObjectEditService.shared.originPropertyToEdit
    @Published var editableOriginExist = false
    @Published var editableOrigin: [PartTag] = []
    
   @Published var partToEdit = ObjectEditService.shared.partToEdit


    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
            super.init()

        ObjectEditService.shared.$partToEdit
            .sink { [weak self] newData in
                self?.partToEdit = newData
                
                //ensure that the previous option not applied to new part
                self?.setDefaultPropertyToEditOnPartChange()
                self?.getIfAnyEditableOrigin()
            }
            .store(in: &self.cancellables)
        
        ObjectEditService.shared.$originPropertyToEdit
            .receive(on: DispatchQueue.main)
            .assign(to: \.originPropertyToEdit,on: self)
            .store(in: &cancellables)
    }
    
    
    func setOriginPropertyToEdit(_ value: PartTag){
        print("DETECT")
        print(value)
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
    
    
    func getPropertiesForOriginPicker(_ part: Part) -> [PartTag] {
        if  let displayPart = PartToDisplayInMenu.dictionary[part] {
                switch displayPart {
                case .seat:
                    if objectType == .showerTray {
                        return []
                    } else {
                        return [.xOrigin, .yOrigin]
                    }
                case .propeller, .footLever, .headrest:
                    return [.xOrigin]
                case .casterForkAtFront, .casterForkAtMid, .casterForkAtRear:
                    return [.yOrigin]
                case .backrest:
                   return []
                default:
                    return [.xOrigin, .yOrigin]
                }
        } else {
            return [.xOrigin, .yOrigin]
        }
    }
    
    
    func getIfAnyEditableOrigin(){
        editableOrigin = getPropertiesForOriginPicker(partToEdit)
        editableOriginExist =
            editableOrigin == [] ? false: true
       
    }
}
