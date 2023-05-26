//
//  CreateOccupantBackSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/05/2023.
//

import Foundation

struct BackSupportStability {
    
    let setBackOfRearWheels: Double
    
    init(
        stability: Double,
        
        maximalTilt: Double ,
        
        backSupportHeight: Double
            = InitialOccupantBackSupportMeasurement.backSupportHeight,
        
        maximalTiltAngle: Measurement<UnitAngle> =
        InitialOccupantBackSupportMeasurement.maximumBackSupportRecline,
        maximalReclineAngle: Double) {
        
            setBackOfRearWheels =
                getSetBack(stability,
                           maximalTilt,
                           backSupportHeight,
                           maximalTiltAngle,
                           maximalReclineAngle)
            
            func getSetBack(
                _ stability: Double,
                _ maximalTilt: Double,
                _ backSupportHeight: Double,
                _ maximumTiltAngle: Measurement<UnitAngle> ,
                _ maximalReclineAngle: Double)
                -> Double {
                    
                InitialOccupantSupportTiltMeasurement(
                    maximumTiltAngle, length: backSupportHeight)
                    
                    
                    return 0.0
            }
    }
    

}

struct InitialOccupantBackSupportMeasurement {
    static let backSupportHeight = 500.0
    
    static let maximumBackSupportRecline =
    Measurement(value: 30, unit: UnitAngle.degrees)
    
    static let minimumBackSupportRecline =
    Measurement(value: 0, unit: UnitAngle.degrees)
    
    static let lengthOfMaximallyReclinedBackSupport =
        Tilted(maximumBackSupportRecline).factor * backSupportHeight
        
    
    static let lengthOfMinimillyReclinedBackSupport =
        Tilted(minimumBackSupportRecline).factor * backSupportHeight
      
        
    let initialOccupantBodySupportMeasure =  InitialOccupantBodySupportMeasurement()
    
    var backSupport: Dimension
    
    let defaultBackSupport: Dimension

    let backSupportFromParentOrigin: PositionAsIosAxes
    let backSupportJointFromParentOrigin: PositionAsIosAxes
    let backSupportJoint = Joint.dimension
       
    init( _ objectOptions: OptionDictionary)
        {
            /// case no recline and no tilt
            /// case recline and no tilt
            /// case tilt and no recline
            /// case tilt and recline
            ///
            ///
            defaultBackSupport =
            (length:
                InitialOccupantBackSupportMeasurement.lengthOfMinimillyReclinedBackSupport,
            width:
                initialOccupantBodySupportMeasure.sitOn.width)
            
            backSupport =
                objectOptions[.reclinedBackSupport] ?? false ?
             (length:
                InitialOccupantBackSupportMeasurement.lengthOfMaximallyReclinedBackSupport,
              width: defaultBackSupport.width) :
                defaultBackSupport
        
//            objectOptions[.reclinedBackSupport] ?? false
//
//            objectOptions[.tiltInSpace] ?? false ?
//
//
//            objectOptions[.tiltAndRecline] ?? false
            
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
    
    var dictionary: PositionDictionary = [:]
    
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
                .backSupportJoint,
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
