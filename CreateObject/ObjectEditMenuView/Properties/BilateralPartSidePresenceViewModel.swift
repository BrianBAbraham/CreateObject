//
//  BilateralPartPresenceViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine
import SwiftUI


class BilateralPartSidePresenceViewModel: BilateralPartSidePresencePickerBase {

    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics

    @Published var showMenu = false

    var leftPresent = true
    var rightPresent = true

    private var cancellables: Set<AnyCancellable> = []
    
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


    override init() {
            super.init()
        UserEditedDictionariesService.shared.$userEditedSharedDics
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEditedSharedDics,on: self)
            .store(in: &cancellables)
    

        getBilateralPresenceMenuStatus(partToEdit)
        
    }
    
   override func handlePartToEditChange(_ newData: Part) {
        partToEdit = newData
        getBilateralPresenceMenuStatus(newData)
        //update new part with its prior presence
        leftPresent = getIfSideIsPresentFromUserEditedDic(.left, newData)
        rightPresent = getIfSideIsPresentFromUserEditedDic(.right, newData)
    }

    
    //called if UI toggle changes
    func changeOneOrTwoStatusOfPart() {
       
        switch (leftPresent, rightPresent) {
        case (true, true):
            //chain label must exist as one was previously true
            //asonly one change at at time possible
            //if both present return to default
            setPartIdDicInKeyToNilRestoringDefaultForPart()
            
        //one added from none or one removed from two
        case(true, false), (false, true):
            let newId: OneOrTwo<PartTag> = leftPresent ?
                .one(one: .id0): //if left requires .id0 for x < 0
                .one(one: .id1)  //if right requires .i1 for x >= 0
         
            //one removed from two
            if getSidesAffected(partToEdit) == .both {
                modifyPartIdsUserEditedDic(newId)
            }
            
            //one added from none
            if getSidesAffected(partToEdit) == .none {
                //the chain label will have been removed
                restoreChainLabelToObject(partToEdit)
                modifyPartIdsUserEditedDic(newId)
            }
            
        case(false, false):
            //remove chainLabel so part does not exist
            removeChainLabelFromObject(partToEdit)
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
        guard let currentObjectChainLabels = objectChainLabelsUserEditDic[objectType] ??
                ObjectChainLabel.dictionary[objectType] else {
            fatalError(
                "no chain labels for object \(objectType)"
            )
        }
        let newChainLabels = currentObjectChainLabels + [chainLabel]
       
        UserEditedDictionariesService.shared.objectChainLabelsUserEditDicModifier(objectType, newChainLabels)
    }
    
    
    func setPartIdDicInKeyToNilRestoringDefaultForPart () {
        let partChain = LabelInPartChainOut(partToEdit).partChain
        for part in partChain {
            UserEditedDictionariesService.shared.partIdsUserEditedDicReseterForBilateralPart(part)
        }
    }
    
    
    func getBilateralPresenceMenuStatus(_ part: Part) {
        let neverBilateral =
            OneOrTwoId.partWhichAreAlwaysUnilateral.contains(part)
        let rigidlyBilateral =
            (part.transformPartToPartGroup() == PartGroup.none ? false: true)
    
        showMenu = (!neverBilateral && !rigidlyBilateral)
        
        //nb T rB T: nil
        //nb F rb F: nil
        //nb T rB F: show
        //nb F rB T: no show
    }
    
}



