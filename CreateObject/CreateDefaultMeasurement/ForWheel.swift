//
//  ForWheel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/06/2023.
//

import Foundation



struct AllWheelRelated {
    var parts: [Part] = []
    var defaultDimensions: [Dimension3d] = []
    var defaultRearMidFrontDimension = ZeroValue.dimension3dRearMidFront
    let wheelDefaultDimension: WheelDefaultDimension
    
    let rearCasterForkDimension: Dimension3d
    let rearCasterWheelDimension: Dimension3d
    let rearCaster: [Dimension3d]
    let frontCasterForkDimension: Dimension3d
    let frontCasterWheelDimension: Dimension3d
    let frontCaster: [Dimension3d]
    let fixedWheelAndJoint: [Dimension3d]
    

    
    init(_ baseType: ObjectTypes) {
        wheelDefaultDimension = WheelDefaultDimension(baseType)
        
        
        rearCasterForkDimension = wheelDefaultDimension.getRearCasterFork()
        rearCasterWheelDimension = wheelDefaultDimension.getRearCasterWheel()
        rearCaster =
            [Joint.dimension3d, rearCasterForkDimension, rearCasterWheelDimension]
        frontCasterForkDimension = wheelDefaultDimension.getFrontCasterFork()
        frontCasterWheelDimension = wheelDefaultDimension.getFrontCasterWheel()
        frontCaster =
            [Joint.dimension3d, frontCasterForkDimension, frontCasterWheelDimension]
        fixedWheelAndJoint = [Joint.dimension3d, wheelDefaultDimension.getFixed()]
        
//        let fourCaster =
//        getDimensionsForFourCaster(PartGroup.fourCasterParts)

        switch baseType {
        case .allCasterBed:
            defaultRearMidFrontDimension =
                getForFourCaster()
            case .allCasterChair:
            defaultRearMidFrontDimension =
                getForFourCaster()
            case .allCasterHoist:
            defaultRearMidFrontDimension =
                getForFourCaster()
//        case .allCasterSixHoist:
//            parts = PartGroup.sixCasterParts
        case .allCasterTiltInSpaceShowerChair:
            defaultRearMidFrontDimension =
                getForFourCaster()
//            parts = PartGroup.fourCasterParts
//            defaultDimensions = fourCaster
//        case .allCasterStandAid:
//            parts = PartGroup.fourCasterParts
//            defaultDimensions = fourCaster
        case .allCasterStretcher:
            defaultRearMidFrontDimension =
                getForFourCaster()
        case .fixedWheelFrontDrive:
            defaultRearMidFrontDimension =
                getForFixedWheelFrontDrive ()
        case .fixedWheelMidDrive:
            defaultRearMidFrontDimension =
                getForFixedWheelMidDrive ()
        
        case .fixedWheelRearDrive:
            defaultRearMidFrontDimension =
                getForFixedWheelRearDrive ()
        
        case .fixedWheelManualRearDrive:
            defaultRearMidFrontDimension =
                getForFixedWheelRearDrive ()

        default:
            break
        }
    }
        
//    func getDimensionsForFourCaster(_ parts: [Part])
//        -> [Dimension3d] {
//            getTwoCaster(
//                wheelDefaultDimension.getRearCasterFork, wheelDefaultDimension.getRearCasterWheel)
//            +
//            getTwoCaster(
//                wheelDefaultDimension.getFrontCasterFork, wheelDefaultDimension.getFrontCasterWheel)
//    }
//
//    func getDimensionsForSixCaster(_ parts: [Part])
//        -> [Dimension3d] {
//            getTwoCaster(
//                wheelDefaultDimension.getRearCasterFork, wheelDefaultDimension.getRearCasterWheel)
//            +
//            getTwoCaster(
//                wheelDefaultDimension.getMidCasterFork, wheelDefaultDimension.getMidCasterWheel)
//            +
//            getTwoCaster(
//                wheelDefaultDimension.getFrontCasterFork, wheelDefaultDimension.getFrontCasterWheel)
//    }
//
//    func getTwoFixedWheels()
//        -> [Dimension3d] {
//        var dimensions: [Dimension3d] = []
//        for part in PartGroup.twoFixedWheelParts {
//            switch part {
//            case .baseWheelJoint:
//                dimensions.append(Joint.dimension3d)
//
//            case .fixedWheel:
//                dimensions.append(wheelDefaultDimension.getFixed())
//
//            default:
//                break
//            }
//
//        }
//            return dimensions
//    }
    
    
    func getForFixedWheelFrontDrive ()
    -> Dimension3dRearMidFront {
        let rear = rearCaster
        let mid: [Dimension3d] = []
        let front =
            fixedWheelAndJoint
        return
            (rear: rear,  mid: mid, front: front )
    }
    
