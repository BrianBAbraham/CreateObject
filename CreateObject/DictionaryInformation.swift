//
//  DictionaryInformation.swift
//  CreateObject
//
//  Created by Brian Abraham on 14/04/2023.
//

import Foundation

struct PartNameAndItsCornerLocations {
    let dictionaryFromPrimaryOrigin: [String: [PositionAsIosAxes]]
    
    init(
        _ uniquePartName: String,
        _ forScreenOrMeasurment: DictionaryTypes,
        _ dictionary: PositionDictionary) {
        
            dictionaryFromPrimaryOrigin = getPartNameAndItsCornerLocationsFromPrimaryOrigin(
                uniquePartName,
                forScreenOrMeasurment,
                dictionary)
            
            func getPartNameAndItsCornerLocationsFromPrimaryOrigin(
                _ uniquePartName: String,
                _ forScreenOrMeasurment: DictionaryTypes,
                _ dictionary: PositionDictionary)
            -> [String: [PositionAsIosAxes]] {
                let cornerNames = Corner.names
                var uniqueCornerLocations: [PositionAsIosAxes] = []
                let uniquePartNameInSplitForm: [String] =
                uniquePartName.components(separatedBy:  ConnectStrings.symbol)
                //uniquePartName.split(separator: ConnectStrings.symbol)// requires IOS 16
                
                let generalPartNameIsFirst = 0
                let generalPartName = String(uniquePartNameInSplitForm[generalPartNameIsFirst])
                var uniqueCornerLocation: PositionAsIosAxes
                var assembledUniquePartCornerName: String
                let numberOfConnectStringSymbols = uniquePartName.filter({ $0 == Character(ConnectStrings.symbol) }).count
                
        //        if numberOfConnectStringSymbols == 5 {
        //            for cornerName in cornerNames {
        //                assembledName = dictionaryNameInSplitForm[0] + ConnectStrings.symbol + dictionaryNameInSplitForm[1] + cornerName + ConnectStrings.symbol + dictionaryNameInSplitForm[2] + ConnectStrings.symbol + dictionaryNameInSplitForm[3]
        //
        //                cornerLocation = dictionary[ String(assembledName)] ?? Global.iosLocation
        //                cornerLocations.append(cornerLocation)
        //            }
        //        }
                
                if numberOfConnectStringSymbols == 3 { //related to possibly two sitOn elements
                    for cornerName in cornerNames {
                        assembledUniquePartCornerName = uniquePartNameInSplitForm[0] + ConnectStrings.symbol + uniquePartNameInSplitForm[1] + cornerName + ConnectStrings.symbol + uniquePartNameInSplitForm[2] + ConnectStrings.symbol + uniquePartNameInSplitForm[3]

                        uniqueCornerLocation = dictionary[ String(assembledUniquePartCornerName)] ?? Globalx.iosLocation
                        uniqueCornerLocations.append(uniqueCornerLocation)
                    }
                }
                if numberOfConnectStringSymbols == 1 { // not related to possibly two sitOn elements
                    for cornerName in cornerNames {
                        let newName = uniquePartName + cornerName
                        uniqueCornerLocation = dictionary[newName] ?? Globalx.iosLocation
                        uniqueCornerLocations.append(uniqueCornerLocation)
                    }
                }
                return [generalPartName: uniqueCornerLocations]
            }
    }
}
