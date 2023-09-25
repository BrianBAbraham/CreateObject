//
//  Tilt.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/09/2023.
//

import Foundation


struct PartToCornersPostTilt {
    let dimensionIn: Dimension3d
    let angleChangeIn: Measurement<UnitAngle>
    var areInitially: [PositionAsIosAxes] {
        CreateIosPosition.getCornersFromDimension( dimensionIn) }
    var aferRotationAre: [PositionAsIosAxes] {
        calculatePositionAfterRotation(areInitially, angleChangeIn)
    }

    
    func calculatePositionAfterRotation(
        _ corners: [PositionAsIosAxes],
        _ angleChange: Measurement<UnitAngle>)
        -> Corners{
        var rotatedCorners: [PositionAsIosAxes] = []
        let cuboidCentre = ZeroValue.iosLocation
        for corner in corners {
            let rotatedDimenionsAsPosition =
                PositionOfPointAfterRotationAboutPoint(
                    staticPoint: cuboidCentre,
                    movingPoint: corner,
                    angleChange: angleChange).fromStaticToPointWhichHasMoved
            rotatedCorners.append(
                    rotatedDimenionsAsPosition  )
        }
        return rotatedCorners
    }
}



