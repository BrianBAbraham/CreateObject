//
//  ObjectDictionaryInformation.swift
//  CreateObject
//
//  Created by Brian Abraham on 14/04/2023.
//

import Foundation

//struct PartNameAndItsCornerLocations {
//    let dictionaryFromPrimaryOrigin: [String: [PositionAsIosAxes]]
//
//    init(
//        _ uniquePartName: String,
//        _ forScreenOrMeasurment: DictionaryTypes,
//        _ dictionary: PositionDictionary) {
//
//
//        dictionaryFromPrimaryOrigin = getPartNameAndItsCornerLocationsFromPrimaryOrigin(
//            uniquePartName,
//            forScreenOrMeasurment,
//            dictionary)
            

//DictionaryInArrayOut().getNameValue( dictionaryFromPrimaryOrigin).forEach{print($0)}
//print ("IN")
//print (dictionary)
//print("OUT")
//print (dictionaryFromPrimaryOrigin)
//print("\n\n\n")
//
        
//        func getPartNameAndItsCornerLocationsFromPrimaryOrigin(
//            _ uniquePartName: String,
//            _ forScreenOrMeasurment: DictionaryTypes,
//            _ dictionary: PositionDictionary)
//            -> [String: [PositionAsIosAxes]] {
//
//            let cornerNames = Corner.names
//
//            var uniqueCornerLocations: [PositionAsIosAxes] = []
//            let uniquePartNameInSplitForm: [String] =
//            uniquePartName.components(separatedBy:  ConnectStrings.symbol)
//
//
//            var uniqueCornerLocation: PositionAsIosAxes
//            var assembledUniquePartCornerName: String
//            let numberOfConnectStringSymbols = uniquePartName.filter({ $0 == Character(ConnectStrings.symbol) }).count
//
//
//
//            if numberOfConnectStringSymbols == 3 { //related to possibly two sitOn elements
//                for cornerName in cornerNames {
//
//                    assembledUniquePartCornerName = uniquePartNameInSplitForm[0] + ConnectStrings.symbol + uniquePartNameInSplitForm[1] + ConnectStrings.symbol + uniquePartNameInSplitForm[2] + ConnectStrings.symbol + uniquePartNameInSplitForm[3] + cornerName
//
//
//
//
//                    uniqueCornerLocation = dictionary[ String(assembledUniquePartCornerName)] ?? ZeroValue.iosLocation
//                    uniqueCornerLocations.append(uniqueCornerLocation)
//                }
//            }
//
//            if numberOfConnectStringSymbols == 1 { // not related to possibly two sitOn elements
//                for cornerName in cornerNames {
//                    let newName = uniquePartName + cornerName
//                    uniqueCornerLocation = dictionary[newName] ?? ZeroValue.iosLocation
//                    uniqueCornerLocations.append(uniqueCornerLocation)
//                }
//            }
//
//            return [uniquePartName: uniqueCornerLocations]
//        }
//    }
//}
//
//struct GetDimensionFromDictionary {
//    let dimension3D: Dimension3d
//    let sitOnDimension3D: [Dimension3d]
//
//
//    init(
//        _ dictionary: Part3DimensionDictionary,
//        _ parts: [Part] = []) {
//
//        dimension3D =
//        getDimension(
//            dictionary,
//            parts
//        )
//
//        sitOnDimension3D =
//                [getDimension( dictionary, [.sitOn, .id0, .stringLink, .object, .id0]),
//
//                getDimension( dictionary, [.sitOn, .id1, .stringLink, .object, .id0])]
//            func getDimension(
//                _ dictionary: Part3DimensionDictionary,
//                _ parts: [Part])
//                -> Dimension3d {
//                let name = CreateNameFromParts(parts).name
//
//                let dimension = dictionary[name] ?? ZeroValue.dimension3d
//
//                return dimension
//        }
//    }
//}


//struct GetPositionFromDictionary {
//    let dimension3D: Dimension3d
//    let sitOnDimension3D: [Dimension3d]
//
//
//    init(
//        _ dictionary: Part3DimensionDictionary,
//        _ parts: [Part] = []) {
//
//        dimension3D =
//        getDimension(
//            dictionary,
//            parts
//        )
//
//        sitOnDimension3D =
//                [getDimension( dictionary, [.sitOn, .id0, .stringLink, .object, .id0]),
//
//                getDimension( dictionary, [.sitOn, .id1, .stringLink, .object, .id0])]
//            func getDimension(
//                _ dictionary: Part3DimensionDictionary,
//                _ parts: [Part])
//                -> Dimension3d {
//                let name = CreateNameFromParts(parts).name
//
//                let dimension = dictionary[name] ?? ZeroValue.dimension3d
//
//                return dimension
//        }
//    }
//}

struct GetValueFromDictionary <T> {
    var value: T

    init(
        _ dictionary: [String: T],
        _ parts: [Part] = []) {
            
            value = ZeroValue.iosLocation as! T
      
        getDimension(
            dictionary,
            parts
        )
 
        func getDimension(
            _ dictionary: [String: T],
            _ parts: [Part]){

            let name = CreateNameFromParts(parts).name

            let wrappedDimension = dictionary[name] //

                if wrappedDimension is PositionAsIosAxes {
                value = wrappedDimension ?? ZeroValue.iosLocation as! T
            }

                if wrappedDimension is Dimension3d {
                value = wrappedDimension ?? ZeroValue.dimension3d as! T
            }
        }
    }
}










