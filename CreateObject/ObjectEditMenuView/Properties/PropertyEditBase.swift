//
//  PropertyBaseViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine



class PropertyEditBase: ObservableObject {

    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
//    var objectType = ObjectDataService.shared.objectType


    
    private var cancellables: Set<AnyCancellable> = []

    init() {
        
        ObjectEditService.shared.$partToEdit
            .sink { [weak self] newData in
                self?.partToEdit = newData
                self?.handlePartToEditChange(newData)
            }
            .store(in: &self.cancellables)
    }

    
    func handlePartToEditChange(_ newData: Part) {
    //children execute their unique code here
    }

}


protocol SharedPartDataDic: AnyObject {
    var partDataDic: [Part: PartData] {get set}
    
    var cancellables: Set<AnyCancellable> {get set}
}
extension SharedPartDataDic {
    func subScribeToService() {
        ObjectDataService.shared.$partDataDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.partDataDic,on: self)
            .store(in: &cancellables)
    }
}



protocol SharedChoieAndScopeOfEditForSideFunc: AnyObject {
    var disabled: Bool {get set}
    
    var choiceOfEditForSide: SidesAffected {get set}
    
    var cancellables: Set<AnyCancellable> {get set}
}
extension SharedChoieAndScopeOfEditForSideFunc {
    func subscribeToServie() {
        ObjectEditService.shared.$scopeOfEditForSide
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.disabled = self?.getPartNotPresent() ?? true
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
