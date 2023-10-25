//
//  ForWheel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/06/2023.
//

import Foundation


struct ObjectWheelDefaultDimension: PartDimension {
    mutating func reinitialise(_ part: Part?) {
        self.part = part
        switch part {
        case .fixedWheelAtRear:
            dimension =
            getFixedWheelRearDrive()
        case .fixedWheelAtMid:
            dimension =
                getFixedWheelMidDrive()
        case .fixedWheelAtFront:
            dimension =
                geFixedWheelFrontDrive()
        case .fixedWheelHorizontalJointAtRear:
            dimension =
                getHorizontalJoint()
        case .casterVerticalJointAtFront:
            dimension =
                getVerticalJoint()
        case .casterForkAtFront:
            dimension =
                getCasterForkAtFront()
        case .casterWheelAtFront:
            dimension = getCasterWheelAtFront()
        default:
            break
        }
    }
    
    let baseType: ObjectTypes
    var dimension: Dimension3d = ZeroValue.dimension3d
    var part: Part?

    init ( _ baseType: ObjectTypes) {
        self.baseType = baseType
    }
    func geFixedWheelFrontDrive ()
    -> Dimension3d {
        getFixedWheel()
    }

    func getFixedWheelMidDrive ()
    -> Dimension3d {
        getFixedWheel()
    }

    func getFixedWheelRearDrive ()
    -> Dimension3d {
        getFixedWheel()
    }
    
    func getHorizontalJoint ()
    -> Dimension3d {
        Joint.dimension3d
    }
    
    func getFixedWheel()
        -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary =
            [.fixedWheelManualRearDrive:
                (width: 20.0,
                 length: 600.0,
                 height: 600.0),
             
                ]
        let general =
            (width: 50.0,
              length: 200.0,
              height: 200.0)
        return
            dictionary[baseType] ??
            general
    }
    
    func getVerticalJoint ()
        -> Dimension3d {
            Joint.dimension3d
    }
    
    func getCasterForkAtFront()
        -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary =
            [.fixedWheelMidDrive:
                (width: 40.0,
                 length: 75.0,
                 height: 40.0),
             
                ]
        let general =
            (width: 50.0,
              length: 100.0,
              height: 50.0)
        return
            dictionary[baseType] ??
            general
        
    }
    
    func getCasterWheelAtFront()
        -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary =
            [.fixedWheelMidDrive:
                (width: 20.0,
                 length: 75.0,
                 height: 50.0),
             
                ]
        let general =
            (width: 50.0,
              length: 150.0,
              height: 100.0)
        return
            dictionary[baseType] ??
            general
        
    }

}
    



    struct Stability {
        let dictionary: BaseObjectDoubleDictionary = [:]
        
        let atRear = 0.0
        let atFront = 0.0
        let atLeft = 0.0
        let atLeftRear = 0.0
        let atRightRear = 0.0
        let atRightMid = 0.0
        let atRightFront = 0.0
        let atRight = 0.0
        let baseType: ObjectTypes
        
        init(_ objectType: ObjectTypes) {
            self.baseType = objectType
        }
    }



struct WheelDefaultDimensionForRearMidFront {
    var dimensions: Dimension3dRearMidFront = ZeroValue.dimension3dRearMidFront
    var baseObjectGroups: BaseObjectGroups {
        BaseObjectGroups()
    }
   var wheelDefaultDimension: ObjectWheelDefaultDimension
   
    
    init(_ object: ObjectTypes) {
        wheelDefaultDimension = ObjectWheelDefaultDimension(object)
        dimensions = getDimensions(object)
        
    }
    
