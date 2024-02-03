//
//  ObjectEditVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 03/02/2024.
//

import Foundation


class ObjectEditViewModel: ObservableObject {
    var userEditedDictionaries: UserEditedDictionaries = UserEditedDictionaries.shared
    init () {
        
    }
    
}

extension ObjectEditViewModel {
//    func replaceChainLabelForObject(_ removal: Part, _ replacement: Part) {
//        let objectType = getCurrentObjectType()
//        removeChainLabelFromObject(removal)
//       
//        guard var curentObjectChainLabels =  UserEditedDictionaries.shared.objectChainLabelsUserEditDic[objectType]  else {
//         fatalError()
//        }
//        curentObjectChainLabels += [replacement]
//
//        UserEditedDictionaries.shared.objectChainLabelsUserEditDic[objectType] = curentObjectChainLabels
//        
//        
//    }
//    
//    
//    func removeChainLabelFromObject(_ chainLabel: Part) {
//        let objectType = getCurrentObjectType()
//        let currentObjectChainLabels =  UserEditedDictionaries.shared.objectChainLabelsUserEditDic[objectType]  ??
//        ObjectChainLabel.dictionary[objectType]
//        
//        let newChainLabels = currentObjectChainLabels?.filter { $0 != chainLabel}
//      
//        UserEditedDictionaries.shared.objectChainLabelsUserEditDic[objectType] = newChainLabels
//    }
//    
//    
//    
//    
//    func getCurrentObjectType () -> ObjectTypes {
//            CurrentObject.shared.currentObject
//    }
//    
//    func getCurrentObjectName () -> String {
//
//        ObjectTypes.fixedWheelRearDrive.rawValue
//    }
}
