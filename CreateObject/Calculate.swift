//
//  Calculate.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/05/2023.
//

import Foundation

struct CircularMotionChange {
    
    let horizontal: Double
    let vertical: Double
    
    init (
        _ r: Double,
        _ angle0: Measurement<UnitAngle>,
        _ angle1: Measurement<UnitAngle>) {
           
            horizontal = getChange(r, angle0, angle1, .horizontal)
            vertical = getChange(r, angle0, angle1, .vertical)
            
            func getChange(
                _ r: Double,
                _ angle0: Measurement<UnitAngle>,
                _ angle1: Measurement<UnitAngle>,
                _ direction: Direction)
                -> Double {
                    
                let angle0 = angle0.converted(to: .radians).value
                let angle1 = angle1.converted(to: .radians).value
                    var trigValue: Double
                    switch direction {
                    case .horizontal:
                        trigValue =
                        ( sin(angle0 + angle1) - sin(angle0) )
                    case .vertical:
                        trigValue =
                        r * ( sin(angle0 + angle1) - sin(angle0) )
                    }
            return r * trigValue
            }
        }
    enum Direction {
        case horizontal
        case vertical
    }
    
}



struct RotationAboutNonOriginPoint {
    let firstPointInGlobal: PositionAsIosAxes
    let secondPointInLocal: PositionAsIosAxes
    let angleChange: Measurement<UnitAngle>
    var currentAngle: Measurement<UnitAngle> {
        AngleFromPosition(position: secondPointInLocal).angle
    }
    var radius: Double {
        RadiusFromPosition(position: secondPointInLocal).radius
    }
    var motionChange: CircularMotionChange {
        CircularMotionChange(radius, currentAngle, angleChange)
    }
    var horzontalChange: Double {
        motionChange.horizontal
    }
    var verticalChange: Double {
        motionChange.vertical
    }
}


struct AngleFromPosition {
    let position: PositionAsIosAxes
    var angle: Measurement<UnitAngle> {
        Measurement(value: atan2(position.z, position.y), unit: UnitAngle.radians)
    }
}

struct RadiusFromPosition {
    let position: PositionAsIosAxes
    var radius: Double {
        sqrt(position.z * position.z + position.y * position.y)
    }
}
