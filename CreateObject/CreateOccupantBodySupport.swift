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
        _ baseType: BaseObjectTypes) {
            
        self.oneBodySupportFromPrimaryOrigin =
            oneBodySupportFromPrimaryOrigin
            
        dictionary +=
            DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToMany(
            .primaryOrigin,
            .sitOn,
            [oneBodySupportFromPrimaryOrigin],
            firstOriginId: 0)

        dictionary +=
            getOneBodySupportCornerDictionary(
                bodySupportCorners,
                supportIndex)
            
            func getOneBodySupportCornerDictionary (
                _ bodySupportCorners: [PositionAsIosAxes],
                _ supportIndex: Int
                ) -> [String: PositionAsIosAxes] {
                    let corners = bodySupportCorners
                    var dictionary: [String: PositionAsIosAxes] = [:]
                    for index in 0..<corners.count {
                        let name =
                        Part.sitOn.rawValue + Part.id.rawValue +
                        String(supportIndex) + Part.stringLink.rawValue +
                        Part.corner.rawValue + String(index)
                        dictionary += [name: corners[index]]
                    }
                    return dictionary
            }
    }
    




    
}
///getAllSitOnFromPrimaryOrigin
///    getOneSitOnFromPrimaryOrigin
///               getAllSitOnFromPrimaryOriginAccountForTwoSitOn
