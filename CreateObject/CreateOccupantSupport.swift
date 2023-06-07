//
//  CreateSitOrStand.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/01/2023.
//

import Foundation


//struct InitialCasterChairMeasure {
//    let bodySuppport: Dimension
//    let sideSupport: Dimension
//    let footSupport: Dimension
//}


struct InitialOccupantSupportTiltMeasurement {

    static let maximumTilt =
        Measurement(value: 90, unit: UnitAngle.degrees)
    
    static let minimumTilt =
        Measurement(value: -10, unit: UnitAngle.degrees)
    
    static let fromPrimaryOriginToTiltAxis =
        (x: 0.0 , y: 0.0, z: -100.0)
    
    let titledLength: Double
    
    init (
        _ tilt: Measurement<UnitAngle> = maximumTilt,
        length: Double
    ) {

           titledLength =
            getTiltedLength(tilt,  length)
            
        func getTiltedLength(
            _ tilt: Measurement<UnitAngle>,
            _ length: Double)
            ->Double {
                
                sin(tilt.converted(to: .radians).value) * length
        }
    }
}


struct Tilted {
    let factor: Double
    init (
        _ tilt: Measurement<UnitAngle>) {
           factor = sin(tilt.converted(to: .radians).value)
    }
}


struct CreateOccupantSupport {
    
    var backSupportRequired = true
    var bodySupportRequired = true
    var headSupportRequired = false
    var overheadSupportRequired = false
    var armSupportRequired = true
    var footSupportRequired = true
    var tiltRequired = false
    
    var allBodySupportFromPrimaryOrigin: [PositionAsIosAxes] = []
    
    let baseType: BaseObjectTypes //

    let baseMeasurement: InitialBaseMeasureFor //
  
    var dictionary: PositionDictionary = [:]
    //var measurements: MeasurementDictionary

    let initialOccupantBodySupportMeasurement: InitialOccupantBodySupportMeasurement //
    
    var numberOfSeats: Int
 
    var occupantSupportMeasure: Dimension //
    let occupantSupportMeasures: InitialOccupantBodySupportMeasurement =
        InitialOccupantBodySupportMeasurement()//
    
    var allBodySupportCorners: [[PositionAsIosAxes]] = []//
    let objectOptions: OptionDictionary//
    

    
    
    init(
        _ baseType: BaseObjectTypes,
        _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasurement,
        _ baseMeasurement: InitialBaseMeasureFor,
        _ objectOptions: OptionDictionary,
        _ fromPrimaryOriginToOccupantSupports: [PositionAsIosAxes],
        _ defaultDictionary: Part3DimensionDictionary
    ) {
        self.baseType = baseType
        self.initialOccupantBodySupportMeasurement = initialOccupantBodySupportMeasure
        self.baseMeasurement = baseMeasurement
        self.objectOptions = objectOptions
        //self.measurements = measurements

        numberOfSeats =  fromPrimaryOriginToOccupantSupports.count// 1
        
        occupantSupportMeasure =
            DimensionChange(GetDimensionFromDictionary(defaultDictionary).sitOnOneDimension2D).from3Dto2D
        
        switch baseType {
            case .allCasterBed:
                footSupportRequired = false
                armSupportRequired = false
                backSupportRequired = false
            case .allCasterStretcher:
                footSupportRequired = false
                armSupportRequired = false
                backSupportRequired = false
            case .allCasterHoist:
                overheadSupportRequired = true
                bodySupportRequired = false
                footSupportRequired = false
                armSupportRequired = false
                backSupportRequired = false
            case .showerTray:
                bodySupportRequired = false
                armSupportRequired = false
                backSupportRequired = false
            case .allCasterTiltInSpaceShowerChair:

                tiltRequired =
                    objectOptions[.tiltInSpace] ?? false ? true: false
                headSupportRequired =
                    objectOptions[.headSupport] ?? false ? true: false
            case .seatThatTilts:
                tiltRequired = true
            
            default:
            break
                //occupantSupportMeasure = occupantSupportMeasures.sitOn

        }
        

        allBodySupportFromPrimaryOrigin =
        fromPrimaryOriginToOccupantSupports

        
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
        

        

        
        
        func getDictionary(
            _ supportIndex: Int,
            _ objectOptions: OptionDictionary
            ){
            if armSupportRequired {
                let occupantSideSuppport =
                CreateOccupantSideSupport(
                    allBodySupportFromPrimaryOrigin,
                    supportIndex
                )
                dictionary +=
                occupantSideSuppport.dictionary
                }

            if backSupportRequired {
                let occupantBackSupport =
                    CreateOccupantBackSupport (
                        allBodySupportFromPrimaryOrigin,
                        supportIndex,
                        objectOptions)
                dictionary +=
                occupantBackSupport.dictionary
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
                
                
            if footSupportRequired {
                let occupantFootSupport =
                    CreateOccupantFootSupport(
                        allBodySupportFromPrimaryOrigin,
                        supportIndex,
                        initialOccupantBodySupportMeasure,
                        baseType//,
                        //measurements
                    )
                    dictionary +=
                    occupantFootSupport.dictionary
            }


            if headSupportRequired {
                let occupantHeadSupport =
                CreateOccupantHeadSupport(
                    allBodySupportFromPrimaryOrigin,
                    supportIndex,
                    objectOptions,
                    defaultDictionary
                )
                dictionary +=
                occupantHeadSupport.dictionary
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
                
//            if tiltRequired {
//               let tiltDictionary =
//                CreateOccupantTiltSupport(
//                    dictionary,
//                    allBodySupportFromPrimaryOrigin,
//                    supportIndex,
//                    [600.0, 500.0]
//                )
//
//                dictionary += tiltDictionary.dictionaryForTiltJoint
//            }
        }
    }
}
    
