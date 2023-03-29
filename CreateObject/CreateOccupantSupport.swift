//
//  CreateSitOrStand.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/01/2023.
//

import Foundation


struct InitialCasterChairMeasure {
    let bodySuppport: Dimension
    let sideSupport: Dimension
    let footSupport: Dimension
}


struct InitialOccupantBodySupportMeasure {

    let lieOn: Dimension
    let overHead: Dimension
    let sitOn: Dimension
    let sleepOn: Dimension
    let standOn: Dimension
    
    init(
        lieOn: Dimension = (length: 1600 ,width: 600),
        sitOn: Dimension = (length: 500 ,width: 400),
        overHead: Dimension = (length: 40 ,width: 600),
        sleepOn: Dimension = (length: 1800 ,width: 900),
        standOn: Dimension = (length: 300 ,width: 500)) {
        self.lieOn = lieOn
        self.overHead = overHead
        self.sitOn = sitOn
        self.sleepOn = sleepOn
        self.standOn = standOn
    }
}



struct CreateOccupantSupport {
    let allBodySupportFromPrimaryOrigin: [PositionAsIosAxes]
    var armSupportRequired: Bool
    let baseType: BaseObjectTypes
    let baseToOccupantSupportJoint: [JointType]
    var bodySupportRequired = true
    var dictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE

    
    var footSupportRequired: Bool
    let initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure
    
    let numberOfOccupantSupport: OccupantSupportNumber
    let occupantSupportTypes: [OccupantSupportTypes]
    var occupantSupportMeasure: Dimension
    let occupantSupportMeasures: InitialOccupantBodySupportMeasure =
        InitialOccupantBodySupportMeasure()
    var overheadSupportRequired = false
    let allBodySupportCorners: [[PositionAsIosAxes]]
    
