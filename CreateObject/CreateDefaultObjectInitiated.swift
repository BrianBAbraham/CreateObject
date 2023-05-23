//
//  CreateAllPartsForObject.swift
//  CreateObject
//
//  Created by Brian Abraham on 16/01/2023.
//

import Foundation



struct CreateDefaultObjectInitiated {
   
    var dictionary: [String: PositionAsIosAxes ] = [:]

    let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasure()

    let objectOptions: OptionDictionary
    let twinSitOnOptions: TwinSitOnOptions
    
    init(
        baseName baseObjectName: String,
        _ objectOptions: OptionDictionary,
        _ twinSitOnOptions: TwinSitOnOptions = [:]
    ) {
           
        self.objectOptions = objectOptions
        self.twinSitOnOptions = twinSitOnOptions
        
        getDictionary(baseObjectName)
    }
    
    

    
    
    mutating func getDictionary(
        _ baseName: String) {

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

            
            let measurementForBaseGivenOccupantSupport =
                    getBaseAndOccupantSupportMeasurement(baseType)
            
            let baseMeasurement = measurementForBaseGivenOccupantSupport.baseMeasurement
            
            let fromPrimaryToOccupantSupports = measurementForBaseGivenOccupantSupport.fromPrimaryToSitOnOrigin
            
            occupantSupport =
                CreateOccupantSupport(
                    baseType,
                    initialOccupantBodySupportMeasure,
                    baseMeasurement,
                    objectOptions,
                    twinSitOnOptions,
                    fromPrimaryToOccupantSupports
                )

            dictionary +=
              CreateBase(
                  baseType,
                  occupantSupport,
                  baseMeasurement
              ).dictionary
            
            
            dictionary += occupantSupport.dictionary
            
        }
    
    func getBaseAndOccupantSupportMeasurement(
        _ baseType: BaseObjectTypes)
        -> (baseMeasurement: InitialBaseMeasureFor,
            fromPrimaryToSitOnOrigin: [PositionAsIosAxes] ) {
        
        var baseMeasurementAndSitOnOrigin:
        (baseMeasurement: InitialBaseMeasureFor,
         fromPrimaryToSitOnOrigin: [PositionAsIosAxes]) =
            (baseMeasurement: InitialBaseMeasureFor(),
             fromPrimaryToSitOnOrigin: [] )
                
        let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasure()
        
        let lieOnDimension = initialOccupantBodySupportMeasure.lieOn
                
        let addedForReclineBackSupport: Double =
            objectOptions[ObjectOptions.recliningBackSupport] ?? false ?
                InitialOccupantBackSupportMeasurement.lengthOfMaximallyReclinedBackSupport: 0
                
        var baseMeasurement: InitialBaseMeasureFor = InitialBaseMeasureFor()
                
        let intialBaseMeasureFor = InitialBaseMeasureFor()

//        let halfWidthAllowingForTwinSeatSideBySide =
//                intialBaseMeasureFor.halfWidth
                
//        let oneSitOnLength = initialOccupantBodySupportMeasure.sitOn.length
//        let frontAndRear = twinSitOnOptions[.frontAndRear] ?? false

                
        let stabilityChoices = [50.0, addedForReclineBackSupport]
        let stability = stabilityChoices.max() ?? stabilityChoices[0]
            

                

            
        switch baseType {
            case .allCasterBed:
                baseMeasurement =
                InitialBaseMeasureFor(rearToFrontLength: 2200, halfWidth: 450)
            
            case .allCasterChair:
                baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength: 500 + addedForReclineBackSupport
                , halfWidth: 200)
            
            case .allCasterHoist:
                baseMeasurement =
                InitialBaseMeasureFor(rearToFrontLength: 1200, halfWidth: 300)
            
            case .allCasterTiltInSpaceShowerChair:
                baseMeasurement =
                InitialBaseMeasureFor(rearToFrontLength: 600, halfWidth: 300)
            
            case .allCasterStandAid:
                break
            
            case .allCasterStretcher:
                baseMeasurement =
                InitialBaseMeasureFor(
                    rearToFrontLength: lieOnDimension.length/2,
                    halfWidth: lieOnDimension.width/2)
            

            case .fixedWheelFrontDrive:
                baseMeasurementAndSitOnOrigin =
                getPositionForTwinSitOnObjects(
                    stability,
                    .fixedWheelFrontDrive)
                        
            case .fixedWheelMidDrive:
                baseMeasurementAndSitOnOrigin =
                getPositionForTwinSitOnObjects(
                    stability,
                    .fixedWheelMidDrive)
            
            case .fixedWheelRearDrive:
                baseMeasurementAndSitOnOrigin =
                getPositionForTwinSitOnObjects(
                    stability,
                    .fixedWheelRearDrive)
            
            case .fixedWheelManualRearDrive:
                baseMeasurementAndSitOnOrigin =
                getPositionForTwinSitOnObjects(
                    stability,
                    .fixedWheelManualRearDrive)
            
            case .showerTray:
                  baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength: 1200,
                    halfWidth: 450)

