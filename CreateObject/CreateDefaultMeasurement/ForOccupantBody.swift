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


//struct OccupantBodySupportAngleJointDefaultDimension: PartDimension {
//    var dimension: Dimension3d = ZeroValue.dimension3d
//
//    mutating func reinitialise(_ part: Part?) {
//        dimension = value
//    }
//
//    let dictionary: BaseObject3DimensionDictionary =
//    [:
//        ]
//    static let general = Joint.dimension3d
//
//    let value: Dimension3d
//
//    init(
//        _ baseType: ObjectTypes) {
//            value =
//                dictionary[baseType] ??
//                Self.general
//    }
//}


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
    
    static let general = (min: Measurement(value: 0.0, unit: UnitAngle.degrees), max: Measurement(value: 30.0, unit: UnitAngle.degrees) )
    
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
struct PreTiltSitOnAndWheelBaseJointOrigin {
    let objectType: ObjectTypes
    let stability: Stability
    var origins: [PositionAsIosAxes] = []
    var objectGroups: BaseObjectGroups {
        BaseObjectGroups()}
    //var wheelDefaultDimension: WheelDefaultDimension
    let bilateralIds: [Part] = [.id0, .id1]
    let bothSitOnId: [Part] = [.id0, .id1]
    //let dimensionDicIn: Part3DimensionDictionary
    //let preTiltObjectToPartOriginDicIn: PositionDictionary = [:]
    var sitOnOriginsIn: TwinSitOnOrigins =  ZeroValue.sitOnOrigins
    var sitOnDimensions: [Dimension3d] = []
    var occupantSideSupportsDimensions: [[Dimension3d]] = []
    var occupantFootSupportHangerLinksMaxLengths: [Double] = []
    var sitOnOrigins: TwinSitOnOrigins = ZeroValue.sitOnOrigins
    var baseObjectGroups: BaseObjectGroups {
        BaseObjectGroups()
    }
    let wheelDefaultDimensionForRearMidFront: Dimension3dRearMidFront
    var wheelBaseJointOriginForOnlyOneSitOn: RearMidFrontPositions = ZeroValue.rearMidFrontPositions
    
    var wheelBaseJointOrigins: TwinSitOnOrigins = ZeroValue.sitOnOrigins
    let onlyOne = 0
    let rear = 0
    let front = 1
    let left = 0
    let right = 1
    let bodySupportHeight: Double

  
    /// 1) rearAndFront && sleftAndRight == false: one origin .id0
    /// 2) rearAndFront == true && sideBySide == false: two origin .id0 (rear), .id1 (front)
    /// 3) rearAndFront == false && leftAndRight == true: two origin .id0 (left), .id1 (right)
    /// locations as per viewing screen
    /// [[PositionAsIos]]
    
    init(
        _ object: ObjectTypes//,
//        _ dimensionIn: Part3DimensionDictionary = [:],
//        _ preTiltObjectToPartOriginDicIn: PositionDictionary = [:]
    ) {

        self.objectType = object

        //self.preTiltObjectToPartOriginDicIn = preTiltObjectToPartOriginDicIn
        stability = Stability(objectType)
        //wheelDefaultDimension = WheelDefaultDimension(objectType)
       // dimensionDicIn = dimensionIn
        bodySupportHeight = PreTiltBodySupportDefaultOriginHeight(objectType).height
            
        wheelDefaultDimensionForRearMidFront =
            WheelDefaultDimensionForRearMidFront(object).dimensions

        for id in bothSitOnId {
            sitOnDimensions.append(
                getEditedOrDefaultSitOnDimension(id))
            
            occupantFootSupportHangerLinksMaxLengths.append(
                getEditedOrDefaultMaximumHangerLinkLength(id))
            
            occupantSideSupportsDimensions.append(
                getEditedOrDefaultSideSupportDimensions(id))
        }

        sitOnOriginsIn = getEditedSitOnOrigins()

        if baseObjectGroups.rearPrimaryOrigin.contains(objectType) {
            sitOnOrigins = originsForDriveLocation(.rear)
            
        }
        
        if baseObjectGroups.midPrimaryOrigin.contains(objectType) {
            sitOnOrigins = originsForDriveLocation(.mid)
            
        }
        
        if baseObjectGroups.frontPrimaryOrigin.contains(objectType) {
            sitOnOrigins =  originsForDriveLocation(.front)
        }
       
    }
    
