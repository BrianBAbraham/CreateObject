//
//  DimensionDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 07/09/2023.
//

import Foundation

/// it is acknowledged that the use of nodes, an array of parts in order from object to part repeated to end of node chairn
/// creates a duplication since for example many parts have sitOn as a parent and therefore the sitOn dimension is created but
/// adds no further elments to the dicitionary as it alreay exists
/// However, this keeps the node chains intact
struct DimensionDictionary {
    var forPart: Part3DimensionDictionary = [:]
    var partIds: [[Part]] = []
    var partChain: [Part] = []
    var partOrigin: [PositionAsIosAxes] = []
    var partDimensions: [Dimension3d] = []
    
    init(
        _ partDimensionOriginIdsChain: [PartDataTuple],
        _ dimensionIn: Part3DimensionDictionary,
        _ sitOnIndex: Int = 0) {
//            print(originIdNodes)
//            print(defaultDimensions)
        let sitOnId: Part = [.id0,.id1][sitOnIndex]
        for item in partDimensionOriginIdsChain {
            partChain.append(item.part)
            partIds.append(item.ids)
            partOrigin.append(item.origin)
            partDimensions.append(item.dimension)
        }

        //let parts = partChain
            
        for partIndex in 0..<partChain.count  {
            let idsForPart: [Part] = partIds[partIndex]
            
            for partIdIndex in  0..<idsForPart.count {
        
                let nameStart: [Part] =
                [.object, .id0, .stringLink]
                
                let nameEnd: [Part] = partChain[partIndex] == .sitOn ?
                    [sitOnId, .stringLink, .sitOn, sitOnId] : [idsForPart[partIdIndex], .stringLink, .sitOn, sitOnId]
                if partChain == LabelInPartChainOut.sitOnTiltJoint {
                 
                }
                let x = nameStart + [ partChain[partIndex]] + nameEnd
                let partName = CreateNameFromParts(x).name
                //let dimension = dimensionIn[partName] ?? defaultDimensions[partIndex]
                let dimension = dimensionIn[partName] ?? partDimensions[partIndex]
                self.forPart +=
                [partName: dimension ]
            }
        }
    }
}

