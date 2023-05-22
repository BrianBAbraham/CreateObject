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
    let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasure()
    //let intialBaseMeasurmement = InitialBaseMeasureFor()
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
            let addedDimensionForTwinSitOn = getOccupantSupportAdditionForTwinSitOn()
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
            
                        
            let baseMeasurement =
                getMeasurementForBaseGivenOccupantSupport(
                    baseType,
                    addedDimensionForTwinSitOn
                )
            
            let measurementForBaseGivenOccupantSupport =
                    getMeasurementForBaseGivenOccupantSupport2(baseType)

            occupantSupport =
                CreateOccupantSupport(
                    baseType,
                    initialOccupantBodySupportMeasure,
                    //baseMeasurement,
                    measurementForBaseGivenOccupantSupport.baseMeasurement,
                    objectOptions,
                    twinSitOnOptions
                )

            dictionary +=
              CreateBase(
                  baseType,
                  occupantSupport,
                  measurementForBaseGivenOccupantSupport.baseMeasurement
              ).dictionary
            
            
            dictionary += occupantSupport.dictionary
            
            
            func getOccupantSupportAdditionForTwinSitOn()
                -> Dimension {
                    let additionDimension = twinSitOnOptions  != [:] ?
                    (length: getAddedLength(), width: getAddedWidth()):
                    (length: 0.0, width: 0)
                    
                func getAddedLength()
                    -> Double {
                        let addedLength =
                            (twinSitOnOptions[.frontAndRear] ?? false ?
                             (InitialOccupantFootSupportMeasure.footSupportHanger.length +
                              initialOccupantBodySupportMeasure.sitOn.length): 0)
                    //tilt-in-space +
                        return addedLength
                }
                
                func getAddedWidth()
                -> Double {
                    let forOneSitOn = initialOccupantBodySupportMeasure.sitOn.width
                    let forOneArmSupport = InitialOccupantSideSupportMeasurement().sitOnArm.width
                    return
                        twinSitOnOptions[TwinSitOnOption.leftAndRight] ?? false ?
                        (forOneSitOn + 2 * forOneArmSupport): 0//forOneSitOn
                }
                    
                return additionDimension
            }
        }
    
    func getMeasurementForBaseGivenOccupantSupport2(
        _ baseType: BaseObjectTypes
//        ,
//        _ addedDimensionForTwinSitOn: Dimension
    )
        -> (baseMeasurement: InitialBaseMeasureFor,
            fromPrimaryToSitOnOrigin: [Double] ) {
        
        var baseMeasurementAndSitOnOrigin =
        (baseMeasurement: InitialBaseMeasureFor(),
         fromPrimaryToSitOnOrigin: [0.0])
                
        let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasure()
        
        let lieOnDimension = initialOccupantBodySupportMeasure.lieOn
                
        let addedForReclineBackSupport: Double =
            objectOptions[ObjectOptions.recliningBackSupport] ?? false ?
                InitialOccupantBackSupportMeasurement.lengthOfMaximallyReclinedBackSupport: 0
                
        var baseMeasurement: InitialBaseMeasureFor = InitialBaseMeasureFor()
                
        let intialBaseMeasureFor = InitialBaseMeasureFor()

        let halfWidthAllowingForTwinSeatSideBySide =
                //addedDimensionForTwinSitOn.width/2 +
                intialBaseMeasureFor.halfWidth
                
        let oneSitOnLength = initialOccupantBodySupportMeasure.sitOn.length
        let frontAndRear = twinSitOnOptions[.frontAndRear] ?? false
        let sitOnLength =
            frontAndRear ?
            [oneSitOnLength, oneSitOnLength]: [oneSitOnLength]
                
        let stabilityChoices = [50.0, addedForReclineBackSupport]
        let stability = stabilityChoices.max() ?? stabilityChoices[0]
        let footSupportHangerLength =
                InitialOccupantFootSupportMeasure.footSupportHanger.length
                
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
                let baseSupport =
                    BaseAndSupport(
                        stability,
                        sitOnLength,
                        footSupportHangerLength ,
                        .fixedWheelFrontDrive)
                
                    baseMeasurement =
                        InitialBaseMeasureFor(
                        rearToFrontLength:
                            baseSupport.rearToFront,
                        halfWidth:
                            halfWidthAllowingForTwinSeatSideBySide )

                baseMeasurementAndSitOnOrigin =
                    (baseMeasurement: baseMeasurement,
                     fromPrimaryToSitOnOrigin: baseSupport.fromPrimaryToSitOnOrign)
            
            
            case .fixedWheelMidDrive:
                let baseSupport =
                    BaseAndSupport(
                        stability,
                        sitOnLength,
                        footSupportHangerLength ,
                        .fixedWheelMidDrive)

                    baseMeasurement = InitialBaseMeasureFor(
                        rearToCentreLength: baseSupport.rearToCentre,
                        rearToFrontLength:
                            baseSupport.rearToFront,
                        halfWidth:
                            halfWidthAllowingForTwinSeatSideBySide
                    )
            
                    baseMeasurementAndSitOnOrigin =
                        (baseMeasurement: baseMeasurement,
                         fromPrimaryToSitOnOrigin: baseSupport.fromPrimaryToSitOnOrign)
            
            case .fixedWheelRearDrive:
                let baseSupport =
                        BaseAndSupport(
                            stability,
                            sitOnLength,
                            footSupportHangerLength ,
                           .fixedWheelRearDrive)
                
                    baseMeasurement =
                    InitialBaseMeasureFor(
                        rearToFrontLength:
                            baseSupport.rearToFront,
                        halfWidth:
                            halfWidthAllowingForTwinSeatSideBySide )
                    
                    baseMeasurementAndSitOnOrigin =
                        (baseMeasurement: baseMeasurement,
                         fromPrimaryToSitOnOrigin: baseSupport.fromPrimaryToSitOnOrign)
        
        
            
            case .fixedWheelManualRearDrive:
                let baseSupport =
                        BaseAndSupport(
                            stability,
                            sitOnLength,
                            footSupportHangerLength ,
                           .fixedWheelRearDrive)
                baseMeasurement =
                    InitialBaseMeasureFor(
                        rearToFrontLength:
                            baseSupport.rearToFront,
                        halfWidth:
                            halfWidthAllowingForTwinSeatSideBySide )
            
                baseMeasurementAndSitOnOrigin =
                    (baseMeasurement: baseMeasurement,
                     fromPrimaryToSitOnOrigin: baseSupport.fromPrimaryToSitOnOrign)
            
            case .showerTray:
            
                  baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength: 1200,
                    halfWidth: 450)
            