    //there may be none, or one or two edited sitOn origins
    //if two these may be frontAndRear or sideBySide
    func getEditedSitOnOrigins()
        -> TwinSitOnOrigins {
        var sitOnOrigins: [PositionAsIosAxes?] = []
        var sitOnOriginsIn = ZeroValue.sitOnOrigins
        for id in bothSitOnId {
            sitOnOrigins.append(nil
//                preTiltObjectToPartOriginDicIn [CreateNameFromParts([.sitOn, id, .stringLink, .sitOn, id]).name]
            )
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
                         rearAndFront: [],
                         leftAndRight: [])
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
                     rearAndFront: [],
                     leftAndRight: [first, second])
            } else {
                sitOnOriginsIn =
                    (onlyOne: [],
                     rearAndFront: [first, second],
                     leftAndRight: [])
            }
        }
            return sitOnOriginsIn
    }
    
    
    func getEditedOrDefaultSitOnDimension(_ sitOnId: Part)
        -> Dimension3d {
//        let name =
//            CreateNameFromParts([.object, .id0, .stringLink, .sitOn, sitOnId, .stringLink, .sitOn, sitOnId]).name
        return
            //dimensionDicIn[name] ??
            OccupantBodySupportDefaultDimension(objectType).value
    }
    
    
    func getEditedOrDefaultSideSupportDimensions(_ sitOnId: Part)
        -> [Dimension3d] {
            var sideSupportDimension: [Dimension3d] = []
            for sideId in bilateralIds {
//                let name =
//                    CreateNameFromParts([.object, .id0, .stringLink, .sideSupport, sideId, .stringLink, .sitOn, sitOnId]).name
                let dimension = //dimensionDicIn[name] ??
                    OccupantSideSupportDefaultDimensionOld(objectType).value
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
//            let name =
//                CreateNameFromParts([.footSupportHangerLink, id, .stringLink, .sitOn, sitOnId]).name
            lengths.append(
                //dimensionDicIn[name]?.length ??
                hangerLinkLength)
        }
        return
            lengths.max() ?? hangerLinkLength
    }
        
    
   mutating func originsForDriveLocation(_ location: Drive)
        -> TwinSitOnOrigins {
        var originForOnlyOneSitOn: [PositionAsIosAxes] = []
        var originForLeftAndRightSitOn: [PositionAsIosAxes] = []
        var originForRearAndFrontSitOn: [PositionAsIosAxes] = []
        var distanceBetweenSitOn: Double = 0.0
            
            
//        var wheelBaseJointOriginForOnlyOneSitOn: RearMidFrontPositions = ZeroValue.rearMidFrontPositions
//        var wheelBaseJointOriginForLeftAndRightSitOn: RearMidFrontPositions = ZeroValue.rearMidFrontPositions
//        var wheelBaseJointOriginForRearAndFrontSitOn: RearMidFrontPositions = ZeroValue.rearMidFrontPositions
            

            
        switch location {
            case .rear:
                originForOnlyOneSitOn =
                    sitOnOrigins.onlyOne.count == 0 ?
                        [(
                        x: 0.0,
                        y: sitOnDimensions[onlyOne].length/2,
                        z: bodySupportHeight )]: sitOnOrigins.onlyOne
                
                originForLeftAndRightSitOn =
                    sitOnOrigins.leftAndRight.count == 0 ?
                        [(
                        x: -sitOnDimensions[left].width/2 - occupantSideSupportsDimensions[left][right].width,
                        y: sitOnDimensions[left].length/2,
                        z: bodySupportHeight), (
                        x: sitOnDimensions[right].width/2 +
                             occupantSideSupportsDimensions[right][left].width,
                        y: sitOnDimensions[right].length/2,
                        z: bodySupportHeight)        ]: sitOnOrigins.leftAndRight
                distanceBetweenSitOn =
                        sitOnDimensions[rear].length +
                        occupantFootSupportHangerLinksMaxLengths[rear] +
                        sitOnDimensions[front].length/2
                originForRearAndFrontSitOn =
                    sitOnOrigins.rearAndFront.count == 0 ?
                    [
                    (x: 0.0,
                     y: sitOnDimensions[rear].length/2,
                     z: bodySupportHeight),
                    (x:0.0,
                     y: distanceBetweenSitOn,
                     z: bodySupportHeight)      ] : sitOnOrigins.rearAndFront
                
                //Wheel Base Joint
                wheelBaseJointOriginForOnlyOneSitOn =
                    (rear: (
                         x: sitOnDimensions[onlyOne].width/2 +
                            occupantSideSupportsDimensions[left][right].width +
                            stability.atRightRear,
                         y: stability.atRear,
                         z: wheelDefaultDimensionForRearMidFront.rear.height/2 ),
                     mid: (
                         x: sitOnDimensions[onlyOne].width/2 +
                           occupantSideSupportsDimensions[left][right].width +
                           stability.atRightMid,
                        y:  sitOnDimensions[onlyOne].length/2 +
                            stability.atRear ,
                        z: wheelDefaultDimensionForRearMidFront.mid.height/2 ),
                     front: (
                        x: sitOnDimensions[onlyOne].width/2 +
                           occupantSideSupportsDimensions[left][right].width +
                           stability.atRightFront,
                        y: stability.atRear +
                            sitOnDimensions[onlyOne].length +
                            stability.atFront,
                        z: wheelDefaultDimensionForRearMidFront.front.height/2 )
                    )
           // print(wheelBaseJointOriginForOnlyOneSitOn)
                
            case .mid:
                originForOnlyOneSitOn =
                    sitOnOrigins.onlyOne.count == 0 ?
                    [(
                    x: 0.0,
                    y: 0.0,
                    z: bodySupportHeight )] : sitOnOrigins.onlyOne
                
                originForLeftAndRightSitOn =
                    sitOnOrigins.leftAndRight.count == 0 ?
                    [
                    (x: -sitOnDimensions[left].width/2 - occupantSideSupportsDimensions[left][right].width,
                     y: 0,
                     z:bodySupportHeight),
                    (x: sitOnDimensions[right].width/2 +
                     occupantSideSupportsDimensions[right][left].width,
                     y: 0.0,
                     z:bodySupportHeight)        ] : sitOnOrigins.leftAndRight
                
                distanceBetweenSitOn =
                        sitOnDimensions[rear].length/2 +
                        occupantFootSupportHangerLinksMaxLengths[rear] +
                        sitOnDimensions[front].length/2
                
                originForRearAndFrontSitOn =
                    sitOnOrigins.rearAndFront.count == 0 ?
                    [
                    (x: 0.0,
                     y: -distanceBetweenSitOn/2,
                     z: bodySupportHeight),
                    (x:0.0,
                     y: distanceBetweenSitOn/2,
                     z: bodySupportHeight)      ] : sitOnOrigins.rearAndFront
            
                //Wheel Base Joint
                wheelBaseJointOriginForOnlyOneSitOn =
                    (rear: (
                         x: sitOnDimensions[onlyOne].width/2 +
                            occupantSideSupportsDimensions[left][right].width +
                            stability.atRightRear,
                         y: -sitOnDimensions[onlyOne].length/2 -
                            stability.atRear,
                         z: wheelDefaultDimensionForRearMidFront.rear.height ),
                     mid: (
                         x: sitOnDimensions[onlyOne].width/2 +
                           occupantSideSupportsDimensions[left][right].width +
                           stability.atRightMid,
                         y:  0.0,
                        z: wheelDefaultDimensionForRearMidFront.mid.height ),
                     front: (
                        x: sitOnDimensions[onlyOne].width/2 +
                           occupantSideSupportsDimensions[left][right].width +
                           stability.atRightFront,
                        y: sitOnDimensions[onlyOne].length/2 +
                            stability.atFront,
                        z: wheelDefaultDimensionForRearMidFront.rear.height )
                    )
                
            
            case .front:
                originForOnlyOneSitOn =
                   sitOnOrigins.onlyOne.count == 0 ?
                       [(
                       x: 0.0,
                       y: -sitOnDimensions[onlyOne].length/2,
                       z: bodySupportHeight )]: sitOnOrigins.onlyOne
                originForLeftAndRightSitOn =
                sitOnOrigins.leftAndRight.count == 0 ?
                    [(
                    x: -sitOnDimensions[left].width/2 - occupantSideSupportsDimensions[left][right].width,
                    y: -sitOnDimensions[left].length/2,
                    z: bodySupportHeight), (
                    x: sitOnDimensions[right].width/2 +
                         occupantSideSupportsDimensions[right][left].width,
                    y: -sitOnDimensions[right].length/2,
                    z: bodySupportHeight)        ]: sitOnOrigins.leftAndRight
                distanceBetweenSitOn =
                    sitOnDimensions[rear].length/2 +
                    occupantFootSupportHangerLinksMaxLengths[rear] +
                    sitOnDimensions[front].length
                originForRearAndFrontSitOn =
                    sitOnOrigins.rearAndFront.count == 0 ?
                    [
                    (x: 0.0,
                     y: -distanceBetweenSitOn,
                     z: bodySupportHeight),
                    (x:0.0,
                     y: -sitOnDimensions[front].length/2,
                     z: bodySupportHeight)      ] : sitOnOrigins.rearAndFront
            
            //Wheel Base Joint
            wheelBaseJointOriginForOnlyOneSitOn =
                (rear: (
                     x: sitOnDimensions[onlyOne].width/2 +
                        occupantSideSupportsDimensions[left][right].width +
                        stability.atRightRear,
                     y: stability.atRear -
                        sitOnDimensions[onlyOne].length -
                        stability.atFront,
                     z: wheelDefaultDimensionForRearMidFront.rear.height ),
                 mid: (
                     x: sitOnDimensions[onlyOne].width/2 +
                       occupantSideSupportsDimensions[left][right].width +
                       stability.atRightMid,
                     y:  -sitOnDimensions[onlyOne].length/2 -
                     stability.atFront,
                    z: wheelDefaultDimensionForRearMidFront.mid.height ),
                 front: (
                    x: sitOnDimensions[onlyOne].width/2 +
                       occupantSideSupportsDimensions[left][right].width +
                       stability.atRightFront,
                    y: 0.0,
                    z: wheelDefaultDimensionForRearMidFront.rear.height )
                )
           // print(wheelBaseJointOriginForOnlyOneSitOn.front.x)
        }
        
        return
            (onlyOne: originForOnlyOneSitOn,
             rearAndFront: originForRearAndFrontSitOn,
             leftAndRight: originForLeftAndRightSitOn)
    }
    
    
    
  
    

    
//
    

    

    
    

}

/// dic ?? dimensions -> origins ->  wheelBaseJoint
