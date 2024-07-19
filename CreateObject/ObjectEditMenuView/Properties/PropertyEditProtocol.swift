//
//  PropertyEditProtocol.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/07/2024.
//

import Foundation
import Combine


protocol SharedPartIdUSerEditedDicFunc: AnyObject {
    var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] {get}
    var cancellables: Set<AnyCancellable> { get set }

    
    func handlePartIdsUserEditedDicChange(_ newData: [Part: OneOrTwo<PartTag>] )
    
}
extension SharedPartIdUSerEditedDicFunc {
    func subscribeToService(){
        UserEditedDictionariesService.shared.$partIdsUserEditedDic
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.handlePartIdsUserEditedDicChange(newData)
            }
            .store(in: &self.cancellables)
    }
}







protocol SharedObjectChainLabelUserEditedDicFunc: AnyObject{
    var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] { get set }
    var cancellables: Set<AnyCancellable> { get set }
    
    func handleObjectChainLabelsUserEditedDicChange(_ newData: [ObjectTypes: [Part]])

}
extension SharedObjectChainLabelUserEditedDicFunc {
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


protocol SharedScopeOfEditForSideFunc: AnyObject {
    var disabled: Bool {get set}
    func getPartNotPresent() -> Bool
    var cancellables: Set<AnyCancellable> {get set}
}
extension SharedScopeOfEditForSideFunc {
    func subscribeToService() {
        ObjectEditService.shared.$scopeOfEditForSide
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.disabled = self?.getPartNotPresent() ?? true
            }
            .store(in: &self.cancellables)
    }
}



