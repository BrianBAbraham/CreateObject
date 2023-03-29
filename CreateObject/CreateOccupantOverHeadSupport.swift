//
//  CreateOccupantOverHeadSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/03/2023.
//

import Foundation

//struct InitialOccupantOverHeadSupportMeasure {
//
//    let lieOn: Dimension
//    let sitOn: Dimension
//    let sleepOn: Dimension
//    let standOn: Dimension
//
//    init(
//        lieOn: Dimension = (length: 1600 ,width: 600),
//        sitOn: Dimension = (length: 500 ,width: 400),
//        sleepOn: Dimension = (length: 1800 ,width: 900),
//        standOn: Dimension = (length: 300 ,width: 500)) {
//        self.lieOn = lieOn
//        self.sitOn = sitOn
//        self.sleepOn = sleepOn
//        self.standOn = standOn
//    }
//}



struct CreateOccupantOverHeadSupport {
    var dictionary: PositionDictionary = [:]
    
    init(
        _ overHeadSupportCorners: [PositionAsIosAxes]) {
            dictionary +=
            DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToMany(
                .primaryOrigin,
                .overHeadSupport,
                [Globalx.iosLocation],
                firstOriginId: 0)
            
            dictionary +=
            getOneOverHeadSupportCornerDictionary (
                overHeadSupportCorners)
            
            func getOneOverHeadSupportCornerDictionary (
                _ bodySupportCorners: [PositionAsIosAxes])
            -> [String: PositionAsIosAxes] {
                let supportIndexAlways = 0
                let corners = bodySupportCorners
                var dictionary: [String: PositionAsIosAxes] = [:]
                for index in 0..<corners.count {
                    let name =
                    Part.overHeadSupport.rawValue + Part.id.rawValue +
                    String(supportIndexAlways) + Part.stringLink.rawValue +
                    Part.corner.rawValue + String(index)
                    dictionary += [name: corners[index]]
                }
                return dictionary
            }
        }
    
    
}


   
