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
                let dimensions = [
                    OccupantBodySupportDefaultDimension(baseType).value
                ]
                    
                dictionary =
                    CreateDefaultDimensionDictionary(
                        [.sitOn],
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
    //var dictionary: BaseObjectOriginDictionary
    
    static let general = ZeroTouple.iosLocation
    let value: [PositionAsIosAxes]
    
    init (
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions:TwinSitOnOptions,
        _ objectOptions: OptionDictionary) {
            
            
            //DEVELOP CODE
            let stability = 0.0
            
            value = getDictionary(
                baseType,
                twinSitOnOptions,
                objectOptions)

       
            func getDictionary (
                _ baseType: BaseObjectTypes,
                _ twinSitOnOptions: TwinSitOnOptions,
                _ objectOptions: OptionDictionary)
                -> [PositionAsIosAxes] {
                
                    
                    let origin: [PositionAsIosAxes]
                    
                    origin = BaseObjectGroups().rearPrimaryOrigin.contains(baseType) ? forRearPrimaryOrigin(): [ZeroTouple.iosLocation]
                    
                    
//                    let dictionary: BaseObjectOriginDictionary =
//                [ .allCasterBed :
//                    (x: 0.0,
//                     y: OccupantBodySupportDefaultDimension(.allCasterBed).value.length/2 ,
//                     z: Self.sitOnHeight),
//                  .allCasterChair:
//                    (x: 0.0,
//                     y: OccupantBodySupportDefaultDimension(.allCasterChair).value.length/2 ,
//                     z: Self.sitOnHeight),
//                  .allCasterHoist:
//                    (x: 0.0,
//                     y: DistanceBetween(.allCasterHoist).frontToRearWheels(),
//                     z: OccupantOverheadSupportMastDefaultDimension(.allCasterHoist).value.height),
//                  .allCasterTiltInSpaceShowerChair:
//                    (x: 0.0,
//                     y:  OccupantBodySupportDefaultDimension(.allCasterTiltInSpaceShowerChair).value.length/2,
//                     z: Self.sitOnHeight),
//                  .allCasterStretcher:
//                    (x: 0.0,
//                     y: OccupantBodySupportDefaultDimension(.allCasterStretcher).value.length/2 ,
//                     z: Self.sitOnHeight),
//                  .fixedWheelFrontDrive:
//                    (x: 0.0,
//                     y: -OccupantBodySupportDefaultDimension(.allCasterChair).value.length/2 ,
//                     z: Self.sitOnHeight),
//                  .fixedWheelMidDrive:
//                    (x: 0.0,
//                     y: 0.0,
//                     z: Self.sitOnHeight),
//                  .fixedWheelRearDrive:
//                   , forRearPrimaryOrigin()
//                  .fixedWheelManualRearDrive:
//                    (x: 0.0,
//                     y: OccupantBodySupportDefaultDimension(.fixedWheelRearDrive).value.length/2 ,
//                     z: Self.sitOnHeight)
//                ]
                    
                    func forRearPrimaryOrigin ()
                    -> [PositionAsIosAxes] {
                        var origin: [PositionAsIosAxes]
                        if BaseObjectGroups().twinSitOnAbility.contains(baseType) {
                                if  twinSitOnOptions[.frontAndRear] ?? false {
                                    let yRear =
                                    DistanceBetween(baseType, twinSitOnOptions).frontToRearWheels()/2
                                    let yFront =
                                        OccupantBodySupportDefaultDimension(baseType).value.length +
                                        OccupantFootSupportHangerLinkDefaultDimension(baseType).value.length
                                }
                                if twinSitOnOptions[.leftAndRight] ?? false {
                                    let xPosition =
                                        OccupantBodySupportDefaultDimension(baseType).value.width +
                                        OccupantSideSupportDefaultDimension(baseType).value.width
                                    let yPosition =
                                        OccupantBodySupportDefaultDimension(baseType).value.length/2
                                    
                                    origin =
                                    [(x: -xPosition, y: yPosition, z: Self.sitOnHeight),
                                     (x: xPosition, y: yPosition, z: Self.sitOnHeight)]
                                     
                                }
                        } else {
                            origin = [ZeroTouple.iosLocation]
                        }
                       
                        
                        return
                        [
                            (x: 0.0,
                             y: OccupantBodySupportDefaultDimension(.fixedWheelRearDrive).value.length/2 ,
                             z: Self.sitOnHeight)
                        ]
                    }
                return origin
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
