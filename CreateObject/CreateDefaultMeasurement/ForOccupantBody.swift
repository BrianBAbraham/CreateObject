//
//  ForrOccupantBody.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation





struct OccupantBodySupportDefaultDimension: PartDimension {
    var dimension: Dimension3d = ZeroValue.dimension3d
    
    mutating func reinitialise(_ part: Part?) {
        dimension = value
    }
    
    let dictionary: BaseObject3DimensionDictionary =
    [.allCasterStretcher: (width: 600.0, length: 1200.0, height: 10.0),
     .allCasterBed: (width: 900.0, length: 2000.0, height: 150.0),
     .allCasterHoist: (width: 0.0, length: 0.0, height: 0.0)
        ]
    static let general = (width: 400.0, length: 400.0, height: 10.0)
    let value: Dimension3d
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


struct OccupantBodySupportAngleJointDefaultDimension: PartDimension {
    var dimension: Dimension3d = ZeroValue.dimension3d
    
    mutating func reinitialise(_ part: Part?) {
        dimension = value
    }
    
    let dictionary: BaseObject3DimensionDictionary =
    [:
        ]
    static let general = Joint.dimension3d
//        (
//         width: OccupantBodySupportDefaultDimension.general.width * 1.5,
//         length: Joint.dimension.length,
//         height: Joint.dimension.length)
    let value: Dimension3d
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


struct PreTiltBodySupportDefaultOriginHeight {
    let objectType: ObjectTypes
    let dictionary: [ObjectTypes: Double] =
    [
        .allCasterStretcher: 900.0,
        .allCasterBed: 800.0]
    let general = 500.0
    let height: Double
    
    init (
        _ objectType: ObjectTypes//,
        
    ) {
        self.objectType = objectType
        
        height = dictionary[objectType] ?? general
    }
}



//struct PreTiltSitOnDefaultOrigin: PartOrigin {
//    var origin: PositionAsIosAxes = ZeroValue.iosLocation
//
//    mutating func reinitialise(_ part: Part?) {
//
//    }
//
//    let baseType: ObjectTypes
//
//
//
//    init (
//            _ objectType: ObjectTypes//,
//
//    ) {
//        self.baseType = objectType
//
//        origin = getBodySupportToBodySupportRotationJoint()
//
//    func getBodySupportToBodySupportRotationJoint()
//      -> PositionAsIosAxes {
//          let dictionary: OriginDictionary = [:]
//          let general =
//              (x: 0.0,
//               y: 0.0,
//               z: 0.0)
//
//          return
//              dictionary[objectType] ?? general
//                  }
//        }
//}

// tilt as in tilted/rotated/angled
// origins are described from the parent origin
// orientations from the object-orientation not the parent orientation

struct PreTiltSitOnBackFootTiltJointDefaultOrigin: PartOrigin {
    var origin: PositionAsIosAxes = ZeroValue.iosLocation
    
    mutating func reinitialise(_ part: Part?) {
        origin = self.getBodySupportToBodySupportRotationJoint()
        
    }
    
    let baseType: ObjectTypes
    //let sitOnLocation: PositionAsIosAxes
    //let value: PositionAsIosAxes
  
    
    init (
            _ baseType: ObjectTypes) {
        self.baseType = baseType
                        
        origin = getBodySupportToBodySupportRotationJoint()
                

        }
    func getBodySupportToBodySupportRotationJoint()
      -> PositionAsIosAxes {
          let dictionary: OriginDictionary = [:]
          let general =
              (x: 0.0,
               y: 0.0,
               z: -100.0)
             
          return
              dictionary[baseType] ?? general
                  }
}



//only angle measurement is returned
struct OccupantBodySupportDefaultAngleChange {
    let dictionary: BaseObjectAngleDictionary =
    [.allCasterTiltInSpaceShowerChair: OccupantBodySupportDefaultAngleMinMax(.allCasterTiltInSpaceShowerChair).value.max]//Measurement(value: 90.0, unit: UnitAngle.degrees)]
    
    static let general = Measurement(value: 0.0, unit: UnitAngle.degrees)
    
