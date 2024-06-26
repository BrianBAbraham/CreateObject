//
//  ObjectDictionaryCreation.swift
//  CreateObject
//
//  Created by Brian Abraham on 14/03/2023.
//

import Foundation




//struct CreateObjectFromViewOrigin {
//    var dictionary: PositionDictionary
//    var name = CreateNameFromParts([.viewOrigin, .id0,.objectOrigin,.id0])
//    
//    init(
//        _ offset: PositionDictionary) {
//            dictionary = [name: offset]
//        }
//}

enum DictionaryVersion {
    case useCurrent
    case useDefault
    case useLoaded
}


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
            let partsNotOnLeftRight: [Part] = [.sitOn, .backSupport, .headSupport, .footSupportInOnePiece, .backSupport ]
            
            let leftRightOrSinglePartAsArrayFromPosition: [PositionAsIosAxes] =
            partsNotOnLeftRight.contains (part) ? [partFromParentOrigin]: CreateIosPosition.forLeftRightAsArrayFromPosition(partFromParentOrigin)
            
            let partFromPrimaryOriginForBothSidesOrSingleForOneSupport: [PositionAsIosAxes] =
                CreateIosPosition.addToupleToArrayOfTouples(
                    parentPartFromPrimaryOrigin,
                    leftRightOrSinglePartAsArrayFromPosition
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
        
        dictionary =
            getPartForBothSidesFromPrimaryOriginForOneSitOn(
                part,
                partOnBothSidesFromPrimaryOrigin,
                supportIndex)
        
        func getPartForBothSidesFromPrimaryOriginForOneSitOn (
            _ part: Part,
            _ partOnBothSidesFromPrimaryOrigin: [PositionAsIosAxes],
            _ supportIndex: Int)
                -> [String: PositionAsIosAxes] {
            
                let supportName = CreateNameFromParts([.stringLink, .sitOn, .id]).name
                let supportIdName = supportName + String(supportIndex)
            
            return
                DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToMany(
                         .objectOrigin,
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


struct CreateCornerDictionaryForLinkBetweenTwoPartsOnOneOrTWoSides {
    var newCornerDictionary: PositionDictionary = [:]
    let uniquePartNames: [String]
    let dictionary: PositionDictionary
    init (
        _ startPart: Part,
        _ endPart: Part,
        _ newPart: Part,
        _ dictionary: PositionDictionary,
        _ supportIndex: Int) {
            self.dictionary = dictionary
            uniquePartNames = GetUniqueNames(dictionary).forPart
//print(dictionary)
            
//print(#function)
//print("CreateCornerDictionaryForLinkBetweenTwoPartsOnOneOrTWoSides")
//print(supportIndex)
//print("")
            newCornerDictionary =
            getCornerDictionaryForPartDerivedFromTwoParts (
                startPart,
                endPart,
                newPart,
                supportIndex)
        }
    
    func getCornerDictionaryForPartDerivedFromTwoParts (
        _ startPart: Part,
        _ endPart: Part,
        _ newPart: Part,
        _ supportIndex: Int)
    -> PositionDictionary{
//print(supportIndex)
        let startPartCorners = getCornersOfOnePartPossiblyOnTwoSides(startPart, supportIndex)
        let endPartCorners = getCornersOfOnePartPossiblyOnTwoSides(endPart, supportIndex)
        
        let corners =
            leftThenRightNewPartCorners(
                startPartCorners,
                endPartCorners)
        var dictionary: PositionDictionary = [:]
                dictionary +=
                CreateCornerDictionaryForBothSides (
                    corners,
                    supportIndex,
                    newPart).dictionary
        return dictionary
    }
    

    
    func getCornersOfOnePartPossiblyOnTwoSides(
        _ partName: Part, _ supportIndex: Int )
    -> [[PositionAsIosAxes]] {
        var relevantNames =
        uniquePartNames.filter{ $0.contains(partName.rawValue)}
//print(supportIndex)
        let supportIndexName = CreateNameFromParts([Part.sitOn, [Part.id0,Part.id1][supportIndex]]).name
        relevantNames = relevantNames.filter{ $0.contains(supportIndexName) }
        var cornerPartDictionary:[String: [PositionAsIosAxes]]  = [:]
        
        var positionsPossiblyForTwoSides: [[PositionAsIosAxes]] = []
//print(partName)

        for index in 0..<relevantNames.count {
//print(relevantNames[index])
            cornerPartDictionary =
            PartNameAndItsCornerLocations(
                relevantNames[index],
                .forMeasurement,
                dictionary).dictionaryFromPrimaryOrigin
//print(cornerPartDictionary)
            positionsPossiblyForTwoSides.append(
                DictionaryElementIn(cornerPartDictionary).locationsFromPrimaryOrigin)
            
//print(cornerPartDictionary)
        }
        return positionsPossiblyForTwoSides
    }
    
    func leftThenRightNewPartCorners (
        _ startPartPositions: [[PositionAsIosAxes]],
        _ endPartPositions: [[PositionAsIosAxes]])
    -> [[PositionAsIosAxes]] {

        let firstSide = 0
        let secondSide = 1
        let youCanUseAnyX = 0
        let leftThenRightStartPartPositions = reverseOrderIfRequired(startPartPositions)

        let leftThenRightEndPartPositions = reverseOrderIfRequired(endPartPositions)
        
        func reverseOrderIfRequired(_ positions: [[PositionAsIosAxes]])
        -> [[PositionAsIosAxes]] {
            var positionsCopy = positions
            positionsCopy =
            CreateIosPosition.getArrayFromPositions(positions[firstSide]).x[youCanUseAnyX] >
            CreateIosPosition.getArrayFromPositions(positions[secondSide]).x[youCanUseAnyX] ?
            positionsCopy.reversed(): positionsCopy
            
            return positionsCopy
        }
        
        let leftPartCorners =
        getRelevantCorners(
            leftThenRightStartPartPositions[firstSide],
            leftThenRightEndPartPositions[firstSide] )
        
        let rightPartCorners =
        getRelevantCorners(
            leftThenRightStartPartPositions[secondSide],
            leftThenRightEndPartPositions[secondSide] )
        
        
        
        func getRelevantCorners (
            _ startPartCorners: [PositionAsIosAxes],
            _ endPartCorners: [PositionAsIosAxes])
        -> [PositionAsIosAxes] {
            
    
            let rightTopCorner = 0
            let rightBottomCorner = 1
            let leftBottomCorner = 2
            let leftTopCorner = 3
            
            let newPartCornersInDrawingOrder =
            [startPartCorners[rightBottomCorner],
             
             endPartCorners[rightTopCorner],
             endPartCorners[leftTopCorner],
             startPartCorners[leftBottomCorner]]
            
            return newPartCornersInDrawingOrder
        }
        
        return [leftPartCorners,rightPartCorners]
        
    }
    
}
                


struct DimensionsBetweenFirstAndSecondOrigin {
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
        .objectOrigin,
        .casterVerticalJointAtRear,
        casterSpindleOriginLocations,
        firstOriginId: 0)
        
    let casterSpindleToWheelDictionary =
    DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToOne(
        .casterVerticalJointAtRear,
        .casterWheelAtRear,
        casterWheelOriginLocations)
        
    return
        (spindleFromPrimaryOrigin: primaryToCasterSpindleDictionary,
            wheelFromSpindleOrigin: casterSpindleToWheelDictionary)
           
    }
}


