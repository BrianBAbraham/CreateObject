//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation

struct ObjectPickModel {
    var currentObjectName: String  //FixedWheelBase.Subtype.midDrive.rawValu
    
    var currentDictionary: PositionDictionary
    var defaultDictionary: PositionDictionary
    var loadedDictionary: PositionDictionary = [:]
    //var editOccuring = true
}


class ObjectPickViewModel: ObservableObject {
    static let initialObjectName = BaseObjectTypes.fixedWheelRearDrive.rawValue
    static let dictionary =
    CreateAllPartsForObject(baseName: initialObjectName).dictionary
    
    @Published private var objectPickModel:ObjectPickModel =
    ObjectPickModel(currentObjectName: BaseObjectTypes.fixedWheelRearDrive.rawValue,
                    currentDictionary: dictionary,
                    defaultDictionary: dictionary)
}

extension ObjectPickViewModel {
    
    func getAllOriginNames()-> String{
        DictionaryInArrayOut().getAllOriginNamesAsString(objectPickModel.currentDictionary)
    }
    
    func getAllOriginValues()-> String{
        DictionaryInArrayOut().getAllOriginValuesAsString(objectPickModel.currentDictionary)
    }
    
    func getAllPartFromPrimaryOriginDictionary() -> [String: PositionAsIosAxes] {
        let allUniquePartNames = getUniquePartNamesFromObjectDictionary()
        
        let dictionary = getRelevantDictionary(.forScreen)
        var originDictionary: [String: PositionAsIosAxes] = [:]
        for uniqueName in allUniquePartNames {
            let entryName = "primaryOrigin_id0_" + uniqueName
            let found = dictionary[entryName] ?? Globalx.iosLocation
            originDictionary += [uniqueName: found]
        }
        //print(originDictionary)
        return originDictionary
    }
    
    
    func getCurrentDictionary()->[String: PositionAsIosAxes] {
        objectPickModel.currentDictionary
    }
    
    
    func getCurrentObjectName() -> String{
        objectPickModel.currentObjectName
    }
    

    func getDefaultDictionary()
    -> PositionDictionary {
        objectPickModel.defaultDictionary
    }
    
    func getDictionaryForScreen (
        _ measurementDictionary: PositionDictionary)
        -> PositionDictionary {
            let offset = getOffset()
            
            let objectDimension = getDimensionOfObject(getCurrentDictionary())
//print(objectDimension)
            let maximumObjectDimension = getMaximumOfObject(objectDimension)
            
            let scale = Screen.smallestDimension / maximumObjectDimension
  //print(scale)
            let screenDictionary =
                ForScreen(
                    measurementDictionary,
                    offset,
                    scale
                ).dictionary
            
//print(screenDictionary.sorted{$0.key > $1.key})
            
            return screenDictionary
    }
    
    func getDimensionOfObject (
        _ dictionary: PositionDictionary)
        -> Dimension {
            let minThenMaxPositionOfObject =
            getMinThenMaxPositionOfObject(dictionary)
            
           return
            getObjectDimension(minThenMaxPositionOfObject)
    }
    
    
    
    
    
    func getList() -> [String] {
let sender = #function
        return
            DictionaryInArrayOut().getNameValue(objectPickModel.currentDictionary, sender)
    }
    
    func getLoadedDictionary()->[String: PositionAsIosAxes] {
        objectPickModel.loadedDictionary
    }
    
    func getMaximumOfObject(_ objectDimensions: Dimension)
        -> Double {
            [objectDimensions.length, objectDimensions.width].max() ?? objectDimensions.length
    }
    
    func getMaximumDimensionOfObject (
        _ dictionary: PositionDictionary)
        -> Double {
            let minThenMaxPositionOfObject =
            getMinThenMaxPositionOfObject(dictionary)
            
            let objectDimensions =
            getObjectDimension(minThenMaxPositionOfObject)
            
            return
                [objectDimensions.length, objectDimensions.width].max() ?? objectDimensions.length
    }
    
    func getMinThenMaxPositionOfObject( _ actualSize: PositionDictionary )
    ->  [PositionAsIosAxes] {
        let values = actualSize.map { $0.value }
        var minX = 0.0
        var minY = 0.0
        var maxX = 0.0
        var maxY = 0.0
        for value in values {
            minX = value.x < minX ? value.x: minX
            minY = value.y < minY ? value.y: minY
            maxX = value.x > maxX ? value.x: maxX
            maxY = value.y > maxY ? value.y: maxY
        }
        
        return
        [(x: minX, y: minY, z: 0), (x: maxX, y: maxY, z: 0)]
    }
    
    
    func getObjectDimension(_ minThenMaxPositionOfObject: [PositionAsIosAxes])
    -> Dimension {
        let minMax = minThenMaxPositionOfObject
 //print(minMax)
        let objectDimension =
        (length: minMax[1].y - minMax[0].y, width: minMax[1].x - minMax[0].x)
 //print(objectDimension)
        return
            objectDimension
    }
    
    

    
    func getObjectDictionary() -> [String: PositionAsIosAxes] {
        objectPickModel.currentDictionary
    }

    
    func getOffset ()
        -> PositionAsIosAxes {
            
        let minThenMaxPositionOfObjectForOffset =
        getMinThenMaxPositionOfObject(getCurrentDictionary())
//print(minThenMaxPositionOfObjectForOffset)
        let offset = CreateIosPosition.minus(minThenMaxPositionOfObjectForOffset[0])
//print(offset)
        return offset
    }

  
    
