//
//  CreateOccupantBackSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/05/2023.
//

import Foundation

struct InitialOccupantBackSupportMeasurement {
    static let backSupportHeight = 500.0
    
    static let maximumBackSupportRecline =
    Measurement(value: 60, unit: UnitAngle.degrees)
    
    static let minimumBackSupportRecline =
    Measurement(value: 5, unit: UnitAngle.degrees)
    
    static let lengthOfMaximallyReclinedBackSupport =
    sin(maximumBackSupportRecline.converted(to: .radians).value) * backSupportHeight
    
    static let lengthOfMinimillyReclinedBackSupport =
    sin(minimumBackSupportRecline.converted(to: .radians).value) * backSupportHeight
    
    let initialOccupantBodySupportMeasure =  InitialOccupantBodySupportMeasure()
    
    let backSupport: Dimension

    let backSupportFromParentOrigin: PositionAsIosAxes
    let backSupportJointFromParentOrigin: PositionAsIosAxes
    let backSupportJoint = Joint.dimension
       
    init( _ objectionOptions: OptionDictionary)
        {
            backSupport =
            (length: objectionOptions[.recliningBackSupport] ?? false ? InitialOccupantBackSupportMeasurement.lengthOfMaximallyReclinedBackSupport: InitialOccupantBackSupportMeasurement.lengthOfMinimillyReclinedBackSupport,
             width: initialOccupantBodySupportMeasure.sitOn.width)
        
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
        _ objectOptions: OptionDictionary
    ){
        measurementFor = InitialOccupantBackSupportMeasurement(objectOptions)
        
         let backSupportMeasurement =
        InitialOccupantBackSupportMeasurement(objectOptions).backSupport
            
      
        self.supportIndex = supportIndex

        getDictionary(
            supportIndex,
            parentFromPrimaryOrigin,
            backSupportMeasurement
        )
    }
    

    mutating func getDictionary(
        _ supportIndex: Int,
        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
        _ backSupportMeasurement: Dimension
        ) {
        
        let partFromParentOrigin =
            measurementFor.backSupportFromParentOrigin
            
        let backSupportDictionary =
            CreateOnePartOrSideSymmetricParts(
                backSupportMeasurement,
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
