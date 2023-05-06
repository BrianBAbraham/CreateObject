//
//  CreateAllPartsForObject.swift
//  CreateObject
//
//  Created by Brian Abraham on 16/01/2023.
//

import Foundation



struct CreateAllPartsForObject {
    var dictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE

    
    init(
        baseName baseObjectName: String,
        _ recline: Bool = false
    ) {

            getDictionary(baseObjectName, recline) }
    
    mutating func getDictionary(_ baseName: String, _ recline: Bool)
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
//print(usableBaseObjectName)
                baseType = BaseObjectTypes(rawValue: usableBaseObjectName)!
            } else {
                baseType = BaseObjectTypes(rawValue: baseName)!
            }
            
                    
            let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasure()
            
            let lieOnDimension = initialOccupantBodySupportMeasure.lieOn
            
            var baseMeasurement = InitialBaseMeasureFor()

            switch baseType {
                case .allCasterBed:
                    baseMeasurement = InitialBaseMeasureFor(rearToFrontLength: 2200, halfWidth: 450)
                case .allCasterChair:
                    baseMeasurement = InitialBaseMeasureFor(rearToFrontLength: 500, halfWidth: 200)
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
            
            occupantSupport =
                CreateOccupantSupport(
                    baseType,
                    occupantSupportJoints,
                    oneOrMultipleSeats,
                    occupantSupportTypes,
                    initialOccupantBodySupportMeasure,
                    baseMeasurement,
                    recline ? 40: 2
                )
//print(dictionary)

            dictionary +=
              CreateBase(
                  baseType,
                  occupantSupport,
                  baseMeasurement
              ).dictionary

            dictionary += occupantSupport.dictionary
        }
}
    
    

///seat = sitOn /leOn/standOn + amrs/sidesk if tiliting + foot support
///base if tilting -foot support
///
///if occupant support is bodySupport its location from primary origin is dependent on
///base typej
///should I create over head here rather than  in occupant support

