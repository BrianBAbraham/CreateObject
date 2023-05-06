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
    var backSupportRecline: Measurement<UnitAngle>
    let backSupport: Dimension
    let backSupportFromParentOrigin: PositionAsIosAxes
    let backSupportJointFromParentOrigin: PositionAsIosAxes
    let backSupportJoint = Joint.dimension
    static let backSupportHeight = 500.0
    
    init( backSupportRecline: Double ) {
        self.backSupportRecline = Measurement(value: backSupportRecline, unit: UnitAngle.degrees)
        
        backSupportWidth = initialOccupantBodySupportMeasure.sitOn.width
        
        backSupportLength =
        InitialOccupantBackSupportMeasurement.backSupportHeight *
        sin(self.backSupportRecline.converted(to: .radians).value)
        
        backSupport = (length: backSupportLength, width: backSupportWidth)
        
        backSupportFromParentOrigin =
        (x: 0,
         y: -(initialOccupantBodySupportMeasure.sitOn.length + backSupport.length)/2,
         z: 0)
        
        backSupportJointFromParentOrigin =
        (x: 0,
         y: -(initialOccupantBodySupportMeasure.sitOn.length - backSupportJoint.length/2
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
        _ supportIndex: Int,
        _ backSupportRecline: Double
    ){
        measurementFor = InitialOccupantBackSupportMeasurement(backSupportRecline: backSupportRecline)
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
                measurementFor.backSupportJoint,
                .backSupportHorizontalJoint,
                parentFromPrimaryOrigin[supportIndex],
                measurementFor.backSupportJointFromParentOrigin,
                supportIndex)

        dictionary =
            Merge.these.dictionaries([
                backSupportJointDictionary.cornerDictionary,
                backSupportDictionary.cornerDictionary,
                backSupportDictionary.originDictionary
            ])

    }
}
