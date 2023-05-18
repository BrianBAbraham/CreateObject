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
    let overHeadHook: Dimension
    let overHeadJoint: Dimension
    let sitOn: Dimension
    let sleepOn: Dimension
    let standOn: Dimension
    
    init(
        lieOn: Dimension = (length: 1600 ,width: 600),
        sitOn: Dimension = (length: 450 ,width: 400),
        overHead: Dimension = (length: 40 ,width: 550),
        overHeadHook: Dimension = (length: 100 ,width: 10),
        overHeadJoint: Dimension = Joint.dimension,
        sleepOn: Dimension = (length: 1800 ,width: 900),
        standOn: Dimension = (length: 300 ,width: 500)) {
        self.lieOn = lieOn
        self.overHead = overHead
        self.overHeadHook = overHeadHook
        self.overHeadJoint = overHeadJoint
        self.sitOn = sitOn
        self.sleepOn = sleepOn
        self.standOn = standOn
    }
}



struct CreateOccupantSupport {
    
    var backSupportRequired = true
    var bodySupportRequired = true
    var overheadSupportRequired = false
    var armSupportRequired = true
    var footSupportRequired = true
    
    var allBodySupportFromPrimaryOrigin: [PositionAsIosAxes] = []
    
    let baseType: BaseObjectTypes //

    let baseMeasurement: InitialBaseMeasureFor //
  
    var dictionary: [String: PositionAsIosAxes ] = [:] //
    
    let frontAndRearSeats: Bool //= false
    let initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure //
    
    var numberOfSeats: Int
 
    var occupantSupportMeasure: Dimension //
    let occupantSupportMeasures: InitialOccupantBodySupportMeasure =
        InitialOccupantBodySupportMeasure()//

    let sideBySideSeats: Bool //= true
    
    
    var allBodySupportCorners: [[PositionAsIosAxes]] = []//
    let objectOptions: OptionDictionary//
    

    
    
