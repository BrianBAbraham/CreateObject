//
//  BilateralPartSidePickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/07/2024.
//

import Foundation
import Combine
import SwiftUI

class BilateralPartSidePickerViewModel: BilateralPartSidePresencePickerBase, 
    SharedGetSidesAffectedFunc,
    SharedObectTypeAndUserEditedDictionaries,
    SharedChoieAndScopeOfEditForSideFunc {
    
    @Published var disabled: Bool = true
    
   //@Published
    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
    
    var objectType: ObjectTypes = ObjectDataService.shared.objectType
    
    //@Published
    var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] = UserEditedDictionariesService.shared.partIdsUserEditedDic
        
        
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
    
    internal var cancellables: Set<AnyCancellable> = []
    
    override init() {
            super.init()
        
        UserEditedDictionariesService.shared.$partIdsUserEditedDic
        .receive(on: DispatchQueue.main)
        .sink { [weak self] newData in
            self?.handlePartIdsUserEditedDicChange(newData)
        }
        .store(in: &self.cancellables)
        
        
        
        (self as SharedObectTypeAndUserEditedDictionaries).subscribeToServices()
        
        (self as SharedChoieAndScopeOfEditForSideFunc) .subscribeToServie()
        
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
    
    
    //override
        func handlePartIdsUserEditedDicChange(_ newData: [Part: OneOrTwo<PartTag>]){
        //detect if part has presence only one side
        partIdsUserEditedDic = newData
        scopeOfEditForSide = getSidesAffected(partToEdit )
        setScopeOfEditForSide()
    }
    
//        func handlePartIdsUserEditedDicChange(_ newData: [Part: OneOrTwo<PartTag>]){
//            partIdsUserEditedDic = newData
//        }
    
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
