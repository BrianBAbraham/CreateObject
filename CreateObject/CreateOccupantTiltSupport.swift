//
//  CreateOccupantTiltSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 25/05/2023.
//

import Foundation

struct CreateOccupantTiltSupport {
    ///accessible by default or UI
    ///tilted to maximum for default
    ///tilting from UI
    ///
    
    var dictionary: [String: PositionAsIosAxes ] = [:]
  
    init(
        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
        _ supportIndex: Int,
        _ sitOnWidth: [Double] ){
            
        dictionary =
        getDictionary(
            supportIndex,
            parentFromPrimaryOrigin,
            sitOnWidth
        )
    }
    
    mutating func getDictionary(
        _ supportIndex: Int,
        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
        _ sitOnWidth: [Double]
        )
        -> PositionDictionary {
        
            let tiltDictionary =
            CreateOnePartOrSideSymmetricParts(
                (length: Joint.dimension.length, width: sitOnWidth[supportIndex] ),
                .tiltJoint,
                parentFromPrimaryOrigin[supportIndex],
                (x: 0.0, y: 0.0, z: -100.0),
                supportIndex)
            
            return tiltDictionary.cornerDictionary
    }
    
}
