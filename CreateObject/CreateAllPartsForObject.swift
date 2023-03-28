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
                  occupantSupport
              ).dictionary

            dictionary += occupantSupport.dictionary
        }
}
    
    

///seat = sitOn /leOn/standOn + amrs/sidesk if tiliting + foot support
///base if tilting -foot support
///

