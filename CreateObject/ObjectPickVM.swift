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
    static let initialObjectName = BaseObjectTypes.fixedWheelRearDrive.rawValue
    static let dictionary =
    CreateAllPartsForObject(baseName: initialObjectName).dictionary
    
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
    
    func getRelevantDictionary(
        _ forScreenOrMeasurment: DictionaryTypes)
    -> [String: PositionAsIosAxes] {
        var relevantDictionary =
        getLoadedDictionary().keys.count == 0 ? getObjectDictionary(): getLoadedDictionary()
        
        let minThenMaxPositionOfObject =
        getMinThenMaxPositionOfObject(relevantDictionary)
        
//print(minThenMaxPositionOfObject)
        
        let objectDimensions =
        getObjectDimension(minThenMaxPositionOfObject)
        
        let maxDimension = [objectDimensions.length, objectDimensions.width].max() ?? objectDimensions.length
        switch forScreenOrMeasurment {
        case .forScreen:
            relevantDictionary = ForScreen(
                relevantDictionary,
                minThenMaxPositionOfObject,
                maxDimension).dictionary
            
        default: break
        }

//print(relevantDictionary)
        return
         relevantDictionary
    }
    
//    func getDimensionOfPart (_ uniqueName: String)
//    -> Dimension
//    {
//        let relevantDictionary = getRelevantDictionary(.forMeasurement)
//        let dictionaryForPart =
//        getPartNameAndItsCornerLocationsFromPrimaryOrigin(
//                uniqueName,
//                .forMeasurement)
//        let onlyOneDictionaryValue = 0
//        let values = dictionaryForPart.map { $0.value }[onlyOneDictionaryValue]
//        let dimension = CreateIosPosition.dimensionFromIosPositions(values)
//
//        return dimension
//    }
    
    func getPartNameAndItsCornerLocationsFromPrimaryOrigin(
        _ uniquePartName: String,
        _ forScreenOrMeasurment: DictionaryTypes)
    -> [String: [PositionAsIosAxes]] {
        let dictionary = getRelevantDictionary(forScreenOrMeasurment)
//print(uniquePartName)
        let cornerNames = Corner.names
        var uniqueCornerLocations: [PositionAsIosAxes] = []
        //let uniquePartNameInSplitForm: [Substring] =
        let uniquePartNameInSplitForm: [String] =
        uniquePartName.components(separatedBy:  ConnectStrings.symbol)
        //uniquePartName.split(separator: ConnectStrings.symbol)// requires IOS 16
        
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
    
    
    
//    func getCornersJoiningTwoPartsPossiblyOnTwoSides(
//        _ startPart: Part,
//        _ endPart: Part)
//        -> [[PositionAsIosAxes]]{
//            let startPartPositions = getCornersOfOnePartPossiblyOnTwoSides(startPart)
//            let endPartPositions = getCornersOfOnePartPossiblyOnTwoSides(endPart)
//
//            let minPositions =
//            getExtremaOfPartPossiblyOnTwoSides(
//                "min",
//                 endPartPositions,
//                endPart)
//            let maxPositions =
//            getExtremaOfPartPossiblyOnTwoSides(
//                "max",
//                 startPartPositions,
//                startPart)
//
//            var inBetweenPartOnOneSide: [PositionAsIosAxes] = []
//
//            var inBetweenPartPossiblyOnBothSides: [[PositionAsIosAxes]] = []
//
//            for sideIndex in 0..<minPositions.count {
//                for cornerIndex in 0..<minPositions[sideIndex].count {
//                    inBetweenPartOnOneSide.append( minPositions[sideIndex][cornerIndex])
//                    inBetweenPartOnOneSide.append( maxPositions[sideIndex][cornerIndex])
//                }
//                inBetweenPartPossiblyOnBothSides.append(inBetweenPartOnOneSide)
//            }
//
//            func getCornersOfOnePartPossiblyOnTwoSides(
//                _ partName: Part )
//            -> [[PositionAsIosAxes]] {
//                let relevantNames = getRelevantNames(partName)
//                var cornerPartDictionary:[String: [PositionAsIosAxes]]  = [:]
//
//                var positionsPossiblyForTwoSides: [[PositionAsIosAxes]] = []
//
//                for index in 0..<relevantNames.count {
//                    cornerPartDictionary =
//                    getPartNameAndItsCornerLocationsFromPrimaryOrigin(
//                        relevantNames[index],
//                        .forMeasurement)
//
//                    positionsPossiblyForTwoSides.append(
//                    DictionaryElementIn(cornerPartDictionary).locationsFromPrimaryOrigin)
//                }
//                return positionsPossiblyForTwoSides
//            }
//
//
//            func getExtremaOfPartPossiblyOnTwoSides(
//                _ minOrMax: String,
//                _ partPositions: [[PositionAsIosAxes]],
//                _ partName: Part)
//            -> [[PositionAsIosAxes]] {
//                var yFirstExtrema: Double
//                var ySecondExtrema: Double
//                var indexOfFirstExtrema: Int = 0
//                var indexOfSecondExtrema: Int = 0
//                var oneSide: [PositionAsIosAxes] = []
//                var bothSidesIfPresent: [[PositionAsIosAxes]] = []
//
//                for index in 0..<partPositions.count {
//                    oneSide = partPositions[index]
//                    var yArray =
//                    CreateIosPosition.getArrayFromPositions(oneSide).y
//
//                    yFirstExtrema =  minOrMax == "max" ? yArray.max() ?? yArray[0]: yArray.min() ?? yArray[0]
//
//                    indexOfFirstExtrema = yArray.firstIndex(of: yFirstExtrema) ?? 0
//                        yArray.remove(at: indexOfFirstExtrema)
//
//                    ySecondExtrema = minOrMax == "max" ? yArray.max() ?? yArray[0]: yArray.min() ?? yArray[0]
//
//                    indexOfSecondExtrema = yArray.firstIndex(of: ySecondExtrema) ?? 1
//
//                    bothSidesIfPresent.append([oneSide[indexOfFirstExtrema], oneSide[indexOfSecondExtrema] ])
//                }
//                return bothSidesIfPresent
//            }
//
//        return inBetweenPartPossiblyOnBothSides
//    }
//
//    func getCornerDictionaryForPartDerivedFromTwoParts (
//        _ startPart: Part,
//        _ endPart: Part,
//        _ newPart: Part) {
//
//            let corners =
//            getCornersJoiningTwoPartsPossiblyOnTwoSides(
//                startPart,
//                endPart)
//            var dictionary: PositionDictionary = [:]
//            let relevantNames = getRelevantNames(startPart)
//            let sitOnIdName = Part.sitOn.rawValue + Part.stringLink.rawValue + "id"
//            let sitOnIdNames = [sitOnIdName + "0", sitOnIdName + "1"]
//
//            for index in 0..<relevantNames.count/2 {
//                if relevantNames[index].contains(sitOnIdNames[index]) {
//               dictionary +=
//                    CreateCornerDictionaryForBothSides (
//                        [corners[index]],
//                        index,
//                        newPart).dictionary
//                }
//        }
//    }
    
    func getRelevantNames(_ partName: Part) -> [String] {
        let uniquePartNames = getUniquePartNamesFromObjectDictionary()
        return
            uniquePartNames.filter{ $0.contains(partName.rawValue)}
    }
    
//    func getFootSupportHangerLength ()
//    -> Double {
//        let startPartName = Part.footSupportHangerSitOnVerticalJoint.rawValue
//        let endPartName = Part.footSupportHorizontalJoint.rawValue
//        let uniquePartNames = getUniquePartNamesFromObjectDictionary()
//        let relevantStartNames = uniquePartNames.filter{ $0.contains(startPartName)}
//        let relevantEndNames = uniquePartNames.filter{ $0.contains(endPartName)}
//        let cornerStartPartDictionary =
//        getPartNameAndItsCornerLocationsFromPrimaryOrigin(
//            relevantStartNames[0],
//            .forMeasurement)
//        let cornerEndPartDictionary =
//        getPartNameAndItsCornerLocationsFromPrimaryOrigin(
//            relevantEndNames[0],
//            .forMeasurement)
//        
//        let startPositions = DictionaryElementIn(cornerStartPartDictionary).locationsFromPrimaryOrigin
//        let endPositions = DictionaryElementIn(cornerEndPartDictionary).locationsFromPrimaryOrigin
//        let startPositionsAsArrays = CreateIosPosition.getArrayFromPositions(startPositions)
//        let endPositionsAsArrays = CreateIosPosition.getArrayFromPositions(endPositions)
//        let length =
//        (endPositionsAsArrays.y.min() ?? endPositionsAsArrays.y[0]) -
//        (startPositionsAsArrays.y.max() ?? startPositionsAsArrays.y[0])
//        
//        return length
//    }
    
    
    
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
    
//    func getUniquePartNamesOfCornerItems(_ dictionary: [String: PositionAsIosAxes] ) -> [String] {
//
//        let relevantKeys = dictionary.filter({$0.key.contains(Part.corner.rawValue)}).keys
//        var uniqueNames: [String] = []
//        var removedName = ""
//        var newName = ""
//        let commonName = Part.stringLink.rawValue + Part.corner.rawValue
//        for relevantKey in relevantKeys {
//            for index in 0...3 {
//                removedName = commonName + String(index)
//                newName = String(relevantKey.replacingOccurrences(of: removedName, with: ""))
//
//                if newName != relevantKey {
//                    uniqueNames.append(newName)
//                }
//            }
//        }
//
//        return uniqueNames.removingDuplicates()
//    }
    
    func getUniquePartNamesFromLoadedDictionary() -> [String] {
        //getUniquePartNamesOfCornerItems(getLoadedDictionary())
        GetUniqueNames(getLoadedDictionary()).uniqueCornerNames
    }
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
       // getUniquePartNamesOfCornerItems(getObjectDictionary())
        GetUniqueNames(getObjectDictionary()).uniqueCornerNames
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
    
    func setObjectDictionary(_ objectName: String = BaseObjectTypes.fixedWheelRearDrive.rawValue) {
        let dictionary = CreateAllPartsForObject(baseName: objectName).dictionary
        objectPickModel.defaultDictionary = dictionary
    }
    

    

    
}
