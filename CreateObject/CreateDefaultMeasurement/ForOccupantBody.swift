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
    static let general = (width: 400.0, length: 400.0, height: 1.0)
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
    static let general = Joint.dimension3d
//        (
//         width: OccupantBodySupportDefaultDimension.general.width * 1.5,
//         length: Joint.dimension.length,
//         height: Joint.dimension.length)
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
// orientations from the object-orientation not the parent orientation

struct PreTiltOccupantTiltInSpaceDefaultOrigin {
    let baseType: BaseObjectTypes
    //let sitOnLocation: PositionAsIosAxes
    let value: PositionAsIosAxes
  
    
    init (
            _ baseType: BaseObjectTypes//,
           // _ sitOnLocation: PositionAsIosAxes
    ) {
        self.baseType = baseType
        //self.sitOnLocation = sitOnLocation
                
        value = getBodySupportToBodySupportRotationJoint()
                
    func getBodySupportToBodySupportRotationJoint()
      -> PositionAsIosAxes {
          let dictionary: OriginDictionary = [:]
          let general =
              (x: 0.0,
               y: 0.0,
               z: -100.0)
             
          return
              dictionary[baseType] ?? general
                  }
        }
}



//only angle measurement is returned
struct OccupantBodySupportDefaultAngleChange {
    let dictionary: BaseObjectAngleDictionary =
        [.allCasterTiltInSpaceShowerChair: Measurement(value: 30.0, unit: UnitAngle.degrees)]
    
    static let general = Measurement(value: 0.0, unit: UnitAngle.degrees)
    
    let value: Measurement<UnitAngle>
    
    init(
        _ baseType: BaseObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


struct OccupantBodySupportDefaultAngleMinMax {
    let dictionary: AngleMinMaxDictionary =
    [.allCasterTiltInSpaceShowerChair: (min: Measurement(value: -5.0, unit: UnitAngle.degrees), max: Measurement(value: 35.0, unit: UnitAngle.degrees) ) ]
    
    static let general = (min: Measurement(value: 0.0, unit: UnitAngle.degrees), max: Measurement(value: 0.0, unit: UnitAngle.degrees) )
    
    let value: MinMaxAngle
    
    init(
        _ baseType: BaseObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}
