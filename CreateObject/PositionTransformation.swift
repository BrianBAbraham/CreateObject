//
//  PositionTransformation.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation

struct ZeroValue {
    static let iosLocation: PositionAsIosAxes = (x: 0.0, y: 0.0, z: 0.0 )
    static let leftRightLocation: LeftRight<PositionAsIosAxes> =
        (left: ZeroValue.iosLocation, right: ZeroValue.iosLocation)
    static let dimension: Dimension = (width:  0.0,  length: 0.0 )
    static let dimension3d: Dimension3d = (width:  0.0,  length: 0.0, height:  0.0)
    static let leftRightDimension3d: LeftRight<Dimension3d> =
        (left: ZeroValue.dimension3d, right: ZeroValue.dimension3d)
    static let angle: Measurement<UnitAngle> = Measurement(value: 0.0, unit: UnitAngle.radians)
    static let angleMinMax: AngleMinMax = (min: angle, max: angle)
    static let dimensions3dRearMidFront =
        (rear: [dimension3d], mid: [dimension3d], front:
            [dimension3d] )
    static let dimension3dRearMidFront =
        (rear: dimension3d, mid: dimension3d, front:
            dimension3d )
    
//    static let sitOnOrigins: TwinSitOnOrigins =
//            (
//            onlyOne: [],
//            rearAndFront: [],
//            leftAndRight: [])
    
    static let rearMidFrontPositions: RearMidFrontPositions =
        (
        rear: ZeroValue.iosLocation,
        mid: ZeroValue.iosLocation,
        front: ZeroValue.iosLocation)

    static let partDataTouple: PartDataTuple =
    (
    part: Part.notFound,
    dimension: Self.dimension3d,
    origin: Self.iosLocation,
    ids: [],
    angles: Self.rotationAngles)
    
    static let rotationAngles: RotationAngles =
        (
        x: Self.angle,
        y: Self.angle,
        z: Self.angle)
    
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
    
//    static func addToupleToArrayOfTouple (
//        _ additiveTouple: PositionAsIosAxes,
//        _ toupleArray: [PositionAsIosAxes])
//        -> [PositionAsIosAxes] {
//            
//            var touples: [PositionAsIosAxes] = []
//            for touple in toupleArray {
//                touples.append(
//                CreateIosPosition.addTwoTouples(
//                    additiveTouple,
//                    touple)
//                )
//            }
//        return touples
//    }
    
    
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
    
    
    static func getCornersFromDimension (
        _ dimension: Dimension3d)
        -> Corners {
            let (w,l,h) = dimension
            let initialCorners: Corners =
            [
            (x: -w/2,  y: -l/2, z: -h/2 ),//c0
            (x: w/2,   y: -l/2, z: -h/2 ),//c1
            (x: w/2,   y: l/2, z: -h/2 ),//c2
            (x: -w/2,  y: l/2, z: -h/2),//c3
            (x: -w/2,  y: -l/2, z: h/2 ),//c4
            (x: w/2,   y: -l/2, z: h/2 ),//c5
            (x: w/2,   y: l/2, z: h/2 ),//c6
            (x: -w/2,  y: l/2, z: h/2) ]//c7
            return
                initialCorners
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
            (
            width: getDimension(xArray),
            length: getDimension(yArray))
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
    

    static func negative(_ touple:
    PositionAsIosAxes)
    -> PositionAsIosAxes {
        (x: -touple.x, y: -touple.y, z: touple.z)
    }
    
    static func getLeftFromRight (
        _ right: PositionAsIosAxes)
        -> PositionAsIosAxes{
        (
            x: -right.x,
            y: right.y,
            z: right.z)
    }
    
    static func byExtractingLeftRightOfAsArray(_ position: LeftRightPositionAsIosAxis  ) -> [PositionAsIosAxes] {
        [position.left, position.right]
    }
    
    static func swapXY (_ positions: [PositionAsIosAxes]) -> [PositionAsIosAxes] {
        var swapped: [PositionAsIosAxes] = []
        for position in positions {
            swapped.append((x: position.y, y: 1500 - position.z, z:  position.x))
        }
        return swapped
    }
    


    
    

    static func minMaxPosition(
        _ corners: PositionDictionary)
        -> [PositionAsIosAxes] {
        let values = corners.map { $0.value }
        let valuesAsArray = CreateIosPosition
            .getArrayFromPositions(values)
        let yValues = minMax(valuesAsArray.y)
        let xValues = minMax(valuesAsArray.x)

            func minMax(_ values: [Double]) -> [Double] {
                let minValue = values.min() ?? 0.0
                let maxValue = values.max() ?? 0.0
                let minIndex = values.firstIndex(of: minValue) ?? 0
                let maxIndex = values.firstIndex(of: maxValue) ?? 0
                
                let minCorner = values[minIndex]
                let maxCorner = values[maxIndex]
                return [minCorner, maxCorner]
            }
            return  [(x: xValues[0], y: yValues[0], z: 0.0), (x: xValues[1], y: yValues[1], z: 0.0)]
    }

    
    
   


//      static func getInteriorPositions (_ polygon: [PositionAsIosAxes]) -> [PositionAsIosAxes] {
//            var updatedPolygon = polygon
//
//            for point in polygon {
//                let otherPoints = polygon.filter { $0 != point }
//                if isPointInsidePolygon(point: point, polygon: otherPoints) {
//                    updatedPolygon.removeAll { $0 == point }
//                }
//            }
//
//          func isPointInsidePolygon(point: PositionAsIosAxes, polygon: [PositionAsIosAxes]) -> Bool {
//              var isInside = false
//              let n = polygon.count
//
//              var i = 0
//              var j = n - 1
//
//              while i < n {
//                  let pi = polygon[i]
//                  let pj = polygon[j]
//
//                  if ((pi.y > point.y) != (pj.y > point.y)) &&
//                     (point.x < (pj.x - pi.x) * (point.y - pi.y) / (pj.y - pi.y) + pi.x) {
//                      isInside = !isInside
//                  }
//
//                  j = i
//                  i += 1
//              }
//
//              return isInside
//          }
//
//            return updatedPolygon
//        }
        

    
    


    // Example usage
//    let polygon = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 5), CGPoint(x: 5, y: 5), CGPoint(x: 5, y: 0)]

//    let filteredPolygon = removeInteriorPoints(polygon: polygon)
//    print(filteredPolygon)
    
    
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
