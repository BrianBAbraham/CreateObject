//
//  TransformOriginIdNodesToDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/09/2023.
//

import Foundation

struct TransformOriginIdNodeForDictionary {
    func getNodePairsToDeepestRoot (
        _ allNodesFromObject: [Part])
        -> [[Part]] {
        var nodePairs: [[Part]] = []
        for i in stride(from: 0, to: allNodesFromObject.count - 1, by: 1) {
            let pair = [allNodesFromObject[i], allNodesFromObject[i + 1]]
            nodePairs.append(pair)
        }
        return nodePairs
    }
    
    
    func getNamesFromNodePairs(
        _ nodePairs: [[Part]],
        _ idForFirstAndSecondNode: [[Part]],
        _ sitOnId: Part)
        -> [String]{
            var nodePairNames: [String] = []
            for index in 0..<nodePairs.count {
                let name =
                    CreateNameFromParts( [
                        nodePairs[index][0],
                        idForFirstAndSecondNode[index][0],
                        .stringLink,
                        nodePairs[index][1],
                        idForFirstAndSecondNode[index][1],
                        .stringLink,
                        .sitOn,
                        sitOnId
                    ]).name
                nodePairNames.append(name)
            }
        return nodePairNames
    }
   
    func getIdForFirstAndSecondNode(
        _ sitOnId: Part,
        _ nodePairsToDeepestRoot: [[Part]],
        _ partIdsForSecondOfNodePair: [[Part]],
        _ usingIdZeroOrOne: Int)
        -> [[Part]] {
        var idForFirstAndSecondNode: [[Part]] = []
        var idZeroOrOne: Int
            for index in 0..<nodePairsToDeepestRoot.count {
                idZeroOrOne =
                    partIdsForSecondOfNodePair[index].count == 2 && usingIdZeroOrOne == 1 ? 1: 0
                
                let firstId =
                nodePairsToDeepestRoot[index][0] == .sitOn ?
                    sitOnId: (nodePairsToDeepestRoot[index][0] == .object ?
                .id0: partIdsForSecondOfNodePair[index][idZeroOrOne] )
                
            let secondId =
                nodePairsToDeepestRoot[index][1] == .sitOn ? sitOnId: partIdsForSecondOfNodePair[index][idZeroOrOne]

            idForFirstAndSecondNode.append([firstId,secondId])
        }
        return idForFirstAndSecondNode
    }
    
    /// INPUTS
    /// allNodes.count =  partIds.count or CRASH
    /// allNodes is in the form [part_1 ... part_n]
    /// allNodes and partIds elements are present only if a part is present:
    /// [ [part_1, part_2, part_3, part_4] with [id0], [id1, id0],  [id1, id0], [id1]  ]
    /// is input for rightAndUnliateral as:
    /// [ [part_1, part_2, part_3, part_4] with [ [id0], [id1, id0],  [id1, id0], [id1]  ]
    /// but for left as:
    /// [part_1, part_2, part_3] with [ [id0], [id1, id0],  [id1, id0] ]
    /// since there is no part_4 on the left
    /// thus allNodes and partIds for left have an element count up to
    /// the last occurance of a partIds element with two entries
    /// TRANSFORMS
    /// allNodesFromObject is in the form [part_0, part_1 ... part_n+1]
    /// as object is always first node it is added here
    /// nodeParisToDeepestRoot is fo the form:
    /// [ [part_0, part1] , [part_1, part_2]...[part_n, part_n+1] ]
    /// idForFirstAndSecondNodeToDeepestRoot has id0 nserted as first
    /// element to correspond to allNodesFromObject
    func getNamesFromNodePairsToDeepestRoot (
        _ allNodes: [Part],
        _ partIds: [[Part]],
       usingIdZeroOrOne: Int)
        -> [String] {
        let sitOnId = allNodes.contains(.sitOn) ?
            partIds[0][0]: .id0 // some roots, eg wheels exclude sitOn so use id0
        let allNodeFromObject = [Part.object] + allNodes // first node is always object
        
        /// [ [part_0, part_1, part_2, part_3, part_4] ] would be transformed to
        /// [ [part_0, part_1], [part_1, part_2], [ part_2, part_3], [ part_3, part_4] ]
        let nodePairsToDeepestRoot =
            getNodePairsToDeepestRoot(allNodeFromObject)
//print(nodePairsToDeepestRoot)
        /// [ [id0] ,[id0], [id1, id0],  [id1, id0], [id1]  ] transforms to
        /// [[id0, id0],  [id0, id1], [id1, id1], [id1, id1]
        let idForFirstAndSecondNodeToDeepestRoot: [[Part]] =
            getIdForFirstAndSecondNode(
                sitOnId,
                nodePairsToDeepestRoot,
                partIds,
                usingIdZeroOrOne)
            
        let names = getNamesFromNodePairs(
            nodePairsToDeepestRoot,
            idForFirstAndSecondNodeToDeepestRoot,
            sitOnId)
        return
            names
    }
}
