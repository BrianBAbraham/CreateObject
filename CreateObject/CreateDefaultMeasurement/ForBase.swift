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