    func getForFixedWheelMidDrive ()
    -> Dimension3dRearMidFront {
        let rear =
                rearCaster
        let mid = fixedWheelAndJoint
        let front =
                frontCaster
        return
            (rear: rear,  mid: mid, front: front )
    }
    
    func getForFixedWheelRearDrive ()
    -> Dimension3dRearMidFront {
        let rear =
            fixedWheelAndJoint
        
        let mid: [Dimension3d] = []
        let front =
            frontCaster
        return
            (rear: rear,  mid: mid, front: front )
    }
    
        func getForFourCaster ()
        -> Dimension3dRearMidFront {
            let rear =
                rearCaster
            let mid: [Dimension3d] = []
            let front =
                frontCaster
            return
                (rear: rear,  mid: mid, front: front )
        }
    
//    func getTwoCaster(
//        _ fork: () -> Dimension3d,
//        _ wheel: () -> Dimension3d)
//        -> [Dimension3d] {
//        var dimensions: [Dimension3d] = []
//        for part in PartGroup.twoCasterParts {
//            switch part {
//            case .baseWheelJoint:
//                dimensions.append(Joint.dimension3d)
//
//            case .casterFork:
//                dimensions.append(fork())
//
//            case .casterWheel:
//                dimensions.append(wheel())
//
//            default:
//                break
//            }
//
//        }
//            return dimensions
//    }
//
}


//struct BaseDefaultDimension {
//    var dictionary: BaseObject3DimensionDictionary =
//    [.allCasterBed: (length: 2200.0, width: 900.0, height: 40.0),
//     .allCasterChair: (length: 500.0, width: 500.0, height: 20.0),
//     .allCasterHoist: (length: 1200.0, width: 600.0, height: 40.0),
//     .allCasterTiltInSpaceShowerChair:  (length: 600.0, width: 500.0, height: 20.0),
//     .allCasterStretcher: (length: 1800.0, width: 600.0, height: 40.0),
//     .scooterFrontDrive3Wheeler: (length: 800.0, width: 600.0, height: 20.0)
//
//        ]
//    static let general = (length: 500.0, width: 500.0, height: 20.0)
//    let value: Dimension3d
//
//    init(_ baseType: BaseObjectTypes) {
//        value = dictionary[baseType] ?? Self.general
//    }
//}


//struct BaseNarrowDefaultDimension {
//    var dictionary: BaseObject3DimensionDictionary =
//    [ .fixedWheelMidDrive: (length: Self.general.length, width: Self.general.width * 0.8, height: Self.general.height)
//        ]
//    static let general = BaseDefaultDimension(.fixedWheelRearDrive).value
//    let value: Dimension3d
//
//    init(_ baseType: BaseObjectTypes) {
//        value = dictionary[baseType] ?? Self.general
//    }
//}



typealias BaseSizeDictionary = [ObjectTypes: Double]



    struct Stability {
        
        let dictionary: BaseObjectDoubleDictionary = [:]
        let atRear = 0.0
        let atFront = 0.0
        let atLeft = 0.0
        let atRight = 0.0
        let baseType: ObjectTypes
        
        init(_ baseType: ObjectTypes) {
            self.baseType = baseType
        }
    }

