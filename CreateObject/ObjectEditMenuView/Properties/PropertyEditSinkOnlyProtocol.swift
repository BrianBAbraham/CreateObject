//
//  PropertyEditSinkOnlyProtocol.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine

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


protocol  SharedObjectType: AnyObject {
    var objectType: ObjectTypes {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedObjectType {
    func subscribeToService() {
        ObjectDataService.shared.$objectType
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectType,on: self)
            .store(in: &cancellables)
    }
}



protocol  SharedUserEditedDictionaries: AnyObject {
    var userEditedSharedDics: UserEditedDictionaries {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedUserEditedDictionaries {
    func subscribeToService() {
        UserEditedDictionariesService.shared.$userEditedSharedDics
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEditedSharedDics,on: self)
            .store(in: &cancellables)
    }
}



protocol SharedDimensionPropertyToEdit: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    
    var dimensionPropertyToEdit: PartTag { get set }

}
extension SharedDimensionPropertyToEdit {
   func subscribeToService() {
       ObjectEditService.shared.$dimensionPropertyToEdit
           .receive(on: DispatchQueue.main)
           .assign(to: \.dimensionPropertyToEdit,on: self)
           .store(in: &cancellables)
   }
}



protocol SharedOriginPropertyToEdit: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    
    var originPropertyToEdit: PartTag { get set }
       
}
extension SharedOriginPropertyToEdit {
   func subscribeToService() {
       ObjectEditService.shared.$originPropertyToEdit
           .receive(on: DispatchQueue.main)
           .assign(to: \.originPropertyToEdit,on: self)
           .store(in: &cancellables)
   }
}



protocol SharedChoiceOfEditForSide: AnyObject {
    var choiceOfEditForSide: SidesAffected {get set}
    var cancellables: Set<AnyCancellable> {get set}
}
extension SharedChoiceOfEditForSide {
    func subscribeToService() {
        ObjectEditService.shared.$choiceOfEditForSide
            .receive(on: DispatchQueue.main)
            .assign(to: \.choiceOfEditForSide,on: self)
            .store(in: &cancellables)
    }
}








