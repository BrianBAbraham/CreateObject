//
//  DictionaryCreation.swift
//  CreateObject
//
//  Created by Brian Abraham on 14/03/2023.
//

import Foundation




///transfsrorm dictiionary into a forScreenDictionary
///find maximum -vs and trasnform to +
///find max dimesnsions and scale to fit screen
///
///{

struct ForScreen {
    var dictionary: PositionDictionary = [:]
    
    init( _ actualSize: PositionDictionary ) {
        
        let minThenMax = findMinThenMax(actualSize)
        let offset = CreateIosPosition.minus(minThenMax[0])
        let objectDimensions = findObjectDimensions(minThenMax)
        let scale = findScale(objectDimensions)
    }
    
    func findMinThenMax (_ actualSize: PositionDictionary) -> [PositionAsIosAxes] {
        let values = actualSize.map { $0.value }
        var minX = 0.0
        var minY = 0.0
        var maxX = 0.0
        var maxY = 0.0
        for value in values {
            minX = value.x < minX ? value.x: minX
            minY = value.y < minY ? value.y: minY
            maxX = value.x < maxX ? value.x: maxX
            maxY = value.y < maxY ? value.y: maxY
        }
        return
            [(x: minX, y: minY, z: 0), (x: maxX, y: maxY, z: 0)]
    }
    
    func findObjectDimensions( _ minMax: [PositionAsIosAxes])
    -> PositionAsIosAxes {
        (x: minMax[1].x - minMax[0].x, y: minMax[1].y - minMax[0].y, z: 0)
    }
    
    func findScale(_ objectDimensions: PositionAsIosAxes) -> Double {
        return 1.0
    }
    
    
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


