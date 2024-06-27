//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation
import Combine

struct ObjectPickModel {
    var currentObjectName: String
   
    var preTiltFourCornerPerKeyDic: CornerDictionary
        
    var angleUserEditedDic: AnglesDictionary
    
    var angleMinMaxDic: AngleMinMaxDictionary

    var userEditedDic: UserEditedDictionaries?
    
    var defaultMinMaxDictionaries: DefaultMinMaxDimensionDictionary
    
    var objectImageData: ObjectImageData

    init(
        currentObjectName: String,
        userEditedDic: UserEditedDictionaries?,
        defaultMinMaxDictionaries: DefaultMinMaxDimensionDictionary,
        objectImageData: ObjectImageData
    ){
        self.userEditedDic = userEditedDic
        self.defaultMinMaxDictionaries = defaultMinMaxDictionaries
        self.currentObjectName = currentObjectName
        self.preTiltFourCornerPerKeyDic = objectImageData.preTilt.objectToPartFourCornerPerKeyDic
      
        angleUserEditedDic = userEditedDic?.angleUserEditedDic ?? [:]
        
        angleMinMaxDic = objectImageData.angleMinMaxDic

        self.objectImageData = objectImageData
    }
}
    

class ObjectPickViewModel: ObservableObject {
    @Published private var objectPickModel: ObjectPickModel
    
    var objectImageData: ObjectImageData = ObjectImageService.shared.objectImageData
    
    @Published var userEditedSharedDics: UserEditedDictionaries
    
    let defaultMinMaxDimensionDic =
        DefaultMinMaxDimensionDictionary.shared
    
    let defaultMinMaxOriginDic =
        DefaultMinMaxOriginDictionary.shared
    
    var currentObjectType: ObjectTypes = .fixedWheelRearDrive

    var partDataSharedDic = DictionaryService.shared.partDataSharedDic
       
    private var cancellables: Set<AnyCancellable> = []
    
    
    @Published var objectChainLabelsDefaultDic: ObjectChainLabelDictionary = [:]
    
    init() {
        
        self.userEditedSharedDics = DictionaryService.shared.userEditedSharedDics
        
      
        objectPickModel =
            ObjectPickModel(
                currentObjectName: currentObjectType.rawValue,
                userEditedDic: nil,
                defaultMinMaxDictionaries: defaultMinMaxDimensionDic,
               objectImageData: ObjectImageData(.fixedWheelRearDrive, nil))
        
        DictionaryService.shared.$currentObjectType
            .sink { [weak self] newData in
                self?.currentObjectType = newData
            }
            .store(in: &self.cancellables)
        
        DictionaryService.shared.$userEditedSharedDics
            .sink { [weak self] newData in
                self?.userEditedSharedDics = newData
            }
            .store(in: &self.cancellables)
        
        DictionaryService.shared.$partDataSharedDic
            .sink { [weak self] newData in
                self?.partDataSharedDic = newData
            }
            .store(in: &self.cancellables)
        

    }
}


//MARK: RESET/MODIFY
extension ObjectPickViewModel {
    
    func resetObjectByCreatingFromName() {
        //DIMENSIONCHANGE
    
        DictionaryService.shared.dimensionUserEditedDicReseter()
        
        //ANGLECHANGE
        
        DictionaryService.shared.angleUserEditedDicReseter()
        
        
        DictionaryService.shared.partIdsUserEditedDicReseter()
        
        modifyObjectByCreatingFromName()
       
        ObjectImageService.shared.setObjectImage(objectImageData)
    }
    
    
    func modifyObjectByCreatingFromName(){
        objectImageData = ObjectImageData(
            currentObjectType,
            userEditedSharedDics
        )
        
        objectChainLabelsDefaultDic = objectImageData.objectChainLabelsDefaultDic//update for new object

        createNewPickModel()
        
        ObjectImageService.shared.setObjectImage(
            objectImageData
        )
    }
    
    
    func pickNewObjectByCreatingFromName(){
        objectImageData = ObjectImageData(
            currentObjectType,
            userEditedSharedDics
        )
        
        createNewPickModel()
        
        ObjectImageService.shared.setObjectImage(objectImageData)
    }
    
    
    func createNewPickModel() {
        DictionaryService.shared.partDataSharedDicModifier(objectImageData.partDataDic)
        
        objectPickModel =
            ObjectPickModel(
                currentObjectName: currentObjectType.rawValue,
                userEditedDic: userEditedSharedDics,
                defaultMinMaxDictionaries: defaultMinMaxDimensionDic,
                objectImageData: objectImageData)
        
        ObjectImageService.shared.setObjectImage(objectImageData)
    }
}



//MARK: GET
extension ObjectPickViewModel {
    
    func getAngleMinMaxDic(_ part: Part)
    -> AngleMinMax {

    let partName =
        CreateNameFromIdAndPart(.id0, part).name

    return
        objectPickModel.angleMinMaxDic[partName] ?? ZeroValue.angleMinMax
    }

    
    func getCurrentObjectName() -> String{
        objectPickModel.currentObjectName
    }
    
    
    func getCurrentObjectType()
        -> ObjectTypes {
        currentObjectType
    }
    

    func getPostTiltOneCornerPerKeyDic()
    -> PositionDictionary {
        objectPickModel.objectImageData.postTilt.objectToOneCornerPerKeyDic
    }
       
    func getObjectDictionaryFromSaved(_ entity: LocationEntity) -> [String]{
        let allOriginNames = entity.interOriginNames ?? ""
        let allOriginValues = entity.interOriginValues ?? ""

        let array =
            DictionaryInArrayOut().getNameValue(
                OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary.filter({$0.key.contains(PartTag.corner.rawValue)})//, sender
                )
        return array
    }
    
    
    func setCurrentObjectName(_ objectName: String){
        objectPickModel.currentObjectName = objectName
        guard let objectType = ObjectTypes(rawValue: objectName) else {
            fatalError()
         }
        DictionaryService.shared.currentObjectType = objectType
    }
}









    
