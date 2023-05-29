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
