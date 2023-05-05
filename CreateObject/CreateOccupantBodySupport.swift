//
//  CreateOccupantBodySupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 25/03/2023.
//

import Foundation


struct CreateOccupantBodySupport {
    let oneBodySupportFromPrimaryOrigin: PositionAsIosAxes
    var dictionary: PositionDictionary = [:]

    init(
        _ oneBodySupportFromPrimaryOrigin: PositionAsIosAxes,
        _ bodySupportCorners: [PositionAsIosAxes],
        _ supportIndex: Int,
        _ baseType: BaseObjectTypes,
        _ occupantSupportMeasure: Dimension) {
            
        self.oneBodySupportFromPrimaryOrigin =
            oneBodySupportFromPrimaryOrigin
            
            let bodySupportDictionary =
            CreateOnePartOrSideSymmetricParts(
                occupantSupportMeasure,
                .sitOn,
                oneBodySupportFromPrimaryOrigin,
                Globalx.iosLocation,
                supportIndex)

            
            dictionary += bodySupportDictionary.originDictionary
            dictionary += bodySupportDictionary.cornerDictionary
            
    }

}



