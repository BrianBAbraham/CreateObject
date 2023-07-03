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
struct PreTiltOccupantBackSupportAdditionalObjectDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (width: OccupantBodySupportDefaultDimension.general.width,
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
         width: OccupantBodySupportDefaultDimension.general.width,
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
         width: OccupantBodySupportDefaultDimension.general.width,
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
// origins of rotation position are described in the parent view
struct OccupantBackSupportDefaultParentToRotationOrigin {
    var dictionary: OriginDictionary =
        [:]

    let value: PositionAsIosAxes

    init(_ baseType: BaseObjectTypes) {
        
        let general =
            (x: 0.0,
             y: -OccupantBodySupportDefaultDimension(baseType).value.length/2,
             z: 0.0)
        
      value = dictionary[baseType] ?? general
    }
}


struct OccupantBackSupportHeadLinkDefaultParentToRotationOrigin {
    var dictionary: OriginDictionary =
        [:]

    let value: PositionAsIosAxes

    init(_ baseType: BaseObjectTypes) {
        
        let general =
            (x: 0.0,
             y: 0.0,
             z: PreTiltOccupantBackSupportDefaultDimension(baseType).value.length/2)
        
      value = dictionary[baseType] ?? general
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
