//
//  Tilt.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/09/2023.
//

import Foundation


//struct ObjectToCornersPostTilt{
//    let objectToPartPostTilt: PositionDictionary = [:]
//    let partToCornersPostTilt: PositionDictionary = [:]
//    let objectToCornersPostTiltForTopView: PositionDictionary = [:]
//    let objecToCornersPostTitleForSideView: PositionDictionary = [:]
//
//    init () {
//
//    }
//}

/// Dimension3/angle/ in -> corners out
/// Rotation centre choice is irrelevant to results
/// Cubiod centre is chosen
/// Rotation is about -x -- x axis of IOS position
/// Corners are as 'Corners quick help'
struct ObjectToCornersPostTilt {
    let origin: PositionAsIosAxes
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
        -> [PositionAsIosAxes] {
        var rotatedCorners: [PositionAsIosAxes] = []
//print (angleChange)
        let cuboidCentre = ZeroValue.iosLocation
        for corner in corners {
            let rotatedDimenionsAsPosition =

                PositionOfPointAfterRotationAboutPoint(
                    staticPoint: cuboidCentre,
                    movingPoint: corner,
                    angleChange: angleChange).fromStaticToPointWhichHasMoved
//print(rotatedDimenions)
            rotatedCorners.append(
                CreateIosPosition.addTwoTouples(
                    rotatedDimenionsAsPosition,
                    origin)  )
        }
        return rotatedCorners
    }

}




