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
        _ sitOnId: Part,
        _ partId: Part) {
            
        getDictionary(sitOnId, .id0)
            

        
            func getDictionary(
                _ supportId: Part,
                _ sitOnId: Part) {
               
             let allOccupantBackRelated =
                    AllOccupantBackRelated(
                        baseType,  supportId, sitOnId)
                    

                dictionary =
                    CreateDefaultDimensionDictionary(
                        allOccupantBackRelated.partsThatMakeNames,
                        allOccupantBackRelated.dimensions
                    ).dictionary
            }
        }
}
// use touple? (part: Part, dimension: Dimension3d)
// avoids errors of assignment
// pass touple wiithout nameEnd and allow create to add 

struct AllOccupantBackRelated {
    var partsThatMakeNames: [[Part]] = []
    var dimensions: [Dimension3d] = []
    init(_ baseType: BaseObjectTypes,
         _ supportId: Part,
         _ sitOnId: Part) {
    
        let nameEnd: [Part] = [supportId, .stringLink, .sitOn, sitOnId]

        let parts: [Part] =
            [.backSupportAdditionalObject,
            .backSupportHeadSupport,
            .backSupportHeadSupportLink,
            .backSupportHeadSupportLinkJoint,
            .backSupportAssistantHandle,
            .backSupportAssistantHandleInOnePiece,
            .backSupportAssistantJoystick,
            .backSupport,
            .backSupportJoint]
        
        for part in parts {
            partsThatMakeNames.append([part] + nameEnd)
        }

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
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
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
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
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
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
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
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
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
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
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
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
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
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
    }
}

struct OccupantBackSupportJointDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
    Joint.dimension3d
    let value: Dimension3d
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
    }
}
