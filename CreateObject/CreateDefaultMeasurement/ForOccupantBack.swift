//
//  ForOccupantBack.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation




struct AllOccupantBackRelated {
    var parts: [Part] = []
    var dimensions: [Dimension3d] = []
    init(_ baseType: BaseObjectTypes
    ) {
         parts =
            [.backSupportAdditionalPart,
            .backSupportHeadSupport,
            .backSupportHeadSupportLink,
            .backSupportHeadLinkRotationJoint,
            .backSupportAssistantHandle,
            .backSupportAssistantHandleInOnePiece,
            .backSupportAssistantJoystick,
            .backSupport,
            .backSupporRotationJoint]
    
        let dimensionList =
            [
            PreTiltOccupantBackSupportAdditionalObjectDefaultDimension(baseType).value,
            PreTiltOccupantHeadSupportDefaultDimension(baseType).value,
            PreTiltOccupantHeadSupportLinkDefaultDimension(baseType).value,
            PreTiltOccupantHeadSupportJointDefaultDimension(baseType).value,
            PreTiltOccupantBackSupportAssistantHandlesDefaultDimension(baseType).value,
            PreTiltOccupantBackSupportAssistantHandlesInOnePieceDefaultDimension(baseType).value,
            PreTiltOccupantBackSupportJoystickDefaultDimension(baseType).value,
            PreTiltOccupantBackSupportDefaultDimension(baseType).value,
            PreTiltOccupantBackSupportAngleJointDefaultDimension(baseType).value
            ]
        
        var rotatedDimensionList: [Dimension3d] = []
        let angle =
            OccupantBackSupportDefaultAngleChange(baseType).value +
            OccupantBodySupportDefaultAngleChange(baseType).value
        
        for dimension in dimensionList {
            rotatedDimensionList.append(
                ObjectCorners(
                    dimensionIn: dimension,
                    angleChangeIn:  angle
                ).rotatedDimension
            )
        }
        dimensions = rotatedDimensionList
    }
}

//MARK: DIMENSION

struct PreTiltOccupantBackSupportDefaultDimension2 {
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
            (width: PreTiltOccupantBodySupportDefaultDimension.general.width,
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
            (width: PreTiltOccupantBodySupportDefaultDimension.general.width,
            length: 100.0,
            height: 100.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getAdditionalObject() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general =
            (width: PreTiltOccupantBodySupportDefaultDimension.general.width,
            length: 100.0,
            height: 100.0)
        return
            dictionary[baseType] ?? general
    }

}


struct PreTiltOccupantBackSupportAdditionalObjectDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (width: PreTiltOccupantBodySupportDefaultDimension.general.width,
        length: 100.0,
        height: 100.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedDictionary: BaseObject3DimensionDictionary = [:] ) {
        
            value =
                modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                Self.general
    }
}

struct PreTiltOccupantHeadSupportDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (width: 100.0,
        length: 100.0,
        height: 100.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedDictionary: BaseObject3DimensionDictionary = [:] ) {
        
            value =
                modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                Self.general
    }
}

struct PreTiltOccupantHeadSupportLinkDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (width: 20.0,
         length: 20.0,
         height: 100.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedDictionary: BaseObject3DimensionDictionary = [:] ) {
        
            value =
                modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                Self.general
    }
}

struct PreTiltOccupantHeadSupportJointDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
    Joint.dimension3d
    let value: Dimension3d
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
    }
}

struct PreTiltOccupantBackSupportJoystickDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (width: 100.0,
         length: 100.0,
         height: 100.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedDictionary: BaseObject3DimensionDictionary = [:] ) {
        
            value =
                modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                Self.general
    }
}

struct PreTiltOccupantBackSupportAssistantHandlesDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (    width: 30.0,
             length: 100.0,
         height: 30.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedDictionary: BaseObject3DimensionDictionary = [:] ) {
        
            value =
                modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                Self.general
    }
}

struct PreTiltOccupantBackSupportAssistantHandlesInOnePieceDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (
         width: PreTiltOccupantBodySupportDefaultDimension.general.width,
         length: 100.0,
         height: 30.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedDictionary: BaseObject3DimensionDictionary = [:] ) {
        
            value =
                modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                Self.general
    }
}

struct PreTiltOccupantBackSupportDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (
         width: PreTiltOccupantBodySupportDefaultDimension.general.width,
         length: 10.0,
         height: 500.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedDictionary: BaseObject3DimensionDictionary = [:] ) {
        
            value =
                modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                Self.general
    }
}

struct PreTiltOccupantBackSupportAngleJointDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
    Joint.dimension3d
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedDictionary: BaseObject3DimensionDictionary = [:] ) {
        
            value =
                modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                Self.general
    }
}

//MARK: -ORIGIN
// tilt as in tilted/rotated/angled
// origins are described from the parent origin
// and the object-orientation not the parent orientation

struct PreTiltOccupantBackSupportDefaultOrigin {
    let baseType: BaseObjectTypes
  
    
    init ( _ baseType: BaseObjectTypes) {
        self.baseType = baseType
        }
    
  func getSitOnToBackSupportRotationJoint()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: 0.0,
             y: -PreTiltOccupantBodySupportDefaultDimension(baseType).value.length/2,
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
             z: PreTiltOccupantBackSupportDefaultDimension(baseType).value.height/2)
        return
            dictionary[baseType] ?? general
    }
    
    func getBackSupportToHeadLinkRotationJoint()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
        (x: 0.0,
         y: 0.0,
         z: PreTiltOccupantBackSupportDefaultDimension(baseType).value.height/2)
        return
            dictionary[baseType] ?? general
    }
    
    func getHeadLinkRotationJointToHeadSupport()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: 0.0,
             y: 0.0,
             z: PreTiltOccupantHeadSupportLinkDefaultDimension(baseType).value.height +
                PreTiltOccupantHeadSupportDefaultDimension(baseType).value.height/2  )
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

//struct OccupantHeadSupportLinkDefaultAngle {
//    var dictionary: BaseObjectAngleDictionary =
//    [:]
//
//    static let general = Measurement(value: 0.0, unit: UnitAngle.radians)
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
