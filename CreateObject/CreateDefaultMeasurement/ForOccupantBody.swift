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
        _ twinSitOnOptions: TwinSitOnOptionDictionary,
        _ modifiedPartDictionary: Part3DimensionDictionary
        ) {

        getDictionary()
            func getDictionary() {
                let dimension =
                    OccupantBodySupportDefaultDimension(
                        baseType).value
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
        _ baseType: BaseObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


struct OccupantBodySupportAngleJointDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:
        ]
   static let general =
        (length: Joint.dimension.length,
         width: OccupantBodySupportDefaultDimension.general.width * 1.5,
         height: Joint.dimension.length)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}

struct OccupantBodySupportDefaultParentToRotationOrigin {
    var dictionary: BaseObjectOriginDictionary = [:]
    
    static let general = (x: 0.0, y: 0.0, z: -100.0)
    
    let value: PositionAsIosAxes
    
    init(
        _ baseType: BaseObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


struct OccupantBodySupportDefaultAngleChange {
    var dictionary: BaseObjectAngleDictionary =
        [.allCasterTiltInSpaceShowerChair: Measurement(value: 30.0, unit: UnitAngle.degrees)]
    
    static let general = Measurement(value: 0.0, unit: UnitAngle.radians)
    
    let value: Measurement<UnitAngle>
    
    init(
        _ baseType: BaseObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}
