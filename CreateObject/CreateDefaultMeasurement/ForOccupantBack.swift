//
//  ForOccupantBack.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation


struct RequestOccupantBackSupportDefaultDimensionDictionary {
    var dictionary: Part3DimensionDictionary = [:]
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions
    ) {
        getDictionary()

        func getDictionary() {
           
         let allOccupantBackRelated =
                AllOccupantBackRelated(
                    baseType
                )
                
            dictionary =
                CreateDefaultDimensionDictionary(
                    allOccupantBackRelated.parts,
                    allOccupantBackRelated.dimensions,
                    twinSitOnOptions
                ).dictionary
        }
    }
}
// use touple? (part: Part, dimension: Dimension3d)
// avoids errors of assignment
// pass touple wiithout nameEnd and allow create to add 

struct AllOccupantBackRelated {
    var parts: [Part] = []
    var dimensions: [Dimension3d] = []
    init(_ baseType: BaseObjectTypes
    ) {
         parts =
            [.backSupportAdditionalObject,
            .backSupportHeadSupport,
            .backSupportHeadSupportLink,
            .backSupportHeadSupportLinkJoint,
            .backSupportAssistantHandle,
            .backSupportAssistantHandleInOnePiece,
            .backSupportAssistantJoystick,
            .backSupport,
            .backSupportJoint]
    
        let dimensionsList =
            [
                OccupantBackSupportAdditionalObjectDefaultDimension(baseType).value,
                OccupantHeadSupportDefaultDimension(baseType).value,
                OccupantHeadSupportLinkDefaultDimension(baseType).value,
                OccupantHeadSupportJointDefaultDimension(baseType).value,
                OccupantBackSupportAssistantHandlesDefaultDimension(baseType).value,
                OccupantBackSupportAssistantHandlesInOnePieceDefaultDimension(baseType).value,
                OccupantBackSupportJoystickDefaultDimension(baseType).value,
                OccupantBackSupportDefaultDimension(baseType).value,
                OccupantBackSupportJointDefaultDimension(baseType).value
                
                ]
        dimensions.append(contentsOf: dimensionsList)
    }
}

//MARK: DIMENSION
struct OccupantBackSupportAdditionalObjectDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (length: 100.0,
         width: OccupantBodySupportDefaultDimension.general.width,
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

struct OccupantHeadSupportDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (length: 100.0,
         width: 100.0,
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

struct OccupantHeadSupportLinkDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (length: 20.0,
         width: 20.0,
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

struct OccupantHeadSupportJointDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
    Joint.dimension3d
    let value: Dimension3d
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
    }
}

struct OccupantBackSupportJoystickDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (length: 100.0,
         width: 100.0,
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

struct OccupantBackSupportAssistantHandlesDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (length: 100.0,
         width: 30.0,
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

struct OccupantBackSupportAssistantHandlesInOnePieceDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (length: 100.0,
         width: OccupantBodySupportDefaultDimension.general.width,
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

struct OccupantBackSupportDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
        (length: 10.0,
         width: OccupantBodySupportDefaultDimension.general.width,
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

struct OccupantBackSupportJointDefaultDimension {
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


//MARK: ANGLE

struct OccupantBackSupportDefaultAngle {
    var dictionary: BaseObjectAngleDictionary =
    [:]
    
    static let general = Measurement(value: 0.0, unit: UnitAngle.radians)
    
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
