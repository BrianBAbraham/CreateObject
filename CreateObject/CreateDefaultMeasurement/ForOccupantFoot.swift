//
// ForOccupantFoot.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/05/2023.
//

import Foundation





/// links are:
/// 1footSupportHangerSitOnVerticalJoint
/// 2 footSupportHorizontalJoint
/// 3 footSupport OR footSupportInOnePiece
/// footSupportHangerLink is derived from 1 and 2 when the final dictionary is available
/// so you edit positions of 1 or 3 to change hangerLink
/// and hangerLink only exists to create default position and not future editiing
struct AllOccupantFootRelated: PartDimension {
    
    let parts: [Part]
    var defaultDimensions: [Dimension3d] = []
   
    init(
        _ baseType: BaseObjectTypes,
        _ nodes: [Part] ) {
        self.parts = nodes
        let defaults =
            OccupantFootSupportDefaultDimension(baseType)
        
        for part in parts {
            defaultDimensions.append(getDefaultDimensions(part))
        }
       
    
        func getDefaultDimensions (
            _ part: Part)
            -> Dimension3d {
                var dimension: Dimension3d = ZeroValue.dimension3d
            switch part {
                case .footSupportHangerJoint:
                    dimension =
                    defaults.getHangerJoint()
                case .footSupportJoint:
                    dimension =
                    defaults.getFootJoint()
                case .footSupport:
                    dimension =
                    defaults.getFootSupportInTwoPieces()
                case .footSupportInOnePiece:
                    dimension =
                    defaults.getFootSupportInOnePiece()
                default: break
            }
            return dimension
        }

    }
}


//MARK: DIMENSION FOOT
struct OccupantFootSupportDefaultDimension {
    let baseType: BaseObjectTypes
        
    init ( _ baseType: BaseObjectTypes) {
        self.baseType = baseType
    }
    
    func getHangerJoint() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = Joint.dimension3d
        return
            dictionary[baseType] ?? general
    }
    
    func getHangerLink() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = (width: 20.0, length: 200.0, height: 20.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getFootJoint () -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = Joint.dimension3d
        return
            dictionary[baseType] ?? general
    }
    
    func getFootSupportInTwoPieces() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = (width: 150.0, length: 100.0, height: 10.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getFootSupportInOnePiece() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general =       (
            width: OccupantBodySupportDefaultDimension.general.width,
            length: 100.0,
            height: 10.0)
        return
            dictionary[baseType] ?? general
    }
    
}



//MARK: ORIGIN FOOT
struct PreTiltOccupantFootSupportDefaultOrigin {
    let baseType: BaseObjectTypes
    let jointBelowSeat = -50.0
    let footSupportHeightAboveFloor = 100.0
    let defaultFootSupportDimension:
        OccupantFootSupportDefaultDimension
    let defaultBodySupportDimension:
        OccupantBodySupportDefaultDimension
    
    
    init ( _ baseType: BaseObjectTypes) {
        self.baseType = baseType
        defaultFootSupportDimension =
            OccupantFootSupportDefaultDimension(baseType)
        defaultBodySupportDimension =
            OccupantBodySupportDefaultDimension(baseType)
    }
    
    func getSitOnToHangerJoint()
        -> PositionAsIosAxes {
            let dictionary: OriginDictionary =
                [:]
            let general =
            (x: defaultBodySupportDimension.value.width/2 * 0.95,
             y: defaultBodySupportDimension.value.length/2 * 0.95,
             z: jointBelowSeat)
        return
            dictionary[baseType] ?? general
    }
    
    func getHangerJointToFootJoint()
        -> PositionAsIosAxes {
            let dictionary: OriginDictionary =
                [:]
            let general =
            (x: 0.0,
                 y: defaultFootSupportDimension.getHangerLink().length,
                 z:  -(DimensionOriginCornerDictionaries.sitOnHeight -
                       footSupportHeightAboveFloor +
                      jointBelowSeat)
            )
        return
            dictionary[baseType] ?? general
    }
    
    func getJointToTwoPieceFoot()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary =
            [:]
        let general =
            (x:   -(defaultFootSupportDimension.getFootJoint().width +
                   defaultFootSupportDimension.getFootSupportInTwoPieces().width)/2,
             y: 0.0,
             z: jointBelowSeat)
    return
        dictionary[baseType] ?? general
    }
    
    func getJointToOnePieceFoot()
    -> PositionAsIosAxes {
        let dictionary: OriginDictionary =
            [:]
        let general =
            (x: 0.0,
             y: 0.0,
             z: jointBelowSeat)
    return
        dictionary[baseType] ?? general
    }
}


//MARK: FOOT ANGLE
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
