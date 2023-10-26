//
//  ForOccupantSide.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

//import Foundation
//


//struct AllOccupantSideRelated {
//    let parts: [Part]
//    var defaultDimensions: [Dimension3d] = []
////    var rotatedDimensions: RotatedInXxDimensions = []
//    init(
//        _ baseType: ObjectTypes,
//        _ chain: [Part]) {
//        self.parts = chain
//
//        let defaults =
//            OccupantSideSupportDefaultDimension(baseType)
//
//        for part in parts {
//            defaultDimensions.append(getDefaultDimensions(part))
//        }
//
//        func getDefaultDimensions (
//            _ part: Part)
//            -> Dimension3d {
//                var dimension: Dimension3d = ZeroValue.dimension3d
//            switch part {
//                case .sideSupportRotationJoint:
//                    dimension =
//                        Joint.dimension3d
//                case .sideSupport:
//                    dimension =
//                    defaults.value
//
//                default: break
//            }
//            return dimension
//        }
//    }
//}

struct OccupantSideSupportDefaultDimension: PartDimension {
    mutating func reinitialise(_ part: Part?) {
        self.part = part
        switch part {
        case .sideSupport:
            dimension = getSideSupport()

        case .sideSupportRotationJoint:
            dimension = getJoint()

        default:
           break
        }
    }
    

    let baseType: ObjectTypes
    var dimension: Dimension3d = ZeroValue.dimension3d
    var part: Part?

    init ( _ baseType: ObjectTypes) {
        self.baseType = baseType
    }

    
    func getOrigin() -> Dimension3d {
        dimension
    }
    
    func getSideSupport()
        -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary =
            [.allCasterStretcher:
                (width: 20.0,
                 length: OccupantBodySupportDefaultDimension(.allCasterStretcher).value.length,
                 height: 20.0),

             .allCasterBed:
                (width: 20.0,
                 length: OccupantBodySupportDefaultDimension(.allCasterBed).value.length,
                 height: 20.0)
                ]
        let general =
            (width: 40.0,
            length: OccupantBodySupportDefaultDimension(baseType).value.length,
            height: 30.0)
        return
            dictionary[baseType] ??
            general
    }
    
    func getJoint () -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = Joint.dimension3d
        return
            dictionary[baseType] ?? general
    }
    
}

struct OccupantSideSupportDefaultDimensionOld {
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
        _ baseType: ObjectTypes) {
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
struct PreTiltOccupantSideSupportDefaultOrigin: PartOrigin {
    var origin: PositionAsIosAxes = ZeroValue.iosLocation
    var part: Part?
    
    mutating func reinitialise(_ part: Part?) {
        self.part = part
        
        switch part {
        case .sideSupportRotationJoint:
            origin = getSitOnToSideSupportRotationJoint()
            

        case .sideSupport:
            origin = getSideSupportRotationJointToSideSupport()
        
        
        default:
           break
        }
    }
    
    let baseType: ObjectTypes
    let sideSupportHeight = 100.0
    
    init ( _ baseType: ObjectTypes) {
        self.baseType = baseType
        }

    
    func getOrigin() -> PositionAsIosAxes {
        origin
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
             y: OccupantSideSupportDefaultDimensionOld(baseType).value.length/2,
             z: 0.0)
        return
            dictionary[baseType] ?? general
    }
}
