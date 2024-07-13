//
//  BilateralPartSidePickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/07/2024.
//

import Foundation
import Combine
import SwiftUI

class BilateralPartSidePickerViewModel: BilateralPartSidePresencePickerBase {
    @Published var choiceOfEditForSide = objectEditService.choiceOfEditForSide
    
    @Published var scopeOfEditForSide = objectEditService.scopeOfEditForSide
    
    @Published var showMenu = false
   
    static let objectEditService = ObjectEditService.shared

    var binding: Binding<SidesAffected> {
        Binding<SidesAffected> (
            get: {self.choiceOfEditForSide},
            set: { newValue in
                self.setSideToEdit(newValue)}
        )
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
            super.init()
        
        Self.objectEditService.$scopeOfEditForSide
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.scopeOfEditForSide = newData
                Self.objectEditService.setSideToEdit(newData)
            }
            .store(in: &self.cancellables)
        
        
        Self.objectEditService.$choiceOfEditForSide
            .receive(on: DispatchQueue.main)
            .assign(to: &$choiceOfEditForSide)
    }
    
    
  override func handlePartToEditChange(_ newData: Part) {
        partToEdit = newData
        scopeOfEditForSide = getSidesAffected(newData)
        setScopeOfEditForSide()
        showMenu = getSidePickerMenuStatus()
    }
    
    
    override func handleObjectChainLabelsUserEditedDicChange(_ newData: [ObjectTypes: [Part]]) {
       objectChainLabelsUserEditDic = newData
        //deteect if no part has no presence on either side
        scopeOfEditForSide = getSidesAffected(partToEdit)
        setScopeOfEditForSide()
    }
    
    
    override func handlePartIdsUserEditedDicChange(_ newData: [Part: OneOrTwo<PartTag>]){
        //detect if part has presence only one side
        partIdsUserEditedDic = newData
        scopeOfEditForSide = getSidesAffected(partToEdit )
        setScopeOfEditForSide()
    }
    
    
    func setSideToEdit(
        _ sideChoice: SidesAffected
    ) {
        ObjectEditService.shared.setSideToEdit(
            sideChoice
        )
    }
    
    
    func setScopeOfEditForSide(){
        ObjectEditService.shared.setScopeOfEditForSide(scopeOfEditForSide)
    }

    
    
    func getSidePickerMenuStatus() -> Bool {
        let alwaysUnilateral =
            OneOrTwoId.partWhichAreAlwaysUnilateral.contains(partToEdit)
        let partGroup = partToEdit.transformPartToPartGroup()
        let alwaysBilateral =
        [.caster, .casterFork, .casterJoint, .fixedWheel, .fixedWheelJoint].contains(partGroup)
        let showMenu = !(alwaysUnilateral || alwaysBilateral)
        
        return showMenu
    }
}