  mutating  func getDimensions(_ object: ObjectTypes)
        -> Dimension3dRearMidFront {
            var wheelDimensions =
                (
                rear: ZeroValue.dimension3d,
                mid: ZeroValue.dimension3d,
                front: ZeroValue.dimension3d )
            wheelDefaultDimension.reinitialise(.casterWheelAtRear)
            let casterWheelAtRear = wheelDefaultDimension.dimension
            wheelDefaultDimension.reinitialise(.casterWheelAtMid)
            let casterWheelAtMid = wheelDefaultDimension.dimension
            wheelDefaultDimension.reinitialise(.casterWheelAtFront)
            let casterWheelAtFront = wheelDefaultDimension.dimension
            wheelDefaultDimension.reinitialise(.fixedWheel)
            let fixedWheel = wheelDefaultDimension.dimension
            
            
            if baseObjectGroups.allCaster.contains(object) {
                wheelDimensions =
                    (
                    rear: casterWheelAtRear,
                    mid: casterWheelAtMid,
                    front: casterWheelAtFront )
            }
            
            if baseObjectGroups.rearFixedWheel.contains(object) {
                wheelDimensions =
                    (
                    rear: fixedWheel,
                    mid: casterWheelAtMid,
                    front: casterWheelAtFront )
            }
            
            if baseObjectGroups.midFixedWheel.contains(object) {
                wheelDimensions =
                    (
                    rear: casterWheelAtRear,
                    mid: fixedWheel,
                    front: casterWheelAtFront)
               // print(wheelDimensions)
            }
            
            if baseObjectGroups.frontFixedWheel.contains(object) {
                wheelDimensions =
                    (
                    rear: casterWheelAtRear ,
                    mid: casterWheelAtMid ,
                    front:  fixedWheel)
                
            }
            return wheelDimensions
    }
    
}





struct WheelId {
    let atMid: [Part] = [.id2, .id3]
    let atRear: [Part]
    let atFront: [Part]
    var allIds: [[Part]] = []
    let baseType: ObjectTypes
    
    init( _ baseType: ObjectTypes) {
        
        self.baseType = baseType
        
        atRear = getAtRear()
        atFront = getAtFront()
        
        // id locations are assigned as follows
        // as visually layed out
        //
        // id0...id1 for two
        //
        // id0...id1 for three front
        //    id2
        //
        //    id0    for three rear
        // id1...id2
        //
        // id0...id1 for four
        // id2...id3
        //
        // id0...id1 for six
        // id2...id3
        // id4...id5
        //
        func getAllIds() {
           allIds = [getAtRear()]
            if BaseObjectGroups().sixWheels.contains(baseType) {
                allIds.append(atMid)
            }
            allIds.append(getAtFront())
        }
        
        func getAtRear() -> [Part] {
            BaseObjectGroups().singleWheelAtRear
                    .contains(baseType) ?
                        [.id0]: [.id0, .id1]
        }
        
       
        func getAtFront ()
            -> [Part] {
                var ids: [Part] = [.id2, .id3]
                
            if BaseObjectGroups().singleWheelAtRear
                .contains(baseType) {
               ids = [.id1, .id2]
            }
            if BaseObjectGroups().singleWheelAtFront
                .contains(baseType) {
               ids = [.id2]
            }
            if BaseObjectGroups().sixWheels
                .contains(baseType) {
             ids =  [.id4, .id5]
            }
                
            if BaseObjectGroups().singleWheelAtFront
                .contains(baseType) {
              ids =  [ .id2]
            }
            return ids
        }
    }
}








struct PreTiltWheelBaseJointDefaultOrigin: PartOrigin {
    var origin: PositionAsIosAxes = ZeroValue.iosLocation
    var part: Part?
    var preTiltSitOnAndWheelBaseJointOrigin: PreTiltSitOnAndWheelBaseJointOrigin
    var wheelDefaultDimension: ObjectWheelDefaultDimension
    
    mutating func reinitialise(_ part: Part?) {
        self.part = part
        //print (part)
        switch part {
            case .fixedWheelHorizontalJointAtRear:
                origin = getObjectToWheelHorizontalJointAtRear()
        case .fixedWheelHorizontalJointAtMid:
            origin = getObjectToWheelHorizontalJointAtMid()
        case .fixedWheelHorizontalJointAtFront:
            origin = getObjectToWheelHorizontalJointAtFront()
            case .fixedWheelAtRear:
                origin = getWheelHorizontalJointToFixedWheelAtRear()
            case .fixedWheelAtMid:
                origin = getWheelHorizontalJointToFixedWheelAtMid()
            case .casterVerticalJointAtFront:
                origin = getCasterWheelVerticalAxisAtFront()
            case .casterForkAtFront:
                origin = getCasterForkAtFront()
            case .casterWheelAtFront:
                origin = getCasterWheelAtFront()
        default:
           break
        }
    }
    
