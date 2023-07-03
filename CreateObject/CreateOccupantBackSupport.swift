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
        minimumSetBack: Double,
        
        fromTiltAxisToBackSupport: PositionAsIosAxes =
        (x:0, y: -250.0, z: 350.0),
        
        backSupportHeight: Double = InitialOccupantBackSupportMeasurement.backSupportHeight,
        
        maximalTiltAngle: Measurement<UnitAngle> =
            InitialOccupantSupportTiltMeasurement.maximumTilt,
        
        maximalReclineAngle: Measurement<UnitAngle>  =
            InitialOccupantBackSupportMeasurement.maximumBackSupportRecline){
                
        setBackOfRearWheels =
        getSetBack(
            minimumSetBack,
            fromTiltAxisToBackSupport,
            backSupportHeight,
            maximalTiltAngle,
            maximalReclineAngle)
            
        func getSetBack(
            _ minimumSetBack: Double,
            _ fromTiltAxisToBackSupport: PositionAsIosAxes,
            _ backSupportHeight: Double,
            _ maximumTiltAngle: Measurement<UnitAngle> ,
            _ maximalReclineAngle: Measurement<UnitAngle>)
            -> Double {
            let o = abs(fromTiltAxisToBackSupport.y)
            let a = fromTiltAxisToBackSupport.z
            let r = sqrt(pow(o,2) + pow(a,2))
            let tiltToBackSupportOriginInitialAngle =
                Measurement(value: atan(o/a), unit: UnitAngle.radians)
            
            let tiltSetBack =
                CircularMotionChange(
                    r,
                    tiltToBackSupportOriginInitialAngle,
                    maximalTiltAngle).yChange
          
            let reclineSetBack =
                CircularMotionChange(
                    backSupportHeight/2,
                    maximalTiltAngle,
                    maximalReclineAngle).yChange

//print(tiltSetBack)
//print(reclineSetBack)
            return
                [ minimumSetBack, tiltSetBack + reclineSetBack].max()
                ?? minimumSetBack
        }
    }
}

struct InitialOccupantBackSupportMeasurement {
    static let backSupportHeight = 500.0
    
    static let maximumBackSupportRecline =
    Measurement(value: 30, unit: UnitAngle.degrees)
    
    static let minimumBackSupportRecline =
    Measurement(value: 2, unit: UnitAngle.degrees)
    
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
                objectOptions[.angleBackSupport] ?? false ?
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
        _ objectOptions: OptionDictionary,
        _ defaultOrModifiedObjectDimensionDictionary: Part3DimensionDictionary
        
        
    ){
        measurementFor = InitialOccupantBackSupportMeasurement(objectOptions)
        
         let backSupportMeasurement =
        InitialOccupantBackSupportMeasurement(objectOptions).backSupport
            
      
        self.supportIndex = supportIndex

        getDictionary(
            supportIndex,
            parentFromPrimaryOrigin,
            backSupportMeasurement,
            defaultOrModifiedObjectDimensionDictionary
        )
    }
    

    mutating func getDictionary(
        _ supportIndex: Int,
        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
        _ backSupportMeasurement: Dimension,
        _ defaultOrModifiedObjectDimensionDictionary: Part3DimensionDictionary
        
        ) {
        
        let partFromParentOrigin =
            measurementFor.backSupportFromParentOrigin
        

        let dimension =
            DimensionChange(
                GetDimensionFromDictionary(
                    defaultOrModifiedObjectDimensionDictionary,
                    [.backSupport, .id0, .stringLink, .sitOn, [.id0, .id1][supportIndex]]).dimension3D
            ).from3Dto2D
            
        let backSupportDictionary =
            CreateOnePartOrSideSymmetricParts(
                dimension,
                .backSupport,
                parentFromPrimaryOrigin[supportIndex],
                partFromParentOrigin,
                supportIndex)
            
       let backSupportJointDictionary =
            CreateOnePartOrSideSymmetricParts(
                Joint.dimension,
                .backSupporRotationJoint,
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
