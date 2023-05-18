//
//  CreateAllPartsForObject.swift
//  CreateObject
//
//  Created by Brian Abraham on 16/01/2023.
//

import Foundation



struct CreateDefaultObjectInitiated {
    var dictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE
    //let twinSitOnOptions: TwinSitOnOptions

    
    init(
        baseName baseObjectName: String,
        _ objectOptions: OptionDictionary,
        _ twinSitOnOptions: TwinSitOnOptions = [:]
    ) {
            getDictionary(baseObjectName, objectOptions, twinSitOnOptions) }
    
    mutating func getDictionary(
        _ baseName: String,
        _ objectOptions: OptionDictionary,
        _ twinSitOnOptions: TwinSitOnOptions)
        {
            let occupantSupport: CreateOccupantSupport

            let baseObjectName_savedNameFlag = "_"
            let theFirstItemIsBaseObjectName = 0
            var baseType: BaseObjectTypes
            
            if baseName.contains(baseObjectName_savedNameFlag) {
                let usableBaseObjectName =
                baseName.components(separatedBy: "_")[
                theFirstItemIsBaseObjectName]

                baseType = BaseObjectTypes(rawValue: usableBaseObjectName)!
            } else {
                baseType = BaseObjectTypes(rawValue: baseName)!
            }
            
            let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasure()
            
            let addedForReclineBackSupport: Double =
                objectOptions[ObjectOptions.recliningBackSupport] ?? false ? InitialOccupantBackSupportMeasurement.lengthOfMaximallyReclinedBackSupport: 0
            
        
            var addedBaseDimensionForMultipleSeats: Dimension {
                var lengthAddition =
                InitialOccupantFootSupportMeasure.footSupportHanger.length +
                InitialOccupantFootSupportMeasure.footSupport.length +
                initialOccupantBodySupportMeasure.sitOn.length
                
                lengthAddition =
                    twinSitOnOptions[TwinSitOnOption.frontAndRear] ?? false ? lengthAddition: 0.0
                
                let widthAddition = twinSitOnOptions[TwinSitOnOption.leftAndRight] ?? false ? 300.0: 0.0
                let dimension = (length: lengthAddition, width: widthAddition)
                
                return dimension
            }
            
            func getOccupantSupportMaximumLength()
                -> Double {
                    var maximumLength =
                        initialOccupantBodySupportMeasure.sitOn.length +
                    
                        (objectOptions[ObjectOptions.recliningBackSupport] ?? false ? InitialOccupantBackSupportMeasurement.lengthOfMaximallyReclinedBackSupport: 0) +
                    
                        (twinSitOnOptions[.frontAndRear] ?? false ? (InitialOccupantFootSupportMeasure.footSupportHanger.length + initialOccupantBodySupportMeasure.sitOn.length): 0)
                    // seat0 length +
                //recline +
                      
                //tilt-in-space +
                  
                //check for twinSitOn
                    //if frontRear

                    //rear seat leg room +
                   
                    // front seat length +
                    //maximumLength += initialOccupantBodySupportMeasure.sitOn.length
                    
                    
                    return 0.0
            }
            
            
            let baseMeasurement =
                getMeasurementForBaseGivenOccupantSupport(
                    baseType,
                    objectOptions,
                    addedForReclineBackSupport,
                    addedBaseDimensionForMultipleSeats)

            occupantSupport =
                CreateOccupantSupport(
                    baseType,
                    initialOccupantBodySupportMeasure,
                    baseMeasurement,
                    objectOptions,
                    twinSitOnOptions
                )

            dictionary +=
              CreateBase(
                  baseType,
                  occupantSupport,
                  baseMeasurement
              ).dictionary
            
            
            dictionary += occupantSupport.dictionary
        }
    
    
    func getMeasurementForBaseGivenOccupantSupport(
        _ baseType: BaseObjectTypes,
        _ objectOptions: OptionDictionary,
        _ addedForReclineBackSupport: Double,
        _ addedBaseMeasurementForMultipleSeats: Dimension)
            -> InitialBaseMeasureFor {
        
        let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasure()
        
        let lieOnDimension = initialOccupantBodySupportMeasure.lieOn
        
        var baseMeasurement = InitialBaseMeasureFor()
        

        switch baseType {
            case .allCasterBed:
                baseMeasurement = InitialBaseMeasureFor(rearToFrontLength: 2200, halfWidth: 450)
            
            case .allCasterChair:
                baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength: 500 + addedForReclineBackSupport
                , halfWidth: 200)
            
            case .allCasterHoist:
                baseMeasurement = InitialBaseMeasureFor(rearToFrontLength: 1200, halfWidth: 300)
            
            case .allCasterTiltInSpaceShowerChair:
                baseMeasurement = InitialBaseMeasureFor(rearToFrontLength: 600, halfWidth: 300)
            
            case .allCasterStandAid:
                break
            
            case .allCasterStretcher:
                baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength: lieOnDimension.length/2,
                    halfWidth: lieOnDimension.width/2)
            
            case .fixedWheelRearDrive:
                baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength:
                        InitialBaseMeasureFor().rearToFrontLength +
                        addedForReclineBackSupport +
                        addedBaseMeasurementForMultipleSeats.length,
                    halfWidth:
                        InitialBaseMeasureFor().halfWidth +
                        addedBaseMeasurementForMultipleSeats.width)
            
            case .fixedWheelFrontDrive:
                baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength:
                        InitialBaseMeasureFor().rearToFrontLength +
                        addedForReclineBackSupport * 0  +
                        addedBaseMeasurementForMultipleSeats.length  )
            
            case .fixedWheelMidDrive:
                baseMeasurement = InitialBaseMeasureFor(
                    rearToCentreLength:
                        InitialBaseMeasureFor().rearToCentreLength +
                        addedForReclineBackSupport +
                        addedBaseMeasurementForMultipleSeats.length/2,
                    rearToFrontLength:
                        InitialBaseMeasureFor().rearToFrontLength +
                        addedForReclineBackSupport +
                        addedBaseMeasurementForMultipleSeats.length/2
                )
            
            case .fixedWheelManualRearDrive:
                baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength: 500 +
                    addedForReclineBackSupport +
                    addedBaseMeasurementForMultipleSeats.length)
            
            case .showerTray:
                  baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength: 1200,
                    halfWidth: 450)

            default:
                 break
        }
        
        return baseMeasurement
    }
    
//    func getReclinedBackSupportLengthAddition()
//        -> Double {
//            let backHeight = InitialOccupantBackSupportMeasurement.backSupportHeight
//
//            let maximumBackSupportRecline = InitialOccupantBackSupportMeasurement.maximumBackSupportRecline.converted(to: .radians).value
//
//            return sin(maximumBackSupportRecline) * backHeight
//    }
    
    
}
    
    