    init(
        _ baseType: BaseObjectTypes,
        _ baseToOccupantSupportJoint: [JointType],
        _ numberOfOccupantSupport: OccupantSupportNumber = .one,
        _ occupantSupportTypes: [OccupantSupportTypes],
        _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure
    ) {
        self.baseType = baseType
        self.baseToOccupantSupportJoint = baseToOccupantSupportJoint
        self.numberOfOccupantSupport = numberOfOccupantSupport
        self.occupantSupportTypes = occupantSupportTypes
        self.initialOccupantBodySupportMeasure = initialOccupantBodySupportMeasure
        
        
        switch baseType {
            case .allCasterChair:
                occupantSupportMeasure = occupantSupportMeasures.sitOn
                footSupportRequired = true
                armSupportRequired = true
            case .allCasterBed:
                occupantSupportMeasure = occupantSupportMeasures.sleepOn
                footSupportRequired = false
                armSupportRequired = false
            case .allCasterStretcher:
                occupantSupportMeasure = occupantSupportMeasures.lieOn
                footSupportRequired = false
                armSupportRequired = false
            case .allCasterHoist:
                occupantSupportMeasure = occupantSupportMeasures.sitOn
                overheadSupportRequired = true
                bodySupportRequired = false
                footSupportRequired = false
                armSupportRequired = false
            default:
                occupantSupportMeasure = occupantSupportMeasures.sitOn
                footSupportRequired = true
                armSupportRequired = true
        }
        

        
        allBodySupportFromPrimaryOrigin =
        getAllBodySuppportFromPrimaryOrigin(
            occupantSupportTypes,
            initialOccupantBodySupportMeasure
        )

        func getAllBodySuppportFromPrimaryOrigin(
            _ occupantSupportTypes: [OccupantSupportTypes],
            _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure)
        -> [PositionAsIosAxes] {
            var fromPrimaryToSitOnOrigins: [PositionAsIosAxes] = []
            for supportIndex in 0..<occupantSupportTypes.count {
                fromPrimaryToSitOnOrigins.append(
                    getOneBodySupportFromPrimaryOrigin(
                        supportIndex,
                        initialOccupantBodySupportMeasure)
                    )
                }
            return
                fromPrimaryToSitOnOrigins
        }
        
        
        allBodySupportCorners =
        getAllBodySupportFromPrimaryOriginCorners(
            allBodySupportFromPrimaryOrigin,
            occupantSupportMeasure.length,
            occupantSupportMeasure.width)

        func getAllBodySupportFromPrimaryOriginCorners(
            _ fromPrimaryToSitOnOrigins: [PositionAsIosAxes],
            _ length: Double,
            _ width: Double )
        -> [[PositionAsIosAxes]] {
            var oneOrTwoSitOnPartCorners:[[PositionAsIosAxes]]  = []
            for supportIndex in 0..<occupantSupportTypes.count {
                    oneOrTwoSitOnPartCorners.append(
                    PartCornerLocationFrom(
                       length,
                        fromPrimaryToSitOnOrigins[supportIndex],
                        width).primaryOrigin
                    )
                }
            return oneOrTwoSitOnPartCorners
        }
        
        for supportIndex in 0..<occupantSupportTypes.count {
            getDictionary(supportIndex)
        }
        
        
        func getDictionary(
            _ supportIndex: Int){
                
            if footSupportRequired {
                let occupantFootSupport =
                    CreateOccupantFootSupport(
                        allBodySupportFromPrimaryOrigin,
                        supportIndex,
                        initialOccupantBodySupportMeasure
                    )
                
                    dictionary +=
                    occupantFootSupport.dictionary
            }

            if armSupportRequired {
                let occupantSideSuppport =
                CreateOccupantSideSupport(
                    allBodySupportFromPrimaryOrigin,
                    supportIndex
                )
                
                dictionary +=
                occupantSideSuppport.dictionary
            }
            
            if bodySupportRequired {
                let bodySupportDictionary =
                CreateOccupantBodySupport (
                    allBodySupportFromPrimaryOrigin[supportIndex],
                    allBodySupportCorners [supportIndex],
                    supportIndex,
                    baseType
                    ).dictionary
                    
                dictionary += bodySupportDictionary
            }
                
            if overheadSupportRequired {
                let allOverHeadSupportCorners =
                getAllBodySupportFromPrimaryOriginCorners(
                    allBodySupportFromPrimaryOrigin,
                    occupantSupportMeasures.overHead.length,
                    occupantSupportMeasures.overHead.width)
                
                let overHeadSupportDictionary =
                CreateOccupantBodySupport (
                    allBodySupportFromPrimaryOrigin[supportIndex],
                    allBodySupportCorners [supportIndex],
                    supportIndex,
                    baseType
                    ).dictionary
                    
                dictionary += overHeadSupportDictionary
            }

        }

//        func getAllOverHeadSupportFromPrimaryOriginCorners(
//            _ allBodySupportFromPrimaryOrigin: [PositionAsIosAxes],
//            _ overHeadSupportMeasure: Dimension) {
//
//            }
        
        
        func getOneBodySupportFromPrimaryOrigin(
            _ supportIndex: Int,
            _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure)
        -> PositionAsIosAxes {

            var occupantBodySupportFromPrimaryOrigin: PositionAsIosAxes = Globalx.iosLocation
            let halfLength = initialOccupantBodySupportMeasure.sitOn.length/2
            var bodySupportlengthFromPrimaryOrigin: Double = 0

            if baseType.rawValue.contains(BaseObjectGroups.fixedWheel.rawValue) {

                switch baseType {
                    case .fixedWheelFrontDrive:
                        bodySupportlengthFromPrimaryOrigin = -halfLength

                    case .fixedWheelMidDrive:
                        bodySupportlengthFromPrimaryOrigin = 0

                    case .fixedWheelRearDrive:
                        bodySupportlengthFromPrimaryOrigin = halfLength

                    default:
                        bodySupportlengthFromPrimaryOrigin = halfLength
                }
                occupantBodySupportFromPrimaryOrigin =
                    getAllBodySupportFromPrimaryOriginAccountForAllSitOn(
                        supportIndex,
                        bodySupportlengthFromPrimaryOrigin)
            }
            
            

            if baseType.rawValue.contains(BaseObjectGroups.caster.rawValue) {
                
                let initialOccupantBodySupportFromPrimaryOrigin =
                    getAllBodySupportFromPrimaryOriginAccountForAllSitOn(
                        supportIndex,
                        halfLength)
                
                switch baseType {
                    case .allCasterChair:
                        occupantBodySupportFromPrimaryOrigin =
                            initialOccupantBodySupportFromPrimaryOrigin
                    
                    case .allCasterStretcher:
                        occupantBodySupportFromPrimaryOrigin =
                        Globalx.iosLocation
                    
                    case .allCasterBed:
                        occupantBodySupportFromPrimaryOrigin =
                        Globalx.iosLocation
                    
                    case .allCasterHoist:
                    break
//                        occupantBodySupportFromPrimaryOrigin =
//                    (x: 0, y: initialOccupantBodySupportMeasure.rearToFrontLength/2, z: 0)
                    
                    default:
                        occupantBodySupportFromPrimaryOrigin =
                            initialOccupantBodySupportFromPrimaryOrigin
                    }
            }
            
            return occupantBodySupportFromPrimaryOrigin
        }
        
        
        func getAllBodySupportFromPrimaryOriginAccountForAllSitOn (
            _ supportIndex: Int,
            _ bodySupportLengthFromPrimaryOrigin: Double)
        -> PositionAsIosAxes {
                var location = Globalx.iosLocation
                let bodySupportDimension = initialOccupantBodySupportMeasure.sitOn
                switch numberOfOccupantSupport {
                case .one:
                    location = (x: 0.0, y: bodySupportLengthFromPrimaryOrigin, z: 0.0)

                case .twoSideBySide:
                    
                    if supportIndex == 0 {
                        location.x = -bodySupportDimension.width
                    } else {
                        location.x = bodySupportDimension.width
                    }
                    
                case .twoFrontAndBack:
                    if supportIndex == 0 {
                        location.y = bodySupportLengthFromPrimaryOrigin + bodySupportDimension.length
                    } else {
                        location.y = bodySupportLengthFromPrimaryOrigin - bodySupportDimension.length
                    }
                }
            return location
        }
    }
    



}
    
///IF TWO SIT ON
///ForOneSitOn
///ForAllSitOn
///ForOneArm
///ForBothArm
///ForOneFootSupport
///ForBothFootSupport
///FOOT SUPPORT
///
///footSupportHangerSeat/BaseJoint LOCAL LOCATION on seat/base
///footSupportHangerSeat/BaseJoint LOCAL LOCATION on footSupportHanger
///foot support hanger DIMENSIONS
///foot support hanger GLOBAL ORIGIN
///foot support hanger CLOBAL CORNER LOCATION
///footSupportHangerFootSupportJoint LOCATION
///footSupport DIMENSION
///footSupport ORIGIN
///footSuppport CORNERS
///foot support hanger <-> seat / base:  joint
///foot support hanger <-> foot support: joint