    init(
        _ baseType: BaseObjectTypes,
        _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure,
        _ baseMeasurement: InitialBaseMeasureFor,
        _ objectOptions: OptionDictionary,
        _ twinSitOnOptions: TwinSitOnOptions
    ) {
        self.baseType = baseType
        self.initialOccupantBodySupportMeasure = initialOccupantBodySupportMeasure
        self.baseMeasurement = baseMeasurement
        self.objectOptions = objectOptions
        
        sideBySideSeats =
        twinSitOnOptions[TwinSitOnOption.leftAndRight] ?? false
        
        frontAndRearSeats =
        twinSitOnOptions[TwinSitOnOption.frontAndRear] ?? false
        
        
        numberOfSeats =  1
        if baseType.rawValue.contains("wheelchair") {
            numberOfSeats += (sideBySideSeats || frontAndRearSeats ? 1:0)}
       
        
        switch baseType {
            case .allCasterChair:
                occupantSupportMeasure = occupantSupportMeasures.sitOn
                footSupportRequired = true
                armSupportRequired = true
            case .allCasterBed:
                occupantSupportMeasure = occupantSupportMeasures.sleepOn
                footSupportRequired = false
                armSupportRequired = false
                backSupportRequired = false
            case .allCasterStretcher:
                occupantSupportMeasure = occupantSupportMeasures.lieOn
                footSupportRequired = false
                armSupportRequired = false
                backSupportRequired = false
            case .allCasterHoist:
                occupantSupportMeasure = occupantSupportMeasures.sitOn
                overheadSupportRequired = true
                bodySupportRequired = false
                footSupportRequired = false
                armSupportRequired = false
                backSupportRequired = false
            case .showerTray:
                occupantSupportMeasure = occupantSupportMeasures.sitOn
                bodySupportRequired = false
                footSupportRequired = true
                armSupportRequired = false
                backSupportRequired = false
            
            default:
                occupantSupportMeasure = occupantSupportMeasures.sitOn
                footSupportRequired = true
                armSupportRequired = true
                backSupportRequired = true
        }
        

        allBodySupportFromPrimaryOrigin =
            getAllBodySuppportFromPrimaryOrigin(
                initialOccupantBodySupportMeasure
            )
        
        allBodySupportCorners =
            getAllBodySupportFromPrimaryOriginCorners(
                allBodySupportFromPrimaryOrigin,
                occupantSupportMeasure.length,
                occupantSupportMeasure.width)

        
        for supportIndex in 0..<numberOfSeats {
            getDictionary(
                supportIndex,
                objectOptions
            )
        }
        
        
        
        func getAllBodySupportFromPrimaryOriginCorners(
            _ fromPrimaryToSitOnOrigins: [PositionAsIosAxes],
            _ length: Double,
            _ width: Double )
            -> [[PositionAsIosAxes]] {
            var oneOrTwoSitOnPartCorners:[[PositionAsIosAxes]]  = []
            for supportIndex in 0..<numberOfSeats {
                    oneOrTwoSitOnPartCorners.append(
                    PartCornerLocationFrom(
                       length,
                        fromPrimaryToSitOnOrigins[supportIndex],
                        width).primaryOrigin
                    )
                }
            return oneOrTwoSitOnPartCorners
        }
        

        
        
        func getAllBodySuppportFromPrimaryOrigin(
            _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure)
            -> [PositionAsIosAxes] {

            var fromPrimaryToSitOnOrigins: [PositionAsIosAxes] = []
            for supportIndex in 0..<numberOfSeats {
                fromPrimaryToSitOnOrigins.append(
                    getOneBodySupportFromPrimaryOrigin(
                        supportIndex,
                        initialOccupantBodySupportMeasure)
                    )
                }
            return
                fromPrimaryToSitOnOrigins
        }
        
        
        func getDictionary(
            _ supportIndex: Int,
            _ objectOptions: OptionDictionary
            ){
                
            if backSupportRequired {
                let occupantBackSupport =
                CreateOccupantBackSupport (
                    allBodySupportFromPrimaryOrigin,
                    supportIndex,
                    objectOptions)
                dictionary +=
                occupantBackSupport.dictionary
            }
                
            if footSupportRequired {
                let occupantFootSupport =
                    CreateOccupantFootSupport(
                        allBodySupportFromPrimaryOrigin,
                        supportIndex,
                        initialOccupantBodySupportMeasure,
                        baseType)
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
                    baseType,
                    occupantSupportMeasure
                    ).dictionary
                dictionary += bodySupportDictionary
            }
                
            if overheadSupportRequired {
                let overHeadSupportFromPrimaryOrigin: PositionAsIosAxes =
                (x: 0, y: baseMeasurement.rearToFrontLength/3*2, z: 1200)
                
                let overHeadSupportDictionary =
                CreateOccupantOverHeadSupport (
                    overHeadSupportFromPrimaryOrigin,
                    initialOccupantBodySupportMeasure
                    ).dictionary
                dictionary += overHeadSupportDictionary
            }
        }

        
        
