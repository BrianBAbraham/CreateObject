//
//  CreateAllPartsForObject.swift
//  CreateObject
//
//  Created by Brian Abraham on 16/01/2023.
//

import Foundation



struct CreateInitialObject {
    
    var defaultOrModifiedObjectDimensionDictionary: Part3DimensionDictionary
    var dictionary: [String: PositionAsIosAxes ] = [:]

    let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasurement()

    let objectOptions: OptionDictionary
    let twinSitOnOptions: TwinSitOnOptionDictionary
    
    init(
        baseName baseObjectName: String,
        _ objectOptions: OptionDictionary,
        _ twinSitOnOptions: TwinSitOnOptionDictionary = [:],
        _ partDictionary: Part3DimensionDictionary = [:]
    ) {
           
        self.objectOptions = objectOptions
        self.twinSitOnOptions = twinSitOnOptions
        self.defaultOrModifiedObjectDimensionDictionary = partDictionary

//DictionaryInArrayOut().getNameValue(defaultDictionary).forEach{print($0)}
//print
        let  objectDefaultOrModifiedSpecification =
        DimensionOriginCornerDictionaries(
    BaseObjectTypes(rawValue: baseObjectName) ??
        .fixedWheelRearDrive,
    twinSitOnOptions,
    [objectOptions, objectOptions])
            //.origin)
        //print(objectDefaultOrModifiedSpecification.parentToPartOriginDictionaryOut)
        
        getDictionary(baseObjectName)
//print("\n\n")
//DictionaryInArrayOut().getNameValue( dictionary).forEach{print($0)}
        dictionary = objectDefaultOrModifiedSpecification.preTiltObjectToCornerOrigin

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
                    fromPrimaryToOccupantSupports,
                    defaultOrModifiedObjectDimensionDictionary
                )

            dictionary +=
              CreateBase(
                  baseType,
                  occupantSupport,
                  baseMeasurement
              ).dictionary
            
            
            dictionary += occupantSupport.dictionary
            
        }
    
    mutating func getBaseAndOccupantSupportMeasurement(
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
            objectOptions[ObjectOptions.angleBackSupport] ?? false ?
                InitialOccupantBackSupportMeasurement.lengthOfMaximallyReclinedBackSupport: 0
                
        var baseMeasurement: InitialBaseMeasureFor = InitialBaseMeasureFor()
                                
        let stabilityChoices = [50.0, addedForReclineBackSupport]
        let stability = stabilityChoices.max() ?? stabilityChoices[0]
            

            /// the dimensions in the default dictionary need to input into the object creation
            /// currently the struct InitialMeasurement is used and intitated with case based values
                
        var rearToFront = 0.0
            
        switch baseType {
            case .allCasterBed:
            let sleepOnDimension =
                DimensionChange(GetDimensionFromDictionary(defaultOrModifiedObjectDimensionDictionary).sitOnDimension3D[0]).from3Dto2D
            rearToFront = sleepOnDimension.length + 200.0
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
            
            
                  baseMeasurement =
                    InitialBaseMeasureFor(
                    )


                    baseMeasurementAndSitOnOrigin =
                        (baseMeasurement: baseMeasurement,
                        fromPrimaryToSitOnOrigin: [ZeroValue.iosLocation])

            
            
            
            
            
            default:
                baseMeasurementAndSitOnOrigin =
                    (baseMeasurement: baseMeasurement,
                     fromPrimaryToSitOnOrigin: [ZeroValue.iosLocation])
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
             fromPrimaryToSitOnOrigin: [ZeroValue.iosLocation])
        
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
    
    


