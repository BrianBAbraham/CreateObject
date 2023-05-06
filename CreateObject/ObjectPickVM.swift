//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation

struct ObjectPickModel {
    var currentObjectName: String  //FixedWheelBase.Subtype.midDrive.rawValu
    var currentObjectDictionary: PositionDictionary
    var defaultDictionary: PositionDictionary
    var loadedDictionary: PositionDictionary = [:]
    //var editOccuring = true
}


class ObjectPickViewModel: ObservableObject {
    static let initialObjectName = BaseObjectTypes.fixedWheelRearDrive.rawValue
    static let dictionary =
    CreateAllPartsForObject(baseName: initialObjectName).dictionary
    
    @Published private var objectPickModel: ObjectPickModel =
        ObjectPickModel(currentObjectName: BaseObjectTypes.fixedWheelRearDrive.rawValue,
                        currentObjectDictionary: dictionary,
                        defaultDictionary: dictionary)
}


extension ObjectPickViewModel {
    
    func getAllOriginNames()-> String{
        DictionaryInArrayOut().getAllOriginNamesAsString(objectPickModel.currentObjectDictionary)
    }
    
    func getAllOriginValues()-> String{
        DictionaryInArrayOut().getAllOriginValuesAsString(objectPickModel.currentObjectDictionary)
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

        return originDictionary
    }
    
    
    func getCurrentObjectDictionary()->[String: PositionAsIosAxes] {
        objectPickModel.currentObjectDictionary
    }
    
    
    func getCurrentObjectName() -> String{
//        print ("getting current object name")
//        print( objectPickModel.currentObjectName)
//        return
        objectPickModel.currentObjectName
    }
    

