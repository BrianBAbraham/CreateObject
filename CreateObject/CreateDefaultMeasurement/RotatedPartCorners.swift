//
//  RotatedPartCorners.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/09/2023.
//

import Foundation

//MARK: CORNERS
/// Rotation centre choice is irrelevant to results
/// Cubiod centre is chosen
/// Rotation is about -x -- x axis of IOS position
/// Corners are as 'Corners quick help'
/// lengthAlteredForRotationDimension only alters length so
/// is useful when viewed in top down
struct RotatedPartCorners {
    let dimensionIn: Dimension3d
    let angleChangeIn: Measurement<UnitAngle>
    var areInitially: [PositionAsIosAxes] {
        CreateIosPosition.getCornersFromDimension( dimensionIn) }
    var aferRotationAre: [PositionAsIosAxes] {
        calculatePositionAfterRotation(areInitially, angleChangeIn)
    }
    var maximumLengthAfterRotationAboutX: Double {
        calculateMaximumLength(aferRotationAre)
    }
    /// when viewed in top down
    /// the length will be corrected for any -x -- x rotation
    /// no other corrections are made
    var lengthAlteredForRotationDimension: Dimension3d {
        (
        width: dimensionIn.width,
        length: maximumLengthAfterRotationAboutX,
        height: dimensionIn.height)
    }
    
    func calculatePositionAfterRotation(
        _ corners: [PositionAsIosAxes],
        _ angleChange: Measurement<UnitAngle>)
        -> [PositionAsIosAxes] {
        var rotatedCorners: [PositionAsIosAxes] = []
        
            let cuboidCentre = ZeroValue.iosLocation
        for corner in corners {
            rotatedCorners.append(
                PositionOfPointAfterRotationAboutPoint(
                    staticPoint: cuboidCentre,
                    movingPoint: corner,
                    angleChange: angleChange).fromStaticToPointWhichHasMoved )
        }
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