    let objectType: ObjectTypes
   
    
    init ( _ objectType: ObjectTypes) {
        self.objectType = objectType
        
        preTiltSitOnAndWheelBaseJointOrigin = PreTiltSitOnAndWheelBaseJointOrigin(objectType)
        wheelDefaultDimension = ObjectWheelDefaultDimension(objectType)
    }

    
    func getOrigin() -> PositionAsIosAxes {
        origin
    }
    

    func getObjectToWheelHorizontalJointAtRear()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general = preTiltSitOnAndWheelBaseJointOrigin.wheelBaseJointOriginForOnlyOneSitOn.rear
        return
            dictionary[objectType] ?? general
    }
    
    func getObjectToWheelHorizontalJointAtMid()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general = preTiltSitOnAndWheelBaseJointOrigin.wheelBaseJointOriginForOnlyOneSitOn.mid
        return
            dictionary[objectType] ?? general
    }
    
    func getObjectToWheelHorizontalJointAtFront()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general = preTiltSitOnAndWheelBaseJointOrigin.wheelBaseJointOriginForOnlyOneSitOn.front
        return
            dictionary[objectType] ?? general
    }
    
    func getWheelHorizontalJointToFixedWheelAtRear()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: 0.0,
             y: 0.0,
             z: 0.0)
        return
            dictionary[objectType] ?? general
    }
    
    func getWheelHorizontalJointToFixedWheelAtMid()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general =
            (x: 0.0,
             y: 0.0,
             z: 0.0)
        return
            dictionary[objectType] ?? general
    }
    
    func getCasterWheelVerticalAxisAtFront()
        -> PositionAsIosAxes {
        let dictionary: OriginDictionary = [:]
        let general = preTiltSitOnAndWheelBaseJointOrigin.wheelBaseJointOriginForOnlyOneSitOn.front
            
        return
            dictionary[objectType] ?? general
    }
    
    
    mutating func getCasterForkAtFront()
    -> PositionAsIosAxes {
        wheelDefaultDimension.reinitialise(.casterForkAtFront)
        let dictionary: OriginDictionary = [:]
        let general =
        (x: 0.0,
         y: -wheelDefaultDimension.dimension.length/2,
         z: 0.0)
        return
            dictionary[objectType] ?? general
    }
    
    
   mutating func getCasterWheelAtFront()
    -> PositionAsIosAxes {
        wheelDefaultDimension.reinitialise(.casterWheelAtFront)
        let dictionary: OriginDictionary = [:]
        let general =
        (x: 0.0,
         y: 0.0,
         z: -wheelDefaultDimension.dimension.height/2)
        return
            dictionary[objectType] ?? general
    }
}








//struct WheelDefaultDimensionForRearMidFront2 {
//    var dimensions: Dimension3dRearMidFront = ZeroValue.dimension3dRearMidFront
//    var baseObjectGroups: BaseObjectGroups {
//        BaseObjectGroups()
//    }
//    let wheelDefaultDimension: WheelDefaultDimension
//
//
//    init(_ object: ObjectTypes) {
//        wheelDefaultDimension = WheelDefaultDimension(object)
//        dimensions = getDimensions(object)
//
//    }
//
//    func getDimensions(_ object: ObjectTypes)
//        -> Dimension3dRearMidFront {
//            var wheelDimensions =
//                (
//                rear: ZeroValue.dimension3d,
//                mid: ZeroValue.dimension3d,
//                front: ZeroValue.dimension3d )
//
//            if baseObjectGroups.allCaster.contains(object) {
//                wheelDimensions =
//                    (
//                    rear: wheelDefaultDimension.getRearCasterWheel(),
//                    mid: wheelDefaultDimension.getMidCasterWheel(),
//                    front: wheelDefaultDimension.getFrontCasterWheel() )
//            }
//
//            if baseObjectGroups.midFixedWheel.contains(object) {
//                wheelDimensions =
//                    (
//                    rear: wheelDefaultDimension.getRearCasterWheel(),
//                    mid: wheelDefaultDimension.getFixed(),
//                    front: wheelDefaultDimension.getFrontCasterWheel() )
//            }
//
//            if baseObjectGroups.rearFixedWheel.contains(object) {
//                wheelDimensions =
//                    (
//                    rear: wheelDefaultDimension.getFixed(),
//                    mid: wheelDefaultDimension.getMidCasterWheel() ,
//                    front: wheelDefaultDimension.getFrontCasterWheel() )
//            }
//
//            if baseObjectGroups.frontFixedWheel.contains(object) {
//                wheelDimensions =
//                    (
//                    rear:  wheelDefaultDimension.getRearCasterWheel() ,
//                    mid: wheelDefaultDimension.getMidCasterWheel() ,
//                    front:  wheelDefaultDimension.getFixed())
//
//            }
//            return wheelDimensions
//    }
//
//}









