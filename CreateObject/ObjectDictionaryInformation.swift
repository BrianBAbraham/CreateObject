//
//  ObjectDictionaryInformation.swift
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
//print(cornerNames)
            var uniqueCornerLocations: [PositionAsIosAxes] = []
            let uniquePartNameInSplitForm: [String] =
            uniquePartName.components(separatedBy:  ConnectStrings.symbol)
            //uniquePartName.split(separator: ConnectStrings.symbol)// requires IOS 16
            
            //let generalPartNameIsFirst = 0
//            let generalPartName = GetGeneralName(uniquePartName).fromUniquePartName
            
            var uniqueCornerLocation: PositionAsIosAxes
            var assembledUniquePartCornerName: String
            let numberOfConnectStringSymbols = uniquePartName.filter({ $0 == Character(ConnectStrings.symbol) }).count
                

 
            if numberOfConnectStringSymbols == 3 { //related to possibly two sitOn elements
                for cornerName in cornerNames {
//print(uniquePartName)
                    assembledUniquePartCornerName = uniquePartNameInSplitForm[0] + ConnectStrings.symbol + uniquePartNameInSplitForm[1] + ConnectStrings.symbol + uniquePartNameInSplitForm[2] + ConnectStrings.symbol + uniquePartNameInSplitForm[3] + cornerName
                    
                    
                    
//print(assembledUniquePartCornerName)
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

           // return [generalPartName: uniqueCornerLocations]
            return [uniquePartName: uniqueCornerLocations]
        }
    }
}



