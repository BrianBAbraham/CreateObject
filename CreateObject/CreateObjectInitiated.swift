//
//  CreateAllPartsForObject.swift
//  CreateObject
//
//  Created by Brian Abraham on 16/01/2023.
//

import Foundation



struct CreateObjectInitiated {
    var dictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE

    
    init(
        baseName baseObjectName: String,
        _ objectOptions: OptionDictionary
    ) {

            getDictionary(baseObjectName, objectOptions) }
    
    mutating func getDictionary(
        _ baseName: String,
        _ objectOptions: OptionDictionary)
        {
            let occupantSupport: CreateOccupantSupport
            
            let occupantSupportJoints: [JointType] =
            [.fixed]
            
            let oneOrMultipleSeats: OccupantSupportNumber =
                .one
            
            let occupantSupportTypes: [OccupantSupportTypes] =
            [.seatedStandard]
            
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
            
            //let lieOnDimension = initialOccupantBodySupportMeasure.lieOn
            
            let addedForReclineBackSupport: Double = objectOptions[ObjectOptions.recliningBackSupport] ?? false ? getReclinedBackSupportLengthAddition(): 0
            
            let baseMeasurement =
                getMeasurement(
                    baseType,
                    objectOptions,
                    addedForReclineBackSupport)

            
            occupantSupport =
                CreateOccupantSupport(
                    baseType,
                    occupantSupportJoints,
                    oneOrMultipleSeats,
                    occupantSupportTypes,
                    initialOccupantBodySupportMeasure,
                    baseMeasurement,
                    objectOptions
                )

            dictionary +=
              CreateBase(
                  baseType,
                  occupantSupport,
                  baseMeasurement,
                  objectOptions
              ).dictionary

            dictionary += occupantSupport.dictionary
        }
    
    
    func getMeasurement(
        _ baseType: BaseObjectTypes,
        _ objectOptions: OptionDictionary,
        _ addedForReclineBackSupport: Double)
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
              
            case .showerTray:
              baseMeasurement = InitialBaseMeasureFor(
                rearToFrontLength: 1200,
                halfWidth: 450)

            default:
                 break
        }
        
        return baseMeasurement
    }
    
    func getReclinedBackSupportLengthAddition()
        -> Double {
            let backHeight = InitialOccupantBackSupportMeasurement.backSupportHeight
            
            let maximumBackSupportRecline = InitialOccupantBackSupportMeasurement.maximumBackSupportRecline.converted(to: .radians).value
            
            return sin(maximumBackSupportRecline) * backHeight
    }
    
    
}
    
    


