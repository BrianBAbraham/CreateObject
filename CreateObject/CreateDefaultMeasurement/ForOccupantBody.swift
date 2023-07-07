//
//  ForrOccupantBody.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation





struct PreTiltOccupantBodySupportDefaultDimension {
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
        (
         width: PreTiltOccupantBodySupportDefaultDimension.general.width * 1.5,
         length: Joint.dimension.length,
         height: Joint.dimension.length)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


// tilt as in tilted/rotated/angled
// origins are described from the parent origin
// and the object-orientation not the parent orientation

struct PreTiltOccupantBodySupportDefaultOrigin {
    let baseType: BaseObjectTypes
  
    
    init ( _ baseType: BaseObjectTypes) {
        self.baseType = baseType
        }
    
  func getBodySupportToBodySupportRotationJoint()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general = (x: 0.0, y: 0.0, z: -100.0)
           
        return
            dictionary[baseType] ?? general
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
