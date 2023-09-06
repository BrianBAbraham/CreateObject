//
//  ForOccupantSide.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

//import Foundation
//


struct AllOccupantSideRelated {
    let parts: [Part]
    let defaultDimensions: [Dimension3d]
    var rotatedDimensions: RotatedDimensions = []
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedPartDictionary: Part3DimensionDictionary) {
        parts =
            [
            .sideSupport]
            
        let defaults =
            PreTiltOccupantSideSupportDefaultDimension(baseType)
        
        defaultDimensions =
        [
        defaults.value]
            
        let angle =
            OccupantBodySupportDefaultAngleChange(baseType).value
        
        for dimension in defaultDimensions {
            rotatedDimensions.append(
                RotatedPartCorners(
                    dimensionIn: dimension,
                    angleChangeIn:  angle
                ).lengthAlteredForRotationDimension
            )
        }
    }
}

struct PreTiltOccupantSideSupportDefaultDimension {
    
    var dictionary: BaseObject3DimensionDictionary =
    [.allCasterStretcher:
        (width: 20.0,
         length: PreTiltOccupantBodySupportDefaultDimension(.allCasterStretcher).value.length,
         height: 20.0),

     .allCasterBed:
        (width: 20.0,
         length: PreTiltOccupantBodySupportDefaultDimension(.allCasterBed).value.length,
         height: 20.0)
        ]
    
    let value: Dimension3d
    var general: Dimension3d
        
    init(
        _ baseType: BaseObjectTypes) {
        general =
        (width: 40.0,
        length: PreTiltOccupantBodySupportDefaultDimension(baseType).value.length,
        height: 30.0)
        
    value =
        dictionary[baseType] ??
        general
    }
    
}

// tilt as in tilted/rotated/angled
// origins are described from the parent origin
// and the object-orientation not the parent orientation
struct PreTiltOccupantSideSupportDefaultOrigin {
    let baseType: BaseObjectTypes
    let sideSupportHeight = 100.0
    
    init ( _ baseType: BaseObjectTypes) {
        self.baseType = baseType
        }
    
  func getSitOnToSideSupportRotationJoint()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: PreTiltOccupantBodySupportDefaultDimension(baseType).value.width/2,
             y: -PreTiltOccupantBodySupportDefaultDimension(baseType).value.length/2,
             z: sideSupportHeight)
        return
            dictionary[baseType] ?? general
    }
    
    func getSideSupportRotationJointToSideSupport()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: 0.0,
             y: PreTiltOccupantSideSupportDefaultDimension(baseType).value.length/2,
             z: 0.0)
        return
            dictionary[baseType] ?? general
    }
}
