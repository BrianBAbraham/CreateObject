//
//  PropertyEditProtocol.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/07/2024.
//

import Foundation
import Combine





protocol SharedGetSidesAffectedFunc: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] {get}
    var objectType: ObjectTypes {get}
    var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] {get}
    
    func handlePartIdsUserEditedDicChange(_ newData: [Part: OneOrTwo<PartTag>] )
}
extension SharedGetSidesAffectedFunc {
    func subscribeToService(){
        UserEditedDictionariesService.shared.$partIdsUserEditedDic
        .receive(on: DispatchQueue.main)
        .sink { [weak self] newData in
            self?.handlePartIdsUserEditedDicChange(newData)
        }
        .store(in: &self.cancellables)
    }
    
    func getIfSideIsPresentFromUserEditedDic(_ side: SidesAffected, _ partToEdit: Part) -> Bool{
        
        var present: Bool
        // it the object has an entry in objectChainLabelsUserEditDic
        // chain labels have been modified
        if let chainLabels = objectChainLabelsUserEditDic[objectType] {
            //if the partToEdit is not present no part present either side
            if !chainLabels.contains(partToEdit) {
                present = false
            } else {
               //if there is a chain label has that side been removed
              present = whichSidePresent()
            }
        } else {
            //if no chain label modifications still need to check for presence on side
            present = whichSidePresent()
        }
        
        func whichSidePresent() -> Bool {
            let oneOrTwoId: OneOrTwo = partIdsUserEditedDic[partToEdit] ?? OneOrTwoId(
                objectType,
                partToEdit
            ).forPart
            
            let sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
        
            return
                sidesPresent.contains(side)
        }
        return present
    }

    
    func getSidesAffected(_ partToEdit: Part) ->SidesAffected {
        let left = getIfSideIsPresentFromUserEditedDic(.left, partToEdit)
        let right = getIfSideIsPresentFromUserEditedDic(.right, partToEdit)
        
        switch (left, right) {
        case (true, true):
            return .both
        case (true, false):
            return .left
        case (false, true):
            return .right
        case (false, false):
            return .none
        }
    }
    
}






protocol SharedObjectChainLabelUserEditedDic: AnyObject{
    var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] { get set }
    var cancellables: Set<AnyCancellable> { get set }
    
    func handleObjectChainLabelsUserEditedDicChange(_ newData: [ObjectTypes: [Part]])
    
    //func subscribeToService()
}
extension SharedObjectChainLabelUserEditedDic {
    func subscribeToService() {
        UserEditedDictionariesService.shared.$objectChainLabelsUserEditDic
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.handleObjectChainLabelsUserEditedDicChange(newData)
            }
            .store(in: &self.cancellables)
    }
}



protocol SharedPartToEditFunc: AnyObject{
    var partToEdit: Part { get set }
    var cancellables: Set<AnyCancellable> { get set }
    func handlePartToEditChange(_ newData: Part)

}
extension SharedPartToEditFunc {
    func subscribeToService() {
        
        ObjectEditService.shared.$partToEdit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                
                self?.handlePartToEditChange(newData)
            }
            .store(in: &self.cancellables)
    }
}






protocol SharedChoiceAndScopeOfEditForSideFunc: AnyObject {
    var disabled: Bool {get set}
    
    var choiceOfEditForSide: SidesAffected {get set}
    
    var cancellables: Set<AnyCancellable> {get set}
}
extension SharedChoiceAndScopeOfEditForSideFunc {
    func subscribeToService() {
        ObjectEditService.shared.$scopeOfEditForSide
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.disabled = self?.getPartNotPresent() ?? true
                self?.handleScopeOfEditForSideChange()
            }
            .store(in: &self.cancellables)
        
        ObjectEditService.shared.$choiceOfEditForSide
            .receive(on: DispatchQueue.main)
            .assign(to: \.choiceOfEditForSide,on: self)
            .store(in: &cancellables)
    }
    
    
    func getPartNotPresent() -> Bool {
        let partOrAssociatedPart = PartsRequiringLinkedPartUse(ObjectEditService.shared.partToEdit).partForEditableOrigin
        let first = getSidesPresentGivenPossibleUserEdit(partOrAssociatedPart)[0]
        return first == .none
    }

    func handleScopeOfEditForSideChange() {
        //only one VM has additional code
    }
    
    func getSidesPresentGivenPossibleUserEdit(_ partOrAssociatedPart: Part) -> [SidesAffected] {
        guard let chainLabels = UserEditedDictionariesService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[ObjectDataService.shared.objectType] ?? ObjectDataService.shared.objectChainLabelsDefaultDic[ObjectDataService.shared.objectType] else {
            fatalError()
        }

        var sidesPresent: [SidesAffected] = []
        if chainLabels.contains(partOrAssociatedPart) {
            let oneOrTwoId: OneOrTwo<PartTag> = UserEditedDictionariesService.shared.userEditedSharedDics.partIdsUserEditedDic[partOrAssociatedPart] ?? OneOrTwoId(ObjectDataService.shared.objectType, partOrAssociatedPart).forPart
            sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
        } else {
            sidesPresent = [.none]
        }

        return sidesPresent
    }
}





