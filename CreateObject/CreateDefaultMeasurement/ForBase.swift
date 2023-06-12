//
//  ForBase.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/06/2023.
//

import Foundation

struct RequestBaseDefaultDimensionDictionary {
    var dictionary: Part3DimensionDictionary = [:]
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions
    ) {
        getDictionary()

        func getDictionary() {
           
         let allOccupantBackRelated =
                AllOccupantBackRelated(
                    baseType
                )
                
            dictionary =
                CreateDefaultDimensionDictionary(
                    allOccupantBackRelated.parts,
                    allOccupantBackRelated.dimensions,
                    twinSitOnOptions
                ).dictionary
        }
    }
}

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

struct DistanceBetween {
    let baseType: BaseObjectTypes
    let twinSitOnOptions: TwinSitOnOptions
    let occupantBodySupportDefaultDimension: Dimension3d
    let stability  = Stability()
    let currentObjectDefaultDimensionDictionary: Part3DimensionDictionary
    //let ySitOnOrigin: [Double]
  


    init(_ baseType: BaseObjectTypes,
         _ twinSitOnOptions: TwinSitOnOptions,
         _ currentObjectDefaultDimensionDictionary: Part3DimensionDictionary = [:]) {
        self.baseType = baseType
        self.twinSitOnOptions = twinSitOnOptions
        self.currentObjectDefaultDimensionDictionary = currentObjectDefaultDimensionDictionary
        
        occupantBodySupportDefaultDimension =
            OccupantBodySupportDefaultDimension(
                .fixedWheelRearDrive).value
        
        //ySitOnOrigin
        
    }
    
    
    /// initially dic = [:] so dic[name] = nil
    /// latter not nil
    
    func frontToRearWheels()
        -> Double {
            var modifiedOrDefaultOccupantBodySupportLengths: [Double] = []
            let ids: [Part] = [.id0, .id1]
            for id in ids {
                modifiedOrDefaultOccupantBodySupportLengths.append(
                    currentObjectDefaultDimensionDictionary[
                        CreateNameFromParts([.sitOn, id,.stringLink,.object,.id0]).name]?.length ??
                    occupantBodySupportDefaultDimension.length )
            }
            
            let defaultFootHangerLinkLength =
                OccupantFootSupportHangerLinkDefaultDimension(baseType).value.length
            var modifiedOrDefaultFootHangerLinkLengths: [Double] = []
            
            for id in ids {
                modifiedOrDefaultFootHangerLinkLengths.append(
                    currentObjectDefaultDimensionDictionary[
                        CreateNameFromParts([.footSupportHangerLink, id,.stringLink,.sitOn,.id0]).name]?.length ??
                    defaultFootHangerLinkLength )
            }
            
            let maximumModifiedOrDefaultHangerLinkLength = modifiedOrDefaultFootHangerLinkLengths.max()!
            
             /// the additional  length includes the rear sitOn length and the maxximum footHangerLinkLength
            var general =
                modifiedOrDefaultOccupantBodySupportLengths[0] +
                stability.atRear +
                stability.atFront +
                    (twinSitOnOptions[.frontAndRear] ?? false
                     ?
                    modifiedOrDefaultOccupantBodySupportLengths[1] +
                    maximumModifiedOrDefaultHangerLinkLength:
                    0.0)
            
            let dictionary: BaseSizeDictionary =
                [
                .allCasterHoist: 1200.0,
                .allCasterTiltInSpaceShowerChair: 600.0]
           
            return
                dictionary[baseType] ?? general
    }
    
    func midToRearWheels()
        -> Double {
            let dictionary: BaseSizeDictionary =
                [.fixedWheelMidDrive: 300.0]
            let general = 0.0
            return
                dictionary[baseType] ?? general
    }
    
    func rearWheels()
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
    
    func midWheels()
        -> Double {
            let dictionary: BaseSizeDictionary =
            [.fixedWheelMidDrive: 500.0]
            let general = 0.0
            return
                dictionary[baseType] ?? general
    }
    
    func frontWheels()
        -> Double {
            let dictionary: BaseSizeDictionary =
            [.fixedWheelMidDrive: 400.0,
            .fixedWheelRearDrive: 400.0,
            .fixedWheelFrontDrive:500.0]
            let general = 400.0
            return
                dictionary[baseType] ?? general
    }
    
    
//    func adjustmentForFrontAndRearSitOn (_ standardSize: Double)
//        -> Double {
//
//        if twinSitOnOptions[.frontAndRear] ?? false {
//            switch baseType {
//
//            case .fixedWheelFrontDrive:
//                return standardSize
//            case .fixedWheelMidDrive:
//                return standardSize
//            case .fixedWheelRearDrive:
//                return standardSize
//            case .fixedWheelManualRearDrive:
//                return standardSize
//            case .fixedWheelSolo:
//                return standardSize
//
//            default:return standardSize
//            }
//        }
//    }
    
}


struct Stability {
    
    let dictionary: BaseObjectDoubleDictionary = [:]
    let atRear = 0.0
    let atFront = 0.0
    let atLeft = 0.0
    let atRight = 0.0
}