/// The length between wheels
/// or the width between wheels
/// taking account of side by side seats
/// or front and rear seats
/// and if there is a mid-wheel
struct DistanceBetweenWheels {
    var ifNoFrontAndRearSitOn: Double = 0.0
    var ifFrontAndRearSitOn: Double = 0.0
    let occupantBodySupport: [Dimension3d]
    let occupantFootSupportHangerLink: [Dimension3d]
    let stability: Stability
    let baseType: ObjectTypes
    
    init (
        _ baseType: ObjectTypes,
        _ occupantBodySupportsDimension: [Dimension3d],
        _ occupantFootSupportHangerLinksDimension: [Dimension3d] ){
            self.baseType = baseType
            
            stability = Stability(baseType)
            
            occupantBodySupport =
                occupantBodySupportsDimension
            
            occupantFootSupportHangerLink =
                occupantFootSupportHangerLinksDimension
            
            if occupantBodySupportsDimension.count == 2 {
                ifFrontAndRearSitOn =
                    frontRearIfFrontAndRearSitOn()
            } else {
                ifNoFrontAndRearSitOn =
                    frontRearIfNoFrontAndRearSitOn()
            }
           
    }
    
    func frontRearIfNoFrontAndRearSitOn()
        -> Double {
        stability.atRear +
        occupantBodySupport[0].length +
        stability.atFront
    }
        
    func frontRearIfFrontAndRearSitOn ()
        -> Double {
        frontRearIfNoFrontAndRearSitOn() +
        occupantFootSupportHangerLink[0].length +
        occupantBodySupport[1].length
    }
    
    
    func rearIfLeftAndRightSitOn()
        -> Double {
            let dictionary: BaseSizeDictionary =
            [.allCasterHoist: 600.0,
            .fixedWheelMidDrive: 300.0,
            .fixedWheelRearDrive: 500.0,
            .fixedWheelFrontDrive: 400.0,
             .fixedWheelManualRearDrive: 500.0]
            let general = 400.0
            return
                dictionary[baseType] ?? general
    }
    
    func rearIfNoLeftAndRightSitOn()
        -> Double {
            let dictionary: BaseSizeDictionary =
            [.allCasterHoist: 600.0,
            .fixedWheelMidDrive: 300.0,
            .fixedWheelRearDrive: 500.0,
            .fixedWheelFrontDrive: 400.0,
             .fixedWheelManualRearDrive: 500.0]
            let general = 400.0
            return
                dictionary[baseType] ?? general
    }
    
    func midIfLeftAndRightSitOn()
        -> Double {
            let dictionary: BaseSizeDictionary =
            [.fixedWheelMidDrive: 500.0]
            let general = 0.0
            return
                dictionary[baseType] ?? general
    }
    
    func midIfNoLeftAndRightSitOn()
        -> Double {
            let dictionary: BaseSizeDictionary =
            [.fixedWheelMidDrive: 500.0]
            let general = 0.0
            return
                dictionary[baseType] ?? general
    }
    
    func frontIfLeftAndRightSitOn()
        -> Double {
            let dictionary: BaseSizeDictionary =
            [.fixedWheelMidDrive: 400.0,
            .fixedWheelRearDrive: 400.0,
            .fixedWheelFrontDrive:500.0]
            let general = 400.0
            return
                dictionary[baseType] ?? general
    }
    
    func frontIfNoLeftAndRightSitOn()
        -> Double {
            let dictionary: BaseSizeDictionary =
            [.fixedWheelMidDrive: 400.0,
            .fixedWheelRearDrive: 400.0,
            .fixedWheelFrontDrive:500.0]
            let general = 400.0
            return
                dictionary[baseType] ?? general
    }
}


//MARK: DIMENSION
struct WheelDefaultDimension {
    
    let baseType: ObjectTypes
        
    init ( _ baseType: ObjectTypes) {
        self.baseType = baseType
    }
    
    func getFrontCasterWheel() -> Dimension3d {
        let wheelSize = getFrontCasterRadius()
        
        return
            (width: wheelSize.width,
             length: wheelSize.radius * 2,
             height: wheelSize.radius * 2)
    }
    
    func getMidCasterWheel() -> Dimension3d {
        let wheelSize = getFrontCasterRadius()
        
        return
            (width: wheelSize.width,
             length: wheelSize.radius * 2,
             height: wheelSize.radius * 2)
    }
    
