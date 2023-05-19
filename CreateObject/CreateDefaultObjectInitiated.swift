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
    
    
    func getMeasurementForBaseGivenOccupantSupport(
        _ baseType: BaseObjectTypes,
        _ addedDimensionForTwinSitOn: Dimension)
            -> InitialBaseMeasureFor {
        
        let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasure()
        
        let lieOnDimension = initialOccupantBodySupportMeasure.lieOn
                
        //let sitOnLength = initialOccupantBodySupportMeasure.sitOn.width
                
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
                baseMeasurement = InitialBaseMeasureFor(
                    rearToFrontLength:
                        InitialBaseMeasureFor().rearToFrontLength +
                        addedForReclineBackSupport  +
                        addedDimensionForTwinSitOn.length,
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
//print(" \(initialOccupantBodySupportMeasure.sitOn.length) \(addedDimensionForTwinSitOn.length) ")
            
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
    
    


