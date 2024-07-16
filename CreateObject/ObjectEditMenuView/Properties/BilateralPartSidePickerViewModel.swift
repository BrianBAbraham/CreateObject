//
//  BilateralPartSidePickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/07/2024.
//

import Foundation
import Combine
import SwiftUI

class BilateralPartSidePickerViewModel: ObservableObject,
    SharedGetSidesAffectedFunc,
    SharedObjectTypeAndUserEditedDictionaries,
    SharedChoiceAndScopeOfEditForSideFunc,
    SharedPartToEditFunc,
    SharedObjectChainLabelUserEditedDic{
    var binding: Binding<SidesAffected> {
        Binding<SidesAffected> (
            get: {self.choiceOfEditForSide},
            set: { newValue in
                self.setSideToEdit(newValue)}
        )
    }
    
    @Published var objectChainLabelsUserEditDic: [ObjectTypes : [Part]] = UserEditedDictionariesService.shared.userEditedSharedDics.objectChainLabelsUserEditDic
    @Published var disabled: Bool = true
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    @Published var choiceOfEditForSide = objectEditService.choiceOfEditForSide
    @Published var scopeOfEditForSide = objectEditService.scopeOfEditForSide
    @Published var showMenu = false
    
    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
    
    var objectType: ObjectTypes = ObjectDataService.shared.objectType
    
    var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] = UserEditedDictionariesService.shared.partIdsUserEditedDic
        
    static let objectEditService = ObjectEditService.shared

    internal var cancellables: Set<AnyCancellable> = []
    
    
        init() {
            
        (self as SharedGetSidesAffectedFunc).subscribeToService()
            
        (self as SharedObjectChainLabelUserEditedDic).subscribeToService()
        
        (self as SharedPartToEditFunc).subscribeToService()
        
        (self as SharedObjectTypeAndUserEditedDictionaries).subscribeToServices()
        
        (self as SharedChoiceAndScopeOfEditForSideFunc).subscribeToService()
    }
    
    
    func handleScopeOfEditForSideChange(_ newData: SidesAffected) {
        scopeOfEditForSide = newData
        Self.objectEditService.setSideToEdit(newData)
    }
    
    
    func handlePartToEditChange(_ newData: Part) {
        partToEdit = newData
        scopeOfEditForSide = getSidesAffected(newData)
        setScopeOfEditForSide()
        showMenu = getSidePickerMenuStatus()
    }
    
    
    func handleObjectChainLabelsUserEditedDicChange(_ newData: [ObjectTypes: [Part]]) {
   objectChainLabelsUserEditDic = newData
    //deteect if no part has no presence on either side
    scopeOfEditForSide = getSidesAffected(partToEdit)
    setScopeOfEditForSide()
    }
    
    
    func handlePartIdsUserEditedDicChange(_ newData: [Part: OneOrTwo<PartTag>]){
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


