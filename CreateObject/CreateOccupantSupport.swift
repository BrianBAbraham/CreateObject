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
    let sitOn: Dimension
    let sleepOn: Dimension
    let standOn: Dimension
    
    init(
        lieOn: Dimension = (length: 1600 ,width: 600),
        sitOn: Dimension = (length: 500 ,width: 400),
        sleepOn: Dimension = (length: 1800 ,width: 900),
        standOn: Dimension = (length: 300 ,width: 500)) {
        self.lieOn = lieOn
        self.sitOn = sitOn
        self.sleepOn = sleepOn
        self.standOn = standOn
    }
}



struct CreateOccupantSupport {
    let allSitOnFromPrimaryOrigin: [PositionAsIosAxes]
    var armSupportRequired: Bool
    let baseType: BaseObjectTypes
    let baseToOccupantSupportJoint: [JointType]
    var dictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE

    
    var footSupportRequired: Bool
    let initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure
    
    let numberOfOccupantSupport: OccupantSupportNumber
    let occupantSupportTypes: [OccupantSupportTypes]
    var occupantSupportMeasure: Dimension
    let occupantSupportMeasures: InitialOccupantBodySupportMeasure =
    InitialOccupantBodySupportMeasure()
    let oneOrTwoBodySupportCorners: [[PositionAsIosAxes]]
    
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
            default:
                occupantSupportMeasure = occupantSupportMeasures.sitOn
                footSupportRequired = true
                armSupportRequired = true
        }
        

        
        allSitOnFromPrimaryOrigin =
        getAllSitOnFromPrimaryOrigin(
            occupantSupportTypes,
            initialOccupantBodySupportMeasure
        )

        func getAllSitOnFromPrimaryOrigin(
            _ occupantSupportTypes: [OccupantSupportTypes],
            _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure
        
        ) -> [PositionAsIosAxes] {
            var fromPrimaryToSitOnOrigins: [PositionAsIosAxes] = []
            for supportIndex in 0..<occupantSupportTypes.count {
                fromPrimaryToSitOnOrigins.append(
                    getOneBodySupportFromPrimaryOrigin(supportIndex, initialOccupantBodySupportMeasure)
                )
            }
            return
                fromPrimaryToSitOnOrigins
        }
        
        
        
        
        
        oneOrTwoBodySupportCorners =
        getAllBodySupportFromPrimaryOriginCorners(
            allSitOnFromPrimaryOrigin,
            occupantSupportMeasure.length,
            occupantSupportMeasure.width)

        func getAllBodySupportFromPrimaryOriginCorners(_ fromPrimaryToSitOnOrigins: [PositionAsIosAxes], _ length: Double, _ width: Double )
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
                        allSitOnFromPrimaryOrigin,
                        supportIndex
                    )
                
                    dictionary +=
                    occupantFootSupport.dictionary
            }

            if armSupportRequired {
                let occupantSideSuppport =
                CreateOccupantSideSupport(
                    allSitOnFromPrimaryOrigin,
                    supportIndex
                )
                
                dictionary +=
                occupantSideSuppport.dictionary
            }
                
            let bodySupportDictionary =
            CreateOccupantBodySupport (
                allSitOnFromPrimaryOrigin[supportIndex],
            oneOrTwoBodySupportCorners [supportIndex],
            supportIndex,
            baseType,
            numberOfOccupantSupport
            ).dictionary
                
            dictionary += bodySupportDictionary
        }

        
        
        func getOneBodySupportFromPrimaryOrigin( _ supportIndex: Int,
                                                 _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure)
        -> PositionAsIosAxes {

            var occupantBodySupportFromPrimaryOrigin: PositionAsIosAxes = Globalx.iosLocation
            let halfLength = initialOccupantBodySupportMeasure.sitOn.length/2
            

            if baseType.rawValue.contains(BaseObjectGroups.fixedWheel.rawValue) {

                switch baseType {
                    case .fixedWheelFrontDrive:
                        occupantBodySupportFromPrimaryOrigin =
                        getAllSitOnFromPrimaryOriginAccountForTwoSitOn (
                            supportIndex,
                            -halfLength)

                    case .fixedWheelMidDrive:
                        occupantBodySupportFromPrimaryOrigin =
                        getAllSitOnFromPrimaryOriginAccountForTwoSitOn(
                            supportIndex,
                            0.0)

                    case .fixedWheelRearDrive:
                    occupantBodySupportFromPrimaryOrigin =
                        getAllSitOnFromPrimaryOriginAccountForTwoSitOn (
                            supportIndex,
                            halfLength)

                    default:
                        occupantBodySupportFromPrimaryOrigin =
                        getAllSitOnFromPrimaryOriginAccountForTwoSitOn (
                            supportIndex,
                            halfLength)
                }
            }

            if baseType.rawValue.contains(BaseObjectGroups.caster.rawValue) {
                switch baseType {
                    case .allCasterChair:
                        occupantBodySupportFromPrimaryOrigin =
                        getAllSitOnFromPrimaryOriginAccountForTwoSitOn(
                            supportIndex,
                            halfLength)
                    
                    case .allCasterStretcher:
                        occupantBodySupportFromPrimaryOrigin =
                        Globalx.iosLocation
                    
                    case .allCasterBed:
                        occupantBodySupportFromPrimaryOrigin =
                        Globalx.iosLocation
                    
                    default:
                        occupantBodySupportFromPrimaryOrigin =
                        getAllSitOnFromPrimaryOriginAccountForTwoSitOn (
                            supportIndex,
                            halfLength)
                    }
            }
            
            return occupantBodySupportFromPrimaryOrigin
        }
        
        
        func getAllSitOnFromPrimaryOriginAccountForTwoSitOn (
            _ supportIndex: Int,
            _ dimensionForSingleSeat: Double) -> PositionAsIosAxes {
                var location = Globalx.iosLocation
                switch numberOfOccupantSupport {
                case .one:

                    location = (x: 0.0, y: dimensionForSingleSeat, z: 0.0)
                case .twoSideBySide:
                    
                    if supportIndex == 0 {
                        location.x = -initialOccupantBodySupportMeasure.sitOn.width
                    } else {
                        location.x = initialOccupantBodySupportMeasure.sitOn.width
                    }
                case .twoFrontAndBack:
                    if supportIndex == 0 {
                        location.y = dimensionForSingleSeat + initialOccupantBodySupportMeasure.sitOn.length
                    } else {
                        location.y = dimensionForSingleSeat - initialOccupantBodySupportMeasure.sitOn.length
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
