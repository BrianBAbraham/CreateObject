//
//  ForOccupantSide.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

//import Foundation
//


struct AllOccupantSideRelated: PartDimension {
    let parts: [Part]
    var defaultDimensions: [Dimension3d] = []
//    var rotatedDimensions: RotatedInXxDimensions = []
    init(
        _ baseType: BaseObjectTypes,
        _ nodes: [Part]) {
        self.parts = nodes
            
        let defaults =
            OccupantSideSupportDefaultDimension(baseType)
        
        for part in parts {
            defaultDimensions.append(getDefaultDimensions(part))
        }
            
        func getDefaultDimensions (
            _ part: Part)
            -> Dimension3d {
                var dimension: Dimension3d = ZeroValue.dimension3d
            switch part {
                case .sideSupportRotationJoint:
                    dimension =
                        Joint.dimension3d
                case .sideSupport:
                    dimension =
                    defaults.value
                
                default: break
            }
            return dimension
        }
    }
}

struct OccupantSideSupportDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [.allCasterStretcher:
        (width: 20.0,
         length: OccupantBodySupportDefaultDimension(.allCasterStretcher).value.length,
         height: 20.0),

     .allCasterBed:
        (width: 20.0,
         length: OccupantBodySupportDefaultDimension(.allCasterBed).value.length,
         height: 20.0)
        ]
    
    let value: Dimension3d
    var general: Dimension3d
        
    init(
        _ baseType: BaseObjectTypes) {
        general =
        (width: 40.0,
        length: OccupantBodySupportDefaultDimension(baseType).value.length,
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
            (x: OccupantBodySupportDefaultDimension(baseType).value.width/2,
             y: -OccupantBodySupportDefaultDimension(baseType).value.length/2,
             z: sideSupportHeight)
        return
            dictionary[baseType] ?? general
    }
    
    func getSideSupportRotationJointToSideSupport()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: 0.0,
             y: OccupantSideSupportDefaultDimension(baseType).value.length/2,
             z: 0.0)
        return
            dictionary[baseType] ?? general
    }
}