    func getPartCornersFromPrimaryOriginDictionary(_ entity: LocationEntity) -> [String]{
        let allOriginNames = entity.interOriginNames ?? ""
        let allOriginValues = entity.interOriginValues ?? ""
let sender = #function
        let array =
            DictionaryInArrayOut().getNameValue(
                OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary.filter({$0.key.contains(Part.corner.rawValue)}), sender
                )
//print(array)
        return array
    }
    
    
    func getRelevantNames(_ partName: Part) -> [String] {
        let uniquePartNames = getUniquePartNamesFromObjectDictionary()
        return
            uniquePartNames.filter{ $0.contains(partName.rawValue)}
    }
    
    func getRelevantDictionary(
        _ forScreenOrMeasurment: DictionaryTypes)
        -> [String: PositionAsIosAxes] {
        
        var relevantDictionary =
        getLoadedDictionary().keys.count == 0 ? getCurrentDictionary(): getLoadedDictionary()
        
        let originDictionary =
        DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToMany(
            .viewOrigin,
            .objectOrigin,
            [getOffset()])
            relevantDictionary += originDictionary
//print(relevantDictionary)
        
        switch forScreenOrMeasurment {
        case .forScreen:
            relevantDictionary =
            getDictionaryForScreen(relevantDictionary)
           
        default: break
        }

      
//print(relevantDictionary.sorted{$0.key > $1.key})
        
        return relevantDictionary
    }
    
    
    
//    func getObjectMaximumLengthIncrease()
//        -> Double {
//
//            - InitialOccupantFootSupportMeasure.footSupportHanger.length
//        }
//
    
    func getScreenFrameSize ()
        -> Dimension{
        
            
        let objectDimension = getDimensionOfObject(getDefaultDictionary())
            
      
        let objectDimensionWithLengthIncrease =
            (length: objectDimension.length +
             InitialOccupantFootSupportMeasure.footSupportHangerMaximumLengthIncrease,
            width: objectDimension.width)

        var frameSize: Dimension =
            (length: Screen.smallestDimension,
             width: Screen.smallestDimension)

        if objectDimensionWithLengthIncrease.length < objectDimensionWithLengthIncrease.width {
            frameSize =
            (length: objectDimensionWithLengthIncrease.length,
             width: Screen.smallestDimension)
            
        }
    
        if objectDimensionWithLengthIncrease.length > objectDimensionWithLengthIncrease.width {
            frameSize = (length: Screen.smallestDimension,
                         width: objectDimensionWithLengthIncrease.width)
        }

            
            frameSize = objectDimensionWithLengthIncrease //(length: 1600.0, width: 700.0)
        return frameSize
     
    }
    

    

    
    
    func getUniquePartNamesFromLoadedDictionary() -> [String] {
        //getUniquePartNamesOfCornerItems(getLoadedDictionary())
        let uniquePartNames =  GetUniqueNames(getCurrentDictionary()).forPart
//print(uniquePartNames)
        return  uniquePartNames
    }
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
       // getUniquePartNamesOfCornerItems(getObjectDictionary())

        
        let uniquePartNames = GetUniqueNames(getObjectDictionary()).forPart

        return  uniquePartNames
    }
    

    
    func setCurrentObjectName(_ objectName: String){
        objectPickModel.currentObjectName = objectName
        setObjectDictionary(objectName)
    }
    
    
    func setEditedObjectDictionary(_ editedDictionary: PositionDictionary) {
        objectPickModel.currentDictionary = editedDictionary
    }
    
    func setDefaultDictionary(_ objectName: String) {
        let defaultDictionary = CreateAllPartsForObject(baseName: objectName).dictionary
        
        objectPickModel.defaultDictionary = defaultDictionary
    }
    
    func setLoadedDictionary(){
        let allOriginNames = getAllOriginNames()
        let allOriginValues = getAllOriginValues()
        objectPickModel.loadedDictionary =
        OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary
    }
    

    func setObjectDictionary(
        _ objectName: String = BaseObjectTypes.fixedWheelRearDrive.rawValue,
        _ editedDictionary: PositionDictionary = ["": Globalx.iosLocation]) {

            var currentDictionary = CreateAllPartsForObject(baseName: objectName).dictionary

            if editedDictionary[""] != nil {
                
            } else {
                currentDictionary = editedDictionary
                
            }

        
        objectPickModel.currentDictionary = currentDictionary
    }
    



    
}