    let value: Measurement<UnitAngle>
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


struct OccupantBodySupportDefaultAngleMinMax {
    let dictionary: BaseObjectAngelMinMaxDictionary =
    [.allCasterTiltInSpaceShowerChair: (min: Measurement(value: 0.0, unit: UnitAngle.degrees), max: Measurement(value: 45.0, unit: UnitAngle.degrees) ) ]
    
    static let general = (min: Measurement(value: 0.0, unit: UnitAngle.degrees), max: Measurement(value: 0.0, unit: UnitAngle.degrees) )
    
    let value: AngleMinMax
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


///origin for one sitOn, and frontAndRear and sideBySide
///are provided by sitOnOrigins
///dicttionary dimension and origin are psssed to make use
///of edited values if extant
struct PreTiltSitOnOrigin {
    let objectType: ObjectTypes
    let stability: Stability
    var origins: [PositionAsIosAxes] = []
    var objectGroups: BaseObjectGroups {
        BaseObjectGroups()}
    var wheelDefaultDimension: WheelDefaultDimension
    let bilateralIds: [Part] = [.id0, .id1]
    let bothSitOnId: [Part] = [.id0, .id1]
    let dimensionDicIn: Part3DimensionDictionary
    let preTiltObjectToPartOriginDicIn: PositionDictionary //= [:]
    var sitOnOriginsIn: TwinSitOnOrigins =  ZeroValue.sitOnOrigins
    var sitOnDimensions: [Dimension3d] = []
    var occupantSideSupportsDimensions: [[Dimension3d]] = []
    var occupantFootSupportHangerLinksMaxLengths: [Double] = []
    var sitOnOrigins: TwinSitOnOrigins = ZeroValue.sitOnOrigins
    var baseObjectGroups: BaseObjectGroups {
        BaseObjectGroups()
    }
    
    
    var wheelBaseJointOrigins: TwinSitOnOrigins = ZeroValue.sitOnOrigins
    let onlyOne = 0
    let rear = 0
    let front = 1
    let left = 0
    let right = 1
    let bodySupportHeight: Double

  
    /// 1) frontAndRear && sideBySide == false: one origin .id0
    /// 2) frontAndRear == true && sideBySide == false: two origin .id0 (rear), .id1 (front)
    /// 3) frontAndRear == false && sideBySide == true: two origin .id0 (left), .id1 (right)
    /// locations as per viewing screen
    /// [[PositionAsIos]]
    
    init(
        _ object: ObjectTypes,
        _ dimensionIn: Part3DimensionDictionary = [:],
        _ preTiltObjectToPartOriginDicIn: PositionDictionary = [:]) {
            
        self.objectType = object
        self.preTiltObjectToPartOriginDicIn = preTiltObjectToPartOriginDicIn
        stability = Stability(objectType)
        wheelDefaultDimension = WheelDefaultDimension(objectType)
        dimensionDicIn = dimensionIn
        bodySupportHeight = PreTiltBodySupportDefaultOriginHeight(objectType).height
        for id in bothSitOnId {
            sitOnDimensions.append(
                getEditedOrDefaultBodySupportDimension(id))
            occupantFootSupportHangerLinksMaxLengths.append(
                getEditedOrDefaultMaximumHangerLinkLength(id))
            occupantSideSupportsDimensions.append(
                getEditedOrDefaultSideSupportDimensions(id)
            )
        }
        
        sitOnOriginsIn = getEditedSitOnOrigins()
            
        if baseObjectGroups.rearPrimaryOrigin.contains(objectType) {
            sitOnOrigins = occupantBodySupportOriginForRear()
        }
        
        if baseObjectGroups.midPrimaryOrigin.contains(objectType) {
            sitOnOrigins = occupantBodySupportOriginForMid()
        }
        
        if baseObjectGroups.frontPrimaryOrigin.contains(objectType) {
            sitOnOrigins = occupantBodySupportOriginForFront()
        }
    
    }
    
