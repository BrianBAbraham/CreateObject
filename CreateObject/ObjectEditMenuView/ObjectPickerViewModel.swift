//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation
import Combine
import SwiftUI

class ObjectPickerViewModel: ObservableObject {
    
    var objectPickerBinding: Binding<String> {
        Binding<String> (
            get: { self.objectType.rawValue },
            set: { self.onChangeOfPicker($0) }
        )
    }
   
    @Published var allObjectsName: [String] = ObjectChainLabel.sortedNames
    
    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics

    @Published var objectType: ObjectTypes = ObjectDataService.shared.objectType
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        
        let _ = ObjectDataMediator.shared
        
        ObjectDataService.shared.$objectType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.objectType = newData
            }
            .store(in: &cancellables)
        
        UserEditedDictionariesService.shared.$userEditedSharedDics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.userEditedSharedDics = newData
            }
            .store(in: &self.cancellables)
    }
    
    
    func onChangeOfPicker(_ objectName: String) {
        guard let newObjectType = ObjectTypes(rawValue: objectName) else {
            fatalError("Invalid object type")
        }

        ObjectDataService.shared.setObjectType(newObjectType)

        // Delay the following code to ensure objectType is updated
        DispatchQueue.main.async { [weak self] in
            self?.resetObjectByCreatingFromName()
            
            ObjectEditService.shared.resetPartToEdit()
        }
    }
    
    
    func resetObjectByCreatingFromName() {
        // DIMENSIONCHANGE
        UserEditedDictionariesService.shared.dimensionUserEditedDicReseter()
        
        // ANGLECHANGE
        UserEditedDictionariesService.shared.angleUserEditedDicReseter()
        
        UserEditedDictionariesService.shared.partIdsUserEditedDicReseter()
        
        modifyObjectByCreatingFromName()
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
}





//    func getObjectDictionaryFromSaved(_ entity: LocationEntity) -> [String]{
//        let allOriginNames = entity.interOriginNames ?? ""
//        let allOriginValues = entity.interOriginValues ?? ""
//
//        let array =
//            DictionaryInArrayOut().getNameValue(
//                OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary.filter({$0.key.contains(PartTag.corner.rawValue)})//, sender
//                )
//        return array
//    }
