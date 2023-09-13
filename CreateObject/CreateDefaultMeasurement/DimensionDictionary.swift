//
//  DimensionDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 07/09/2023.
//

import Foundation


enum DimensionGroup {
    case wheel
    case body
    case foot
    case side
    case back
}

struct DimensionDictionary {
    var forPart: Part3DimensionDictionary = [:]
    
    /// uses UI editable dimensionIn value
    /// else uses defaultDimension value
    /// - Parameters:
    ///   - parts: all the parts associated with that section of the object
    ///   - defaultDimensions: default
    ///   - twinSitOnOptions:
    ///   - dimensionIn: no value or  default value or  edited value
    init(
        _ parts: [Part],
        _ defaultDimensions: [Dimension3d],
        _ twinSitOnOptions: TwinSitOnOptionDictionary,
        _ dimensionIn: Part3DimensionDictionary) {
            
        var idsForPart: [Part] = [.id0, .id1]
        let idsForSitOn: [Part] =  TwinSitOn(twinSitOnOptions).state ? [.id0, .id1]: [.id0]
        
        // any part with backSupport in the name will only have one item per sitOn
        let onlyOneExists = [Part.backSupport.rawValue]
        let enumCodedSoAnyMemberCanBeUsed = 0
        idsForPart =
            onlyOneExists.contains(where: parts[enumCodedSoAnyMemberCanBeUsed].rawValue.contains) ? [.id0]: idsForPart
//print(parts)
//print(defaultDimensions)
//print("\n\n")
        for index in 0..<parts.count{
            for partId in  idsForPart {
                for sitOnId in idsForSitOn {
                    let nameStart: [Part] =
                    [.object, .id0, .stringLink]
                    let nameEnd: [Part] = parts[index] == .sitOn ?
                    [sitOnId, .stringLink, .sitOn, .id0] : [partId, .stringLink, .sitOn, sitOnId]
                    let x = nameStart + [ parts[index]] + nameEnd
                    let partName = CreateNameFromParts(x).name
                    let dimension = dimensionIn[partName] ?? defaultDimensions[index]
                    self.forPart +=
                    [partName: dimension ]
                }
            }
        }
    }
}


