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
        let idsForSitOn: [Part] =  TwinSitOn(twinSitOnOptions).state ? [.id0, .id1]: [.id0]
        
        // any part with backSupport in the name will only have one item per sitOn
        let onlyOneExists = [Part.backSupport.rawValue]
        let enumCodedSoAnyMemberCanBeUsed = 0
        idsForPart =
            onlyOneExists.contains(where: parts[enumCodedSoAnyMemberCanBeUsed].rawValue.contains) ? [.id0]: idsForPart

        for index in 0..<parts.count{
            for partId in  idsForPart {
                for sitOnId in idsForSitOn {
                    let nameEnd: [Part] = parts[index] == .sitOn ?
                    [sitOnId, .stringLink, .object, .id0] : [partId, .stringLink, .sitOn, sitOnId]
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
                    

//print("DEFAULT")
//DictionaryInArrayOut().getNameValue(defaultDimensionDictionary).forEach{print($0)}
//print("")
                    
                    return defaultDimensionDictionary
            }
    }
}


//struct CreateDefaultOriginDictionary {
//    var dictionary: PositionDictionary = [:]
//
//    init(
//        _ parts: [Part],
//        _ origins: [PositionAsIosAxes],
//        _ twinSitOnOptions: TwinSitOnOptions) {
//            
//        var idsForPart: [Part] = [.id0, .id1]
//        var idsForSitOn: [Part] =  [.id0, .id1]
//        
//        // any part with backSupport in the name will only have one item per sitOn
//        let onlyOneExists = [Part.backSupport.rawValue]
//        let enumCodedSoAnyMemberCanBeUsed = 0
//        idsForPart =
//            onlyOneExists.contains(where: parts[enumCodedSoAnyMemberCanBeUsed].rawValue.contains) ? [.id0]: idsForPart
//
//        idsForSitOn =
//            (twinSitOnOptions[.frontAndRear] ?? false ||
//            twinSitOnOptions[.leftAndRight] ?? false)  ? idsForSitOn: [.id0]
//            
//        for partId in  idsForPart {
//            for sitOnId in idsForSitOn {
//                let nameEnd: [Part] = [partId, .stringLink, .sitOn, sitOnId]
//                
//                for index in 0..<parts.count {
//                    let x = [parts[index]] + nameEnd
//                    self.dictionary +=
//                    [CreateNameFromParts(x).name: dimensions[index] ]
//                }
//            }
//        }
//    }
//}


struct ObjectDefaultOrigin {
    let dictionary: PositionDictionary
    
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOptions: TwinSitOnOptions) {
            
            dictionary =
                createDefaultOriginDictionary(
                baseType,
                twinSitOnOptions)
            
            func createDefaultOriginDictionary(
                _ baseType: BaseObjectTypes,
                _ twinSitOnOptions: TwinSitOnOptions)
            -> PositionDictionary{
                
                return [:]
            }
        }
}


//
//struct Chair {
//    let sizeDictionaryOut: Part3DimensionDictionary = [:]
//    let originDictionaryOut: PositionDictionary = [:]
//    let options: ObjectOptions
//    let baseType: BaseObjectTypes
//
//
//    struct DistanceBetween {
//        let frontToRearWheels: BaseSizeDictionary =
//            [.fixedWheelRearDrive: 400.0, .fixedWheelFrontDrive: 400.0, .fixedWheelMidDrive: 400.0]
//        let frontToMidWheels: BaseSizeDictionary
//        let midToFrontWheels: BaseSizeDictionary
//        let rearWheels: BaseSizeDictionary
//        let midWheels: BaseSizeDictionary
//        let frontWheels: BaseSizeDictionary
//    }
//
//    struct SizeOf {
//        let parts: Part3DimensionDictionary =
//        [Part.armSupport.rawValue: ZeroTouple.dimension3D]
//
//    }
//
//    struct OriginFrom {
//
//    }
//
//}
