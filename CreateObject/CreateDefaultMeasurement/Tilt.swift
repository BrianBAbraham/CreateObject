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



struct OccupantDefaultAngle {
    var minAngle: RotationAngles = ZeroValue.rotationAngles
    var maxAngle: RotationAngles = ZeroValue.rotationAngles

    mutating func reinitialise(_ part: Part?) {
        self.part = part

        switch part {
        case .backSupportRotationJoint:
            minAngle = getBackSupportRotationJointAngle()

        case .sitOnTiltJoint:
            minAngle = getSitOnTiltJointMinAngle()
            maxAngle = getSitOnTiltJointMaxAngle()


        default:
            print("\(#function) \(part!.rawValue) not found")
            break
        }
    }

    let baseType: ObjectTypes
    var part: Part?

    init ( _ baseType: ObjectTypes) {
        self.baseType = baseType
    }




    func getBackSupportRotationJointAngle() -> RotationAngles {
        let dictionary: [ObjectTypes: RotationAngles] = [:]
        let general =
            ZeroValue.rotationAngles
        return
            dictionary[baseType] ?? general
    }


    func getSitOnTiltJointMinAngle() -> RotationAngles {
        let dictionary: [ObjectTypes: RotationAngles] = [:]
        let general = ZeroValue.rotationAngles
        return
            dictionary[baseType] ?? general
    }

    func getSitOnTiltJointMaxAngle() -> RotationAngles {
        let dictionary: [ObjectTypes: RotationAngles] = [:]
        let general = ZeroValue.rotationAngles
        return
            dictionary[baseType] ?? general
    }

}

struct ObjectValues {
    let objectIn: ObjectTypes
    let partsIn: [Part]
    let part: Part
    let dimension: Dimension3d
    let origin:PositionAsIosAxes
    let ids: [Part]
    let angles: RotationAngles
}

struct ObjectPartValues {
    let part: Part
    let dimension: Dimension3d
    let maxAngle: RotationAngle
}


/// getAllUniquePartInObject
/// getPartValue(objectType, part)
