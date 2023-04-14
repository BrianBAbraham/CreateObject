//
//  DictionaryCreation.swift
//  CreateObject
//
//  Created by Brian Abraham on 14/03/2023.
//

import Foundation









struct CreateOnePartOrSideSymmetricParts {

    var originDictionary: [String: PositionAsIosAxes ] = [:]
    
    var cornerDictionary: [String: PositionAsIosAxes ] = [:]
    
    var partCornersBothSides: [[PositionAsIosAxes]] = []
    
    init(
        _ dimension: Dimension,
        _ part: Part,
        _ parentPartFromPrimaryOrigin: PositionAsIosAxes,
        _ partFromParentOrigin: PositionAsIosAxes,
        _ supportIndex: Int)
        {
            
            
            let partFromPrimaryOriginForBothSidesOrSingleForOneSupport =
                CreateIosPosition.addToupleToArrayOfTouples(
                    parentPartFromPrimaryOrigin,
                    CreateIosPosition.forLeftRightAsArrayFromPosition (
                        partFromParentOrigin)
                    )
            
            originDictionary =
                SymmetricalOrSingleParts(
                    part,
                    partFromPrimaryOriginForBothSidesOrSingleForOneSupport,
                    supportIndex).dictionary
            
            for position in partFromPrimaryOriginForBothSidesOrSingleForOneSupport {
                partCornersBothSides.append(
                    PartCornerLocationFrom(
                        dimension.length,
                        position,
                        dimension.width).primaryOrigin
                    )
            }
            
            cornerDictionary =
            CreateCornerDictionaryForBothSides (
              partCornersBothSides,
              supportIndex,
              part).dictionary

    }
}


struct SymmetricalOrSingleParts {
    var dictionary: [String: PositionAsIosAxes]
    
    init(
        _ part: Part,
        _ partOnBothSidesFromPrimaryOrigin: [PositionAsIosAxes],
        _ supportIndex: Int) {
        
        dictionary = getPartForBothSidesFromPrimaryOriginForOneSitOn(
                part,
                partOnBothSidesFromPrimaryOrigin,
                supportIndex)
        
        func getPartForBothSidesFromPrimaryOriginForOneSitOn (
            _ part: Part,
            _ partOnBothSidesFromPrimaryOrigin: [PositionAsIosAxes],
            _ supportIndex: Int)
            -> [String: PositionAsIosAxes] {
            
            let supportName = Part.stringLink.rawValue + Part.sitOn.rawValue + Part.id.rawValue
            let supportIdName = supportName + String(supportIndex)
            
            return
                DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToMany(
                         .primaryOrigin,
                         part,
                         partOnBothSidesFromPrimaryOrigin ,
                         supportId: supportIdName)
        }
    }

}

struct CreateCornerDictionaryForBothSides {
    
    let dictionary: [String: PositionAsIosAxes]
    
    init(_ cornersForLeftAndRight: [[PositionAsIosAxes]],
         _ sitOnId: Int,
         _ part: Part) {
        
        dictionary = getDictionary(cornersForLeftAndRight, sitOnId, part)
        
        func getDictionary(
        _ cornersForBothSides: [[PositionAsIosAxes]],
        _ sitOnId: Int,
        _ part: Part) ->  [String: PositionAsIosAxes] {
            
            var dictionary: [String: PositionAsIosAxes] = [:] //CHANGE
            
            for sideIndex in 0..<cornersForLeftAndRight.count {
                for index in 0..<cornersForLeftAndRight[sideIndex].count {
                    
                   
                    let name = CreateSymmetricPartName(
                        indexForSide: sideIndex,
                        indexForCorner: index,
                        indexForSitOn: sitOnId,
                        part: part
                    ).name
                    
                    dictionary +=
                    [name: cornersForLeftAndRight[sideIndex][index]]
                }
            }
            return dictionary
        }
    }
}


//struct CreateCornerDictionaryForLinkBetweenTwoPartsOnOneOrTWoSides {
//
//    let newCornerDictionary: PositionDictionary
//    let uniquePartNames: [String]
//
//    init (
//        _ startPart: Part,
//        _ endPart: Part,
//        _ newPart: Part,
//        _ dictionary: PositionDictionary) {
//
//            uniquePartNames = GetUniqueNames(dictionary).uniqueCornerNames
//
//            getCornerDictionaryForPartDerivedFromTwoParts (
//            startPart,
//            endPart,
//            newPart)
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
//            let relevantNames = uniquePartNames.filter{ $0.contains(startPart.rawValue)}
//
//            //getRelevantNames(startPart)
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
//
//
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
//                let relevantNames = uniquePartNames.filter{ $0.contains(partName.rawValue)}//getRelevantNames(partName)
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
//}

