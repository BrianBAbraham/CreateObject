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
            OccupantFootSupportHangerLinkDefaultDimension(baseType, modifiedPartDictionary).value,
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
    let dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general = (length: 200.0, width: 20.0, height: 20.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes,
        _ modifiedPartDictionary: Part3DimensionDictionary ) {
        
            value =
                //modifiedDictionary[baseType] ??
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
                //modifiedDictionary[baseType] ??
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
                //modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                Self.general
    }
}







///parent orgin to child orrigin
///base is parent
///sitOn is paren sitt
///


//MARK: POSITION

//struct RequestOccupantFootSupportDefaultOriginDictionary {
//    var dictionary: PositionDictionary = [:]
//
//    init(
//        _ baseType: BaseObjectTypes,
//        _ twinSitOnOptions: TwinSitOnOptions
//        ) {
//
//        getDictionary()
//
//        func getDictionary() {
//
//            let allOccupantRelated = AllOccupantFootRelated(baseType)
//            dictionary =
//                CreateDefaultOriginDictionary(
//                    allOccupantRelated.parts,
//                    allOccupantRelated.dimensions,
//                    twinSitOnOptions
//                ).dictionary
//        }
//    }
//}



//struct SitOnRightFrontCornerToFootSupportHangerVerticalJointPosition {
//    let dictionary: BaseObjectPositionDictionary = [:]
//    let general: PositionAsIosAxes
//    let value: PositionAsIosAxes
//    
//    init(_ baseType: BaseObjectTypes) {
//        general =
//        (x: 40.0, y: -40.0, z: 0.0)
//        value = dictionary[baseType] ?? general
//    }
//}

struct HangerVerticalJointToFootSupportJointPosition {
    let dictionary: OriginDictionary =
        [:]
    let general =
        (x: 0.0,
         y: OccupantFootSupportHangerLinkDefaultDimension.general.length,
         z: 0.0)
    
    let value: PositionAsIosAxes
    
    init(_ baseType: BaseObjectTypes) {
      value = dictionary[baseType] ?? general
    }
}


struct FootSupportJointToFootSupportPosition {
    let dictionary: OriginDictionary =
        [:]
    let general: PositionAsIosAxes = (x: 0.0, y: OccupantFootSupportDefaultDimension.general.length, z: 0.0)
    
    let value: PositionAsIosAxes
    
    init(_ baseType: BaseObjectTypes) {
        
        value = dictionary[baseType] ?? general
    }
}






struct FootSupportMaximumDictionary {
    let dictionary: BaseObjectDimensionDictionary =
        [.showerTray: (length: 1800.0, width: 1400.0),
        ]
    let general = (length: 100.0, width: 150.0)
    
    let value: Dimension
    
    init(_ baseType: BaseObjectTypes) {
      value = dictionary[baseType] ?? general
    }
}
