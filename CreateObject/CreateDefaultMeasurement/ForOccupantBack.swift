//
//  ForOccupantBack.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation

struct AllOccupantBackRelated: PartDimension {
    var parts: [Part] = []
    var defaultDimensions: [Dimension3d] = []
//    var rotatedDimensions: RotatedInXxDimensions = []

    init(
        _ baseType: BaseObjectTypes,
        _ nodes: [Part] ) {
        self.parts = nodes
        
        let defaults =
            OccupantBackSupportDefaultDimension(baseType)
        for part in parts {
            defaultDimensions.append(getDefaultDimensions(part))
        }
       
        func getDefaultDimensions (
            _ part: Part)
            -> Dimension3d {
                var dimension: Dimension3d = ZeroValue.dimension3d
            switch part {
                case .backSupportHeadSupport:
                    dimension =
                        defaults.getHeadSupport()
                case .backSupportHeadSupportJoint:
                    dimension =
                    defaults.getHeadSupportRotationJoint()
                case .backSupportHeadSupportLink:
                    dimension =
                    defaults.getHeadSupportLink()
                case .backSupport:
                    dimension =
                    defaults.getBackSupport()
            case .backSupporRotationJoint:
                dimension =
                defaults.getBackSupportRotationJoint()
                default: break
            }
            return dimension
        }
    }
}


//MARK: DIMENSION

struct OccupantBackSupportDefaultDimension {
    let baseType: BaseObjectTypes
    
    init ( _ baseType: BaseObjectTypes) {
        self.baseType = baseType
    }
    
    func getBackSupportRotationJoint() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = Joint.dimension3d
        return
            dictionary[baseType] ?? general
    }
    
    func getBackSupport() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general =
        (width: OccupantBodySupportDefaultDimension.general.width * 0.9,
            length: 10.0,
            height: 500.0)
        return
            dictionary[baseType] ?? general
    }

    func getHeadSupportRotationJoint() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = Joint.dimension3d
        return
            dictionary[baseType] ?? general
    }
    
    func getHeadSupportLink() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general =
        (width: 20.0,
         length: 20.0,
         height: 100.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getHeadSupport() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general =
            (width: 150.0,
            length: 100.0,
            height: 100.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getAdditionalObject() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general =
            (width: OccupantBodySupportDefaultDimension.general.width,
            length: 100.0,
            height: 100.0)
        return
            dictionary[baseType] ?? general
    }

}



//MARK: -ORIGIN
// tilt as in tilted/rotated/angled
// origins are described from the parent origin
// and the object-orientation not the parent orientation

struct PreTiltOccupantBackSupportDefaultOrigin {
    let baseType: BaseObjectTypes
    let defaultBackSupportDimension:
        OccupantBackSupportDefaultDimension
  
    
    init ( _ baseType: BaseObjectTypes) {
        self.baseType = baseType
        
        defaultBackSupportDimension =
            OccupantBackSupportDefaultDimension(baseType)
    }
    
  func getSitOnToBackSupportRotationJoint()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: 0.0,
             y: -OccupantBodySupportDefaultDimension(baseType).value.length/2,
             z: 0.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getRotationJointToBackSupport()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: 0.0,
             y: 0.0,
             z: defaultBackSupportDimension.getBackSupport().height/2)
        return
            dictionary[baseType] ?? general
    }
    
    func getBackSupportToHeadLinkRotationJoint()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
        (x: 0.0,
         y: 0.0,
         z: defaultBackSupportDimension.getBackSupport().height/2)
        return
            dictionary[baseType] ?? general
    }
    
    func getHeadLinkRotationJointToHeadLink()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
        (x: 0.0,
         y: 0.0,
         z: defaultBackSupportDimension.getHeadSupportLink().height/2)
        return
            dictionary[baseType] ?? general
    }
    
    func getHeadSupportLinkToHeadSupport()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: 0.0,
             y: 0.0,
             z: defaultBackSupportDimension.getHeadSupportLink().height +
                 defaultBackSupportDimension.getHeadSupport().height/2  )
        return
            dictionary[baseType] ?? general
    }
}

//MARK: ANGLE

struct OccupantBackSupportDefaultAngleChange {
    var dictionary: BaseObjectAngleDictionary =
    [:]
    
    static let general = Measurement(value: 0.0 , unit: UnitAngle.radians)
    
    let value: Measurement<UnitAngle>
    
    init(
        _ baseType: BaseObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}

//struct OccupantSitOnFootAndBackSupportDefaultAngleChange {
//    var dictionary: BaseObjectAngleDictionary =
//    [:]
//
//    static let general = Measurement(value: 30.0 , unit: UnitAngle.degrees)
//
//    let value: Measurement<UnitAngle>
//
//    init(
//        _ baseType: BaseObjectTypes) {
//            value =
//                dictionary[baseType] ??
//                Self.general
//    }
//}

struct OccupantBackSupportHeadLinkDefaultAngleChange {
    var dictionary: BaseObjectAngleDictionary =
    [:]
    
    static let general = Measurement(value: 0.0 , unit: UnitAngle.radians)
    
    let value: Measurement<UnitAngle>
    
    init(
        _ baseType: BaseObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


