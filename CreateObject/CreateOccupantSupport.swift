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
        sitOn: Dimension = (length: 400 ,width: 400),
        overHead: Dimension = (length: 40 ,width: 550),
        overHeadHook: Dimension = (length: 100 ,width: 10),
        overHeadJoint: Dimension = Joint.dimension,
        sleepOn: Dimension = (length: 2000 ,width: 900),
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
    
//    let frontAndRearSeats: Bool //= false
    let initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure //
    
    var numberOfSeats: Int
 
    var occupantSupportMeasure: Dimension //
    let occupantSupportMeasures: InitialOccupantBodySupportMeasure =
        InitialOccupantBodySupportMeasure()//

//    let sideBySideSeats: Bool //= true
    
    
    var allBodySupportCorners: [[PositionAsIosAxes]] = []//
    let objectOptions: OptionDictionary//
    

    
    
    init(
        _ baseType: BaseObjectTypes,
        _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure,
        _ baseMeasurement: InitialBaseMeasureFor,
        _ objectOptions: OptionDictionary,
        _ twinSitOnOptions: TwinSitOnOptions,
        _ fromPrimaryOriginToOccupantSupports: [PositionAsIosAxes]
    ) {
        self.baseType = baseType
        self.initialOccupantBodySupportMeasure = initialOccupantBodySupportMeasure
        self.baseMeasurement = baseMeasurement
        self.objectOptions = objectOptions
        
//        sideBySideSeats =
//        twinSitOnOptions[TwinSitOnOption.leftAndRight] ?? false
//
//        frontAndRearSeats =
//        twinSitOnOptions[TwinSitOnOption.frontAndRear] ?? false
        
//print(fromPrimaryOriginToOccupantSupports)
//print("")
        numberOfSeats =  fromPrimaryOriginToOccupantSupports.count// 1
        
//print(numberOfSeats)
//        if baseType.rawValue.contains("wheelchair") {
//            numberOfSeats += (sideBySideSeats || frontAndRearSeats ? 1:0)}
       
        
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
        fromPrimaryOriginToOccupantSupports
//            getAllBodySuppportFromPrimaryOrigin(
//                initialOccupantBodySupportMeasure
//            )
        
        allBodySupportCorners =
            getAllBodySupportFromPrimaryOriginCorners(
                allBodySupportFromPrimaryOrigin,
                occupantSupportMeasure.length,
                occupantSupportMeasure.width)

        
        for supportIndex in 0..<numberOfSeats {
//    print("numberOfSeats")
//    print(numberOfSeats)
//    print("")
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
        

        
//
//        func getAllBodySuppportFromPrimaryOrigin(
//            _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure)
//            -> [PositionAsIosAxes] {
//
//            var fromPrimaryToSitOnOrigins: [PositionAsIosAxes] = []
//            for supportIndex in 0..<numberOfSeats {
//                fromPrimaryToSitOnOrigins.append(
//                    getOneBodySupportFromPrimaryOrigin(
//                        supportIndex,
//                        initialOccupantBodySupportMeasure)
//                    )
//                }
//            return
//                fromPrimaryToSitOnOrigins
//        }
        
        
        func getDictionary(
            _ supportIndex: Int,
            _ objectOptions: OptionDictionary
            ){
//print(#function)
//print("CreateOccupantSupport")
//print(supportIndex)
//print("")
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
//print(baseType)
//print(allBodySupportFromPrimaryOrigin)
//print(initialOccupantBodySupportMeasure)
//print("")
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
