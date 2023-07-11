//
//  ForBase.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/06/2023.
//

import Foundation



struct AllBaseRelated {
    let parts: [Part]
    let dimensions: [Dimension3d]
    init(_ baseType: BaseObjectTypes) {
        parts = [
        
        ]
        
        dimensions = [
        
        ]
    }
    
    
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



typealias BaseSizeDictionary = [BaseObjectTypes: Double]





/// Dimensions for  support determine the length
struct LengthBetween {
    var ifNoFrontAndRearSitOn: Double = 0.0
    var ifFrontAndRearSitOn: Double = 0.0
    let occupantBodySupport: [Dimension3d]
    let occupantFootSupportHangerLink: [Dimension3d]
    let stability: Stability
    let baseType: BaseObjectTypes
    
    init (
        _ baseType: BaseObjectTypes,
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
struct WheelDimension {
    
    let baseType: BaseObjectTypes
        
    init ( _ baseType: BaseObjectTypes) {
        self.baseType = baseType
    }
    
    func getFrontCasterDimension() -> Dimension3d {
        let wheelSize = getFrontCasterRadius()
        
        return
            (width: wheelSize.width,
             length: wheelSize.radius * 2,
             height: wheelSize.radius * 2)
    }
    
    func getMidCasterDimension() -> Dimension3d {
        let wheelSize = getFrontCasterRadius()
        
        return
            (width: wheelSize.width,
             length: wheelSize.radius * 2,
             height: wheelSize.radius * 2)
    }
    
    func getRearCasterDimension() -> Dimension3d {
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
        let general = (radius: 40.0, width: 20.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getFrontCasterFork() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = (width: 30.0, length: 150.0, height: 20.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getMidCasterFork() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = (width: 30.0, length: 150.0, height: 20.0)
        return
            dictionary[baseType] ?? general
    }
    
    func getRearCasterFork() -> Dimension3d {
        let dictionary: BaseObject3DimensionDictionary  = [:]
        let general = (width: 30.0, length: 150.0, height: 20.0)
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
        [.fixedWheelManualRearDrive: (radius: 300.0, width: 20.0)]
        let general = (radius: 125.0, width: 40.0)
        return
            dictionary[baseType] ?? general
    }
}



//MARK: ORIGIN
/// The array of fixed wheel or caster vertical origin
/// is ordered rear most left (UI left top screen as viewed), rearmost right
/// moving towards bottom of screen
struct WheelAndCasterVerticalJointOrigin {
    let baseType: BaseObjectTypes
    let lengthBetweenFrontAndRearWheels: Double
    let widthBetweeenWheelsOnOrigin: Double
    
    init (
            _ baseType: BaseObjectTypes,
            _ lengthBetweenFrontRearWheels: Double,
            _ widthBetweeenWheelsOnOrigin: Double) {
        
                self.baseType = baseType
                self.lengthBetweenFrontAndRearWheels = lengthBetweenFrontRearWheels
                self.widthBetweeenWheelsOnOrigin =
                    widthBetweeenWheelsOnOrigin
                
    }
    
    func getDriveWheels()
        -> [PositionAsIosAxes] {
        //getLeftAndRightSide(
            [(
            x: widthBetweeenWheelsOnOrigin/2,
            y: 0.0,
            z: WheelDimension(baseType).getFixedRadius().radius)
             ]
        //)
    }
    
    func getSteerWheel()
    -> [PositionAsIosAxes] {
        baseType == .scooterRearDrive3Wheeler ?
        [(
            x: 0.0,
            y: -lengthBetweenFrontAndRearWheels,
            z: WheelDimension(baseType).getFixedRadius().radius)
        ] :
        [(
            x: 0.0,
            y: lengthBetweenFrontAndRearWheels,
            z: WheelDimension(baseType).getFixedRadius().radius)
        ]
        
    }
    
    func getCasterwhenRearPrimaryOrigin()
    -> [PositionAsIosAxes] {
        //getLeftAndRightSide(
            [(
            x: widthBetweeenWheelsOnOrigin/2,
            y: lengthBetweenFrontAndRearWheels,
            z: WheelDimension(baseType).getFrontCasterRadius().radius)
             ]
        //)
    }
    
    func getCasterWhenAllCaster()
    -> [PositionAsIosAxes] {
        //getLeftAndRightSide(
            [(
            x: widthBetweeenWheelsOnOrigin/2,
            y: 0,
            z: WheelDimension(baseType).getFrontCasterRadius().radius),
             (
            x: widthBetweeenWheelsOnOrigin/2,
            y: lengthBetweenFrontAndRearWheels,
            z: WheelDimension(baseType).getFrontCasterRadius().radius) ]
        //)
    }
    
    func getCasterWhenAllSixCaster()
    -> [PositionAsIosAxes] {
            //getLeftAndRightSide(
            getCasterWhenAllCaster() +
            [(
            x: widthBetweeenWheelsOnOrigin/2,
            y: lengthBetweenFrontAndRearWheels/2,
            z: WheelDimension(baseType).getFrontCasterRadius().radius)]
        //)
    }
    
    func getCasterWhenMidPrimaryOrigin()
    -> [PositionAsIosAxes] {
        //getLeftAndRightSide(
            [(
            x: widthBetweeenWheelsOnOrigin/2,
            y: -lengthBetweenFrontAndRearWheels/2,
            z: WheelDimension(baseType).getFrontCasterRadius().radius),
            (
            x: widthBetweeenWheelsOnOrigin/2,
            y: lengthBetweenFrontAndRearWheels/2,
            z: WheelDimension(baseType).getFrontCasterRadius().radius)]
        //)
    }
    
    func getCasterWhenFrontPrimaryOrgin()
    -> [PositionAsIosAxes] {
        //getLeftAndRightSide(
            [(
            x: widthBetweeenWheelsOnOrigin/2,
            y: -lengthBetweenFrontAndRearWheels,
            z: WheelDimension(baseType).getFrontCasterRadius().radius)
             ]
       // )
    }
    
//s
}

struct CasterOrigin {
    
    let baseType: BaseObjectTypes
        
    init ( _ baseType: BaseObjectTypes) {
        self.baseType = baseType
    }
    
    func forFrontCasterVerticalJointToFork()
        -> PositionAsIosAxes {
            
        let casterForkDimension =
            WheelDimension(baseType).getFrontCasterFork()
        let casterTrailDimension =
            WheelDimension(baseType).getFrontCasterTrail()
        return
            (
                x: 0.0,
                y: -(casterForkDimension.length + casterTrailDimension.length)/2,
                z: -casterForkDimension.height/2)
    }
    
    func forMidCasterVerticalJointToFork()
        -> PositionAsIosAxes {
            
        let casterForkDimension =
            WheelDimension(baseType).getMidCasterFork()
        let casterTrailDimension =
            WheelDimension(baseType).getMidCasterTrail()
        return
            (
                x: 0.0,
                y: -(casterForkDimension.length + casterTrailDimension.length)/2,
                z: -casterForkDimension.height/2)
    }
    
    func forRearCasterVerticalJointToFork()
        -> PositionAsIosAxes {
            
        let casterForkDimension =
            WheelDimension(baseType).getRearCasterFork()
        let casterTrailDimension =
            WheelDimension(baseType).getRearCasterTrail()
        return
            (
                x: 0.0,
                y: -(casterForkDimension.length + casterTrailDimension.length)/2,
                z: -casterForkDimension.height/2)
    }
    
    
    func forFrontCasterForkToWheel()
        -> PositionAsIosAxes {
            
        let casterWheelDimension =
            WheelDimension(baseType).getFrontCasterDimension()
        return
            (
                x: 0.0,
                y: 0.0,
                z: -casterWheelDimension.height/2)
    }
    
    func forMidCasterForkToWheel()
        -> PositionAsIosAxes {
            
        let casterWheelDimension =
            WheelDimension(baseType).getMidCasterDimension()
        return
            (
                x: 0.0,
                y: 0.0,
                z: -casterWheelDimension.height/2)
    }
    
    func forRearCasterForkToWheel()
        -> PositionAsIosAxes {
            
        let casterWheelDimension =
            WheelDimension(baseType).getRearCasterDimension()
        return
            (
                x: 0.0,
                y: 0.0,
                z: -casterWheelDimension.height/2)
    }
}


struct Stability {
    
    let dictionary: BaseObjectDoubleDictionary = [:]
    let atRear = 0.0
    let atFront = 0.0
    let atLeft = 0.0
    let atRight = 0.0
    let baseType: BaseObjectTypes
    
    init(_ baseType: BaseObjectTypes) {
        self.baseType = baseType
    }
}


