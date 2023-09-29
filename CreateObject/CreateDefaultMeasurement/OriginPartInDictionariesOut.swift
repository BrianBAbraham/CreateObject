//
//  OriginPartInDictionariesOut.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/09/2023.
//

import Foundation

///first step create names for dictionary
/// get origin for left parts
/// create parentToPartDic
///  use names to extract origin in correct order from parentToPartDic
///  func to create new  object to part orgiins
///  create objecToPartDic
///  for object to part

//MARK:- DICTIONARY
struct OriginPartInDictionariesOut {
    let rightOrUnilateralOrigin: [PositionAsIosAxes]
    var leftOrigin: [PositionAsIosAxes] = []
    let partIds: [[Part]]
    let partNodes: [Part]
    let preTiltParentToPartOriginIn: PositionDictionary
    let namesForRightOrUnilateral: [String]
    let namesForLeft: [String]
    let allNames: [String]
    
    init(
        _ originIdNodes: OriginIdNodes,
        _ preTiltParentToPartOriginIn: PositionDictionary) {
        rightOrUnilateralOrigin = originIdNodes.origin
        partIds = originIdNodes.ids
        partNodes = originIdNodes.chain
        self.preTiltParentToPartOriginIn =
            preTiltParentToPartOriginIn
        ///names are in order from object to part
        ///so these can be used to determine
        ///object to part origin
        namesForRightOrUnilateral =
            TransformOriginIdNodeForDictionary()
                .getNamesFromNodePairsToDeepestRoot(
                    partNodes,
                    partIds,
                    usingIdZeroOrOne: 0)

        let numberOfNodesTillOnlyOneId =
            getNumberOfNodesTillOnlyOneId(partIds)
        let partIdsForLeft = Array(partIds.prefix(numberOfNodesTillOnlyOneId))
        let partNodesForLeft = Array(partNodes.prefix(numberOfNodesTillOnlyOneId))
        if numberOfNodesTillOnlyOneId > 0 {
           namesForLeft =
                TransformOriginIdNodeForDictionary().getNamesFromNodePairsToDeepestRoot(
                        partNodesForLeft,
                        partIdsForLeft,
                        usingIdZeroOrOne: 1)

        } else {
            namesForLeft = []
        }

        allNames =
            namesForRightOrUnilateral +
            namesForLeft

        createLeftOrigin()
        
        /// for [id0], [id1, id0],  [id1, id0], [id1]  ] for
        /// the left side there is no part at the fourth deepest
        /// node, the terminal node so the node position at which
        /// the last occurance of the part is  determined
        /// while there is no left part for the first element
        /// all elements prior to the last occurance of a
        /// left element must be retained as you only reach that
        /// part via unilateral elements
        func getNumberOfNodesTillOnlyOneId (
            _ partIds: [[Part]])
            -> Int {
            var numberOfNodesTillOnlyOneId = 0
            let correctForCountStartAtZero = 1
                
                if let lastIndex = partIds.indices.reversed().first(where: { partIds[$0].count == 2 }) {
                    numberOfNodesTillOnlyOneId =
                        lastIndex + correctForCountStartAtZero
                }
          return numberOfNodesTillOnlyOneId
        }
    }
    
    mutating func createLeftOrigin()
        {
        let rightUnilateralAndLeftOrigin =
                LeftAndRightOrigin(
                    rightAndUnilateralOrigin: rightOrUnilateralOrigin,
                    partIds: partIds)
        leftOrigin = rightUnilateralAndLeftOrigin.left
    }
    
    
    func makeAndGetForParentToPart()
        -> PositionDictionary {
        let allOrigin =
            rightOrUnilateralOrigin +
            leftOrigin
        var dictionary: PositionDictionary = [:]
        for (index, key) in allNames.enumerated() {
            dictionary[key] =
            preTiltParentToPartOriginIn[key] ??
                allOrigin[index]
        }
        return dictionary
    }
    
    
    func createForObjectToPart(
        _ preTiltObjectToPartOriginIn: PositionDictionary )
        -> PositionDictionary {
        let rightOrUnilateralOrigin =
            createObjectToPartOrigin(rightOrUnilateralOrigin)
        let leftOrigin =
            createObjectToPartOrigin(leftOrigin)
        let allOrigin =
            rightOrUnilateralOrigin +
            leftOrigin
        var dictionary: PositionDictionary = [:]
        for (index, key) in allNames.enumerated() {
            dictionary[key] =
            preTiltObjectToPartOriginIn[key] ??
                allOrigin[index]
        }
//DictionaryInArrayOut().getNameValue( dictionary).forEach{print($0)}
//print("\n\n")
        return dictionary
    }
    
    
    func createObjectToPartOrigin( _ positions: [PositionAsIosAxes] )
        -> [PositionAsIosAxes] {
        let rightOrUnilateralAsArray = CreateIosPosition.getArrayFromPositions(positions)
        let transformedX = sumUp(rightOrUnilateralAsArray.x)
        let transformedY = sumUp(rightOrUnilateralAsArray.y)
        let transformedZ = sumUp(rightOrUnilateralAsArray.z)
        var objectToPartOrigin: [PositionAsIosAxes] = []
        for index in 0..<transformedX.count {
            objectToPartOrigin.append(
                (x: transformedX[index],
                 y: transformedY[index],
                 z: transformedZ[index])
                )
        }

        func sumUp(_ positionInOneAxis:[Double])
        -> [Double] {
            ///add up the indvidual axes measures to get the object to part
            ///Code by ChatGPT
            let transformedArray = positionInOneAxis.enumerated().map
            { index, element in
                return positionInOneAxis.prefix(index + 1).reduce(0, +)
            }
            return transformedArray
        }
        return objectToPartOrigin
    }
    
    func makeAndGetForObjectToPart()
        -> PositionDictionary {

        let allNames =
            namesForRightOrUnilateral + namesForLeft
        let rightUnilateralAndLeftOrigin =
                LeftAndRightOrigin(
                    rightAndUnilateralOrigin: rightOrUnilateralOrigin,
                    partIds: partIds)
            let leftOrigin = rightUnilateralAndLeftOrigin.left

        let allOrigin =
            createObjectToPartOrigin(rightOrUnilateralOrigin) + createObjectToPartOrigin(leftOrigin)
        var dictionary: PositionDictionary = [:]
//print(allNames)
//print(allOrigin)
//print("")
        for (index, key) in allNames.enumerated() {
            let objectToPartName =    ParentToPartName().convertedToObjectToPart(key)
            dictionary[objectToPartName] = allOrigin[index]
            //preTiltObjectToPartOriginIn[key] ??
                
        }
        return dictionary
    }
}
