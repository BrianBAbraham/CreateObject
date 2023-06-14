//
//  ForrOccupantBody.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation


struct RequestOccupantBodySupportDefaultDimensionDictionary {
    var dictionary: Part3DimensionDictionary = [:]
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions,
        _ modifiedPartDictionary: Part3DimensionDictionary
        ) {
            
        getDictionary()
            
        
            func getDictionary() {
                let dimension =
                    OccupantBodySupportDefaultDimension(
                        baseType,
                        modifiedPartDictionary).value
                let dimensions =
                TwinSitOn(twinSitOnOptions).state ? [dimension, dimension]: [dimension]
                let parts: [Part] =
                TwinSitOn(twinSitOnOptions).state ? [.sitOn, .sitOn]: [.sitOn]
                
                dictionary =
                    CreateDefaultDimensionDictionary(
                        parts,
                        dimensions,
                        twinSitOnOptions
                    ).dictionary
            }
        }
}


struct OccupantBodySupportDefaultDimension {
    
    var dictionary: BaseObject3DimensionDictionary =
    [.allCasterStretcher: (length: 1200.0, width: 600.0, height: 10.0),
     .allCasterBed: (length: 2000.0, width: 900.0, height: 150.0),
     .allCasterHoist: (length: 0.0, width: 0.0, height: 0.0)
        ]
    static let general = (length: 500.0, width: 400.0, height: 50.0)
    let value: Dimension3d
    
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedPartDictionary: Part3DimensionDictionary) {
        
            value =
                //modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                Self.general
    }
}

//
//struct RequestOccupantBodySupportDefaultOriginDictionary {
//    var dictionary: PositionDictionary = [:]
//
//    init(
//        _ baseType: BaseObjectTypes,
//        _ twinSitOnOptions: TwinSitOnOptions
//        ) {
//
//        getDictionary()
//
//        func getDictionary() {
//
//            let allOccupantRelated = AllOccupantFootRelated(baseType)
//            dictionary =
//                CreateDefaultOriginDictionary(
//                    allOccupantRelated.parts,
//                    allOccupantRelated.dimensions,
//                    twinSitOnOptions
//                ).dictionary
//        }
//    }
//}


/// twin seat?
/// stability?
/// base type?
struct OccupantBodySupportDefaultOrigin {
    static let sitOnHeight = 500.0
    let stability: Stability
    var origin: [PositionAsIosAxes] = []
    let frontAndRearState: Bool
    let leftandRightState: Bool
    var dictionaryOut: PositionDictionary = [:]
    let occupantBodySupport: Dimension3d
    let occupantFootSupportHangerLink: Dimension3d
    let distanceBetweenFrontAndRearWheels: DistanceBetweenFrontAndRearWheels
    