//MARK: GET DIMENSIONS
//retrieves a passed value if extant else a default value
struct OccupantSupportDimensionDictionary {
    let parent: DimensionOriginCornerDictionaries
    let preTiltOccupantSupportOrigin: DimensionOriginCornerDictionaries.PreTiltOccupantSupportOrigin?
    let preTiltWheelOrigin: DimensionOriginCornerDictionaries.PreTiltWheelOrigin?
    var forBack:  Part3DimensionDictionary = [:]
    var forBody:  Part3DimensionDictionary = [:]
    var forFoot:  Part3DimensionDictionary = [:]
    var forSide: Part3DimensionDictionary = [:]
    var forWheels: Part3DimensionDictionary = [:]

    
    init(
        parent: DimensionOriginCornerDictionaries) {
            self.parent = parent
            
        preTiltOccupantSupportOrigin =
        parent.preTiltOccupantFootBackSideSupportOrigin as? DimensionOriginCornerDictionaries.PreTiltOccupantSupportOrigin
            
            preTiltWheelOrigin =
            parent.preTiltWheelOrigin as? DimensionOriginCornerDictionaries.PreTiltWheelOrigin
        
        forBack = getDictionary(
            AllOccupantBackRelated(
                parent.baseType) )
        forBody = getDictionaryForBody()
            
        forFoot =
            getDictionary(
                AllOccupantFootRelated(
                    parent.baseType) )
            
        forSide = getDictionary(
            AllOccupantSideRelated(
                parent.baseType) )
            
            getPartAndId(.back, preTiltOccupantSupportOrigin)
            getPartAndId(.wheel, preTiltWheelOrigin)
            
        let allWheelRelated =
            AllWheelRelated(
                parent.baseType)
  
            
/// I have structs which conform to a protocol
            ///
            //            if let preTiltOccupantSupportOrigin {
            //                let ids = (preTiltOccupantSupportOrigin.allOriginIdNodesForSideSupportForBothSitOn[0].ids)
            //                 let parts = (preTiltOccupantSupportOrigin.allOriginIdNodesForSideSupportForBothSitOn[0].nodes)
            //
            
        func getPartAndId (
            _ dimensionGroup: DimensionGroup,
            _ anyInputForDictionary: InputForDictionary?)
           // -> [OriginIdNodes]
            {
                var supportInputForDictionary: DimensionOriginCornerDictionaries.PreTiltOccupantSupportOrigin?
                var wheelInputForDictionary:
                DimensionOriginCornerDictionaries.PreTiltWheelOrigin?
 
                if dimensionGroup == DimensionGroup.back {
                    supportInputForDictionary = DimensionOriginCornerDictionaries.preTiltOccupantFootBackSideSupportOrigin
                                        as? DimensionOriginCornerDictionaries.PreTiltOccupantSupportOrigin
                    if inputForDictionary == nil {
print ("still nil")
                    }

print (type(of: inputForDictionary))
                }
                
                if dimensionGroup == DimensionGroup.wheel {
                    inputForDictionary = parent.preTiltWheelOrigin as? DimensionOriginCornerDictionaries.PreTiltWheelOrigin
                    
print (type(of: inputForDictionary))
                }
                
            var originIdNodes: [OriginIdNodes] = []
                
                
//            if let inputForDictionary {
//
//                switch dimensionGroup {
//                case .back:
//                    originIdNodes =
//                        inputForDictionary
//                            .allOriginIdNodesForBackSupportForBothSitOn
//                case .side:
//                    originIdNodes =
//                        preTiltOccupantSupportOrigin.allOriginIdNodesForSideSupportForBothSitOn
//                case .foot:
//                    originIdNodes =
//                        preTiltOccupantSupportOrigin.allOriginIdNodesForFootSupportForBothSitOn
//
//
//                default:
//                    break
//                }
            }
//            if let preTiltOccupantSupportOrigin {
//
//                switch dimensionGroup {
//                case .back:
//                    originIdNodes =
//                        preTiltOccupantSupportOrigin.allOriginIdNodesForBackSupportForBothSitOn
//                case .side:
//                    originIdNodes =
//                        preTiltOccupantSupportOrigin.allOriginIdNodesForSideSupportForBothSitOn
//                case .foot:
//                    originIdNodes =
//                        preTiltOccupantSupportOrigin.allOriginIdNodesForFootSupportForBothSitOn
//
//
//                default:
//                    break
//                }
            //}

//                if ids.count != parts.count {
//                    checkCondition(false)
//                }
//            }
                    //return originIdNodes
        //}

 
            
            func checkCondition(_ nonEqualCount: Bool) {
                guard nonEqualCount else {
                    fatalError("Id count and part count do not match")
                }
                
                // Continue with your program if the condition is met.
            }


            
//print(parent.preTiltOccupantFootBackSideSupportOrigin.allOriginIdNodesForSideSupportForBothSitOn)
//print(allWheelRelated.parts.count)
//        forWheels = getDictionary(
//            allWheelRelated
//            )
//print(forWheels)
        func  getDictionaryForBody()
            -> Part3DimensionDictionary {
                let dimension =
                    OccupantBodySupportDefaultDimension(
                        parent.baseType).value
                

                let parts: [Part] =
                    parent.twinSitOnState ? [.sitOn, .sitOn]: [.sitOn]
                
                return
                    DimensionDictionary(
                        parts,
                        [dimension],
                        parent.twinSitOnOption,
                        parent.dimensionIn
                    ).forPart
        }
            
         

        func getDictionary(
            _ fromPartAndDimensions: PartDimension)
        -> Part3DimensionDictionary {
            DimensionDictionary(
                fromPartAndDimensions.parts,
                fromPartAndDimensions.defaultDimensions,
                parent.twinSitOnOption,
                parent.dimensionIn
            ).forPart
        }
    }
}



