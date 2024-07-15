//
//  UnilateralPartPresence.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/07/2024.
//

import Foundation
import Combine
import SwiftUI


class UnilateralPartPresenceViewModel: 
    BilateralPartSidePresencePickerBase,
    SharedModifyObjectByCreatingFromNameFuncOnly,
    SharedObectTypeAndUserEditedDictionaries
{

    
    var partBinding: Binding<Bool> {
       Binding<Bool> (
           get: {self.partPresent},
           set: {self.partPresent = $0
               self.changeStatusOfPart()}
       )
   }
    
    var partPresent = true
    
  @Published  var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
    
    var objectType: ObjectTypes = ObjectDataService.shared.objectType
    
    @Published var showMenu = false
    
    var cancellables: Set<AnyCancellable> = []
    
    override init() {
            super.init()

            (self as SharedObectTypeAndUserEditedDictionaries).subscribeToServices()
    }
    
    
    override func handlePartToEditChange(_ newData: Part) {
          partToEdit = newData
          showMenu = setShowMenuStatus()
      }
    
    
    func setShowMenuStatus() -> Bool{
        switch partToEdit {
        case .backSupportHeadSupport:
            return true
        default :
            return false
        }
    }
    
    //called if UI toggle changes
    func changeStatusOfPart() {

        switch partPresent {
        case true:
            //chain label must not exist as one was previously true
            //as only one change at at time possible
            restoreChainLabelToObject(partToEdit)
            setPartIdDicInKeyToNilRestoringDefaultForPart()
        case false:
            //remove chainLabel so part does not exist
            removeChainLabelFromObject(partToEdit)
        }
            
        
        //finally create a new object with the new specification
       modifyObjectByCreatingFromName()
    
        
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
        
        
        func replaceChainLabelForObject(
            _ removalThenReplacment: [Part]) {
                     
            removeChainLabelFromObject(removalThenReplacment[0])

            guard var curentObjectChainLabels = userEditedSharedDics
                    .objectChainLabelsUserEditDic[objectType]  else {
             fatalError()
            }
            curentObjectChainLabels += [removalThenReplacment[1]]

            UserEditedDictionariesService.shared.userEditedSharedDics
                .objectChainLabelsUserEditDic[objectType] =
                    curentObjectChainLabels
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
            let oneOrTwo = OneOrTwoId(objectType, part).forPart
            UserEditedDictionariesService.shared.partIdsUserEditedDicReseterForBilateralPart(part, oneOrTwo)
        }
    }
    
    

    
//    func setPartIdDicInKeyToNilRestoringDefaultForPart () {
//        let partChain = LabelInPartChainOut(partToEdit).partChain
//        for part in partChain {
//            UserEditedDictionariesService.shared.partIdsUserEditedDicReseterForUnilateralPart(part)
//        }
//    }
    
}
