//
//  DictionaryCreation.swift
//  CreateObject
//
//  Created by Brian Abraham on 14/03/2023.
//

import Foundation


struct CreateBothSidesFromRight {

    var originDictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE
    
    var cornerDictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE
    
    var partCornersBothSides: [[PositionAsIosAxes]] = []
    
    var partFromPrimaryOriginBothSidesOneSupport: LeftRightPositionAsIosAxis
    
    //var dimension: Dimension = InitialOccupantSideSupportMeasurement.sitOnArm
    
    init(
        _ dimension: Dimension,
        _ part: Part,
        _ parentPartFromPrimaryOrigin: PositionAsIosAxes,
        _ partFromParentOrigin: PositionAsIosAxes,
        _ supportIndex: Int)
        {
            partFromPrimaryOriginBothSidesOneSupport =
                CreateIosPosition.addToupleToLeftRightTouple(
                    parentPartFromPrimaryOrigin,
                    CreateIosPosition.forLeftRightFromPosition(
                        partFromParentOrigin)
                    )
            
            originDictionary =
                SymmetricalParts(
                    part,
                    partFromPrimaryOriginBothSidesOneSupport,
                    supportIndex).dictionary
            
            for position in CreateIosPosition.byExtractingLeftRightOfAsArray(
                partFromPrimaryOriginBothSidesOneSupport) {
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

struct SymmetricalParts {
    var dictionary: [String: PositionAsIosAxes]
    
    init(
        _ part: Part,
        _ partOnBothSidesFromPrimaryOrigin: LeftRightPositionAsIosAxis,
        _ supportIndex: Int) {
        
        dictionary = getPartForBothSidesFromPrimaryOriginForOneSitOn(
                part,
                partOnBothSidesFromPrimaryOrigin,
                supportIndex)
        
        func getPartForBothSidesFromPrimaryOriginForOneSitOn (
            _ part: Part,
            _ partOnBothSidesFromPrimaryOrigin: LeftRightPositionAsIosAxis,
            _ supportIndex: Int)
            -> [String: PositionAsIosAxes] {
            
            let supportName = Part.stringLink.rawValue + Part.sitOn.rawValue + Part.id.rawValue
            let supportIdName = supportName + String(supportIndex)
            
            return
                DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToMany(
                         .primaryOrigin,
                         part,
                         [partOnBothSidesFromPrimaryOrigin.left, partOnBothSidesFromPrimaryOrigin.right] ,
                         supportId: supportIdName)
        }
    }

}

struct DimensionsBetweenFirstAndSecondOrigin{
    static func dictionaryForManyToMany (
        _ firstOrigin: Part,
        _ secondOrigin: Part,
        _ secondOriginLocations: [PositionAsIosAxes],
        count firstOriginCount: Int)
    -> [String: PositionAsIosAxes] {    //CHANGE
        var dictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE
        
        for firstOriginId in 0..<firstOriginCount {
            let firstOriginName = CreateOriginName(firstOrigin, identifierForThisPartType: firstOriginId).firstName
            
            get(firstOriginName)
        }
        
        func get(_ firstOriginName: String) {
           
            for index in 0..<secondOriginLocations.count {
                dictionary +=
                newDictionary(
                    firstOriginName,
                    secondOrigin,
                    secondOriginLocations[index],
                    index)
                }
        }
        return dictionary
    }
    
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
    (spindleFromPrimaryOrigin: [String: PositionAsIosAxes ],    //CHANGE
     wheelFromSpindleOrigin: [String: PositionAsIosAxes ] ) {    //CHANGE
    
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

struct DimensionsBetweenPrimaryAndOccupantSupport {
    static func getDictionary (
        _ occupantSupportType: Part,
        _ occupantSupportLocations: [PositionAsIosAxes]
    )  -> [String: PositionAsIosAxes ]  {    //CHANGE
        DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToMany(
            .primaryOrigin,
            occupantSupportType,
            occupantSupportLocations,
            firstOriginId: 0)
    }
}