    func getRearCasterWheel() -> Dimension3d {
        let wheelSize = getRearCasterRadius()
        
        return
            (width: wheelSize.width,
             length: wheelSize.radius * 2,
             height: wheelSize.radius * 2)
    }
    
    func getFrontCasterRadius()  -> WheelSize {
        let dictionary: BaseObjectWheelSizeDictionary =
        [.allCasterStandAid: (radius: 25.0, width: 10.0)]
        let general = (radius: 40.0, width: 20.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getMidCasterRadius()  -> WheelSize {
        let dictionary: BaseObjectWheelSizeDictionary =
        [.allCasterStandAid: (radius: 25.0, width: 10.0)]
        let general = (radius: 40.0, width: 20.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getRearCasterRadius()  -> WheelSize {
        let dictionary: BaseObjectWheelSizeDictionary =
        [.allCasterStandAid: (radius: 25.0, width: 10.0)]
        let general = (radius: 40.0, width: 40.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getFrontCasterFork() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = (width: 30.0, length: 150.0, height: 100.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getMidCasterFork() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = (width: 30.0, length: 150.0, height: 100.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getRearCasterFork() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = (width: 30.0, length: 150.0, height: 100.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getFrontCasterTrail() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = (width: 0.0, length: 20.0, height: 0.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getMidCasterTrail() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = (width: 0.0, length: 20.0, height: 0.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getRearCasterTrail() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = (width: 0.0, length: 20.0, height: 0.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getFixed() -> Dimension3d {
        let wheelSize = getFixedRadius()
        
        return
            (width: wheelSize.width,
             length: wheelSize.radius * 2,
             height: wheelSize.radius * 2)
    }
    
    func getFixedRadius() -> WheelSize {
        let dictionary: BaseObjectWheelSizeDictionary =
        [.fixedWheelManualRearDrive: (radius: 300.0, width: 20.0),
         ]
        let general = (radius: 125.0, width: 40.0)
        return
            dictionary[baseType] ?? general
    }
}



//MARK: ORIGIN
/// The array of fixed wheel or caster vertical origin
/// is ordered rearmost left (UI left top screen as viewed), rearmost right
/// moving towards bottom of screen
struct WheelAndCasterVerticalJointOrigin {
    let baseType: ObjectTypes
    let lengthBetweenFrontAndRearWheels: Double
    let widthBetweeenWheelsOnOrigin: Double
    let wheelDimension: WheelDefaultDimension
    let rearCasterJointAboveFloor: Double
    let frontCasterJointAboveFloor: Double
    
    init (
            _ baseType: ObjectTypes,
            _ lengthBetweenFrontRearWheels: Double,
            _ widthBetweeenWheelsOnOrigin: Double) {
        
                self.baseType = baseType
                self.lengthBetweenFrontAndRearWheels = lengthBetweenFrontRearWheels
                self.widthBetweeenWheelsOnOrigin =
                    widthBetweeenWheelsOnOrigin
                wheelDimension = WheelDefaultDimension(baseType)
                rearCasterJointAboveFloor =
                    wheelDimension.getRearCasterRadius().radius +
                    wheelDimension.getRearCasterFork().height
                frontCasterJointAboveFloor =
                    wheelDimension.getFrontCasterRadius().radius +
                    wheelDimension.getFrontCasterFork().height
                
    }
    
    func getRightDriveWheel()
        -> PositionAsIosAxes {
            (
            x: widthBetweeenWheelsOnOrigin/2,
            y: 0.0,
            z: wheelDimension.getFixedRadius().radius)
    }
    
    func getSteerableWheelAtRear()
        -> PositionAsIosAxes {
            (
            x: 0.0,
            y: lengthBetweenFrontAndRearWheels,
            z: wheelDimension.getFixedRadius().radius)
    }
    
    func getSteerableWheelAtFront()
        -> PositionAsIosAxes {
            (
            x: 0.0,
            y: -lengthBetweenFrontAndRearWheels,
            z: wheelDimension.getFixedRadius().radius)
    }
    
    func getRearCasterWhenRearPrimaryOrigin()
        -> PositionAsIosAxes {
            (x: getRightDriveWheel().x,
             y: 0.0,
             z: rearCasterJointAboveFloor)
    }
    
    func getMidCasterWhenRearPrimaryOrigin()
        -> PositionAsIosAxes {
            (x: getRightDriveWheel().x,
             y: lengthBetweenFrontAndRearWheels/2,
             z: rearCasterJointAboveFloor)
    }
    
    
    func getFrontCasterWhenRearPrimaryOrigin()
        -> PositionAsIosAxes {
             (
            x: widthBetweeenWheelsOnOrigin/2,
            y: lengthBetweenFrontAndRearWheels,
            z: frontCasterJointAboveFloor)
    }
    
    //MAARK- REQUIRES OWN z value
    func getRearCasterWhenMidPrimaryOrigin()
    -> PositionAsIosAxes {
            (
                x: widthBetweeenWheelsOnOrigin/2.5,
            y: -lengthBetweenFrontAndRearWheels/2,
            z: rearCasterJointAboveFloor)
    }
    
    
    func getFrontCasterWhenMidPrimaryOrigin()
    -> PositionAsIosAxes {
            (
            x: widthBetweeenWheelsOnOrigin/2,
            y: lengthBetweenFrontAndRearWheels/2,
            z: frontCasterJointAboveFloor)
    }
    
    func getRearCasterWhenFrontPrimaryOrigin()
    -> PositionAsIosAxes {
            (
            x: widthBetweeenWheelsOnOrigin/2,
            y: -lengthBetweenFrontAndRearWheels,
            z: rearCasterJointAboveFloor)
    }
}

struct CasterOrigin {
    
    let baseType: ObjectTypes
        
    init ( _ baseType: ObjectTypes) {
        self.baseType = baseType
    }
    
    func forFrontCasterVerticalJointToFork()
        -> PositionAsIosAxes {
            
        let casterForkDimension =
            WheelDefaultDimension(baseType).getFrontCasterFork()
        let casterTrailDimension =
            WheelDefaultDimension(baseType).getFrontCasterTrail()
        return
            (
                x: 0.0,
                y: -(casterForkDimension.length + casterTrailDimension.length)/2,
                z: -casterForkDimension.height/2)
    }
    
    func forMidCasterVerticalJointToFork()
        -> PositionAsIosAxes {
            
        let casterForkDimension =
            WheelDefaultDimension(baseType).getMidCasterFork()
        let casterTrailDimension =
            WheelDefaultDimension(baseType).getMidCasterTrail()
        return
            (
                x: 0.0,
                y: -(casterForkDimension.length + casterTrailDimension.length)/2,
                z: -casterForkDimension.height/2)
    }
    
    func forRearCasterVerticalJointToFork()
        -> PositionAsIosAxes {
            
        let casterForkDimension =
            WheelDefaultDimension(baseType).getRearCasterFork()
        let casterTrailDimension =
            WheelDefaultDimension(baseType).getRearCasterTrail()
        return
            (
                x: 0.0,
                y: -(casterForkDimension.length + casterTrailDimension.length)/2,
                z: -casterForkDimension.height/2)
    }
    
    
    func forFrontCasterForkToWheel()
        -> PositionAsIosAxes {
            
        let casterWheelDimension =
            WheelDefaultDimension(baseType).getFrontCasterWheel()
        return
            (
                x: 0.0,
                y: 0.0,
                z: -casterWheelDimension.height/2)
    }
    
    func forMidCasterForkToWheel()
        -> PositionAsIosAxes {
            
        let casterWheelDimension =
            WheelDefaultDimension(baseType).getMidCasterWheel()
        return
            (
                x: 0.0,
                y: 0.0,
                z: -casterWheelDimension.height/2)
    }
    
    func forRearCasterForkToWheel()
        -> PositionAsIosAxes {
            
        let casterWheelDimension =
            WheelDefaultDimension(baseType).getRearCasterWheel()
        return
            (
                x: 0.0,
                y: 0.0,
                z: -casterWheelDimension.height/2)
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