    func getDefaultObjectDictionary()
    -> PositionDictionary {
        objectPickModel.defaultDictionary
    }
    
    
    func getList(_  version: DictionaryVersion) -> [String] {
        
        let dictionary: PositionDictionary = getVersion()
        
        func getVersion() -> PositionDictionary {
            switch version  {
            case .useCurrent:
              return  objectPickModel.currentObjectDictionary
            case .useDefault:
              return  objectPickModel.defaultDictionary
            case .useLoaded:
              return  objectPickModel.loadedDictionary
            }
        }
        return
            DictionaryInArrayOut().getNameValue(dictionary)
    }
    
    
    func getLoadedDictionary()->[String: PositionAsIosAxes] {
print("getting loaded dictionary")
        return
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
    
    func getObjectDimension (
        _ dictionary: PositionDictionary)
        -> Dimension {
            let minThenMaxPositionOfObject =
            getMinThenMaxPositionOfObject(dictionary)
            
           return
            getObjectDimension(minThenMaxPositionOfObject)
    }
    

    
    func getObjectDictionary() -> [String: PositionAsIosAxes] {
        objectPickModel.currentObjectDictionary
    }
    
    func getObjectDictionaryForScreen (
        _ measurementDictionary: PositionDictionary)
        -> PositionDictionary {
            let offset = getOffset()
            
            let objectDimension = getObjectDimension(getCurrentObjectDictionary())

            let maximumObjectDimension = getMaximumOfObject(objectDimension)
            
            let scale = Screen.smallestDimension / maximumObjectDimension

            let screenDictionary =
                ForScreen(
                    measurementDictionary,
                    offset,
                    scale
                ).dictionary
            
            return screenDictionary
    }
    

    
    func getOffset ()
        -> PositionAsIosAxes {
            
        let minThenMaxPositionOfObjectForOffset =
        getMinThenMaxPositionOfObject(getCurrentObjectDictionary())
//print(minThenMaxPositionOfObjectForOffset)
        let offset = CreateIosPosition.minus(minThenMaxPositionOfObjectForOffset[0])
//print(offset)
        return offset
    }

  
    
    func getObjectDictionaryFromSaved(_ entity: LocationEntity) -> [String]{
        let allOriginNames = entity.interOriginNames ?? ""
        let allOriginValues = entity.interOriginValues ?? ""

        let array =
            DictionaryInArrayOut().getNameValue(
                OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary.filter({$0.key.contains(Part.corner.rawValue)})//, sender
                )
        return array
    }
    
    
    func getRelevantNames(_ partName: Part) -> [String] {
        let uniquePartNames = getUniquePartNamesFromObjectDictionary()
        return
            uniquePartNames.filter{ $0.contains(partName.rawValue)}
    }
    
    func getRelevantDictionary(
        _ forScreenOrMeasurment: DictionaryTypes,
        _ dictionaryVersion: DictionaryVersion = .useCurrent)
            -> [String: PositionAsIosAxes] {
        
                var relevantDictionary: PositionDictionary = [:]
//        getLoadedDictionary().keys.count == 0 ? getCurrentObjectDictionary(): getLoadedDictionary()
                switch dictionaryVersion {
                case .useCurrent:
                    relevantDictionary = getCurrentObjectDictionary()
                case .useLoaded:
                    relevantDictionary = getLoadedDictionary()
//print("use loaded")
                default:
                    break
                }
     
        
        let originDictionary =
        DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToMany(
            .viewOrigin,
            .objectOrigin,
            [getOffset()])
        
        relevantDictionary += originDictionary

        switch forScreenOrMeasurment {
        case .forScreen:
            relevantDictionary =
            getObjectDictionaryForScreen(relevantDictionary)
           
        default: break
        }
        return relevantDictionary
    }
    
    
    
    func getScreenFrameSize ()
        -> Dimension{
        
        let objectName = getCurrentObjectName()
            var maximumLengthIncrease = 0.0
            
            maximumLengthIncrease =
            objectName.contains(GroupsDerivedFromRawValueOfPartTypes.sitOn.rawValue) ?
            InitialOccupantFootSupportMeasure.footSupportHangerMaximumLengthIncrease: maximumLengthIncrease
            
            maximumLengthIncrease =
            objectName.contains(BaseObjectTypes.showerTray.rawValue) ?
            InitialOccupantFootSupportMeasure.footShowerSupportMaximumIncrease.length: maximumLengthIncrease
            
            
            
        let objectDefaultDimension = getObjectDimension(getDefaultObjectDictionary())
            
        let objectDimensionWithLengthIncrease =
            (length: objectDefaultDimension.length +
             maximumLengthIncrease,
            width: objectDefaultDimension.width)

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

            frameSize = objectDimensionWithLengthIncrease
        return frameSize
    }
    

    func getUniquePartNamesFromLoadedDictionary() -> [String] {
   
        //let uniquePartNames =  GetUniqueNames(getCurrentObjectDictionary()).forPart
        let uniquePartNames =  GetUniqueNames(getLoadedDictionary()).forPart

        return  uniquePartNames
    }
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
        
        let uniquePartNames = GetUniqueNames(getObjectDictionary()).forPart

        return  uniquePartNames
    }
    
//    func setLoadedObjectName(_ objectName: String){
//        objectPickModel.loadedObjectName = objectName
//        setCurrentObjectDictionary(objectName)
//    }
    
    
    func setCurrentObjectName(_ objectName: String){
        objectPickModel.currentObjectName = objectName
        setCurrentObjectDictionary(objectName)
    }
    
    
    func setEditedObjectDictionary(_ editedDictionary: PositionDictionary) {
        objectPickModel.currentObjectDictionary = editedDictionary
    }
    
    func setDefaultObjectDictionary(_ objectName: String) {
        let defaultDictionary = CreateAllPartsForObject(baseName: objectName).dictionary
        
        objectPickModel.defaultDictionary = defaultDictionary
    }
    
    func setLoadedDictionary(_ entity: LocationEntity){
        let allOriginNames = entity.interOriginNames ?? ""
        let allOriginValues = entity.interOriginValues ?? ""
print("loaded dictiionary set")
        objectPickModel.loadedDictionary =
        OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary
    }
    

    func setCurrentObjectDictionary(
        _ objectName: String = BaseObjectTypes.fixedWheelRearDrive.rawValue,
        _ editedDictionary: PositionDictionary = ["": Globalx.iosLocation],
        _ recline: Bool = false) {

            var currentDictionary = CreateAllPartsForObject(
                baseName: objectName,
                recline).dictionary

            if editedDictionary[""] != nil {
                
            } else {
//print(editedDictionary)
                currentDictionary = editedDictionary
            }
            

            
        objectPickModel.currentObjectDictionary = currentDictionary
    }
    



    
}
