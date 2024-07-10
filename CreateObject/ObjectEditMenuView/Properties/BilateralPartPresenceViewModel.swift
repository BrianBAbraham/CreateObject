//
//  BilateralPartPresenceViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine
import SwiftUI

class BilateralPartPresenceViewModel: ObservableObject {
    
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
    @Published var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
    
    @Published var objectType: ObjectTypes = ObjectDataService.shared.objectType
    
    @Published var objectChainLabelsDefaultDic: ObjectChainLabelsDictionary = [:]
    
    @Published var scopeOfEditForSide: SidesAffected = ObjectEditService.shared.scopeOfEditForSide
    
    @Published var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] = UserEditedDictionariesService.shared.partIdsUserEditedDic
    
    @Published var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] = UserEditedDictionariesService.shared.userEditedSharedDics.objectChainLabelsUserEditDic
    
    @Published var showMenu = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var leftPresent = true
    @Published var rightPresent = true
    
    
     var leftBinding: Binding<Bool> {
        Binding<Bool> (
            get: {self.leftPresent},
            set: {self.leftPresent = $0
                self.changeOneOrTwoStatusOfPart()}
        )
    }
    
    var rightBinding: Binding<Bool> {
        Binding<Bool> (
            get: {self.rightPresent},
            set: {self.rightPresent = $0
                self.changeOneOrTwoStatusOfPart()}
        )
    }
    
    init() {
        UserEditedDictionariesService.shared.$userEditedSharedDics
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEditedSharedDics,on: self)
            .store(in: &cancellables)
        
        
        UserEditedDictionariesService.shared.$partIdsUserEditedDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.partIdsUserEditedDic,on: self)
            .store(in: &cancellables)
        
        UserEditedDictionariesService.shared.$objectChainLabelsUserEditDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectChainLabelsUserEditDic,on: self)
            .store(in: &cancellables)
        
        ObjectEditService.shared.$partToEdit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.partToEdit = newData
                self?.resetPartPresenceForNewPart()
            }
            .store(in: &self.cancellables)
        
        ObjectEditService.shared.$scopeOfEditForSide
            .receive(on: DispatchQueue.main)
            .assign(to: \.scopeOfEditForSide,on: self)
            .store(in: &cancellables)
        
        ObjectDataService.shared.$objectType
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectType,on: self)
            .store(in: &cancellables)
        
        ObjectDataService.shared.$objectChainLabelsDefaultDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectChainLabelsDefaultDic,on: self)
            .store(in: &cancellables)
        
        showMenu = getBilateralPresenceMenuStatus(partToEdit)
    }
    
    
    func resetPartPresenceForNewPart(){
        showMenu = getBilateralPresenceMenuStatus(partToEdit)
        
        if let ids = partIdsUserEditedDic[partToEdit] {
            if ids.one == .id0 {
                leftPresent = true
                rightPresent = false
            }
            
            if ids.one == .id1 {
                rightPresent = true
                leftPresent = false
            }
        } else {
            //if no edites then both sides present
            leftPresent = true
            rightPresent = true
        }
    }
    
    
    func getSidesPresentGivenPossibleUserEdit() -> [SidesAffected] {
        //source of truth is the dic or the default struct
        let oneOrTwoId = partIdsUserEditedDic[partToEdit] ?? OneOrTwoId(
            objectType,
            partToEdit
        ).forPart
        
        guard let chainLabels = objectChainLabelsUserEditDic[objectType] ?? objectChainLabelsDefaultDic[objectType] else {
            fatalError()
        }
        
        var sidesPresent: [SidesAffected] = []
        //the part may be removed from both sides by user edit
        if chainLabels.contains(
            partToEdit
        ) {
            sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
            
        } else {
            sidesPresent = [.none]
        }

        return sidesPresent
    }
    


    
    
    func convertLeftRightSelectionToSideSelection(
        _ isLeftSelected: Bool,
        _ isRightSelected: Bool) -> SidesAffected {
       
        if isLeftSelected && isRightSelected {
            return .both
        } else if isLeftSelected {
            return .left
        } else if isRightSelected {
            return .right
        } else {
            return .none
        }
    }
    
    
    

    func changeOneOrTwoStatusOfPart() {
        switch (leftPresent, rightPresent) {
        case (true, true):
            //chain label must exist as one was previously true
            //and only one change at at time possible
            //if both present return to default
            setPartIdDicInKeyToNilRestoringDefault()
            
        //one added from none or one removed from two
        case(true, false), (false, true):
            let newId: OneOrTwo<PartTag> = leftPresent ?
                .one(one: .id0): //if left requires .id0 for x < 0
                .one(one: .id1)  //if right requires .i1 for x >= 0
         
            //one removed from two
            if scopeOfEditForSide == .both {
                modifyPartIdsUserEditedDic(newId)
            }
            
            //one added from none
            if scopeOfEditForSide == .none {
    
                //the chain label will have been removed
                restoreChainLabelToObject(partToEdit)

                modifyPartIdsUserEditedDic(newId)
            }
            
        case(false, false):
            
            //remove chainLabel so part does not exist
            removeChainLabelFromObject(partToEdit)
        }
            
        updateScopeOfEdit()
        
            func updateScopeOfEdit() {
                let sidesPresent = //.both/.left/.right/.none
                    convertLeftRightSelectionToSideSelection(
                        leftPresent,
                        rightPresent)
                    
                let partChain = LabelInPartChainOut(partToEdit).partChain
                
                ObjectEditService.shared.setScopeOfEditForSide(sidesPresent)
            }

        
        //finally create a new object with the new specification
       modifyObjectByCreatingFromName()
        
        func modifyObjectByCreatingFromName() {
            let objectImageData = ObjectImageData(
                objectType,
                userEditedSharedDics
            )
            
            ObjectImageService.shared.setObjectImage(
                objectImageData
            )
        }
        
        
        func modifyPartIdsUserEditedDic(_ newId: OneOrTwo<PartTag> ) {
            
            let partChain = LabelInPartChainOut(partToEdit).partChain
            
            let linkedPartDic: [Part: Part] = [
                .footSupport: .footSupportHangerLink,
            ]
             
            let partOrLinkedPart = linkedPartDic[partToEdit] ?? partToEdit
            
            guard let firstIndex = partChain.firstIndex(of: partOrLinkedPart) else {
                fatalError("\(partChain)")
            }
            //provide id for the parts of the chain being edited
            //as not all the chain may be removed
            //if there were two then if on the right the id must be id0 as only one
            for index in firstIndex..<partChain.count {
                UserEditedDictionariesService.shared.partIdsUserEditedDicModifier([partChain[index]: newId])
            }
        }
        
        
        func removeChainLabelFromObject(
            _ chainLabel: Part) {
            guard let currentObjectChainLabels =
                    objectChainLabelsUserEditDic[objectType] ??
                        ObjectChainLabel.dictionary[objectType] else {
                              fatalError()
                            }
            let newChainLabels =
                currentObjectChainLabels.filter { $0 != chainLabel}
                
                UserEditedDictionariesService.shared.objectChainLabelsUserEditDicModifier(objectType, newChainLabels)
        }
            
    }
    
    
    func restoreChainLabelToObject(
        _ chainLabel: Part
    ) {
        guard let currentObjectChainLabels =
                ObjectChainLabel.dictionary[objectType] else {
            fatalError(
                "no chain labels for object \(objectType)"
            )
        }
        let newChainLabels = currentObjectChainLabels + [chainLabel]
        
        UserEditedDictionariesService.shared.objectChainLabelsUserEditDicModifier(objectType, newChainLabels)
    }
    
    
    func setPartIdDicInKeyToNilRestoringDefault () {
        let partChain = LabelInPartChainOut(partToEdit).partChain
        for part in partChain {
            UserEditedDictionariesService.shared.partIdsUserEditedDicReseter(part)
        }
    }
    
    
    func getBilateralPresenceMenuStatus(_ part: Part) -> Bool {
        let neverBilateral =
            OneOrTwoId.partWhichAreAlwaysUnilateral.contains(part)
        let rigidlyBilateral =
            (part.transformPartToPartGroup() == PartGroup.none ? false: true)
    
        let showMenu = (!neverBilateral && !rigidlyBilateral)
        
        return showMenu
        
        //nb T rB T: nil
        //nb F rb F: nil
        //nb T rB F: show
        //nb F rB T: no show
    }
    
}



