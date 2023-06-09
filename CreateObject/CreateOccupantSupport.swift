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
    let baseType: BaseObjectTypes

    let baseMeasurement: InitialBaseMeasureFor
  
    var dictionary: PositionDictionary = [:]
    var numberOfSeats: Int
 
    let occupantSupportMeasures: InitialOccupantBodySupportMeasurement =
        InitialOccupantBodySupportMeasurement()//
    
    var allBodySupportCorners: [[PositionAsIosAxes]] = []
    let objectOptions: OptionDictionary//

    init(
        _ baseType: BaseObjectTypes,
        _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasurement,
        _ baseMeasurement: InitialBaseMeasureFor,
        _ objectOptions: OptionDictionary,
        _ fromPrimaryOriginToOccupantSupports: [PositionAsIosAxes],
        _ defaultOrModifiedObjectDimensionDictionary: Part3DimensionDictionary
    ) {
        self.baseType = baseType
        self.baseMeasurement = baseMeasurement
        self.objectOptions = objectOptions
        
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
        }
        
        numberOfSeats =  fromPrimaryOriginToOccupantSupports.count// 1
        
        let dimensions = GetDimensionFromDictionary(
            defaultOrModifiedObjectDimensionDictionary).sitOnDimension3D

          let occupantSupportMeasures =
            [DimensionChange(dimensions[0]).from3Dto2D,
             DimensionChange(dimensions[1]).from3Dto2D
            ]


        
        for supportIndex in 0..<numberOfSeats {
            
            allBodySupportCorners =
                getAllBodySupportFromPrimaryOriginCorners(
                    fromPrimaryOriginToOccupantSupports,
                    occupantSupportMeasures[supportIndex].length,
                    occupantSupportMeasures[supportIndex].width)

            
            getDictionary(
                supportIndex,
                objectOptions,
                fromPrimaryOriginToOccupantSupports,
                defaultOrModifiedObjectDimensionDictionary,
                initialOccupantBodySupportMeasure,
                occupantSupportMeasures
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
        
        

    }
    
   mutating func getDictionary(
        _ supportIndex: Int,
        _ objectOptions: OptionDictionary,
        _ fromPrimaryOriginToOccupantSupports: [PositionAsIosAxes],
        _ defaultOrModifiedObjectDimensionDictionary: Part3DimensionDictionary,
        _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasurement,
        _ occupantSupportMeasures: [Dimension]
        ){
        if armSupportRequired {
            let occupantSideSuppport =
            CreateOccupantSideSupport(
                fromPrimaryOriginToOccupantSupports,
                supportIndex,
                defaultOrModifiedObjectDimensionDictionary
            )
            dictionary +=
            occupantSideSuppport.dictionary
            }

        if backSupportRequired {
            let occupantBackSupport =
                CreateOccupantBackSupport (
                    fromPrimaryOriginToOccupantSupports,
                    supportIndex,
                    objectOptions,
                    defaultOrModifiedObjectDimensionDictionary)
            dictionary +=
            occupantBackSupport.dictionary
        }
        
            
        if bodySupportRequired {
            let bodySupportDictionary =
            CreateOccupantBodySupport (
                fromPrimaryOriginToOccupantSupports[supportIndex],
                allBodySupportCorners [supportIndex],
                supportIndex,
                baseType,
                occupantSupportMeasures[supportIndex]
                ).dictionary
            dictionary += bodySupportDictionary
        }
            
            
        if footSupportRequired {
            let occupantFootSupport =
                CreateOccupantFootSupport(
                    fromPrimaryOriginToOccupantSupports,
                    supportIndex,
                    initialOccupantBodySupportMeasure,
                    baseType,
                    defaultOrModifiedObjectDimensionDictionary
                )
                dictionary +=
                occupantFootSupport.dictionary
        }


        if headSupportRequired {
            let occupantHeadSupport =
            CreateOccupantHeadSupport(
                fromPrimaryOriginToOccupantSupports,
                supportIndex,
                objectOptions,
                defaultOrModifiedObjectDimensionDictionary
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
                initialOccupantBodySupportMeasure,
                defaultOrModifiedObjectDimensionDictionary
                ).dictionary
            dictionary += overHeadSupportDictionary
        }
            
    }
    
    
    
}
    
