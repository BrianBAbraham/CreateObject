//
//  PartPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 01/07/2024.
//

import Foundation
import Combine

class PartPickerViewModel: ObservableObject {
    
    @Published var objectType = ObjectDataService.shared.objectType
    
    @Published var oneOfAllEditablePartForObjectBeforeEdit: [String] = []
    
    @Published var oneOfAllEditablePartWithMenuNamesForObjectBeforeEdit: [String] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    static let partsNotToAppearOnEditMenu: [PartGroup] = [
        .tilt,
        .backJointAndLink,
        .casterJoint,
        .fixedWheelJoint,
        .footJointAndLink,
        .stabiliser,
        .steeredJoint,
    ]
    
    init() {
        
        ObjectDataService.shared.$objectType
            .sink { [weak self] newData in
                self?.objectType = newData
                self?.oneOfAllEditablePartForObjectBeforeEdit = self?.getOneOfAllEditablePartForObjectBeforeEdit() ?? []
                self?.oneOfAllEditablePartWithMenuNamesForObjectBeforeEdit = self?.getOneOfAllEditablePartWithMenuNamesForObjectBeforeEdit() ?? []
             
            }
            .store(in: &self.cancellables)
    }
    
    
    func getOneOfAllPartForObjectBeforeEdit() -> [Part] {
            AllPartInObject.getOneOfAllPartInObjectBeforeEdit(objectType)
      }
    
    
    func getOneOfAllEditablePartForObjectBeforeEdit() -> [String] {
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        let parts =
        oneOfAllPartForObjectBeforeEdit.filter {!Self.partsNotToAppearOnEditMenu.contains( $0.transformPartToPartGroup())}
        return parts.map{$0.rawValue}
    }
    
    
    func getOneOfAllEditablePartWithMenuNamesForObjectBeforeEdit() -> [String] {
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        let parts =
        oneOfAllPartForObjectBeforeEdit.filter {!Self.partsNotToAppearOnEditMenu.contains($0.transformPartToPartGroup())}

        return PartToDisplayInMenu(parts, objectType).names
    }
    
    
    func resetForNewPartEdit(){
        //what to edit
        //objectEditVM.setSideToEdit(.both)
        
        setSideToEdit(.both)
        
        //what can be edited
        setBothOrLeftOrRightAsEditible(.both)
    }
    
    
    func setSideToEdit(
        _ sideChoice: SidesAffected
    ) {
        ObjectEditService.shared.setSideToEdit(
            sideChoice
        )
    }
    
    
    func setBothOrLeftOrRightAsEditible(
        _ sideChoice: SidesAffected
    ) {
        ObjectEditService.shared.setScopeOfEditForSide(
            sideChoice)
    }
    
    
    func setPartToEdit(_ partName: String) {
        guard let part = Part(rawValue: partName) else {
            fatalError("no part for that part name")
        }
        ObjectEditService.shared.setPartToEdit(part)
    }
}
