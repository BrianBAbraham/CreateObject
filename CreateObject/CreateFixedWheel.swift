//
//  CreateFixedWheel.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/03/2023.
//

import Foundation

struct InitialFixedWheelMeasurement {
    let electric: Dimension
    let selfPropeller: Dimension
    let independence: Dimension
    let supported: Dimension
    
    init (
        electric: Dimension = (length: 200, width: 100),
        selfPropeller: Dimension = (length: 550, width: 20),
        independence: Dimension = (length: 600, width: 20),
        supported: Dimension = (length: 400, width: 40)
    ) {
        self.electric = electric
        self.selfPropeller = selfPropeller
        self.independence = independence
        self.supported = supported
       
    }
}


struct CreateFixedWheel {
    let measurmentFor: InitialFixedWheelMeasurement
    var dictionary: PositionDictionary = [:]

    init(
            _ parentFromPrimaryOrigin: PositionAsIosAxes
    ) {
        measurmentFor = InitialFixedWheelMeasurement()
                
        getDictionary (
            parentFromPrimaryOrigin
        )
    }

    mutating func getDictionary(
        _ parentFromPrimaryOrigin: PositionAsIosAxes//,
    ) {

        let fixedWheelDictionary =
            CreateOnePartOrSideSymmetricParts(
                measurmentFor.electric,
                .fixedWheel,
                (x: 0.0, y:0.0, z: 0.0),
                parentFromPrimaryOrigin,
 
                0)
        
        let wheelPropellerDictionary =
            CreateOnePartOrSideSymmetricParts(
                measurmentFor.selfPropeller,
                .fixedWheelPropeller,
 
                (x: 100.0, y:0.0, z: 0.0),
                parentFromPrimaryOrigin,
                0)

        dictionary =
            Merge.these.dictionaries([
                fixedWheelDictionary.cornerDictionary,
                fixedWheelDictionary.originDictionary,
                //wheelPropellerDictionary.cornerDictionary
            ])
    }
}

