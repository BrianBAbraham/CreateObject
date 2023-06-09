//
//  CreateOccupantSideSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation

struct InitialOccupantSideSupportMeasurement {
    
    let initialOccupantBodySupportMeasure =  InitialOccupantBodySupportMeasurement()
    
    let sideSupportJoint: Dimension =
    (length: 20, width: 20 )

    let sitOnArm: Dimension =
    (length: 350,  width: 40)

    let sleepOnSide: Dimension =
    (length: 1800,  width: 20)

    let stretchOnSide:Dimension =
    (length: 1800,  width: 20)

    
    let rightSideSupportFromSitOnOrigin: PositionAsIosAxes
    let rightSideSupportJointFromSitOnOrigin: PositionAsIosAxes
    
    init() {
        rightSideSupportFromSitOnOrigin =
        (x:  initialOccupantBodySupportMeasure.sitOn.width/2 + sitOnArm.width/2, y: 0.0 , z: 0.0)
        
        rightSideSupportJointFromSitOnOrigin =
        (x:  initialOccupantBodySupportMeasure.sitOn.width/2 + sitOnArm.width/2,
         y: -sitOnArm.length/2 , z: 0.0)
    }
}

struct CreateOccupantSideSupport {
    // INPUT FROM SEAT
    let measurementFor: InitialOccupantSideSupportMeasurement
    
    var dictionary: [String: PositionAsIosAxes ] = [:]
    
    let supportIndex: Int
    
    init(
        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
        _ supportIndex: Int,
        _ defaultOrModifiedObjectDimensionDictionary: Part3DimensionDictionary
    ){
        measurementFor = InitialOccupantSideSupportMeasurement()
        self.supportIndex = supportIndex


        
        getDictionary(
            supportIndex,
            parentFromPrimaryOrigin,
            defaultOrModifiedObjectDimensionDictionary
        )
    }
    

    mutating func getDictionary(
        _ supportIndex: Int,
        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
        _ defaultOrModifiedObjectDimensionDictionary: Part3DimensionDictionary
        ) {
            let dimension =
                DimensionChange(
                    GetDimensionFromDictionary(
                        defaultOrModifiedObjectDimensionDictionary,
                        [.armSupport, .id0, .stringLink, .sitOn, [.id0, .id1][supportIndex]]).dimension3D
                ).from3Dto2D
            
            
        let partFromParentOrigin =
            measurementFor.rightSideSupportFromSitOnOrigin
            
        let sideSupportDictionary =
            CreateOnePartOrSideSymmetricParts(
                dimension,
                .armSupport,
                parentFromPrimaryOrigin[supportIndex],
                partFromParentOrigin,
                supportIndex)
            
       let sideSupportJointDictionary =
            CreateOnePartOrSideSymmetricParts(
                Joint.dimension,
                .armVerticalJoint,
                parentFromPrimaryOrigin[supportIndex],
                measurementFor.rightSideSupportJointFromSitOnOrigin,
                supportIndex)

        dictionary =
            Merge.these.dictionaries([
                sideSupportJointDictionary.cornerDictionary,
                sideSupportDictionary.cornerDictionary,
                sideSupportDictionary.originDictionary
            ])

    }
}
