//
//  PositionTransformation.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation

struct Globalx {
    static let iosLocation: PositionAsIosAxes = (x: 0.0, y: 0.0, z: 0.0 )}

struct CreateIosPosition {
    static  func addTwoTouples(_ first: PositionAsIosAxes, _ second: PositionAsIosAxes) -> PositionAsIosAxes {
        
        (x: first.x + second.x,y: first.y + second.y, z: first.z + second.z )
    }
    
    static func addArrayOfTouples(
        _ toupleArray: [PositionAsIosAxes])
        -> PositionAsIosAxes {
            
            var toupleSum = toupleArray[0]
            for index in 1..<toupleArray.count {
                toupleSum =
                CreateIosPosition.addTwoTouples(
                    toupleSum,
                    toupleArray[index])
            }
        return toupleSum
    }
    
    static func subtractSecondFromFirstTouple(_ first: PositionAsIosAxes, _ second: PositionAsIosAxes)  -> PositionAsIosAxes {
        (x: first.x - second.x,y: first.y - second.y, z: first.z - second.z )
    }
    
    static func addToupleToLeftRightTouple(
        _ touple: PositionAsIosAxes,
        _ leftRightTouple :LeftRightPositionAsIosAxis)
        -> LeftRightPositionAsIosAxis {
            
            (left: addTwoTouples(
                touple,
                leftRightTouple.left),
             right: addTwoTouples(
                touple,
                leftRightTouple.right) )
    }
    
    static func addTwoLeftAndRightTouples(_ first: LeftRightPositionAsIosAxis, _ second: LeftRightPositionAsIosAxis) -> LeftRightPositionAsIosAxis {
        
        (left: addTwoTouples(first.left, second.left),
         right: addTwoTouples(first.right, second.right) )
    }
    
    static func addArrayOfLeftAndRightTouples(
        _ toupleArray: [LeftRightPositionAsIosAxis])
        -> LeftRightPositionAsIosAxis {
            
            var leftAndRightToupleSum = toupleArray[0]
            for index in 1..<toupleArray.count {
                leftAndRightToupleSum =
                CreateIosPosition.addTwoLeftAndRightTouples(
                    leftAndRightToupleSum,
                    toupleArray[index])
            }
        return leftAndRightToupleSum
    }
    
    static func subtractSecondFromFirstLeftAndRightTouple(_ first: LeftRightPositionAsIosAxis, _ second: LeftRightPositionAsIosAxis) -> LeftRightPositionAsIosAxis {
        
        (left: subtractSecondFromFirstTouple(first.left, second.left),
         right: subtractSecondFromFirstTouple(first.right, second.right) )
    }
    
    static func convertArrayToLeftRightTouple(
        _  positions:[PositionAsIosAxes])
    -> LeftRightPositionAsIosAxis{
        (left: positions[0], right: positions[1])
    }
    
    static func addToupleToArrayOfTouples(_ touple: PositionAsIosAxes, _ toupleArray: [PositionAsIosAxes]) -> [PositionAsIosAxes] {
        [addTwoTouples(touple, toupleArray[0]),
         addTwoTouples(touple, toupleArray[1]),
        ]
    }
    
//    static func addToupleToArrayOfTouplesReturnAsLeftRight(
//        _ touple: PositionAsIosAxes,
//        _ toupleArray: [PositionAsIosAxes])
//            -> LeftRightPositionAsIosAxis {
//
//            let newToupleArray =
//            CreateIosPosition.addToupleToArrayOfTouples( touple,
//               toupleArray)
//
//            return
//                convertArrayToLeftRightTouple(newToupleArray)
//    }
    
    
    
//    static func forLeftFromStartPositionAndDisplacement(_ startPosition: PositionAsIosAxes, _ displacement: PositionAsIosAxes) -> PositionAsIosAxes {
//            CreateIosPosition.addTwoTouples(
//                startPosition,
//                (x: -displacement.x, y: displacement.y, z: displacement.z) )
//    }
    
//    static func forRightFromStartPositionAndDisplacement(_ startPosition: PositionAsIosAxes, _ displacement: PositionAsIosAxes) -> PositionAsIosAxes {
//            CreateIosPosition.addTwoTouples(
//                startPosition,
//                displacement)
//    }
    
    static func forLeftRight(
        x: Double = 0.0,
        y: Double = 0.0,
        z: Double = 0.0)
    -> LeftRightPositionAsIosAxis{
            (left:  (x: -x, y: y, z: 0.0 ),
             right: (x: x, y: y, z: 0.0 )
            )
            
        }
    
    static func forLeftRightFromPosition(
        _ position: PositionAsIosAxes)
    -> LeftRightPositionAsIosAxis{
        (left:  (x: -position.x, y: position.y, z: position.z ),
         right: (x: position.x, y: position.y, z: position.z)
            )
        }
    
    static func forLeftRightAsArray(
        x: Double = 0.0,
        y: Double = 0.0,
        z: Double = 0.0)
    -> [PositionAsIosAxes]{
            [(x: -x, y: y, z: 0.0 ),
             (x: x, y: y, z: 0.0 )
            ]
        }
    static func forLeftRightAsArrayFromPosition(
        _ p: PositionAsIosAxes )
    -> [PositionAsIosAxes]{
        [(x: -p.x, y: p.y, z: p.z ),
         (x: p.x, y: p.y, z: p.z)
            ]
        }
    
    static func byExtractingLeftRightOfAsArray(_ position: LeftRightPositionAsIosAxis  ) -> [PositionAsIosAxes] {
        [position.left, position.right]
    }
    

    static func forDisplacementOfBaseOriginTopToBottomBy (_ lengthChange: Double, from positions: BasePositionAsIosAxes)
    -> BasePositionAsIosAxes {
        var newPositions = positions

        newPositions.centre.y +=  -lengthChange
        newPositions.front.y +=  -lengthChange
        newPositions.rear.y +=  -lengthChange
        
        return newPositions
    }
}
