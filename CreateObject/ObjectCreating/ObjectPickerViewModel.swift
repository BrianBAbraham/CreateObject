//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation
import Combine
  

class ObjectPickerViewModel: ObservableObject {
   
    @Published var objectName: String = ObjectDataService.shared.objectType.rawValue

    var userEditedSharedDics: UserEditedDictionaries = DictionaryService.shared.userEditedSharedDics

    var objectType: ObjectTypes = ObjectDataService.shared.objectType
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        let _ = ObjectDataMediator.shared
        
        DictionaryService.shared.$userEditedSharedDics
            .sink { [weak self] newData in
                self?.userEditedSharedDics = newData
            }
            .store(in: &self.cancellables)
        
        ObjectDataService.shared.$objectType
            .sink { [weak self] newData in
                self?.objectType = newData
                self?.objectName = newData.rawValue
            }
            .store(in: &self.cancellables)
    }
}


//MARK: RESET/MODIFY
extension ObjectPickerViewModel {
    
    func modifyObjectByCreatingFromName(){
        let objectImageData = ObjectImageData(
            objectType,
            userEditedSharedDics
        )
        
        ObjectImageService.shared.setObjectImage(
            objectImageData
        )
    }

    
    func onChangeOfPicker(_ objectName: String) {
        setCurrentObjectName(objectName)
        
        resetObjectByCreatingFromName()
        
        ObjectEditService.shared.resetPartToEdit()
        
        func setCurrentObjectName(_ objectName: String){
            guard let objectType = ObjectTypes(rawValue: objectName) else {
                fatalError()
             }

            ObjectDataService.shared.setObjectType(objectType)
            
        }
        
        
        func resetObjectByCreatingFromName() {
            //DIMENSIONCHANGE
            DictionaryService.shared.dimensionUserEditedDicReseter()
            
            //ANGLECHANGE
            DictionaryService.shared.angleUserEditedDicReseter()
            
            DictionaryService.shared.partIdsUserEditedDicReseter()
            
            modifyObjectByCreatingFromName()
        }
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
