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
    let modifiedPartDictionary: Part3DimensionDictionary
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptionDictionary,
        _ modifiedPartDictionary: Part3DimensionDictionary
        ) {
        self.modifiedPartDictionary = modifiedPartDictionary
        getDictionary()
        
        func getDictionary() {
                
            let allOccupantRelated =
            OccupantSideSupportDefaultDimension(
                baseType
            )
            
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
    
    let value: Dimension3d
    //let modifiedPartDictionary: Part3DimensionDictionary
    var general: Dimension3d
        
    
    init(
        _ baseType: BaseObjectTypes//,
        //_ modifiedPartDictionary: Part3DimensionDictionary
    ) {
            
            //self.modifiedPartDictionary = modifiedPartDictionary
            general =
            (length: OccupantBodySupportDefaultDimension(.fixedWheelRearDrive//, modifiedPartDictionary
                                                        ).value.length,
            width: 40.0,
             height: 30.0)
        
            value =
                //modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                general
    }
    
}