//MARK: ORIGIN
/// The array of fixed wheel or caster vertical origin
/// is ordered rearmost left (UI left top screen as viewed), rearmost right
/// moving towards bottom of screen
//struct WheelAndCasterVerticalJointOrigin {
//    let baseType: ObjectTypes
//    let lengthBetweenFrontAndRearWheels: Double
//    let widthBetweeenWheelsOnOrigin: Double
//    let wheelDimension: WheelDefaultDimension
//    let rearCasterJointAboveFloor: Double
//    let frontCasterJointAboveFloor: Double
//
//    init (
//            _ baseType: ObjectTypes,
//            _ lengthBetweenFrontRearWheels: Double,
//            _ widthBetweeenWheelsOnOrigin: Double) {
//
//                self.baseType = baseType
//                self.lengthBetweenFrontAndRearWheels = lengthBetweenFrontRearWheels
//                self.widthBetweeenWheelsOnOrigin =
//                    widthBetweeenWheelsOnOrigin
//                wheelDimension = WheelDefaultDimension(baseType)
//                rearCasterJointAboveFloor =
//                    wheelDimension.getRearCasterRadius().radius +
//                    wheelDimension.getRearCasterFork().height
//                frontCasterJointAboveFloor =
//                    wheelDimension.getFrontCasterRadius().radius +
//                    wheelDimension.getFrontCasterFork().height
//
//    }
//
//    func getRightDriveWheel()
//        -> PositionAsIosAxes {
//            (
//            x: widthBetweeenWheelsOnOrigin/2,
//            y: 0.0,
//            z: wheelDimension.getFixedRadius().radius)
//    }
//
//    func getSteerableWheelAtRear()
//        -> PositionAsIosAxes {
//            (
//            x: 0.0,
//            y: lengthBetweenFrontAndRearWheels,
//            z: wheelDimension.getFixedRadius().radius)
//    }
//
//    func getSteerableWheelAtFront()
//        -> PositionAsIosAxes {
//            (
//            x: 0.0,
//            y: -lengthBetweenFrontAndRearWheels,
//            z: wheelDimension.getFixedRadius().radius)
//    }
//
//    func getRearCasterWhenRearPrimaryOrigin()
//        -> PositionAsIosAxes {
//            (x: getRightDriveWheel().x,
//             y: 0.0,
//             z: rearCasterJointAboveFloor)
//    }
//
//    func getMidCasterWhenRearPrimaryOrigin()
//        -> PositionAsIosAxes {
//            (x: getRightDriveWheel().x,
//             y: lengthBetweenFrontAndRearWheels/2,
//             z: rearCasterJointAboveFloor)
//    }
//
//
//    func getFrontCasterWhenRearPrimaryOrigin()
//        -> PositionAsIosAxes {
//             (
//            x: widthBetweeenWheelsOnOrigin/2,
//            y: lengthBetweenFrontAndRearWheels,
//            z: frontCasterJointAboveFloor)
//    }
//
//    //MAARK- REQUIRES OWN z value
//    func getRearCasterWhenMidPrimaryOrigin()
//    -> PositionAsIosAxes {
//            (
//                x: widthBetweeenWheelsOnOrigin/2.5,
//            y: -lengthBetweenFrontAndRearWheels/2,
//            z: rearCasterJointAboveFloor)
//    }
//
//
//    func getFrontCasterWhenMidPrimaryOrigin()
//    -> PositionAsIosAxes {
//            (
//            x: widthBetweeenWheelsOnOrigin/2,
//            y: lengthBetweenFrontAndRearWheels/2,
//            z: frontCasterJointAboveFloor)
//    }
//
//    func getRearCasterWhenFrontPrimaryOrigin()
//    -> PositionAsIosAxes {
//            (
//            x: widthBetweeenWheelsOnOrigin/2,
//            y: -lengthBetweenFrontAndRearWheels,
//            z: rearCasterJointAboveFloor)
//    }
//}