    init (
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions:TwinSitOnOptions,
        _ objectOptions: OptionDictionary,
        _ modifiedPartDictionary: Part3DimensionDictionary){
        
        stability = Stability(baseType)
        frontAndRearState = twinSitOnOptions[.frontAndRear] ?? false
        leftandRightState = twinSitOnOptions[.leftAndRight] ?? false
            
        occupantBodySupport =
            OccupantBodySupportDefaultDimension(baseType, modifiedPartDictionary).value
        occupantFootSupportHangerLink =
            OccupantFootSupportHangerLinkDefaultDimension(baseType, modifiedPartDictionary).value
            
        distanceBetweenFrontAndRearWheels =
             DistanceBetweenFrontAndRearWheels(baseType, modifiedPartDictionary)
            
        if BaseObjectGroups().rearPrimaryOrigin.contains(baseType) {
            forRearPrimaryOrigin()
        }
        if BaseObjectGroups().frontPrimaryOrigin.contains(baseType) {
            forFrontPrimaryOrgin()
        }
        if BaseObjectGroups().midPrimaryOrigin.contains(baseType) {
            forMidPrimaryOrigin()
        }
            
        
        getDictionary()
    
print("")
print(baseType.rawValue)
//print(dictionaryOut)
print(distanceBetweenFrontAndRearWheels.ifFrontAndRearSitOn)
print("")
            
        func getDictionary() {
            let ids: [Part] =
                (frontAndRearState || leftandRightState) ?
                [.id0, .id1] :  [.id0]
            
                
                for index in 0..<ids.count {
                    self.dictionaryOut[
                        CreateNameFromParts([
                            .sitOn,
                            ids[index],
                            .stringLink,
                            .object,
                            .id0]).name] = origin[index]
                }
        }
        
        func forRearPrimaryOrigin() {
            origin.append(
                (x: 0.0,
                y:
                stability.atRear +
                 occupantBodySupport.length/2,
                 z: Self.sitOnHeight)
            )
            
            if frontAndRearState {
                origin.append(
                        (x: 0.0,
                        y:
                            
                        stability.atRear +
                         occupantBodySupport.length +
                         occupantFootSupportHangerLink.length +
                        occupantBodySupport.length/2,
                         z: Self.sitOnHeight)
                )
            }
            
            if leftandRightState {
                let xOrigin1 =
                    leftAndRightX()
                let xOrigin0 =
                    -leftAndRightX()
                
            origin =
                [(x: xOrigin0,
                  y: origin[0].y,
                  z: 0.0),
                (x: xOrigin1,
                 y: origin[0].y,
                 z: Self.sitOnHeight)
                ]
            }
        }
            
        func forMidPrimaryOrigin(){
            let baseLength = frontAndRearState ?
                distanceBetweenFrontAndRearWheels.ifFrontAndRearSitOn: distanceBetweenFrontAndRearWheels.ifNoFrontAndRearSitOn
            
            origin.append(
            (x: 0.0,
             y: 0.5 * (baseLength - occupantBodySupport.length),
             z: Self.sitOnHeight)
            )
            
            if frontAndRearState {
                origin =
                [
                (x: 0.0,
                 y: -origin[0].y,
                 z: Self.sitOnHeight)
                 ,
                (x: 0.0,
                 y: origin[0].y,
                z: Self.sitOnHeight)
                ]
            }
            
            if leftandRightState {
                origin =
                [
                (x: 0.0,
                 y: -origin[0].y,
                 z: Self.sitOnHeight)
                 ,
                (x: 0.0,
                 y: origin[0].y,
                z: Self.sitOnHeight)
                ]
            }
        }
            
        func forFrontPrimaryOrgin() {
            origin.append(
                (x: 0.0,
                 y:
                -(stability.atFront +
                    occupantBodySupport.length/2),
                 z: Self.sitOnHeight )
                 )
            
            if frontAndRearState {
                origin = [
                    (x: 0.0,
                     y:
                        -stability.atFront -
                        occupantBodySupport.length -
                        occupantFootSupportHangerLink.length -
                        occupantBodySupport.length/2,
                     z: Self.sitOnHeight
                     ),
                    origin[0]
                ]
            }
            
            if leftandRightState {
                origin = [
                    (x: -leftAndRightX(),
                     y: origin[0].y,
                     z: Self.sitOnHeight),
                    (x: leftAndRightX(),
                     y: origin[0].y,
                     z: Self.sitOnHeight)
                ]
            }
        }
            
            func leftAndRightX ()
                -> Double {
                    (occupantBodySupport.width/2 +
                     OccupantSideSupportDefaultDimension(baseType, modifiedPartDictionary).value.width)
            }
    }
}
//struct RequestOccupantSupportDefaultDimensionDictionary {
//    var dictionary: Part3DimensionDictionary = [:]
//
//    init(
//        _ baseType: BaseObjectTypes,
//        _ sitOnId: Part,
//        _ options: OptionDictionary,
//        _ partsThatMakeNames: [[Part]],
//        _ dimensions: [Dimension3d]) {
//
//            dictionary =
//                CreateDefaultDimensionDictionary(
//                partsThatMakeNames,
//                dimensions
//                ).dictionary
//        }
//}
