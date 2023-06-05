//
//  ForOccupantSide.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

//import Foundation
//

struct RequestOccupantSideSupportDefaultDimensionDictionary {
    var dictionary: Part3DimensionDictionary = [:]
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions
        ) {
            
        getDictionary()
        
        func getDictionary() {
                
            let allOccupantRelated = OccupantSideSupportDefaultDimension(baseType)
            dictionary =
                CreateDefaultDimensionDictionary(
                    [.armSupport],
                    [allOccupantRelated.value],
                    twinSitOnOptions
                ).dictionary
        }
    }
}



struct OccupantSideSupportDefaultDimension {
    
    var dictionary: BaseObject3DimensionDictionary =
    [.allCasterStretcher:
        (length: OccupantBackSupportDefaultDimension(.allCasterStretcher).value.length
         , width: 20.0, height: 20.0),
     .allCasterBed:
        (length: OccupantBackSupportDefaultDimension(.allCasterBed).value.length
         , width: 20.0, height: 20.0)
        ]
    static let general =
    (length: OccupantBackSupportDefaultDimension(.fixedWheelRearDrive).value.length,
         width: 50.0, height: 30.0)
    let value: Dimension3d
    
    init(
        _ baseType: BaseObjectTypes) {
            
            value = dictionary[baseType] ?? Self.general
    }
    
}
