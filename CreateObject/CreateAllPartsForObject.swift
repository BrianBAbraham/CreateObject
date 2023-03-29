//
//  CreateAllPartsForObject.swift
//  CreateObject
//
//  Created by Brian Abraham on 16/01/2023.
//

import Foundation



struct CreateAllPartsForObject {
    var dictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE
    
    init(_ baseObjectName: String)
        {
            getDictionary(baseObjectName)
        }
    
    mutating func getDictionary(_ baseObjectName: String)
        {
            let occupantSupport: CreateOccupantSupport
            
            let occupantSupportJoints: [JointType] =
                [.fixed]
            
            let oneOrMultipleSeats: OccupantSupportNumber =
                .one
            
            let occupantSupportTypes: [OccupantSupportTypes] =
                [.seatedStandard]
            
            let baseType = BaseObjectTypes(rawValue: baseObjectName)!
            
            let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasure()
            
            
            var measurement = InitialBaseMeasureFor()

          switch baseType {
            case .allCasterBed:
                measurement = InitialBaseMeasureFor(rearToFrontLength: 2200, halfWidth: 450)
            case .allCasterChair:
                measurement = InitialBaseMeasureFor(rearToFrontLength: 500, halfWidth: 200)
            case .allCasterHoist:
                measurement = InitialBaseMeasureFor(rearToFrontLength: 1200, halfWidth: 300)
            case .allCasterStandAid:
                break
            case .allCasterStretcher:
                measurement = InitialBaseMeasureFor(rearToFrontLength: initialOccupantBodySupportMeasure.lieOn.length/2, halfWidth: initialOccupantBodySupportMeasure.lieOn.width/2)

            default:
                 break

            }
            
            
            
            
            occupantSupport =
                CreateOccupantSupport(
                    baseType,
                    occupantSupportJoints,
                    oneOrMultipleSeats,
                    occupantSupportTypes,
                    initialOccupantBodySupportMeasure
                )

            dictionary +=
              CreateBase(
                  baseType,
                  occupantSupport,
                  measurement
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

