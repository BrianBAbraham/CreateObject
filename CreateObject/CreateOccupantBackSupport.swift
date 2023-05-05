//
//  CreateOccupantBackSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/05/2023.
//

import Foundation

struct InitialOccupantBackSupportMeasurement {
    let initialOccupantBodySupportMeasure =  InitialOccupantBodySupportMeasure()
    let backSupportLength: Double
    let backSupportWidth: Double
    var backSupportRecline = Measurement(value: 10, unit: UnitAngle.degrees)
    let backSupport: Dimension
    let backSupportFromParentOrigin: PositionAsIosAxes
    let backSupportJointFromParentOrigin: PositionAsIosAxes
    static let backSupportHeight = 500.0
    
    init() {
        backSupportWidth = initialOccupantBodySupportMeasure.sitOn.width
        
        backSupportLength =
        InitialOccupantBackSupportMeasurement.backSupportHeight * sin(backSupportRecline.converted(to: .radians).value)
        backSupport = (length: backSupportLength, width: backSupportWidth)
        
        backSupportFromParentOrigin =
        (x: 0,
         y: -(initialOccupantBodySupportMeasure.sitOn.length ),
         z: 0)
        
        backSupportJointFromParentOrigin =
        (x: 0,
         y: -(initialOccupantBodySupportMeasure.sitOn.length
             )/2,
         z: 0)
    }
    
}


struct CreateOccupantBackSupport {
    // INPUT FROM SEAT
    let measurementFor: InitialOccupantBackSupportMeasurement
    
    var dictionary: [String: PositionAsIosAxes ] = [:]
    
    let supportIndex: Int
    
    init(
        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
        _ supportIndex: Int
    ){
        measurementFor = InitialOccupantBackSupportMeasurement()
        self.supportIndex = supportIndex

        getDictionary(
            supportIndex,
            parentFromPrimaryOrigin
        )
    }
    

    mutating func getDictionary(
        _ supportIndex: Int,
        _ parentFromPrimaryOrigin: [PositionAsIosAxes]
        ) {
        
        let partFromParentOrigin =
            measurementFor.backSupportFromParentOrigin
            
        let backSupportDictionary =
            CreateOnePartOrSideSymmetricParts(
                measurementFor.backSupport,
                .backSupport,
                parentFromPrimaryOrigin[supportIndex],
                partFromParentOrigin,
                supportIndex)
            
       let backSupportJointDictionary =
            CreateOnePartOrSideSymmetricParts(
                measurementFor.backSupport,
                .backSupportJoint,
                parentFromPrimaryOrigin[supportIndex],
                measurementFor.backSupportJointFromParentOrigin,
                supportIndex)

        dictionary =
            Merge.these.dictionaries([
                backSupportJointDictionary.cornerDictionary,
               // backSupportDictionary.cornerDictionary,
                backSupportDictionary.originDictionary
            ])

    }
}
