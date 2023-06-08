//
//  CreateDefaultDimensionDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation

struct CreateDefaultDimensionDictionary {
    var dictionary: Part3DimensionDictionary = [:]

    init(
        _ parts: [Part],
        _ dimensions: [Dimension3d],
        _ twinSitOnOptions: TwinSitOnOptions) {
            
        var idsForPart: [Part] = [.id0, .id1]
        var idsForSitOn: [Part] =  [.id0, .id1]
        
        // any part with backSupport in the name will only have one item per sitOn
        let onlyOneExists = [Part.backSupport.rawValue]
        let enumCodedSoAnyMemberCanBeUsed = 0
        idsForPart =
            onlyOneExists.contains(where: parts[enumCodedSoAnyMemberCanBeUsed].rawValue.contains) ? [.id0]: idsForPart

        idsForSitOn =
            (twinSitOnOptions[.frontAndRear] ?? false ||
            twinSitOnOptions[.leftAndRight] ?? false)  ? idsForSitOn: [.id0]
print(idsForSitOn)
        
        for partId in  idsForPart {
            for sitOnId in idsForSitOn {
                let nameEnd: [Part] = [partId, .stringLink, .sitOn, sitOnId]
                
                for index in 0..<parts.count {
                    let x = [parts[index]] + nameEnd
                    self.dictionary +=
                    [CreateNameFromParts(x).name: dimensions[index] ]
                }
            }
        }
    }
}

struct ObjectDefaultDimension {
    let dictionary: Part3DimensionDictionary
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions) {
            
            dictionary =
            createDefaultObjectDictionary(
                baseType,
                twinSitOnOptions)
        
            func createDefaultObjectDictionary(
                _ baseType: BaseObjectTypes,
                _ twinSitOnOptions: TwinSitOnOptions)
                -> Part3DimensionDictionary {
                    var defaultDimensionDictionary =
                            RequestOccupantBodySupportDefaultDimensionDictionary(
                                baseType, twinSitOnOptions).dictionary
                            
                        defaultDimensionDictionary +=
                                RequestOccupantFootSupportDefaultDimensionDictionary(
                                    baseType, twinSitOnOptions).dictionary
                            
                         defaultDimensionDictionary +=
                            RequestOccupantBackSupportDefaultDimensionDictionary(
                                baseType, twinSitOnOptions).dictionary
                            
                        defaultDimensionDictionary +=
                            RequestOccupantSideSupportDefaultDimensionDictionary(
                                baseType, twinSitOnOptions).dictionary
                    
                    return defaultDimensionDictionary
            }
            
    }
}

//struct FilterDefaultDimensionDictionary {
//    var filtered: Part3DimensionDictionary
//
//    init(
//        dictionary: Part3DimensionDictionary,
//        objectOptions: ObjectOptions,
//        twinSitOnOptions: TwinSitOnOptions
//    ) {
//        let twoSitOn =
//        twinSitOnOptions[.frontAndRear] ?? false || twinSitOnOptions[.leftAndRight] ?? false
//        let secondSitOnName = CreateNameFromParts([.stringLink, .sitOn, .id1]).name
//
//        filtered = dictionary
//        filtered = filterDictionary(filtered)
//
//        func filterDictionary(
//            _ dictionary: Part3DimensionDictionary)
//            -> Part3DimensionDictionary {
//
//                for (part, dimension ) in dictionary {
//                    if !twoSitOn && part.contains(secondSitOnName) {
//dictionary[part] = nil
//                    }
//                }
//                return dictionary
//        }
//
//    }
//
//}

