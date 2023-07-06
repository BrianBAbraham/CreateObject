//
// ForOccupantFoot.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/05/2023.
//

import Foundation





struct AllOccupantFootRelated {
    let parts: [Part]
    let dimensions: [Dimension3d]
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedPartDictionary: Part3DimensionDictionary) {
        parts =
            [.footSupportHangerSitOnVerticalJoint,
             //.footSupportHangerLink,
             .footSupportHorizontalJoint,
             .footSupport,
             .footSupportInOnePiece
        ]
        
        let dimensionList =
        [
        OccupantFootSupportHangerJointDefaultDimension(baseType).value,
        OccupantFootSupportHorizontalJointDefaultDimension(baseType).value,
        OccupantFootSupportDefaultDimension(baseType).value,
        OccupantFootSupportInOnePieceDefaultDimension(baseType,modifiedPartDictionary).value
        ]
            
        var rotatedDimensionList: [Dimension3d] = []
        let angle =
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
    static let general = (width: 20.0, length: 200.0, height: 20.0)
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
        (         width: Joint.dimension.width,
            length: OccupantFootSupportDefaultDimension.general.length,

         height: Joint.dimension.width)
        
        value = dictionary[baseType] ?? general
    }
}

struct OccupantFootSupportInOnePieceDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [ :
        ]
    static let general =
        (
         width: PreTiltOccupantBodySupportDefaultDimension.general.width,
         length: 100.0,
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
    [.showerTray: (width: 900.0, length: 1200.0, height: 0.0),
        ]
    static let general = (width: 150.0, length: 100.0, height: 10.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes) {
        
            value =
                dictionary[baseType] ??
                Self.general
    }
}



//MARK: ORIGIN
struct PreTiltSitOnToHangerVerticalJointDefaultOrigin {
    static let jointBelowSeat = -50.0
    let dictionary: OriginDictionary =
        [:]
    let general =
        (x: PreTiltOccupantBodySupportDefaultDimension.general.width/2 * 0.95,
         y: PreTiltOccupantBodySupportDefaultDimension.general.length/2 * 0.95,
         z: jointBelowSeat)
    
    let value: PositionAsIosAxes
    
    init(_ baseType: BaseObjectTypes) {
      value = dictionary[baseType] ?? general
    }
}


struct PreTiltHangerVerticalJointToFootSupportJointDefaultOrigin {
    static let footSupportHeightAboveFloor = 100.0
    let dictionary: OriginDictionary =
        [:]
    let general =
        (x: 0.0,
         y: OccupantFootSupportHangerLinkDefaultDimension.general.length,
         z: -(ObjectDefaultOrEditedDictionaries.sitOnHeight -
             Self.footSupportHeightAboveFloor +
             PreTiltSitOnToHangerVerticalJointDefaultOrigin.jointBelowSeat) )

    let value: PositionAsIosAxes

    init(_ baseType: BaseObjectTypes) {
      value = dictionary[baseType] ?? general
    }
}


struct 0{
    
    let dictionary: OriginDictionary =
        [:]
    let general: PositionAsIosAxes
    let value: PositionAsIosAxes
    
    init(_ baseType: BaseObjectTypes) {
    general =
        (x: -(OccupantFootSupportHorizontalJointDefaultDimension(baseType).value.width +
         OccupantFootSupportDefaultDimension(baseType).value.width)/2,
         y: 0.0,
         z: 0.0 )
        
    value = dictionary[baseType] ?? general
    }
}

struct PreTiltFootSupportJointToFootSupportInOnePieceDefaultOrigin {

    let dictionary: OriginDictionary =
        [:]
    let general: PositionAsIosAxes
    let value: PositionAsIosAxes
    
    init(_ baseType: BaseObjectTypes) {
    general =
        (x: -PreTiltOccupantBodySupportDefaultDimension(baseType).value.width/2,
         y: 0.0,
         z: 0.0 )
        
    value = dictionary[baseType] ?? general
    }
}



struct OccupantFootSupportDefaultAngleChange {
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
