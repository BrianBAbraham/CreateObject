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



struct OccupantDefaultAhgle {
    var angles: RotationAngles = ZeroValue.rotationAhgles
    
    mutating func reinitialise(_ part: Part?) {
        self.part = part
        
        switch part {
        case .backSupporRotationJoint:
            angles = getBackSupportRotationJointAngle()
            
        case .sitOnTiltJoint:
            angles = getSitOnTiltJointAngle()
            
       
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
            ZeroValue.rotationAhgles
        return
            dictionary[baseType] ?? general
    }

    
    func getSitOnTiltJointAngle() -> RotationAngles {
        let dictionary: [ObjectTypes: RotationAngles] = [:]
        let general = ZeroValue.rotationAhgles
        return
            dictionary[baseType] ?? general
    }
    

}
