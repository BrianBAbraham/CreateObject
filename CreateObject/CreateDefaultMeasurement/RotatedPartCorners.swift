//
//  RotatedPartCorners.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/09/2023.
//

import Foundation

//MARK: CORNERS
/// Provide all eight corner positions for part
/// Rotate about x axis left to rigth on screen
/// Provide maximum y length resulting from rotation
struct RotatedPartCorners {
    let dimensionIn: Dimension3d
    let angleChangeIn: Measurement<UnitAngle>
    var are: [PositionAsIosAxes] {
        calculateFrom(dimension: dimensionIn) }
    var aferRotationAre: [PositionAsIosAxes] {
        calculatePositionAfterRotation(are, angleChangeIn)
    }
    var maximumLengthAfterRotationAboutX: Double {
        calculateMaximumLength(aferRotationAre)
    }
    var dimension: Dimension3d {
        (
        width: dimensionIn.width,
        length: maximumLengthAfterRotationAboutX,
        height: dimensionIn.height)
    }
    

    func calculateFrom( dimension: Dimension3d)
    -> [PositionAsIosAxes] {
        let (w,l,h) = dimension
        return
            [
            ZeroValue.iosLocation,
            (x: w,      y: 0.0, z: 0.0 ),
            (x: w,      y: l,   z: 0.0 ),
            (x: 0.0,    y: l,   z: 0.0),
            (x: 0.0,    y: 0.0, z: h),
            (x: w,      y: 0.0, z: h),
            (x: w,      y: l,   z: h ),
            (x: 0.0,    y: l,   z: h )
            ]
    }
    
    func calculatePositionAfterRotation(
        _ corners: [PositionAsIosAxes],
        _ angleChange: Measurement<UnitAngle>)
        -> [PositionAsIosAxes] {
        var rotatedCorners: [PositionAsIosAxes] = []
        
        let useAnyIndexForRotation = 0
        for corner in corners {
            rotatedCorners.append(
                PositionOfPointAfterRotationAboutPoint(
                    staticPoint: corners[useAnyIndexForRotation],
                    movingPoint: corner,
                    angleChange: angleChange).fromStaticToPointWhichHasMoved )
        }
//print(rotatedCorners)
        return rotatedCorners
    }
    
    func calculateMaximumLength(
        _ corners: [PositionAsIosAxes])
        -> Double {
        let yValues =
            CreateIosPosition.getArrayFromPositions(corners).y
        return
            yValues.max()! - yValues.min()!
    }
}
