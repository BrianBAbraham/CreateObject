//
//  PositionTransformation.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation

struct ZeroValue {
    static let iosLocation: PositionAsIosAxes = (x: 0.0, y: 0.0, z: 0.0 )
    static let oneOrTwoPositionAsTuple =
    (left: Self.iosLocation, right: Self.iosLocation, one: Self.iosLocation)
    static let dimension: Dimension = (width:  0.0,  length: 0.0 )
    static let dimension3d: Dimension3d = (width:  0.0,  length: 0.0, height:  0.0)
    static let angle: Measurement<UnitAngle> = Measurement(value: 0.0, unit: UnitAngle.radians)
    static let angleDeg: Measurement<UnitAngle> = Measurement(value: 0.0, unit: UnitAngle.degrees)
    
    static let angleMinMax: AngleMinMax = (min: angle, max: Measurement(value: 1.0, unit: UnitAngle.radians))
    
    static let anglesMinMax: AnglesMinMax = (min: rotationAngles, max: rotationAngles)


    
    static let rotationAngles: RotationAngles =
        (
        x: Self.angle,
        y: Self.angle,
        z: Self.angle)
    
    static let partData: PartData = PartData(part: .objectOrigin, originName: .one(one: Part.objectOrigin.rawValue), dimensionName: .one(one: Part.objectOrigin.rawValue), dimension: .one(one: ZeroValue.dimension3d), origin: .one(one: ZeroValue.iosLocation), minMaxAngle: nil, angles: nil, id: .one(one: .id0))
    
}
    

struct CreateIosPosition {
    static func addToToupleX(_ touple: PositionAsIosAxes, _ value: Double) -> PositionAsIosAxes {
        let p = touple
        return
            (x: p.x + value, y: p.y, z: p.z)
    }
    
    
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
    
    
    static func getCornersFromDimension (
        _ dimension: Dimension3d)
        -> Corners {
            let (w,l,h) = dimension
            let initialCorners: Corners =
            [
            (x: -w/2,  y: -l/2, z: -h/2 ),//c0
            (x: w/2,   y: -l/2, z: -h/2 ),//c1
            (x: w/2,   y: l/2, z: -h/2 ),//c2 thirdOfTopView bottomRightOnScreen
            (x: -w/2,  y: l/2, z: -h/2),//c3 fourthOfTopView bottomLeftOnScreen
            (x: -w/2,  y: -l/2, z: h/2 ),//c4 firstOfTopView topLeftOnScreen
            (x: w/2,   y: -l/2, z: h/2 ),//c5 seondOfTopView topRightOnScreen
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
