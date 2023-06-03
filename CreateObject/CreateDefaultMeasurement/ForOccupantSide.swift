//
//  ForOccupantSide.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

//import Foundation
//
//struct OccupantSideSupportDefaultDimensionDictionary {
//    let dictionary: Part3DimensionDictionary
//
//    init(
//        _ baseType: BaseObjectTypes,
//        _ sitOnOptions: TwinSitOnOptions,
//        _ options: OptionDictionary) {
//
//        dictionary =
//            getDimensionDictionary(
//                baseType,
//                sitOnOptions,
//                options)
//
//        func getDimensionDictionary (
//            _ baseType: BaseObjectTypes,
//            _ sitOnOptions: TwinSitOnOptions,
//            _ options: OptionDictionary)
//            -> Part3DimensionDictionary {
//                
//            var dictionary: Part3DimensionDictionary =
//            getOneDictionary(.id0)
//
//            let thereAreTwoSitOn =
//            sitOnOptions[.frontAndRear] ?? false ||
//            sitOnOptions[.leftAndRight] ?? false
//
//
//
//
//            if thereAreTwoSitOn {
//                dictionary += getOneDictionary(.id1)
//            }
//
//            func getOneDictionary(_ id: Part)
//            -> Part3DimensionDictionary {
//                
//                        
//                var dictionary = getForEachSupport(.id0)
//                
//                func getForEachSupport( _ idSupport: Part)
//                -> Part3DimensionDictionary {
//                    return
//                        [CreateNameFromParts(
//                            [.footSupportHangerSitOnVerticalJoint, idSupport, .stringLink, .sitOn, id]).name:
//                            Joint.dimension3d,
//                        CreateNameFromParts(
//                            [.footSupportHangerLink, idSupport, .stringLink, .sitOn, id]).name:
//                        OccupantFootSupportHangerDefaultDimension(baseType).value,
//                            CreateNameFromParts(
//                            [.footSupportHorizontalJoint, idSupport, .stringLink, .sitOn, id]).name:
//                        OccupantFootSupportJointDefaultDimension(baseType).value,
//                         CreateNameFromParts(
//                             [.footSupport, idSupport, .stringLink, .sitOn, id]).name:
//                         OccupantFootSupportDefaultDimension(baseType).value
//                        ]
//                }
//
//                
//               
//                    dictionary += getForEachSupport(.id1)
//                
//                return dictionary
//
//            }
//
//            return dictionary
//        }
//    }
//
//}
