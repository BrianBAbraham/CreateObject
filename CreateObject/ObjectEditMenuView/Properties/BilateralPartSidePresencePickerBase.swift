//
//  SidePresencePickerBaseViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/07/2024.
//
//
import Foundation
import Combine

class BilateralPartSidePresencePickerBase: ObservableObject {
    //on first use toggle flips back to true without this
    @Published var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] = UserEditedDictionariesService.shared.partIdsUserEditedDic
    
    var objectType: ObjectTypes = ObjectDataService.shared.objectType
    
    var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] = UserEditedDictionariesService.shared.userEditedSharedDics.objectChainLabelsUserEditDic
    
    var partToEdit = ObjectEditService.shared.partToEdit
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        UserEditedDictionariesService.shared.$partIdsUserEditedDic
        .receive(on: DispatchQueue.main)
        .sink { [weak self] newData in
            self?.handlePartIdsUserEditedDicChange(newData)
        }
        .store(in: &self.cancellables)
        
        ObjectDataService.shared.$objectType
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectType,on: self)
            .store(in: &cancellables)
        
        UserEditedDictionariesService.shared.$objectChainLabelsUserEditDic
        .receive(on: DispatchQueue.main)
        .sink { [weak self] newData in
            self?.handleObjectChainLabelsUserEditedDicChange(newData)
        }
        .store(in: &self.cancellables)
        
        ObjectEditService.shared.$partToEdit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.handlePartToEditChange(newData)
            }
            .store(in: &self.cancellables)
    }
    
    func handlePartToEditChange(_ newData: Part){
        partToEdit = newData
    }
    
    
    func handleObjectChainLabelsUserEditedDicChange(_ newData: [ObjectTypes: [Part]]) {
        objectChainLabelsUserEditDic = newData
    }
    
    
    func handlePartIdsUserEditedDicChange(_ newData: [Part: OneOrTwo<PartTag>]){
        partIdsUserEditedDic = newData
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