//struct CasterOrigin {
//
//    let baseType: ObjectTypes
//
//    init ( _ baseType: ObjectTypes) {
//        self.baseType = baseType
//    }
//
//    func forFrontCasterVerticalJointToFork()
//        -> PositionAsIosAxes {
//
//        let casterForkDimension =
//            WheelDefaultDimension(baseType).getFrontCasterFork()
//        let casterTrailDimension =
//            WheelDefaultDimension(baseType).getFrontCasterTrail()
//        return
//            (
//                x: 0.0,
//                y: -(casterForkDimension.length + casterTrailDimension.length)/2,
//                z: -casterForkDimension.height/2)
//    }
//
//    func forMidCasterVerticalJointToFork()
//        -> PositionAsIosAxes {
//
//        let casterForkDimension =
//            WheelDefaultDimension(baseType).getMidCasterFork()
//        let casterTrailDimension =
//            WheelDefaultDimension(baseType).getMidCasterTrail()
//        return
//            (
//                x: 0.0,
//                y: -(casterForkDimension.length + casterTrailDimension.length)/2,
//                z: -casterForkDimension.height/2)
//    }
//
//    func forRearCasterVerticalJointToFork()
//        -> PositionAsIosAxes {
//
//        let casterForkDimension =
//            WheelDefaultDimension(baseType).getRearCasterFork()
//        let casterTrailDimension =
//            WheelDefaultDimension(baseType).getRearCasterTrail()
//        return
//            (
//                x: 0.0,
//                y: -(casterForkDimension.length + casterTrailDimension.length)/2,
//                z: -casterForkDimension.height/2)
//    }
//
//
//    func forFrontCasterForkToWheel()
//        -> PositionAsIosAxes {
//
//        let casterWheelDimension =
//            WheelDefaultDimension(baseType).getFrontCasterWheel()
//        return
//            (
//                x: 0.0,
//                y: 0.0,
//                z: -casterWheelDimension.height/2)
//    }
//
//    func forMidCasterForkToWheel()
//        -> PositionAsIosAxes {
//
//        let casterWheelDimension =
//            WheelDefaultDimension(baseType).getMidCasterWheel()
//        return
//            (
//                x: 0.0,
//                y: 0.0,
//                z: -casterWheelDimension.height/2)
//    }
//
//    func forRearCasterForkToWheel()
//        -> PositionAsIosAxes {
//
//        let casterWheelDimension =
//            WheelDefaultDimension(baseType).getRearCasterWheel()
//        return
//            (
//                x: 0.0,
//                y: 0.0,
//                z: -casterWheelDimension.height/2)
//    }
//}





//
//struct WheelAndCasterDefaultOrigin: PartOrigin {
//    var origin: PositionAsIosAxes = ZeroValue.iosLocation
//    var part: Part?
//
//    var objectWheelDefaultDimension: ObjectWheelDefaultDimension
//    var dictionary: OriginDictionary = [:]
//
//    mutating func reinitialise(_ part: Part?) {
//        self.part = part
//
//        switch part {
//        case .fixedWheelAtRear:
//            origin = getFixedWheelAtRear()
//        default:
//            break
//        }
//    }
//
//    let baseType: ObjectTypes
//
//
//    init ( _ baseType: ObjectTypes) {
//        self.baseType = baseType
//
//        objectWheelDefaultDimension  = ObjectWheelDefaultDimension(baseType)
//
//        dictionary  =
//        [
//            .fixedWheelManualRearDrive:
//                (x: 0,//objectWheelDefaultDimension,
//                 y: 0,
//                 z: 0)]
//    }
//    mutating func getFixedWheelAtRear()
//        -> PositionAsIosAxes {
//            objectWheelDefaultDimension.reinitialise(.fixedWheelAtRear)
//
//            return
//                (
//                x: objectWheelDefaultDimension.dimension.width,
//                y: 0.0,
//                z: 0)
//
//    }
//
//    func getOrigin() -> PositionAsIosAxes {
//        origin
//    }
//}



