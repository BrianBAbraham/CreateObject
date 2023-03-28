//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation

struct ObjectPickModel {
    var equipment: String  //FixedWheelBase.Subtype.midDrive.rawValue
    var defaultDictionary: [String: PositionAsIosAxes]
    var loadedDictionary: [String: PositionAsIosAxes] = [:]
}


class ObjectPickViewModel: ObservableObject {
    static let initialObject = BaseObjectTypes.fixedWheelRearDrive.rawValue
    static let dictionary = CreateAllPartsForObject(initialObject).dictionary
    
    @Published private var objectPickModel:ObjectPickModel =
    ObjectPickModel(equipment: BaseObjectTypes.fixedWheelRearDrive.rawValue, defaultDictionary: dictionary)
}

extension ObjectPickViewModel {
    
    func getAllOriginNames()-> String{
        DictionaryInArrayOut().getAllOriginNamesAsString(objectPickModel.defaultDictionary)
    }

    func getAllOriginValues()-> String{
        DictionaryInArrayOut().getAllOriginValuesAsString(objectPickModel.defaultDictionary)
    }
    
    func getCurrentObjectType() -> String{
        objectPickModel.equipment
    }
    
    func getAllPartFromPrimaryOriginDictionary() -> [String: PositionAsIosAxes] {
        let allUniquePartNames = getUniquePartNamesFromObjectDictionary()
//print(allUniquePartNames)
        let dictionary = getRelevantDictionary()
        var originDictionary: [String: PositionAsIosAxes] = [:]
        for uniqueName in allUniquePartNames {
            let entryName = "primaryOrigin_id0_" + uniqueName
            let found = dictionary[entryName] ?? Globalx.iosLocation
            originDictionary += [uniqueName: found]
        }
//print(originDictionary)
        return originDictionary
    }

    
    
    
    func getRelevantDictionary() -> [String: PositionAsIosAxes] {
        getLoadedDictionary().keys.count == 0 ? getObjectDictionary(): getLoadedDictionary()
    }
    
    func getPartNameAndItsCornerLocationsFromPrimaryOrigin(_ uniquePartName: String) -> [String: [PositionAsIosAxes]] {
        let dictionary = getRelevantDictionary()
//print(uniquePartName)
        let cornerNames = Corner.names
        var uniqueCornerLocations: [PositionAsIosAxes] = []
        let uniquePartNameInSplitForm: [Substring] = uniquePartName.split(separator: ConnectStrings.symbol)//[]
        let generalPartNameIsFirst = 0
        let generalPartName = String(uniquePartNameInSplitForm[generalPartNameIsFirst])
//Print.this(#function,generalPartName)
        var uniqueCornerLocation: PositionAsIosAxes
        var assembledUniquePartCornerName: String
        let numberOfConnectStringSymbols = uniquePartName.filter({ $0 == Character(ConnectStrings.symbol) }).count
        
//        if numberOfConnectStringSymbols == 5 {
//            for cornerName in cornerNames {
//                assembledName = dictionaryNameInSplitForm[0] + ConnectStrings.symbol + dictionaryNameInSplitForm[1] + cornerName + ConnectStrings.symbol + dictionaryNameInSplitForm[2] + ConnectStrings.symbol + dictionaryNameInSplitForm[3]
//
//                cornerLocation = dictionary[ String(assembledName)] ?? Global.iosLocation
//                cornerLocations.append(cornerLocation)
//            }
//        }
        
        if numberOfConnectStringSymbols == 3 { //related to possibly two sitOn elements
            for cornerName in cornerNames {
                assembledUniquePartCornerName = uniquePartNameInSplitForm[0] + ConnectStrings.symbol + uniquePartNameInSplitForm[1] + cornerName + ConnectStrings.symbol + uniquePartNameInSplitForm[2] + ConnectStrings.symbol + uniquePartNameInSplitForm[3]

                uniqueCornerLocation = dictionary[ String(assembledUniquePartCornerName)] ?? Globalx.iosLocation
                uniqueCornerLocations.append(uniqueCornerLocation)
            }
        }
        if numberOfConnectStringSymbols == 1 { // not related to possibly two sitOn elements
            for cornerName in cornerNames {
                let newName = uniquePartName + cornerName
                uniqueCornerLocation = dictionary[newName] ?? Globalx.iosLocation
                uniqueCornerLocations.append(uniqueCornerLocation)
            }
        }
        return [generalPartName: uniqueCornerLocations]
    }
    
    
    
    func getList() -> [String] {
let sender = #function
        return
            DictionaryInArrayOut().getNameValue(objectPickModel.defaultDictionary, sender)
    }
    
    func getLoadedDictionary()->[String: PositionAsIosAxes] {
        objectPickModel.loadedDictionary
    }
    
    func getObjectDictionary() -> [String: PositionAsIosAxes] {
        
        objectPickModel.defaultDictionary
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
    
    func getUniquePartNamesOfCornerItems(_ dictionary: [String: PositionAsIosAxes] ) -> [String] {
//print(dictionary.keys)
        let relevantKeys = dictionary.filter({$0.key.contains(Part.corner.rawValue)}).keys
        var uniqueNames: [String] = []
        var removedName = ""
        var newName = ""
        let commonName = Part.stringLink.rawValue + Part.corner.rawValue
        for relevantKey in relevantKeys {
            for index in 0...3 {
                removedName = commonName + String(index)
                newName = String(relevantKey.replacingOccurrences(of: removedName, with: ""))
                
                if newName != relevantKey {
                    uniqueNames.append(newName)
                }
            }
        }
//print(uniqueNames.removingDuplicates())
        return uniqueNames.removingDuplicates()
    }
    
    func getUniquePartNamesFromLoadedDictionary() -> [String] {
        getUniquePartNamesOfCornerItems(getLoadedDictionary())
    }
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
        getUniquePartNamesOfCornerItems(getObjectDictionary())
    }
    

    
    func setCurrentObjectType(_ equipmentType: String){
        objectPickModel.equipment = equipmentType
        setObjectDictionary(objectType: equipmentType)
    }
    
    func setLoadedDictionary(){
        let allOriginNames = getAllOriginNames()
        let allOriginValues = getAllOriginValues()
        objectPickModel.loadedDictionary =
        OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary
    }
    
    func setObjectDictionary(objectType: String = BaseObjectTypes.fixedWheelRearDrive.rawValue) {
        let dictionary = CreateAllPartsForObject(objectType).dictionary
        objectPickModel.defaultDictionary = dictionary
    }
    

    

    
}
