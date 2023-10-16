//
//  OriginPartInDictionariesOut.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/09/2023.
//

import Foundation

///first step create names for dictionary
/// x >= 0 origins are reflected for for x < 0
/// create parentToPartDic
///  use names to extract origin in correct order from parentToPartDic
///  func to create new  object to part orgiins
///  create objecToPartDic
///  for object to part

//MARK:- DICTIONARY
struct OriginIdPartChainInDictionariesOut {
    var xGreaterThanOrEqualZeroOriginIn: [PositionAsIosAxes]
    var xLessThanZeroOrigin: [PositionAsIosAxes] = []
    
    ///xGreaterThanZeroOriginIn provides seed for xLessThanOrEqualZeroOrigin
    ///but if there is only an even id, xGreaterThanZeroOriginOut = []
    var xGreaterThanOrEqualZeroOriginOut: [PositionAsIosAxes] = []
    let partIds: [[Part]]
    let partChain: [Part]
    let preTiltParentToPartOriginIn: PositionDictionary
    var xGreaterThanOrEqualZeroNames: [String] = []
    var xLessThanZeroNames: [String] = []
    let allNames: [String]
    
    init(
        _ originIdPartChain: OriginIdPartChain,
        _ preTiltParentToPartOriginIn: PositionDictionary) {
        xGreaterThanOrEqualZeroOriginIn = originIdPartChain.origin
        partIds = originIdPartChain.ids
        partChain = originIdPartChain.chain
        self.preTiltParentToPartOriginIn =
            preTiltParentToPartOriginIn
        ///names are in order from object to part
        ///so these can be used to determine
        ///object to part origin
        
        /// even id, eg id0, id2, indicate x <=0, odd id indicate x>0
        /// the id of the final part in the chain indicates
        ///  if there are x<0, x>=0 or both
        ///  x is the origin of the part from object or parent
        var evenOdd: [Int] = []
        let finalPartId = partIds[partIds.count - 1]
            if finalPartId == [] {
//                print ("empty id detected")
//                print (partIds)
//                print (partChain)
//                print ("")
            }
        // id array with no id are ignored
        // so the partChain will not appear in the dictionary
        for id in finalPartId {
            if let lastCharacter = id.rawValue.last,
                let digitValue = Int(String(lastCharacter)) {
                if digitValue % 2 == 0 {
                    evenOdd.append(0)
                } else {
                    evenOdd.append(1)
                }
            }
        }

        // names have different id depending on
        // x<=0 have an even or zero id digit
        // or x>0 have an odd id digit
        if evenOdd.contains(0) {
            let names =
            OriginIdPartChainTransformed()
                .createAnGetNames(
                    partChain,
                    partIds,
                    usingIdZeroOrOne: 0)
            
            xLessThanZeroNames = names
        }
        if evenOdd.contains(1) {
            let names =
            OriginIdPartChainTransformed()
                .createAnGetNames(
                    partChain,
                    partIds,
                    usingIdZeroOrOne: 1)
            xGreaterThanOrEqualZeroNames = names
        }
        // test to see if the seed orgin for x>0 is required
        // if only on right, nor required
        if !evenOdd.contains(1) {
            xGreaterThanOrEqualZeroOriginOut = []
        } else {
            xGreaterThanOrEqualZeroOriginOut = xGreaterThanOrEqualZeroOriginIn
        }
            
        allNames =
            xGreaterThanOrEqualZeroNames +
            xLessThanZeroNames
        createLeftOrigin(xLessThanZeroNames)
            
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
    
    mutating func createLeftOrigin(_ names: [String])
        {
        let rightUnilateralAndLeftOrigin =
                LeftAndRightOrigin(
                    names: names,
                    rightAndUnilateralOrigin: xGreaterThanOrEqualZeroOriginIn,
                    partIds: partIds)
        xLessThanZeroOrigin = rightUnilateralAndLeftOrigin.left
    }
    
    
    func makeAndGetForParentToPart()
        -> PositionDictionary {
            //print (Thread.callStackSymbols[1])
        let allOrigin =
                        xGreaterThanOrEqualZeroOriginOut +
            xLessThanZeroOrigin
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
            createObjectToPartOrigin(            xGreaterThanOrEqualZeroOriginOut)
        let leftOrigin =
            createObjectToPartOrigin(xLessThanZeroOrigin)
        let allOrigin =
            rightOrUnilateralOrigin +
            leftOrigin
        var dictionary: PositionDictionary = [:]
        for (index, key) in allNames.enumerated() {
            dictionary[key] =
            preTiltObjectToPartOriginIn[key] ??
                allOrigin[index]
        }

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
            xGreaterThanOrEqualZeroNames + xLessThanZeroNames
        let allOrigin =
            createObjectToPartOrigin(            xGreaterThanOrEqualZeroOriginOut) + createObjectToPartOrigin(xLessThanZeroOrigin)
        var dictionary: PositionDictionary = [:]
        for (index, key) in allNames.enumerated() {
            let objectToPartName =    ParentToPartName().convertedToObjectToPart(key)
            dictionary[objectToPartName] = allOrigin[index]
        }
        return dictionary
    }
}