//struct AllWheelRelated {
//    var parts: [Part] = []
//    var defaultDimensions: [Dimension3d] = []
//    var defaultRearMidFrontDimension = ZeroValue.dimensions3dRearMidFront
//    let wheelDefaultDimension: WheelDefaultDimension
//
//    let rearCasterForkDimension: Dimension3d
//    let rearCasterWheelDimension: Dimension3d
//    let rearCaster: [Dimension3d]
//    let frontCasterForkDimension: Dimension3d
//    let frontCasterWheelDimension: Dimension3d
//    let frontCaster: [Dimension3d]
//    let fixedWheelAndJoint: [Dimension3d]
//
//
//
//    init(_ baseType: ObjectTypes) {
//        wheelDefaultDimension = WheelDefaultDimension(baseType)
//
//
//        rearCasterForkDimension = wheelDefaultDimension.getRearCasterFork()
//        rearCasterWheelDimension = wheelDefaultDimension.getRearCasterWheel()
//        rearCaster =
//            [Joint.dimension3d, rearCasterForkDimension, rearCasterWheelDimension]
//        frontCasterForkDimension = wheelDefaultDimension.getFrontCasterFork()
//        frontCasterWheelDimension = wheelDefaultDimension.getFrontCasterWheel()
//        frontCaster =
//            [Joint.dimension3d, frontCasterForkDimension, frontCasterWheelDimension]
//        fixedWheelAndJoint = [Joint.dimension3d, wheelDefaultDimension.getFixed()]
        
//        let fourCaster =
//        getDimensionsForFourCaster(PartGroup.fourCasterParts)

//        switch baseType {
//        case .allCasterBed:
//            defaultRearMidFrontDimension =
//                getForFourCaster()
//            case .allCasterChair:
//            defaultRearMidFrontDimension =
//                getForFourCaster()
//            case .allCasterHoist:
//            defaultRearMidFrontDimension =
//                getForFourCaster()
//        case .allCasterSixHoist:
//            parts = PartGroup.sixCasterParts
//        case .allCasterTiltInSpaceShowerChair:
//            defaultRearMidFrontDimension =
//                getForFourCaster()
//            parts = PartGroup.fourCasterParts
//            defaultDimensions = fourCaster
//        case .allCasterStandAid:
//            parts = PartGroup.fourCasterParts
//            defaultDimensions = fourCaster
//        case .allCasterStretcher:
//            defaultRearMidFrontDimension =
//                getForFourCaster()
//        case .fixedWheelFrontDrive:
//            defaultRearMidFrontDimension =
//                getForFixedWheelFrontDrive ()
//        case .fixedWheelMidDrive:
//            defaultRearMidFrontDimension =
//                getForFixedWheelMidDrive ()
//
//        case .fixedWheelRearDrive:
//            defaultRearMidFrontDimension =
//                getForFixedWheelRearDrive ()
//
//        case .fixedWheelManualRearDrive:
//            defaultRearMidFrontDimension =
//                getForFixedWheelRearDrive ()
//
//        default:
//            break
//        }
//    }
        
   
//
//    func getForFixedWheelFrontDrive ()
//    -> Dimensions3dRearMidFront {
//        let rear = rearCaster
//        let mid: [Dimension3d] = []
//        let front =
//            fixedWheelAndJoint
//        return
//            (rear: rear,  mid: mid, front: front )
//    }
//
//    func getForFixedWheelMidDrive ()
//    -> Dimensions3dRearMidFront {
//        let rear =
//                rearCaster
//        let mid = fixedWheelAndJoint
//        let front =
//                frontCaster
//        return
//            (rear: rear,  mid: mid, front: front )
//    }
//
//    func getForFixedWheelRearDrive ()
//    -> Dimensions3dRearMidFront {
//        let rear =
//            fixedWheelAndJoint
//
//        let mid: [Dimension3d] = []
//        let front =
//            frontCaster
//        return
//            (rear: rear,  mid: mid, front: front )
//    }
//
//        func getForFourCaster ()
//        -> Dimensions3dRearMidFront {
//            let rear =
//                rearCaster
//            let mid: [Dimension3d] = []
//            let front =
//                frontCaster
//            return
//                (rear: rear,  mid: mid, front: front )
//        }
//
//
//}


