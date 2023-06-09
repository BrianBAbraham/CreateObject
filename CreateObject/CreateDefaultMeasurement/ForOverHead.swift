//
//  ForOverHead.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/06/2023.
//

import Foundation


//MARK: DIMENSION

struct RequestOccupantOverHeadSupportDefaultDimensionDictionary {
    var dictionary: Part3DimensionDictionary = [:]
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions
        ) {
            
        getDictionary()
        
        func getDictionary() {
                
            let allOccupantRelated = AllOccupantOverheadRelated(baseType)
            dictionary =
                CreateDefaultDimensionDictionary(
                    allOccupantRelated.parts,
                    allOccupantRelated.dimensions,
                    twinSitOnOptions
                ).dictionary
        }
    }
}



struct AllOccupantOverheadRelated {
    static let tube = (length: 50.0, width: 50.0)
    var parts: [Part] = []
    var dimensions: [Dimension3d] = []
    init(_ baseType: BaseObjectTypes
    ) {
        let width = BaseDefaultDimension(.allCasterHoist).value.width
        
         parts =
            [.overheadSupportMastBase,
            .overheadSupportMast,
            .overheadSupportAssistantHandle,
            .overheadSupportAssistantHandleInOnePiece,
            .overheadSupportLink,
            .overheadSupportJoint,
            .overheadSupport,
            .overheadSupportHook
            ]
    
        let dimensionsList =
            [
                (length: Self.tube.length, width: width , height: Self.tube.width ),
                (length: Self.tube.length ,
                 width: Self.tube.width ,
                 height: OccupantOverheadSupportMastDefaultDimension(.allCasterHoist).value.height),
                (length:  100.0, width: 40.0, height: 40.00 ),
                (length: 100.0 ,width: width/2, height: 40.0 ),
                (length: 700.0 ,width: Self.tube.width, height: Self.tube.length ),
                Joint.dimension3d,
                (length: Self.tube.length ,width: width, height: Self.tube.width ),
                (length: Self.tube.length * 2  ,width: Self.tube.width , height: Self.tube.length)
                ]
        dimensions.append(contentsOf: dimensionsList)
    }
}





struct OccupantOverheadSupportMastDefaultDimension {
    let dictionary: BaseObject3DimensionDictionary =
    [:]
    static let general =
    (length: AllOccupantOverheadRelated.tube.length,
     width: AllOccupantOverheadRelated.tube.length,
     height: 1500.0)
    let value: Dimension3d
    
    init(_ baseType: BaseObjectTypes) {
        value = dictionary[baseType] ?? Self.general
    }
}
