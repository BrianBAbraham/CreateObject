//
//  UnilateralPartPresence.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/07/2024.
//

import Foundation
import Combine
import SwiftUI


class UnilateralPartPresence: ObservableObject,
                              SharedModifyObjectByCreatingFromName {

    
    var partBinding: Binding<Bool> {
       Binding<Bool> (
           get: {self.partPresent},
           set: {self.partPresent = $0
               self.changeStatusOfPart()}
       )
   }
    
    var partPresent = true
    
    var partToEdit = ObjectEditService.shared.partToEdit
    
    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
    
    var objectType: ObjectTypes = ObjectDataService.shared.objectType
    
    var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] = UserEditedDictionariesService.shared.userEditedSharedDics.objectChainLabelsUserEditDic
    
    @Published var showMenu = false
    
    
    
    var preent = true
    
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        ObjectDataService.shared.$objectType
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectType,on: self)
            .store(in: &cancellables)
        
        
        ObjectEditService.shared.$partToEdit
            .sink { [weak self] newData in
                self?.partToEdit = newData
                //self?.handlePartToEditChange(newData)
            }
            .store(in: &self.cancellables)
        
        
        UserEditedDictionariesService.shared.$objectChainLabelsUserEditDic
        .receive(on: DispatchQueue.main)
        .sink { [weak self] newData in
            self?.objectChainLabelsUserEditDic = newData
        }
        .store(in: &self.cancellables)
        
        subscribeTServices()
    }
    
    //called if UI toggle changes
    func changeStatusOfPart() {
       
        switch partPresent {
        case true:
            //chain label must exist as one was previously true
            //asonly one change at at time possible
            //if both present return to default
            setPartIdDicInKeyToNilRestoringDefaultForPart()
        case false:
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
    
    
    func setPartIdDicInKeyToNilRestoringDefaultForPart () {
        let partChain = LabelInPartChainOut(partToEdit).partChain
        for part in partChain {
            UserEditedDictionariesService.shared.partIdsUserEditedDicReseterForBilateralPart(part)
        }
    }
    
}