//                baseMeasurementAndSitOnOrigin =
//                    (baseMeasurement: baseMeasurement,
//                     fromPrimaryToSitOnOrigin: [0.0])

            default:
            baseMeasurementAndSitOnOrigin =
                (baseMeasurement: InitialBaseMeasureFor(),
                 fromPrimaryToSitOnOrigin: [0.0])
        }
        
        return baseMeasurementAndSitOnOrigin
                
                

    }
    
    func getMeasurementForBaseGivenOccupantSupport(
        _ baseType: BaseObjectTypes,
        _ addedDimensionForTwinSitOn: Dimension)
            -> InitialBaseMeasureFor {
        
        let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasure()
        
        let lieOnDimension = initialOccupantBodySupportMeasure.lieOn
                
        let addedForReclineBackSupport: Double =
            objectOptions[ObjectOptions.recliningBackSupport] ?? false ?
                InitialOccupantBackSupportMeasurement.lengthOfMaximallyReclinedBackSupport: 0
                
        var baseMeasurement: InitialBaseMeasureFor = InitialBaseMeasureFor()
                
        let intialBaseMeasureFor = InitialBaseMeasureFor()

        let halfWidthAllowingForTwinSeatSideBySide =
                addedDimensionForTwinSitOn.width/2 +
                intialBaseMeasureFor.halfWidth
                
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
            let stabilityChoices = [50.0, addedForReclineBackSupport]
            let stability = stabilityChoices.max() ?? stabilityChoices[0]

            let oneSitOnLength = initialOccupantBodySupportMeasure.sitOn.length
            let frontAndRear = twinSitOnOptions[.frontAndRear] ?? false
            let sitOnLength =
                frontAndRear ?
                [oneSitOnLength, oneSitOnLength]: [oneSitOnLength]

            let baseSupport =
            BaseAndSupport(
                stability,
                sitOnLength,
                InitialOccupantFootSupportMeasure.footSupportHanger.length,
                .fixedWheelFrontDrive)
            
                baseMeasurement = InitialBaseMeasureFor(
                    rearToCentreLength: baseSupport.rearToCentre,
                    rearToFrontLength:
                        baseSupport.rearToFront,
                    
                    halfWidth:
                        halfWidthAllowingForTwinSeatSideBySide )
            
            case .fixedWheelMidDrive:
                let rearToFrontLength =
                        InitialBaseMeasureFor().rearToFrontLength +
                        addedForReclineBackSupport +
                        addedDimensionForTwinSitOn.length
            
                baseMeasurement = InitialBaseMeasureFor(
                    rearToCentreLength:
                        rearToFrontLength/2
                    ,
                    rearToFrontLength:
                        rearToFrontLength
                    ,
                    halfWidth:
                        halfWidthAllowingForTwinSeatSideBySide
                )
            
        case .fixedWheelRearDrive:
            baseMeasurement =
            InitialBaseMeasureFor(
                rearToFrontLength:
                    initialOccupantBodySupportMeasure.sitOn.length +
                    addedForReclineBackSupport +
                    addedDimensionForTwinSitOn.length,
                halfWidth:
                    halfWidthAllowingForTwinSeatSideBySide )
            
            case .fixedWheelManualRearDrive:
                baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength: 500 +
                    addedForReclineBackSupport +
                    addedDimensionForTwinSitOn.length,
                    halfWidth:
                        halfWidthAllowingForTwinSeatSideBySide )
            
            case .showerTray:
                  baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength: 1200,
                    halfWidth: 450)

            default:
                 break
        }
        
        return baseMeasurement
                
                

    }
    

    
}
    
    


