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
struct OriginIdPartChainInDictionariesOut {
    let rightOrUnilateralOrigin: [PositionAsIosAxes]
    var leftOrigin: [PositionAsIosAxes] = []
    //var rightOrigin: [PositionAsIosAxes] = []
    let partIds: [[Part]]
    let partChain: [Part]
    let preTiltParentToPartOriginIn: PositionDictionary
    var namesForRightOrUnilateral: [String] = []
    var namesForLeft: [String] = []
    let allNames: [String]
    
    init(
        _ originIdPartChain: OriginIdPartChain,
        _ preTiltParentToPartOriginIn: PositionDictionary) {
        rightOrUnilateralOrigin = originIdPartChain.origin
        partIds = originIdPartChain.ids
        partChain = originIdPartChain.chain
        self.preTiltParentToPartOriginIn =
            preTiltParentToPartOriginIn
        ///names are in order from object to part
        ///so these can be used to determine
        ///object to part origin
        ///Only one name is printed using an even id from id0
//        namesForRightOrUnilateral =
//            TransformOriginIdPartChainForDictionary()
//                .getNamesFromPartChainPairsToDeepestRoot(
//                    partChain,
//                    partIds,
//                    usingIdZeroOrOne: 0)
            

            
            let finalPartId = partIds[partIds.count - 1]
            var evenOdd: [Int] = []
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
//            print (partChain)
//            print (partIds)
            if evenOdd.contains(0) {
               // print ("x<=0 required")
                let names =
                TransformOriginIdPartChainForDictionary()
                    .getNamesFromPartChainPairsToDeepestRoot(
                        partChain,
                        partIds,
                        usingIdZeroOrOne: 1)
                
                namesForLeft = names
              
                //print (names)
            
               // print ("")
            }
            if evenOdd.contains(1) {
               // print ("x>0 required")
                
                let names =
                TransformOriginIdPartChainForDictionary()
                    .getNamesFromPartChainPairsToDeepestRoot(
                        partChain,
                        partIds,
                        usingIdZeroOrOne: 0)
            print (names)
                namesForRightOrUnilateral = names
                //print ("")
            }


            


            ///in originIdPartChain one or two id are associated with a part
            ///if unilateral one id if bilateral two id
            ///origins are intially created for origin x > 0 that is the right side
            ///for parts withh bilateral id a symmetrical set is created for the left side
            ///for unilateral if the single id is even it is on the left or centre
            ///if it is odd it is on the right
            ///HOWEVER, unilateral id are always have an id0 in their name
            ///as there is only one of them so irrespective of being left or right its string
            ///identifier is "id0"
            
            
            
        allNames =
            namesForRightOrUnilateral +
            namesForLeft

        createLeftOrigin(namesForLeft)
        
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
                    rightAndUnilateralOrigin: rightOrUnilateralOrigin,
                    partIds: partIds)
//            print(names)
//            print( rightUnilateralAndLeftOrigin.left)
//            print("")
        leftOrigin = rightUnilateralAndLeftOrigin.left
            //print(names)
            //print(leftOrigin)
//            rightOrigin = rightUnilateralAndLeftOrigin.right
    }
    
    
    func makeAndGetForParentToPart()
        -> PositionDictionary {
        let allOrigin =
            rightOrUnilateralOrigin +
            leftOrigin
            
            print (allOrigin)
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
                    names: namesForRightOrUnilateral,
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