    //there may be none, or one or two edited sitOn origins
    //if two these may be frontAndRear or sideBySide
    func getEditedSitOnOrigins()
        -> TwinSitOnOrigins {
        var sitOnOrigins: [PositionAsIosAxes?] = []
        var sitOnOriginsIn = ZeroValue.sitOnOrigins
        for id in bothSitOnId {
            sitOnOrigins.append(
                preTiltObjectToPartOriginDicIn [CreateNameFromParts([.sitOn, id, .stringLink, .sitOn, id]).name])
        }
        // one or more nill
        if sitOnOrigins.contains(where: { $0 == nil }) {
            ///two nil
            if sitOnOrigins.allSatisfy({ $0 == nil }) {
            // do nothing
            } else { //one nil
                if let nonNilElement = sitOnOrigins.first(where: { $0 != nil } ) {
                    sitOnOriginsIn =
                        (onlyOne: [nonNilElement!],
                         frontAndRear: [],
                         sideBySide: [])
                }
            }
        } else {
            // No elements are nil so check for frontAndRear and sideBySide
            let first = sitOnOrigins[0]!
            let second = sitOnOrigins[1]!
            
            // if x origins difference is greatest must be side by side
            if abs(first.x - second.x) > abs(first.y - second.y) {
                sitOnOriginsIn =
                    (onlyOne: [],
                     frontAndRear: [],
                     sideBySide: [first, second])
            } else {
                sitOnOriginsIn =
                    (onlyOne: [],
                     frontAndRear: [first, second],
                     sideBySide: [])
            }
        }
            return sitOnOriginsIn
    }
    
    
    func getEditedOrDefaultBodySupportDimension(_ sitOnId: Part)
        -> Dimension3d {
        let name =
            CreateNameFromParts([.object, .id0, .stringLink, .sitOn, sitOnId, .stringLink, .sitOn, sitOnId]).name
        return
            dimensionDicIn[name] ?? OccupantBodySupportDefaultDimension(objectType).value
    }
    
    
    func getEditedOrDefaultSideSupportDimensions(_ sitOnId: Part)
        -> [Dimension3d] {
            var sideSupportDimension: [Dimension3d] = []
            for sideId in bilateralIds {
                let name =
                    CreateNameFromParts([.object, .id0, .stringLink, .sideSupport, sideId, .stringLink, .sitOn, sitOnId]).name
                let dimension = dimensionDicIn[name] ??
                    OccupantSideSupportDefaultDimension(objectType).value
                //sideSupportDefaultDimension
                sideSupportDimension.append(dimension)
            }
        return
            sideSupportDimension
    }
    
    
    func getEditedOrDefaultMaximumHangerLinkLength(
            _ sitOnId: Part)
    -> Double{
        var lengths:[Double] = []
        let hangerLinkLength = OccupantFootSupportDefaultDimension(objectType).getHangerLink().length
        for id in bilateralIds {
            let name =
                CreateNameFromParts([.footSupportHangerLink, id, .stringLink, .sitOn, sitOnId]).name
            lengths.append(
                dimensionDicIn[name]?.length ?? hangerLinkLength)
        }
        return
            lengths.max() ?? hangerLinkLength
    }
        
    
    func occupantBodySupportOriginForRear()
        -> TwinSitOnOrigins {
            
        let sitOnOriginForOnlyOne =
            sitOnOrigins.onlyOne.count == 0 ?
                [(
                x: 0.0,
                y: sitOnDimensions[onlyOne].length/2,
                z: bodySupportHeight )]: sitOnOrigins.onlyOne
            
        let rearWheelBaseJointOrigin =
            (x: sitOnDimensions[onlyOne].length/2 +
                occupantSideSupportsDimensions[left][right].width +
                 stability.atRightRear,
             y: 0.0,
             z: 0.0 )
        let  sitOnOriginForSideBySide: [PositionAsIosAxes] =
            sitOnOrigins.sideBySide.count == 0 ?
                [(
                x: -sitOnDimensions[left].width/2 - occupantSideSupportsDimensions[left][right].width,
                y: sitOnDimensions[left].length/2,
                z: bodySupportHeight), (
                x: sitOnDimensions[right].width/2 +
                     occupantSideSupportsDimensions[right][left].width,
                y: sitOnDimensions[right].length/2,
                z: bodySupportHeight)        ]: sitOnOrigins.sideBySide
        let lengthBetweenSitOn =
                sitOnDimensions[rear].length +
                occupantFootSupportHangerLinksMaxLengths[rear] +
                sitOnDimensions[front].length/2
        let sitOnOriginForFrontAndRear: [PositionAsIosAxes] =
            sitOnOrigins.frontAndRear.count == 0 ?
            [
            (x: 0.0,
             y: sitOnDimensions[rear].length/2,
             z: bodySupportHeight),
            (x:0.0,
             y: lengthBetweenSitOn,
             z: bodySupportHeight)      ] : sitOnOrigins.frontAndRear
   
        return
            (onlyOne: sitOnOriginForOnlyOne,
             frontAndRear: sitOnOriginForFrontAndRear,
             sideBySide: sitOnOriginForSideBySide)
    }

    
    func occupantBodySupportOriginForMid()
        -> TwinSitOnOrigins{
        let occupantBodySupportOriginForOnlyOne =
            sitOnOrigins.onlyOne.count == 0 ?
            [(
            x: 0.0,
            y: 0.0,
            z: bodySupportHeight )] : sitOnOrigins.onlyOne
        let  occupantBodySupportOriginForSideBySide: [PositionAsIosAxes] =
            sitOnOrigins.sideBySide.count == 0 ?
            [
            (x: -sitOnDimensions[left].width/2 - occupantSideSupportsDimensions[left][right].width,
             y: 0,
             z:bodySupportHeight),
            (x: sitOnDimensions[right].width/2 +
             occupantSideSupportsDimensions[right][left].width,
             y: 0.0,
             z:bodySupportHeight)        ] : sitOnOrigins.sideBySide
        let lengthToFrontBodySupport =
                sitOnDimensions[rear].length/2 +
                occupantFootSupportHangerLinksMaxLengths[rear] +
                sitOnDimensions[front].length/2
        
        let occupantBodySupportOriginForFrontAndRear: [PositionAsIosAxes] =
            sitOnOrigins.frontAndRear.count == 0 ?
            [
            (x: 0.0,
             y: -lengthToFrontBodySupport/2,
             z: bodySupportHeight),
            (x:0.0,
             y: lengthToFrontBodySupport/2,
             z: bodySupportHeight)      ] : sitOnOrigins.frontAndRear
   
        return
            (onlyOne: occupantBodySupportOriginForOnlyOne,
             frontAndRear: occupantBodySupportOriginForFrontAndRear,
             sideBySide: occupantBodySupportOriginForSideBySide)
    }
    
    
    func occupantBodySupportOriginForFront()
        -> TwinSitOnOrigins{
        let occupantBodySupportOriginForOnlyOne =
            sitOnOrigins.onlyOne.count == 0 ?
                [(
                x: 0.0,
                y: -sitOnDimensions[onlyOne].length/2,
                z: bodySupportHeight )]: sitOnOrigins.onlyOne
        let  occupantBodySupportOriginForSideBySide: [PositionAsIosAxes] =
            sitOnOrigins.sideBySide.count == 0 ?
                [(
                x: -sitOnDimensions[left].width/2 - occupantSideSupportsDimensions[left][right].width,
                y: -sitOnDimensions[left].length/2,
                z: bodySupportHeight), (
                x: sitOnDimensions[right].width/2 +
                     occupantSideSupportsDimensions[right][left].width,
                y: -sitOnDimensions[right].length/2,
                z: bodySupportHeight)        ]: sitOnOrigins.sideBySide
        let lengthToFrontBodySupport =
                sitOnDimensions[rear].length/2 +
                occupantFootSupportHangerLinksMaxLengths[rear] +
                sitOnDimensions[front].length
        let occupantBodySupportOriginForFrontAndRear: [PositionAsIosAxes] =
            sitOnOrigins.frontAndRear.count == 0 ?
            [
            (x: 0.0,
             y: -lengthToFrontBodySupport,
             z: bodySupportHeight),
            (x:0.0,
             y: -sitOnDimensions[front].length/2,
             z: bodySupportHeight)      ] : sitOnOrigins.frontAndRear
        return
            (onlyOne: occupantBodySupportOriginForOnlyOne,
             frontAndRear: occupantBodySupportOriginForFrontAndRear,
             sideBySide: occupantBodySupportOriginForSideBySide)
    }
}

/// dic ?? dimensions -> origins ->  wheelBaseJoint
