//
//  ForBase.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/06/2023.
//

import Foundation

struct RequestBaseDefaultDimensionDictionary {
    var dictionary: Part3DimensionDictionary = [:]
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions
    ) {
        getDictionary()

        func getDictionary() {
           
         let allOccupantBackRelated =
                AllOccupantBackRelated(
                    baseType
                )
                
            dictionary =
                CreateDefaultDimensionDictionary(
                    allOccupantBackRelated.parts,
                    allOccupantBackRelated.dimensions,
                    twinSitOnOptions
                ).dictionary
        }
    }
}

struct AllBaseRelated {
    let parts: [Part]
    let dimensions: [Dimension3d]
    init(_ baseType: BaseObjectTypes) {
        parts = [
        
        ]
        
        dimensions = [
        
        ]
    }
    
    
}


struct BaseDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [.allCasterBed: (length: 2200.0, width: 900.0, height: 40.0),
     .allCasterChair: (length: 500.0, width: 500.0, height: 20.0),
     .allCasterHoist: (length: 1200.0, width: 600.0, height: 40.0),
     .allCasterTiltInSpaceShowerChair:  (length: 600.0, width: 500.0, height: 20.0),
     .allCasterStretcher: (length: 1800.0, width: 600.0, height: 40.0),
     .scooterFrontDrive3Wheeler: (length: 800.0, width: 600.0, height: 20.0)
     
        ]
    static let general = (length: 500.0, width: 500.0, height: 20.0)
    let value: Dimension3d
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
    }
}


struct BaseNarrowDefaultDimension {
    var dictionary: BaseObject3DimensionDictionary =
    [ .fixedWheelMidDrive: (length: Self.general.length, width: Self.general.width * 0.8, height: Self.general.height)
        ]
    static let general = BaseDefaultDimension(.fixedWheelRearDrive).value
    let value: Dimension3d
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
    }
}
