//
//  Calculate.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/05/2023.
//

import Foundation

struct CircularMotionChange {
    
    let yChange: Double
    let zChange: Double
    
    init (
        _ r: Double,
        _ angle0: Measurement<UnitAngle>,
        _ angle1: Measurement<UnitAngle>) {
           
            yChange = getChange(r, angle0, angle1, .yChange)
            zChange = getChange(r, angle0, angle1, .zChange)
            
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
                    case .yChange:
                        trigValue =
                        ( sin(angle0 + angle1) - sin(angle0) )
                    case .zChange:
                        trigValue =
                        r * ( sin(angle0 + angle1) - sin(angle0) )
                    }
            return r * trigValue
            }
        }
    enum Direction {
        case yChange
        case zChange
    }
    
}



struct PositionOfPointAfterRotationAboutPoint {
    //let staticPoint: PositionAsIosAxes
    let fromStaticToMovingPoint: PositionAsIosAxes
    let angleChange: Measurement<UnitAngle>
    var currentAngle: Measurement<UnitAngle> {
        AngleFromPosition(position: fromStaticToMovingPoint).angle
    }
    var radius: Double {
        RadiusFromPosition(position: fromStaticToMovingPoint).radius
    }
    var motionChange: CircularMotionChange {
        CircularMotionChange(radius, currentAngle, angleChange)
    }
    var yChange: Double {
        motionChange.yChange
    }
    var zChange: Double {
        motionChange.zChange
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
