//
//  ForOccupantBack.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation



struct OccupantBackSupportDefaultDimension: PartDimension {
    var dimension: Dimension3d = ZeroValue.dimension3d
    
    mutating func reinitialise(_ part: Part?) {
        self.part = part
        
        switch part {
        case .backSupportRotationJoint:
            dimension = getBackSupportRotationJoint()
            
        case .backSupport:
            dimension = getBackSupport()
            
        case .backSupportHeadSupportJoint:
            dimension = getHeadSupportRotationJoint()
            
        case .backSupportHeadSupportLink:
            dimension = getHeadSupportLink()
            
        case .backSupportHeadSupport:
            dimension = getHeadSupport()
        default:
            break
        }
    }
    
    let baseType: ObjectTypes
    var part: Part?
    
    init ( _ baseType: ObjectTypes) {
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
            (
            width: OccupantBodySupportDefaultDimension.general.width * 0.8,
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
            (
            width: 20.0,
            length: 20.0,
            height: 100.0)
        return
            dictionary[baseType] ?? general
    }
    
    
    func getHeadSupport() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general =
            (
            width: 150.0,
            length: 100.0,
            height: 100.0)
        return
            dictionary[baseType] ?? general
    }
    
    
    func getAdditionalObject() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general =
            (
            width: OccupantBodySupportDefaultDimension.general.width,
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

struct PreTiltOccupantBackSupportDefaultOrigin: PartOrigin {
    var origin: PositionAsIosAxes = ZeroValue.iosLocation
    var part: Part?
    mutating func reinitialise(_ part: Part?) {
        self.part = part
        
        switch part {
        case .backSupportRotationJoint:
            origin = getSitOnToBackSupportRotationJoint()
            
        case .backSupport:
            origin = getRotationJointToBackSupport()
            
        case .backSupportHeadSupportJoint:
            origin = getBackSupportToBackSupportHeadSupportJoint()
            
        case .backSupportHeadSupportLink:
            origin = getHeadLinkRotationJointToHeadLink()
            
        case .backSupportHeadSupport:
            origin = getHeadSupportLinkToHeadSupport()
        default:
            break
        }
    }
   
    let baseType: ObjectTypes
    let defaultBackSupportDimension:
        OccupantBackSupportDefaultDimension
  
    
    init ( _ baseType: ObjectTypes) {
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

    func getBackSupportToBackSupportHeadSupportJoint()
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
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}



struct OccupantBackSupportHeadLinkDefaultAngleChange {
    var dictionary: BaseObjectAngleDictionary =
    [:]
    
    static let general = Measurement(value: 0.0 , unit: UnitAngle.radians)
    
    let value: Measurement<UnitAngle>
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


