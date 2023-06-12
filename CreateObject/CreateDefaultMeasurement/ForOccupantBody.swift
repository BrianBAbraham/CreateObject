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
        _ twinSitOnOptions: TwinSitOnOptions
    ) {
            
        getDictionary()
            
        
            func getDictionary() {
                let dimension = OccupantBodySupportDefaultDimension(baseType).value
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
     .allCasterHoist: (length: 600.0, width: 550.0, height: 40.0)
        ]
    static let general = (length: 500.0, width: 400.0, height: 50.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes) {
            
            value = dictionary[baseType] ?? Self.general
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
   // let modifiedOrDefaultDimensionDictionary: Part3DimensionDictionary
    let modifiedOrDefaultOriginDictionary: PositionDictionary
    let stability = Stability()
    var origin: [PositionAsIosAxes] = []
    let sitOnOrigin0: PositionAsIosAxes?
    let sitOnOrigin1: PositionAsIosAxes?

    
    init (
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions:TwinSitOnOptions,
        _ objectOptions: OptionDictionary,
      //  _ modifiedOrDefaultDimensionDictionary: Part3DimensionDictionary = [:],
        _ modifiedOrDefaultOriginDictionary: PositionDictionary = [:]) {
            
        //self.modifiedOrDefaultDimensionDictionary =  modifiedOrDefaultDimensionDictionary
        self.modifiedOrDefaultOriginDictionary =  modifiedOrDefaultOriginDictionary
        
        sitOnOrigin0 = modifiedOrDefaultOriginDictionary[
            CreateNameFromParts([.sitOn, .id0, .object, .id0]).name ]
            
        sitOnOrigin1 = modifiedOrDefaultOriginDictionary[
            CreateNameFromParts([.sitOn, .id1, .object, .id0]).name ]
            
   
        if BaseObjectGroups().rearPrimaryOrigin.contains(baseType) {
            forRearPrimaryOrigin()
        }
            
        if BaseObjectGroups().frontPrimaryOrigin.contains(baseType) {
            forFrontPrimaryOrgin()
        }
  
        if BaseObjectGroups().midPrimaryOrigin.contains(baseType) {
            forMidPrimaryOrigin()
        }
        
        func forRearPrimaryOrigin() {
            origin.append(
                sitOnOrigin0 ??
                (x: 0.0,
                y:
                Stability().atRear +
                OccupantBodySupportDefaultDimension(baseType).value.length/2,
                z: 0.0)
            )
            
            if twinSitOnOptions[.frontAndRear] ?? false {
                origin.append(
                    sitOnOrigin1 ??
                        (x: 0.0,
                        y:
                        Stability().atRear +
                        OccupantBodySupportDefaultDimension(baseType).value.length +
                        OccupantFootSupportHangerLinkDefaultDimension(baseType).value.length +
                        OccupantBodySupportDefaultDimension(baseType).value.length/2,
                         z: 0.0)
                )
            }
            
            if twinSitOnOptions[.leftAndRight]  ?? false {
                let xOrigin1 =
                sitOnOrigin1?.x ??
                    leftAndRightX()
                let xOrigin0 =
                sitOnOrigin0?.x ??
                    -leftAndRightX()
                
            origin =
                [(x: xOrigin0,
                  y: origin[0].y,
                  z: 0.0),
                (x: xOrigin1,
                 y: origin[0].y,
                 z: 0.0)
                ]
            }
        }
            
            
        func forMidPrimaryOrigin(){
            let baseLength =
                Stability().atRear +
                OccupantBodySupportDefaultDimension(baseType).value.length +
                OccupantFootSupportHangerLinkDefaultDimension(baseType).value.length +
                OccupantBodySupportDefaultDimension(baseType).value.length +
                Stability().atFront
            
            origin.append(
            sitOnOrigin0 ??
            (x: 0.0,
             y: 0.5 * (baseLength - OccupantBodySupportDefaultDimension(baseType).value.length),
             z: 0.0)
            )
            
            if twinSitOnOptions[.frontAndRear] ?? false {
                origin =
                [sitOnOrigin0 ??
                (x: 0.0,
                 y: -origin[0].y,
                 z: 0.0)
                 ,
                sitOnOrigin1 ??
                (x: 0.0,
                 y: origin[0].y,
                z: 0.0)
                ]
            }
            
            if twinSitOnOptions[.leftAndRight] ?? false {
                origin =
                [sitOnOrigin0 ??
                (x: 0.0,
                 y: -origin[0].y,
                 z: 0.0)
                 ,
                sitOnOrigin1 ??
                (x: 0.0,
                 y: origin[0].y,
                z: 0.0)
                ]
            }
        }
            
        func forFrontPrimaryOrgin() {
            origin.append(
                sitOnOrigin0 ??
                (x: 0.0,
                 y:
                -(Stability().atFront +
                    OccupantBodySupportDefaultDimension(baseType).value.length/2),
                 z: 0.0 )
                 )
            
            if twinSitOnOptions[.frontAndRear] ?? false {
                origin = [
                    sitOnOrigin1 ??
                    (x: 0.0,
                     y:
                        -Stability().atFront -
                        OccupantFootSupportHangerLinkDefaultDimension(baseType).value.length -
                        OccupantFootSupportHangerLinkDefaultDimension(baseType).value.length -
                        OccupantBodySupportDefaultDimension(baseType).value.length/2,
                     z: 0.0
                     ),
                    origin[0]
                ]
            }
        }
            
            func leftAndRightX ()
                -> Double {
                    (OccupantBodySupportDefaultDimension(baseType).value.width/2 +
                   OccupantSideSupportDefaultDimension(baseType).value.width)
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
