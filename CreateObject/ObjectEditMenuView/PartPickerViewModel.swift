//
//  PartPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 01/07/2024.
//

import Foundation
import Combine
import SwiftUI

class PartPickerViewModel: ObservableObject {
    
    var partBinding: Binding<String> {
        Binding<String>(
            get: { self.getObjectSensitiveNameForPart()  },
            set: { self.setPartToEdit($0) }
        )
    }
    
    @Published var objectType = ObjectDataService.shared.objectType
    
    //@Published
    var oneOfAllEditablePartForObjectBeforeEdit: [String] = []
    
    //@Published
    var oneOfAllEditablePartWithMenuNamesForObjectBeforeEdit: [String] = []
    
    
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
    
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
        ObjectEditService.shared.$partToEdit
            .receive(on: DispatchQueue.main)
            .assign(to: \.partToEdit,on: self)
            .store(in: &cancellables)
        
        ObjectDataService.shared.$objectType
            .sink { [weak self] newData in
                self?.objectType = newData
                self?.oneOfAllEditablePartForObjectBeforeEdit = self?.getOneOfAllEditablePartForObjectBeforeEdit() ?? []
                
                self?.oneOfAllEditablePartWithMenuNamesForObjectBeforeEdit = self?.getOneOfAllEditablePartWithMenuNamesForObjectBeforeEdit() ?? []
             
            }
            .store(in: &self.cancellables)
    }
    
    
    func getObjectSensitiveNameForPart() -> String {
        PartToDisplayInMenu([partToEdit], objectType).name
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
    
    
    func setPartToEdit(_ menuPartName: String) {
       
        let index = oneOfAllEditablePartWithMenuNamesForObjectBeforeEdit.firstIndex(where: { $0 == menuPartName }) ?? 0
        
        let partName =
        oneOfAllEditablePartForObjectBeforeEdit[index]
        
        
        guard let part = Part(rawValue: partName) else {
            fatalError("no part for that part name")
        }
        
        print(part.rawValue)
        
        ObjectEditService.shared.setPartToEdit(part)
        
        resetForNewPartEdit()
    }
}