            default:
                baseMeasurementAndSitOnOrigin =
                    (baseMeasurement: InitialBaseMeasureFor(),
                     fromPrimaryToSitOnOrigin: [Globalx.iosLocation])
        }
        
        return baseMeasurementAndSitOnOrigin
                
    }
    

    func getPositionForTwinSitOnObjects (
        _ stability: Double,
        _ baseType: BaseObjectTypes)
    -> (baseMeasurement: InitialBaseMeasureFor,
        fromPrimaryToSitOnOrigin: [PositionAsIosAxes] ) {
        
        var baseMeasurementAndSitOnOrigin:
        (baseMeasurement: InitialBaseMeasureFor,
         fromPrimaryToSitOnOrigin: [PositionAsIosAxes]) =
            (baseMeasurement: InitialBaseMeasureFor(),
             fromPrimaryToSitOnOrigin: [] )
        
        var baseMeasurement: InitialBaseMeasureFor = InitialBaseMeasureFor()
        let intialBaseMeasureFor = InitialBaseMeasureFor()
        
        let footSupportHangerLength =
                InitialOccupantFootSupportMeasure.footSupportHanger.length
        
        let oneSitOnLength = initialOccupantBodySupportMeasure.sitOn.length
        let frontAndRear = twinSitOnOptions[.frontAndRear] ?? false
        let sitOnLength =
            frontAndRear ?
            [oneSitOnLength, oneSitOnLength]: [oneSitOnLength]
        
        let halfWidthAllowingForTwinSeatSideBySide =
                //addedDimensionForTwinSitOn.width/2 +
                intialBaseMeasureFor.halfWidth
        
        let oneSitOnWidth = initialOccupantBodySupportMeasure.sitOn.width
        let oneArmSupportWidth = InitialOccupantSideSupportMeasurement().sitOnArm.width
    
        let leftAndRight = twinSitOnOptions[.leftAndRight] ?? false
        let sitOnWidth =
            leftAndRight ?
            [oneSitOnWidth, oneSitOnWidth]: [oneSitOnWidth]
        let armSupportWidth =
            leftAndRight ?
            [oneArmSupportWidth, oneArmSupportWidth]: [oneArmSupportWidth]
        
        let baseSupport =
            BaseDimensionAndSupportPosition(
                stability,
                sitOnLength,
                sitOnWidth,
                armSupportWidth,
                footSupportHangerLength ,
                baseType)
        
            baseMeasurement =
                InitialBaseMeasureFor(
                rearToCentreLength:
                    baseSupport.rearToCentre,
                rearToFrontLength:
                    baseSupport.rearToFront,
                halfWidth:
                    baseSupport.baseWidth/2 )

        baseMeasurementAndSitOnOrigin =
            (baseMeasurement: baseMeasurement,
             fromPrimaryToSitOnOrigin: baseSupport.fromPrimaryToSitOnOrign )
        
        
        return baseMeasurementAndSitOnOrigin
    }

    
}
    
    