/// The length between wheels
/// or the width between wheels
/// taking account of side by side seats
/// or front and rear seats
/// and if there is a mid-wheel
//struct DistanceBetweenWheels {
//    var ifNoFrontAndRearSitOn: Double = 0.0
//    var ifFrontAndRearSitOn: Double = 0.0
//    let occupantBodySupport: [Dimension3d]
//    let occupantFootSupportHangerLink: [Dimension3d]
//    let stability: Stability
//    let baseType: ObjectTypes
//
//    init (
//        _ baseType: ObjectTypes,
//        _ occupantBodySupportsDimension: [Dimension3d],
//        _ occupantFootSupportHangerLinksDimension: [Dimension3d] ){
//            self.baseType = baseType
//
//            stability = Stability(baseType)
//
//            occupantBodySupport =
//                occupantBodySupportsDimension
//
//            occupantFootSupportHangerLink =
//                occupantFootSupportHangerLinksDimension
//
//            if occupantBodySupportsDimension.count == 2 {
//                ifFrontAndRearSitOn =
//                    frontRearIfFrontAndRearSitOn()
//            } else {
//                ifNoFrontAndRearSitOn =
//                    frontRearIfNoFrontAndRearSitOn()
//            }
//
//    }
//
//    func frontRearIfNoFrontAndRearSitOn()
//        -> Double {
//        stability.atRear +
//        occupantBodySupport[0].length +
//        stability.atFront
//    }
//
//    func frontRearIfFrontAndRearSitOn ()
//        -> Double {
//        frontRearIfNoFrontAndRearSitOn() +
//        occupantFootSupportHangerLink[0].length +
//        occupantBodySupport[1].length
//    }
//
//
//    func rearIfLeftAndRightSitOn()
//        -> Double {
//            let dictionary: BaseSizeDictionary =
//            [.allCasterHoist: 600.0,
//            .fixedWheelMidDrive: 300.0,
//            .fixedWheelRearDrive: 500.0,
//            .fixedWheelFrontDrive: 400.0,
//             .fixedWheelManualRearDrive: 500.0]
//            let general = 400.0
//            return
//                dictionary[baseType] ?? general
//    }
//
//    func rearIfNoLeftAndRightSitOn()
//        -> Double {
//            let dictionary: BaseSizeDictionary =
//            [.allCasterHoist: 600.0,
//            .fixedWheelMidDrive: 300.0,
//            .fixedWheelRearDrive: 500.0,
//            .fixedWheelFrontDrive: 400.0,
//             .fixedWheelManualRearDrive: 500.0]
//            let general = 400.0
//            return
//                dictionary[baseType] ?? general
//    }
//
//    func midIfLeftAndRightSitOn()
//        -> Double {
//            let dictionary: BaseSizeDictionary =
//            [.fixedWheelMidDrive: 500.0]
//            let general = 0.0
//            return
//                dictionary[baseType] ?? general
//    }
//
//    func midIfNoLeftAndRightSitOn()
//        -> Double {
//            let dictionary: BaseSizeDictionary =
//            [.fixedWheelMidDrive: 500.0]
//            let general = 0.0
//            return
//                dictionary[baseType] ?? general
//    }
//
//    func frontIfLeftAndRightSitOn()
//        -> Double {
//            let dictionary: BaseSizeDictionary =
//            [.fixedWheelMidDrive: 400.0,
//            .fixedWheelRearDrive: 400.0,
//            .fixedWheelFrontDrive:500.0]
//            let general = 400.0
//            return
//                dictionary[baseType] ?? general
//    }
//
//    func frontIfNoLeftAndRightSitOn()
//        -> Double {
//            let dictionary: BaseSizeDictionary =
//            [.fixedWheelMidDrive: 400.0,
//            .fixedWheelRearDrive: 400.0,
//            .fixedWheelFrontDrive:500.0]
//            let general = 400.0
//            return
//                dictionary[baseType] ?? general
//    }
//}




