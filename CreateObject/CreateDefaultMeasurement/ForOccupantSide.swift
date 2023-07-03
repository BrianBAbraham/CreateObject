//
//  ForOccupantSide.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

//import Foundation
//





struct PreTiltOccupantSideSupportDefaultDimension {
    
    var dictionary: BaseObject3DimensionDictionary =
    [.allCasterStretcher:
        (width: 20.0, length: PreTiltOccupantBackSupportDefaultDimension(.allCasterStretcher).value.length, height: 20.0),

     .allCasterBed:
        (width: 20.0,
         length: PreTiltOccupantBackSupportDefaultDimension(.allCasterBed).value.length
         , height: 20.0)
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
            (            width: 40.0,
                length: OccupantBodySupportDefaultDimension(.fixedWheelRearDrive//, modifiedPartDictionary
                                                        ).value.length,

             height: 30.0)
        
            value =
                //modifiedDictionary[baseType] ??
                dictionary[baseType] ??
                general
    }
    
}
