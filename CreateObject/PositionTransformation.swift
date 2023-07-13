//
//  PositionTransformation.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation

struct ZeroValue {
    static let iosLocation: PositionAsIosAxes = (x: 0.0, y: 0.0, z: 0.0 )
    static let dimension3D: Dimension3d = (width:  0.0,  length: 0.0, height:  0.0)
    static let angle: Measurement<UnitAngle> = Measurement(value: 0.0, unit: UnitAngle.radians)
}

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
    
    static func addTwoLeftAndRightTouples(_ first:
                                          LeftRightPositionAsIosAxis, _ second: LeftRightPositionAsIosAxis) -> LeftRightPositionAsIosAxis {
        
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
    
    static func dimensionFromIosPositions(_ positions: [PositionAsIosAxes])
    -> Dimension {
        
        let arrayTouple = getArrayFromPositions(positions)
        let xArray = arrayTouple.x
        let yArray = arrayTouple.z
        
        func getDimension(_ measurements :[Double]) -> Double {
            let defaultMeasurement = measurements[0]
            let maxMeasurement = measurements.max() ?? defaultMeasurement
            let minMeasurement = measurements.min() ?? defaultMeasurement
            return maxMeasurement - minMeasurement
        }
        return
            (length: getDimension(yArray),
            width: getDimension(xArray))
    }
    
    static func getArrayFromPositions( _ positions: [PositionAsIosAxes])
    -> PositionArrayAsIosAxes {
        var xArray: [Double] = []
        var yArray: [Double] = []
        var zArray: [Double] = []
        
        for position in positions {
            xArray.append(position.x)
            yArray.append(position.y)
            zArray.append(position.z)
        }
        
        return (x: xArray, y: yArray, z: zArray)
    }
    
 
    
    
//    static func maximumPosition( _ positions: [PositionAsIosAxes]) {
//        let arrayTouple = getArrayFromPositions(positions)
//    }
    
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
        var newArrayOfTouple: [PositionAsIosAxes] = []
        for array in toupleArray {
            newArrayOfTouple.append(addTwoTouples(touple, array))
        }
        return newArrayOfTouple
    }
    

    static func minus(_ touple:
    PositionAsIosAxes)
    -> PositionAsIosAxes {
        (x: -touple.x, y: -touple.y, z: touple.z)
    }
    
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
    
//    static func forSinglePartAsArrayFromPosition(
//        _ p: PositionAsIosAxes )
//    -> [PositionAsIosAxes]{
//            [(x: p.x, y: p.y, z: p.z)]
//        }
    
    static func forLeftRightAsArrayFromPosition(
        _ p: PositionAsIosAxes )
    -> [PositionAsIosAxes]{
            [(x: -p.x, y: p.y, z: p.z ),
             (x: p.x, y: p.y, z: p.z)]
        }
    
//    static func forLeftRightAsArrayFromPositionIfNonZeroX(
//        _ p: PositionAsIosAxes )
//    -> [PositionAsIosAxes]{
//        p.x == 0.0 ?
//            [p]:
//            [(x: -p.x, y: p.y, z: p.z ),
//             (x: p.x, y: p.y, z: p.z)]
//        }
    
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
    
    static func orderLeftThenRightmost(
        _ positions: [PositionAsIosAxes])
    -> [PositionAsIosAxes] {
        var leftThenRightmost = positions
        
        if positions[1].x < positions[0].x {
            leftThenRightmost.reverse()
        }
            
            return leftThenRightmost
    }
}

struct DimensionChange {
    let from3Dto2D: Dimension
    init(
        _ threeDimension: Dimension3d
    ) {
        from3Dto2D = (length: threeDimension.length ,width: threeDimension.width)
    }
}

struct HalfThis {
    let dimension: Dimension3d
    
    init(_ dimension: Dimension3d) {
        self.dimension = get(dimension)
        
        func  get(_ dimension: Dimension3d)
          -> Dimension3d {
              (width: dimension.width/2,
               length: dimension.length/2,
               height: dimension.height/2)
          }
    }
    

}