struct DimensionsBetweenFirstAndSecondOrigin{
//    static func dictionaryForManyToMany (
//        _ firstOrigin: Part,
//        _ secondOrigin: Part,
//        _ secondOriginLocations: [PositionAsIosAxes],
//        count firstOriginCount: Int)
//    -> [String: PositionAsIosAxes] {    //CHANGE
//        var dictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE
//
//        for firstOriginId in 0..<firstOriginCount {
//            let firstOriginName = CreateOriginName(firstOrigin, identifierForThisPartType: firstOriginId).firstName
//
//            get(firstOriginName)
//        }
//
//        func get(_ firstOriginName: String) {
//
//            for index in 0..<secondOriginLocations.count {
//                dictionary +=
//                newDictionary(
//                    firstOriginName,
//                    secondOrigin,
//                    secondOriginLocations[index],
//                    index)
//                }
//        }
//        return dictionary
//    }
    
    static func dictionaryForOneToMany(
        _ firstOrigin: Part,
        _ secondOrigin: Part,
        _ secondOriginLocations: [PositionAsIosAxes],
        firstOriginId: Int = 0,
        supportId: String = "")
    -> [String: PositionAsIosAxes] {    //CHANGE
   
        var dictionary: [String: PositionAsIosAxes] = [:]    //CHANGE
    
        let firstOriginName = CreateOriginName(firstOrigin, identifierForThisPartType: firstOriginId).firstName
        
        for index in 0..<secondOriginLocations.count {
            
            dictionary +=
            newDictionary(
                firstOriginName,
                secondOrigin,
                secondOriginLocations[index],
                index,
                supportId: supportId)
        }
    return dictionary
    }
    

    
    static func dictionaryForOneToOne(
        _ firstOrigin: Part,
        _ secondOrigin: Part,
        _ secondOriginLocations: [PositionAsIosAxes])
    -> [String: PositionAsIosAxes] {    //CHANGE
                
    var dictionary: [String: PositionAsIosAxes] = [:]    //CHANGE

    for index in 0..<secondOriginLocations.count {
        let firstOriginName = CreateOriginName(
            firstOrigin,
            identifierForThisPartType: index).firstName
        
        dictionary += newDictionary(firstOriginName, secondOrigin, secondOriginLocations[index], index)
        }
    return dictionary
    }
    
    
    //CHANGE
    static func newDictionary(
        _ firstName:String,
        _ secondOrigin: Part,
        _ location: PositionAsIosAxes,
        _ index: Int,
        supportId: String = "")
        -> [String: PositionAsIosAxes] {
        
            var dictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE
        
            let secondOriginName = CreateOriginName(secondOrigin, identifierForThisPartType: index).secondName
        
            var name = ConnectStrings.byUnderscoreOrSymbol(firstName,secondOriginName)
            name = supportId == "" ? name: name + supportId
        dictionary[name] = location    //CHANGE
        
        return dictionary
    }
}


struct DimensionsForCaster{
    
    static func dictionaryTouple(
        _ positionOfCaster:
            (itsSpindleFromPrimaryOrigin: [PositionAsIosAxes ],
            wheelFromItsCasterSpindleOrigin: [PositionAsIosAxes] ),
    firstOriginId: Int)
    ->
    (spindleFromPrimaryOrigin: [String: PositionAsIosAxes ],
     wheelFromSpindleOrigin: [String: PositionAsIosAxes ] ) {
    
        let casterSpindleOriginLocations = positionOfCaster.itsSpindleFromPrimaryOrigin
        
        let casterWheelOriginLocations = positionOfCaster.wheelFromItsCasterSpindleOrigin
        
    let primaryToCasterSpindleDictionary =
    DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToMany(
        .primaryOrigin,
        .casterSpindleJointAtRear,
        casterSpindleOriginLocations,
        firstOriginId: 0)
        
    let casterSpindleToWheelDictionary =
    DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToOne(
        .casterSpindleJointAtRear,
        .casterWheelAtRear,
        casterWheelOriginLocations)
        
    return
        (spindleFromPrimaryOrigin: primaryToCasterSpindleDictionary,
            wheelFromSpindleOrigin: casterSpindleToWheelDictionary)
           
    }
}