        func getOneBodySupportFromPrimaryOrigin(
            _ supportIndex: Int,
            _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure)
                -> PositionAsIosAxes {

            let modifiedPositionForReclineBackRest = InitialOccupantBackSupportMeasurement(objectOptions).backSupport.length
            
            var occupantBodySupportFromPrimaryOrigin: PositionAsIosAxes = Globalx.iosLocation
            
            let halfLength = initialOccupantBodySupportMeasure.sitOn.length/2
            
            var bodySupportlengthFromPrimaryOrigin: Double = 0

            if baseType.rawValue.contains(GroupsDerivedFromRawValueOfBaseObjectTypes.fixedWheel.rawValue) {
            
            let hangerStartToFootSupportEndLength =
                InitialOccupantFootSupportMeasure.footSupportHanger.length +
                InitialOccupantFootSupportMeasure.footSupport.length
                
            switch baseType {
                    
                    case .fixedWheelFrontDrive:
                        if !frontAndRearSeats {
                            bodySupportlengthFromPrimaryOrigin += -halfLength
                        }
                
                        if frontAndRearSeats && supportIndex == 0 {
                            bodySupportlengthFromPrimaryOrigin +=
                            -halfLength +
                            -hangerStartToFootSupportEndLength
                        }

                    case .fixedWheelMidDrive:
                            bodySupportlengthFromPrimaryOrigin =
                            soloAndMidDriveCase()
                    
                    case .fixedWheelSolo:
                            bodySupportlengthFromPrimaryOrigin =
                            soloAndMidDriveCase()
                
                    case .fixedWheelRearDrive:
                        bodySupportlengthFromPrimaryOrigin =
                            allRearDriveCase()
                    
                    case .fixedWheelManualRearDrive:
                        bodySupportlengthFromPrimaryOrigin =
                            allRearDriveCase()

                    default:
                        bodySupportlengthFromPrimaryOrigin =
                    halfLength +
                    modifiedPositionForReclineBackRest
                }
                
                
                func soloAndMidDriveCase() -> Double {
                    
                    var bodySupportlengthFromPrimaryOrigin = 0.0
                    
                    if frontAndRearSeats  {
                        bodySupportlengthFromPrimaryOrigin =
                        supportIndex == 0 ?
                        -halfLength: -(hangerStartToFootSupportEndLength + halfLength)
                    }
                    
                    return bodySupportlengthFromPrimaryOrigin
                }
                
                func allRearDriveCase() -> Double {
                    var bodySupportlengthFromPrimaryOrigin =
                    halfLength
                    if !frontAndRearSeats {
                        bodySupportlengthFromPrimaryOrigin +=
                        modifiedPositionForReclineBackRest
                    } else {
                        if supportIndex == 1 {
                            bodySupportlengthFromPrimaryOrigin +=
                            (halfLength +
                            hangerStartToFootSupportEndLength)
                        }
                    }
                    
//print(supportIndex)
//print(bodySupportlengthFromPrimaryOrigin)
//print("")
                    return bodySupportlengthFromPrimaryOrigin
                }
                
//                occupantBodySupportFromPrimaryOrigin =
//                    getAllBodySupportFromPrimaryOriginAccountForAllSitOn(
//                        supportIndex,
//                        bodySupportlengthFromPrimaryOrigin)
                
                return (x: 0.0, y: bodySupportlengthFromPrimaryOrigin, z: 0)
            }
            
            

            if baseType.rawValue.contains(GroupsDerivedFromRawValueOfBaseObjectTypes.caster.rawValue) {
                
                let initialOccupantBodySupportFromPrimaryOrigin =
                (x: 0.0, y: halfLength, z: 0.0 )

                
                switch baseType {
                    case .allCasterChair:
                        occupantBodySupportFromPrimaryOrigin =
                    CreateIosPosition.addTwoTouples(
                            initialOccupantBodySupportFromPrimaryOrigin,
                            (x:0, y: modifiedPositionForReclineBackRest, z:0) )
                    
                    case .allCasterStretcher:
                        occupantBodySupportFromPrimaryOrigin =
                    (x: 0,
                     y: baseMeasurement.rearToFrontLength/2,
                     z: 0)
                    
                    case .allCasterBed:
                        let headEndPartWidth = 100.0
                        occupantBodySupportFromPrimaryOrigin =

                    (x: 0,
                     y: initialOccupantBodySupportMeasure.sleepOn.length/2 +
                     headEndPartWidth,
                     z: 0)
                    
                    case .allCasterHoist:
                    //break
                        occupantBodySupportFromPrimaryOrigin =
                    (x: 0, y: 0, z: 0)
                    
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
                let supportHalfWidthDimension =
                InitialOccupantSideSupportMeasurement().rightSideSupportFromSitOnOrigin.x
                + InitialOccupantSideSupportMeasurement().sitOnArm.width/2
                
                if !sideBySideSeats && !frontAndRearSeats {
                    location = (x: 0.0, y: bodySupportLengthFromPrimaryOrigin, z: 0.0)
                }

                if sideBySideSeats {
                    if supportIndex == 0 {
                        location.x = -supportHalfWidthDimension

                    } else {
                        location.x = supportHalfWidthDimension
                    }
                }

                if frontAndRearSeats {
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
