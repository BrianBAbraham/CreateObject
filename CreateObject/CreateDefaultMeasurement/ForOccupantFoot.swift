//
// ForOccupantFoot.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/05/2023.
//

import Foundation



struct RequestOccupantFootSupportDefaultDimensionDictionary {
    var dictionary: Part3DimensionDictionary = [:]
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions,
        _ modifiedPartDictionary: Part3DimensionDictionary
        ) {
            
        getDictionary()
        
        func getDictionary() {
                
            let allOccupantRelated =
                AllOccupantFootRelated(
                    baseType,
                    modifiedPartDictionary)
            dictionary =
                CreateDefaultDimensionDictionary(
                    allOccupantRelated.parts,
                    allOccupantRelated.dimensions,
                    twinSitOnOptions
                ).dictionary
        }
    }
}

struct AllOccupantFootRelated {
    let parts: [Part]
    let dimensions: [Dimension3d]
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedPartDictionary: Part3DimensionDictionary) {
        parts =
            [.footSupportHangerSitOnVerticalJoint,
             .footSupportHangerLink,
             .footSupportHorizontalJoint,
             .footSupport,
             .footSupportInOnePiece
        ]
        
        dimensions =
        [
            OccupantFootSupportHangerJointDefaultDimension(baseType).value,
            OccupantFootSupportHangerLinkDefaultDimension(baseType).value,
            OccupantFootSupportHorizontalJointDefaultDimension(baseType).value,
            OccupantFootSupportDefaultDimension(baseType,modifiedPartDictionary).value,
            OccupantFootSupportInOnePieceDefaultDimension(baseType,modifiedPartDictionary).value
        ]
    }
}



//MARK: DIMENSION

struct OccupantFootSupportHangerJointDefaultDimension {
    let dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general = Joint.dimension3d
    let value: Dimension3d
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
    }
}

struct OccupantFootSupportHangerLinkDefaultDimension {
    let dictionary: BaseObject3DimensionDictionary = [:]
    static let general = (length: 200.0, width: 20.0, height: 20.0)
    let value: Dimension3d
    init(
        _ baseType: BaseObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}

struct OccupantFootSupportHorizontalJointDefaultDimension {
    let dictionary: BaseObject3DimensionDictionary =
        [:]
    let general: Dimension3d
    let value: Dimension3d
    
    init(_ baseType: BaseObjectTypes) {
        
        general =
        (length: OccupantFootSupportDefaultDimension.general.length,
         width: Joint.dimension.width,
         height: Joint.dimension.width)
        
        value = dictionary[baseType] ?? general
    }
}

struct OccupantFootSupportInOnePieceDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [ :
        ]
    static let general =
        (length: 100.0,
         width: OccupantBodySupportDefaultDimension.general.width,
         height: 10.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedPartDictionary: Part3DimensionDictionary) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}

struct OccupantFootSupportDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [.showerTray: (length: 1200.0, width: 900.0, height: 0.0),
        ]
    static let general = (length: 100.0, width: 150.0, height: 10.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedPartDictionary: Part3DimensionDictionary) {
        
            value =
                dictionary[baseType] ??
                Self.general
    }
}



//MARK: ORIGIN


struct SitOnToHangerVerticalJointDefaultOrigin {
    static let jointBelowSeat = -50.0
    let dictionary: OriginDictionary =
        [:]
    let general =
        (x: OccupantBodySupportDefaultDimension.general.width/2 * 0.95,
         y: OccupantBodySupportDefaultDimension.general.length/2 * 0.95,
         z: jointBelowSeat)
    
    let value: PositionAsIosAxes
    
    init(_ baseType: BaseObjectTypes) {
      value = dictionary[baseType] ?? general
    }
}


struct HangerVerticalJointToHangerLinkDefaultOrigin {
    let dictionary: OriginDictionary =
        [:]
    let general: PositionAsIosAxes =
    (x: 0.0,
     y: OccupantFootSupportHangerLinkDefaultDimension.general.length/2,
     z: ObjectDefaultOrModifiedSpecification.sitOnHeight)
    
    let value: PositionAsIosAxes
    
    init(_ baseType: BaseObjectTypes) {
        
        value = dictionary[baseType] ?? general
    }
}

struct HangerLinkToFootSupportJointDefaultOrigin {
    static let footSupportHeightAboutFloor = 100.0
    let dictionary: OriginDictionary =
        [:]
    let general =
        (x: 0.0,
         y: OccupantFootSupportDefaultDimension.general.length/2,
         z: -(ObjectDefaultOrModifiedSpecification.sitOnHeight -
             Self.footSupportHeightAboutFloor +
             SitOnToHangerVerticalJointDefaultOrigin.jointBelowSeat) )
    
    let value: PositionAsIosAxes
    
    init(_ baseType: BaseObjectTypes) {
      value = dictionary[baseType] ?? general
    }
}

struct FootSupportJointToFootSupportInTwoPieceDefaultOrigin {
    static let footSupportHeightAboutFloor = 100.0
    let dictionary: OriginDictionary =
        [:]
    let general: PositionAsIosAxes
    let value: PositionAsIosAxes
    
    init(_ baseType: BaseObjectTypes) {
    general =
        (x: -OccupantFootSupportHorizontalJointDefaultDimension(baseType).value.width/2,
         y: (OccupantFootSupportHangerLinkDefaultDimension.general.length +  OccupantFootSupportDefaultDimension.general.length)/2,
         z: 0.0 )
        
    value = dictionary[baseType] ?? general
    }
}

struct FootSupportJointToFootSupportInOnePieceDefaultOrigin {
    static let footSupportHeightAboutFloor = 100.0
    let dictionary: OriginDictionary =
        [:]
    let general: PositionAsIosAxes
    let value: PositionAsIosAxes
    
    init(_ baseType: BaseObjectTypes) {
    general =
        (x: -OccupantBodySupportDefaultDimension(baseType).value.width/2,
         y: (OccupantFootSupportHangerLinkDefaultDimension.general.length +  OccupantFootSupportDefaultDimension.general.length)/2,
         z: 0.0 )
        
    value = dictionary[baseType] ?? general
    }
}

//struct FootSupportMaximumDictionary {
//    let dictionary: BaseObjectDimensionDictionary =
//        [.showerTray: (length: 1800.0, width: 1400.0),
//        ]
//    let general = (length: 100.0, width: 150.0)
//
//    let value: Dimension
//
//    init(_ baseType: BaseObjectTypes) {
//      value = dictionary[baseType] ?? general
//    }
//}
