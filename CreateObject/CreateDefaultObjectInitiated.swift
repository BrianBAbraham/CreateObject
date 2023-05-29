//
//  CreateAllPartsForObject.swift
//  CreateObject
//
//  Created by Brian Abraham on 16/01/2023.
//

import Foundation



struct CreateDefaultObjectInitiated {
   
    var dictionary: [String: PositionAsIosAxes ] = [:]

    let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasurement()

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
//if baseType == .allCasterBed{
//    print(initialOccupantBodySupportMeasure)
//    print(baseMeasurement)
//    print(fromPrimaryToOccupantSupports)
//    print("")
//}
            occupantSupport =
                CreateOccupantSupport(
                    baseType,
                    initialOccupantBodySupportMeasure,
                    baseMeasurement,
                    objectOptions,
                    //twinSitOnOptions,
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
                
        let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasurement()
                
        let addedForReclineBackSupport: Double =
            objectOptions[ObjectOptions.reclinedBackSupport] ?? false ?
                InitialOccupantBackSupportMeasurement.lengthOfMaximallyReclinedBackSupport: 0
                
        var baseMeasurement: InitialBaseMeasureFor = InitialBaseMeasureFor()
                                
        let stabilityChoices = [50.0, addedForReclineBackSupport]
        let stability = stabilityChoices.max() ?? stabilityChoices[0]
            

                
        var rearToFront = 0.0
            
        switch baseType {
            case .allCasterBed:
            let sleepOnDimension = initialOccupantBodySupportMeasure.sleepOn
            rearToFront = 2200.0
                baseMeasurement =
                InitialBaseMeasureFor(
                    rearToFrontLength: rearToFront, halfWidth: sleepOnDimension.width/2)
            
                baseMeasurementAndSitOnOrigin =
                    getBaseMeasurementAndSitOnOriginForSingleSupport(baseMeasurement, rearToFront/2)
            
            
            
            case .allCasterChair:
                let sitOnDimension = initialOccupantBodySupportMeasure.sitOn
                rearToFront = sitOnDimension.length + stability
            
            baseMeasurement =
                InitialBaseMeasureFor(
                    rearToFrontLength: rearToFront, halfWidth: sitOnDimension.width/2)
            
                baseMeasurementAndSitOnOrigin =
                    getBaseMeasurementAndSitOnOriginForSingleSupport(
                        baseMeasurement, stability + sitOnDimension.length/2)
            
            case .allCasterHoist:
                rearToFront = 1200
                baseMeasurement =
                    InitialBaseMeasureFor(rearToFrontLength: rearToFront, halfWidth: 300)
                baseMeasurementAndSitOnOrigin =
                    getBaseMeasurementAndSitOnOriginForSingleSupport(baseMeasurement, rearToFront/2)
    
            
            case .allCasterTiltInSpaceShowerChair:
            
            let tilt = InitialOccupantSupportTiltMeasurement.maximumTilt
            let recline = InitialOccupantBackSupportMeasurement.maximumBackSupportRecline
            
            BackSupportStability(minimumSetBack: 50.0)
            
            
                let sitOnDimension = initialOccupantBodySupportMeasure.sitOn
                rearToFront = sitOnDimension.length + stability
            
                baseMeasurement =
                    InitialBaseMeasureFor(
                        rearToFrontLength: rearToFront, halfWidth: sitOnDimension.width/2)
            
                baseMeasurementAndSitOnOrigin =
                    getBaseMeasurementAndSitOnOriginForSingleSupport(
                        baseMeasurement, stability + sitOnDimension.length/2)
            
            
            
            
            
            case .allCasterStandAid:
                break
            
            case .allCasterStretcher:
                let lieOnDimension = initialOccupantBodySupportMeasure.lieOn
                rearToFront = 1400
                baseMeasurement =
                InitialBaseMeasureFor(
                    rearToFrontLength: rearToFront,
                    halfWidth: lieOnDimension.width/2)
                baseMeasurementAndSitOnOrigin =
                    getBaseMeasurementAndSitOnOriginForSingleSupport(baseMeasurement, rearToFront/2)
          
            

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
                    baseMeasurementAndSitOnOrigin =
                        (baseMeasurement: baseMeasurement,
                        fromPrimaryToSitOnOrigin: [Globalx.iosLocation])

            default:
                baseMeasurementAndSitOnOrigin =
                    (baseMeasurement: baseMeasurement,
                     fromPrimaryToSitOnOrigin: [Globalx.iosLocation])
        }
        
        return baseMeasurementAndSitOnOrigin
                
    }
    
    func getBaseMeasurementAndSitOnOriginForSingleSupport(
        _ baseMeasurement: InitialBaseMeasureFor,
        _ fromPrimaryToSupportOrigin: Double)
        ->  (baseMeasurement: InitialBaseMeasureFor,
             fromPrimaryToSitOnOrigin: [PositionAsIosAxes]) {
        
        (baseMeasurement: baseMeasurement,
         fromPrimaryToSitOnOrigin:
            [(x: 0.0, y: fromPrimaryToSupportOrigin, z: 500.0)])
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
             fromPrimaryToSitOnOrigin: [Globalx.iosLocation])
        
        var baseMeasurement: InitialBaseMeasureFor = InitialBaseMeasureFor()
        
        let footSupportHangerLength =
                InitialOccupantFootSupportMeasure.footSupportHanger.length
        
        let oneSitOnLength = initialOccupantBodySupportMeasure.sitOn.length
        let frontAndRear = twinSitOnOptions[.frontAndRear] ?? false
        let sitOnLength =
            frontAndRear ?
            [oneSitOnLength, oneSitOnLength]: [oneSitOnLength]
        
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
    
    


