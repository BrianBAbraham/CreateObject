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
    
    @Published var userEditedSharedDics: UserEditedDictionaries = DictionaryService.shared.userEditedSharedDics
    
    @Published var objectType: ObjectTypes = ObjectDataService.shared.objectType
    
    @Published var objectChainLabelsDefaultDic: ObjectChainLabelsDictionary = [:]
    
    @Published var scopeOfEditForSide: SidesAffected = ObjectEditService.shared.scopeOfEditForSide
    
    @Published var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] = DictionaryService.shared.partIdsUserEditedDic
    
    @Published var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] = DictionaryService.shared.objectChainLabelsUserEditDic
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    var leftBinding: Binding<Bool> {
        Binding<Bool> (
            get: {self.getIfLeftPresent()},
            set: {self.changeLeftForOneOrTwoStatusOfPart($0)}
        )
    }
    
    var rightBinding: Binding<Bool> {
        Binding<Bool> (
            get: {self.getIfRightPresent()},
            set: {self.changeRightForOneOrTwoStatusOfPart($0)}
        )
    }
    
    init() {
        DictionaryService.shared.$userEditedSharedDics
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEditedSharedDics,on: self)
            .store(in: &cancellables)
        
        DictionaryService.shared.$partIdsUserEditedDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.partIdsUserEditedDic,on: self)
            .store(in: &cancellables)
        
        
        DictionaryService.shared.$objectChainLabelsUserEditDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectChainLabelsUserEditDic,on: self)
            .store(in: &cancellables)
        
        ObjectEditService.shared.$partToEdit
            .receive(on: DispatchQueue.main)
            .assign(to: \.partToEdit,on: self)
            .store(in: &cancellables)
        
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
    }
    
    
    func getSidesPresentGivenPossibleUserEdit() -> [SidesAffected] {
        
        let oneOrTwoId = partIdsUserEditedDic[partToEdit] ?? OneOrTwoId(objectType, partToEdit).forPart
        

        guard let chainLabels = objectChainLabelsUserEditDic[objectType] ?? objectChainLabelsDefaultDic[objectType] else {
            fatalError()
        }
    
        var sidesPresent: [SidesAffected] = []
        //the part may be removed from both sides by user edit
        if chainLabels.contains(partToEdit) {
            sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
        } else {
            sidesPresent = [.none]
        }

        let firstSidesPresentGivesSidesAffected = 0
        

        ObjectEditService.shared.setScopeOfEditForSide(sidesPresent[firstSidesPresentGivesSidesAffected])

        return sidesPresent
    }
    
    
    func getIfLeftPresent() -> Bool {
        getSidesPresentGivenPossibleUserEdit().contains(SidesAffected.left) ?
            true: false
    }
    
    
    func getIfRightPresent() -> Bool {
        getSidesPresentGivenPossibleUserEdit().contains(SidesAffected.right) ?
            true: false
    }
    
    
    func modifyObjectByCreatingFromName() {
        let objectImageData = ObjectImageData(
            objectType,
            userEditedSharedDics
        )
        
        ObjectImageService.shared.setObjectImage(
            objectImageData
        )
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
    
    
    func changeLeftForOneOrTwoStatusOfPart(_ left: Bool) {
        
        changeOneOrTwoStatusOfPart(
            left,
            getIfRightPresent())
    }
    
    
    func changeRightForOneOrTwoStatusOfPart(_ right: Bool) {
        changeOneOrTwoStatusOfPart(
                   getIfLeftPresent(),
                    right)
    }
    
    func changeOneOrTwoStatusOfPart(
        _ isLeftSelected: Bool,
        _ isRightSelected: Bool) {
//print("\(isLeftSelected)  \(isRightSelected)")
            
        let part = partToEdit
        let linkedPartDic: [Part: Part] = [
            .footSupport: .footSupportHangerLink,
        ]
         
        let sidesPresent = //.both/.left/.right/.none
            convertLeftRightSelectionToSideSelection(
                isLeftSelected,
                isRightSelected)
            
print(sidesPresent)
            
        let partChain = LabelInPartChainOut(part).partChain
            
        let oldScope = scopeOfEditForSide
print("oldScope \(oldScope)")
      
        ObjectEditService.shared.setScopeOfEditForSide(sidesPresent)
            
        switch sidesPresent {
            //if left xor right selected
            //id of part may change
        case .left, .right:
            
            let newId: OneOrTwo<PartTag> = (sidesPresent == .left) ?
                .one(one: .id0): //if left requires .id0 for x < 0
                .one(one: .id1)  //if right requires .i1 for x >= 0
            print(newId)
            //has part been removed?
            let chainLabelWasAlreadyRemoved = objectChainLabelsUserEditDic[objectType]?.contains(part) == false
            //replace chain label if removed
            if chainLabelWasAlreadyRemoved {
                print("already removed")
                restoreChainLabelToObject(part)
            } else {
                print("not previously removed")
            }
            //update id dic for part
            
            let partOrLinkedPart = linkedPartDic[part] ?? part
            
            guard let firstIndex = partChain.firstIndex(of: partOrLinkedPart) else {
                fatalError("\(partChain)")
            }
            //provide id for the parts of the chain being edited
            //as not all the chain may be removed
            //if there were two then if on the right the id must be id0 as only one
            for index in firstIndex..<partChain.count {
                print (index)
                DictionaryService.shared.partIdsUserEditedDicModifier([partChain[index]: newId])
            }
            
            //modifyObjectByCreatingFromName()
        case .none:
            removeChainLabelFromObject(part)
        case .both:
            setPartIdDicInKeyToNilRestoringDefault(partChain)
            DictionaryService.shared.objectChainLabelsUserEditDicReseter(objectType)
        }
            
        setNewValueForChoice()

            func setNewValueForChoice() {
                var newChoice = SidesAffected.none
                //from both to one
                if oldScope == .both && isRightSelected ||
                    oldScope == .both && isLeftSelected{
                    
                    newChoice = sidesPresent
                    print("newChoice: \(sidesPresent)")
                }
                //from one to both
                if oldScope == .left && isRightSelected ||
                   oldScope == .right && isLeftSelected {
                    newChoice = .both}
                //from one to none
                if oldScope == .left && !isRightSelected ||
                   oldScope == .right && !isLeftSelected {
                    newChoice = .none}
                //from none to one
                if oldScope == .none && isRightSelected ||
                   oldScope == .none && isLeftSelected {
                    newChoice = sidesPresent
                }
                ObjectEditService.shared.setSideToEdit(newChoice)
            }
            
        modifyObjectByCreatingFromName()
            
    }
    
    
    func removeChainLabelFromObject(
        _ chainLabel: Part) {
        guard let currentObjectChainLabels =
                DictionaryService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[objectType] ??
                    ObjectChainLabel.dictionary[objectType] else {
                          fatalError()
                        }
        let newChainLabels =
            currentObjectChainLabels.filter { $0 != chainLabel}
        DictionaryService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[objectType] = newChainLabels
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
        
        DictionaryService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[objectType] =
            newChainLabels
    }
    
    
    func setPartIdDicInKeyToNilRestoringDefault (_ partChainWithoutRoot: [Part]) {
        //PARTIDUSEREDITEDICCHANGE
        for part in partChainWithoutRoot {
            DictionaryService.shared.partIdsUserEditedDicReseter(part)
        }
    }
    
}



