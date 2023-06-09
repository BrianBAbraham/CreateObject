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
     .allCasterHoist: (length: 40.0, width: 550.0, height: 40.0)
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

struct OccupantBodySupportDefaultOrigin {
    static let sitOnHeight = 500.0
    var dictionary: BaseObjectOriginDictionary =
    [ .allCasterBed :
        (x: 0.0,
         y: OccupantBodySupportDefaultDimension(.allCasterBed).value.length/2 ,
         z: Self.sitOnHeight),
      .allCasterChair:
        (x: 0.0,
         y: OccupantBodySupportDefaultDimension(.allCasterChair).value.length/2 ,
         z: Self.sitOnHeight),
      .allCasterHoist:
        (x: 0.0,
         y: BaseDefaultDimension(.allCasterHoist).value.length/2 ,
         z: OccupantOverheadSupportMastDefaultDimension(.allCasterHoist).value.height),
      .allCasterTiltInSpaceShowerChair:
        (x: 0.0,
         y:  OccupantBodySupportDefaultDimension(.allCasterTiltInSpaceShowerChair).value.length/2,
         z: Self.sitOnHeight),
      .allCasterStretcher:
        (x: 0.0,
         y: OccupantBodySupportDefaultDimension(.allCasterStretcher).value.length/2 ,
         z: Self.sitOnHeight),
      .fixedWheelFrontDrive:
        (x: 0.0,
         y: -OccupantBodySupportDefaultDimension(.allCasterChair).value.length/2 ,
         z: Self.sitOnHeight),
      .fixedWheelMidDrive:
        (x: 0.0,
         y: 0.0,
         z: Self.sitOnHeight),
      .fixedWheelRearDrive:
        (x: 0.0,
         y: OccupantBodySupportDefaultDimension(.fixedWheelRearDrive).value.length/2 ,
         z: Self.sitOnHeight),
      .fixedWheelManualRearDrive:
        (x: 0.0,
         y: OccupantBodySupportDefaultDimension(.fixedWheelRearDrive).value.length/2 ,
         z: Self.sitOnHeight)
    ]
    
    static let general = ZeroTouple.iosLocation
    let value: PositionAsIosAxes
    
    init (
        _ baseType: BaseObjectTypes ) {
            value = dictionary[baseType] ?? Self.general
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