//typealias BaseSizeDictionary = [ObjectTypes: Double]



//MARK: DIMENSION
//struct WheelDefaultDimension {
//
//    let baseType: ObjectTypes
//
//    init ( _ baseType: ObjectTypes) {
//        self.baseType = baseType
//    }
//
//    func getFrontCasterWheel() -> Dimension3d {
//        let wheelSize = getFrontCasterRadius()
//
//        return
//            (width: wheelSize.width,
//             length: wheelSize.radius * 2,
//             height: wheelSize.radius * 2)
//    }
//
//    func getMidCasterWheel() -> Dimension3d {
//        let wheelSize = getFrontCasterRadius()
//
//        return
//            (width: wheelSize.width,
//             length: wheelSize.radius * 2,
//             height: wheelSize.radius * 2)
//    }
//
//    func getRearCasterWheel() -> Dimension3d {
//        let wheelSize = getRearCasterRadius()
//
//        return
//            (width: wheelSize.width,
//             length: wheelSize.radius * 2,
//             height: wheelSize.radius * 2)
//    }
//
//    func getFrontCasterRadius()  -> WheelSize {
//        let dictionary: BaseObjectWheelSizeDictionary =
//        [.allCasterStandAid: (radius: 25.0, width: 10.0)]
//        let general = (radius: 40.0, width: 20.0)
//        return
//            dictionary[baseType] ?? general
//    }
//
//    func getMidCasterRadius()  -> WheelSize {
//        let dictionary: BaseObjectWheelSizeDictionary =
//        [.allCasterStandAid: (radius: 25.0, width: 10.0)]
//        let general = (radius: 40.0, width: 20.0)
//        return
//            dictionary[baseType] ?? general
//    }
//
//    func getRearCasterRadius()  -> WheelSize {
//        let dictionary: BaseObjectWheelSizeDictionary =
//        [.allCasterStandAid: (radius: 25.0, width: 10.0)]
//        let general = (radius: 40.0, width: 40.0)
//        return
//            dictionary[baseType] ?? general
//    }
//
//    func getFrontCasterFork() -> Dimension3d {
//        let dictionary: BaseObject3DimensionDictionary  = [:]
//        let general = (width: 30.0, length: 150.0, height: 100.0)
//        return
//            dictionary[baseType] ?? general
//    }
//
//    func getMidCasterFork() -> Dimension3d {
//        let dictionary: BaseObject3DimensionDictionary  = [:]
//        let general = (width: 30.0, length: 150.0, height: 100.0)
//        return
//            dictionary[baseType] ?? general
//    }
//
//    func getRearCasterFork() -> Dimension3d {
//        let dictionary: BaseObject3DimensionDictionary  = [:]
//        let general = (width: 30.0, length: 150.0, height: 100.0)
//        return
//            dictionary[baseType] ?? general
//    }
//
//    func getFrontCasterTrail() -> Dimension3d {
//        let dictionary: BaseObject3DimensionDictionary  = [:]
//        let general = (width: 0.0, length: 20.0, height: 0.0)
//        return
//            dictionary[baseType] ?? general
//    }
//
//    func getMidCasterTrail() -> Dimension3d {
//        let dictionary: BaseObject3DimensionDictionary  = [:]
//        let general = (width: 0.0, length: 20.0, height: 0.0)
//        return
//            dictionary[baseType] ?? general
//    }
//
//    func getRearCasterTrail() -> Dimension3d {
//        let dictionary: BaseObject3DimensionDictionary  = [:]
//        let general = (width: 0.0, length: 20.0, height: 0.0)
//        return
//            dictionary[baseType] ?? general
//    }
//
//    func getFixed() -> Dimension3d {
//        let wheelSize = getFixedRadius()
//
//        return
//            (width: wheelSize.width,
//             length: wheelSize.radius * 2,
//             height: wheelSize.radius * 2)
//    }
//
//    func getFixedRadius() -> WheelSize {
//        let dictionary: BaseObjectWheelSizeDictionary =
//        [.fixedWheelManualRearDrive: (radius: 300.0, width: 20.0),
//         ]
//        let general = (radius: 125.0, width: 40.0)
//        return
//            dictionary[baseType] ?? general
//    }
//}


