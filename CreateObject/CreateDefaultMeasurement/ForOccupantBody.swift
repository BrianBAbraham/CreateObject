//
//  ForrOccupantBody.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation





struct OccupantBodySupportDefaultDimension {
    let dictionary: BaseObject3DimensionDictionary =
    [.allCasterStretcher: (width: 600.0, length: 1200.0, height: 10.0),
     .allCasterBed: (width: 900.0, length: 2000.0, height: 150.0),
     .allCasterHoist: (width: 0.0, length: 0.0, height: 0.0)
        ]
    static let general = (width: 400.0, length: 500.0, height: 50.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


struct OccupantBodySupportAngleJointDefaultDimension {
    let dictionary: BaseObject3DimensionDictionary =
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
    let dictionary: BaseObjectOriginDictionary = [:]
    
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
    let dictionary: BaseObjectAngleDictionary =
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
