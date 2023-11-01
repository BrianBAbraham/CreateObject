//
//  DimensionDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 07/09/2023.
//

import Foundation


//enum DimensionGroup {
//    case rearWheel
//    case midWheel
//    case frontWheel
//    case body
//    case foot
//    case side
//    case back
//    case tiltInSpace
//}

/// it is acknowledged that the use of nodes, an array of parts in order from object to part repeated to end of node chairn
/// creates a duplication since for example many parts have sitOn as a parent and therefore the sitOn dimension is created but
/// adds no further elments to the dicitionary as it alreay exists
/// However, this keeps the node chains intact
struct DimensionDictionary {
    var forPart: Part3DimensionDictionary = [:]
    
    
    init(
        _ originIdNodes: [OriginIdPartChain],
        _ defaultDimensions: [Dimension3d],
        _ dimensionIn: Part3DimensionDictionary,
        _ sitOnIndex: Int) {
//            print(originIdNodes)
//            print(defaultDimensions)
        let sitOnId: Part = [.id0,.id1][sitOnIndex]
        let parts = originIdNodes[sitOnIndex].chain
//print(defaultDimensions)
//print(parts)
//print(parts.count)
        for partIndex in 0..<parts.count  {
            let idsForPart: [Part] = originIdNodes[sitOnIndex].ids[partIndex]
            for partIdIndex in  0..<idsForPart.count {
        
                let nameStart: [Part] =
                [.object, .id0, .stringLink]
                
                let nameEnd: [Part] = parts[partIndex] == .sitOn ?
                    [sitOnId, .stringLink, .sitOn, sitOnId] : [idsForPart[partIdIndex], .stringLink, .sitOn, sitOnId]
                if parts == LabelInPartChainOut.sitOnTiltJoint {
                 
                }
                let x = nameStart + [ parts[partIndex]] + nameEnd
                let partName = CreateNameFromParts(x).name
                let dimension = dimensionIn[partName] ?? defaultDimensions[partIndex]
                self.forPart +=
                [partName: dimension ]
            }
        }
    }
}




/// it is acknowledged that the use of nodes, an array of parts in order from object to part repeated to end of node chairn
/// creates a duplication since for example many parts have sitOn as a parent and therefore the sitOn dimension is created but
/// adds no further elments to the dicitionary as it alreay exists
/// However, this keeps the node chains intact
struct DimensionDictionary2 {
    var forPart: Part3DimensionDictionary = [:]
    var partIds: [[Part]] = []
    var partChain: [Part] = []
    var partOrigin: [PositionAsIosAxes] = []
    var partDimensions: [Dimension3d] = []
    
    init(
        _ partDimensionOriginIdsChain: [PartDimensionOriginIdsChain],
//        _ originIdNodes: [OriginIdPartChain],
//        _ defaultDimensions: [Dimension3d],
        _ dimensionIn: Part3DimensionDictionary,
        _ sitOnIndex: Int = 0) {
//            print(originIdNodes)
//            print(defaultDimensions)
        let sitOnId: Part = [.id0,.id1][sitOnIndex]
        

            for item in partDimensionOriginIdsChain {
                partChain.append(item[0].part)
                partIds.append(item[0].ids)
                partOrigin.append(item[0].origin)
                partDimensions.append(item[0].dimension)
               
            }
            //let parts = originIdNodes[sitOnIndex].chain
            let parts = partChain
            
        for partIndex in 0..<parts.count  {
            //let idsForPart: [Part] = originIdNodes[sitOnIndex].ids[partIndex]
            let idsForPart: [Part] = partIds[partIndex]
            
            for partIdIndex in  0..<idsForPart.count {
        
                let nameStart: [Part] =
                [.object, .id0, .stringLink]
                
                let nameEnd: [Part] = parts[partIndex] == .sitOn ?
                    [sitOnId, .stringLink, .sitOn, sitOnId] : [idsForPart[partIdIndex], .stringLink, .sitOn, sitOnId]
                if parts == LabelInPartChainOut.sitOnTiltJoint {
                 
                }
                let x = nameStart + [ parts[partIndex]] + nameEnd
                let partName = CreateNameFromParts(x).name
                //let dimension = dimensionIn[partName] ?? defaultDimensions[partIndex]
                let dimension = dimensionIn[partName] ?? partDimensions[partIndex]
                self.forPart +=
                [partName: dimension ]
            }
        }
    }
}

