//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation

struct ObjectPickModel {
    var equipment: String  //FixedWheelBase.Subtype.midDrive.rawValu
    
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
    ObjectPickModel(equipment: BaseObjectTypes.fixedWheelRearDrive.rawValue,
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
    
    func getCurrentObjectType() -> String{
        objectPickModel.equipment
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
        
        let objectDimension =
        (length: minMax[1].y - minMax[0].y, width: minMax[1].x - minMax[0].x)
        
        return
            objectDimension
    }
    
    
   // func toggleEditOccuring() {
       // print("Tpbb")
      //  objectPickModel.editOccuring.toggle()
   // }
    
//    func getEditOccuringState()
//     -> Bool {
//
//
//    }
    
    func getDefaultDictionary()
    -> PositionDictionary {
        objectPickModel.defaultDictionary
    }
    
    func getRelevantDictionary(
        _ forScreenOrMeasurment: DictionaryTypes)
    -> [String: PositionAsIosAxes] {
        
        var relevantDictionary =
        getLoadedDictionary().keys.count == 0 ? getObjectDictionary(): getLoadedDictionary()
        
        let defaultDictionary = objectPickModel.defaultDictionary
        
//print(defaultDictionary)
        
        let minThenMaxPositionOfObject =
        getMinThenMaxPositionOfObject(defaultDictionary)

        let objectDimensions =
        getObjectDimension(minThenMaxPositionOfObject)
        
        let maxDimension = [objectDimensions.length, objectDimensions.width].max() ?? objectDimensions.length
        

        switch forScreenOrMeasurment {
        case .forScreen:
            relevantDictionary =
            ForScreen(
                relevantDictionary,
                minThenMaxPositionOfObject,
                maxDimension//,
                 //objectPickModel.editOccuring
            ).dictionary
            
        default: break
        }
        return
         relevantDictionary
    }
    

    
    func getRelevantNames(_ partName: Part) -> [String] {
        let uniquePartNames = getUniquePartNamesFromObjectDictionary()
        return
            uniquePartNames.filter{ $0.contains(partName.rawValue)}
    }
    

    
    
    
    func getList() -> [String] {
let sender = #function
        return
            DictionaryInArrayOut().getNameValue(objectPickModel.currentDictionary, sender)
    }
    
    func getLoadedDictionary()->[String: PositionAsIosAxes] {
        objectPickModel.loadedDictionary
    }
    
    func getObjectDictionary() -> [String: PositionAsIosAxes] {
        objectPickModel.currentDictionary
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
    

    
    func getUniquePartNamesFromLoadedDictionary() -> [String] {
        //getUniquePartNamesOfCornerItems(getLoadedDictionary())
        let uniquePartNames =  GetUniqueNames(getLoadedDictionary()).forPart
//print(uniquePartNames)
        return  uniquePartNames
    }
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
       // getUniquePartNamesOfCornerItems(getObjectDictionary())

        
        let uniquePartNames = GetUniqueNames(getObjectDictionary()).forPart

        return  uniquePartNames
    }
    

    
    func setCurrentObjectType(_ objectName: String){
        objectPickModel.equipment = objectName
        setObjectDictionary(objectName)
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
            
            //objectPickModel.defaultDictionary = currentDictionary
            
//            var dictionary: PositionDictionary = [:]
            if editedDictionary[""] != nil {
                
            } else {
                currentDictionary = editedDictionary
                
            }

        
        objectPickModel.currentDictionary = currentDictionary
    }
    
    func setEditedObjectDictionary(_ editedDictionary: PositionDictionary) {
        objectPickModel.currentDictionary = editedDictionary
    }
    

    
}
