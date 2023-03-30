//
//  CreateOccupantSideSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation

struct InitialOccupantSideSupportMeasurement {
    
    let initialOccupantBodySupportMeasure =  InitialOccupantBodySupportMeasure()
    
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
        _ supportIndex: Int
    ){
        measurementFor = InitialOccupantSideSupportMeasurement()
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
            measurementFor.rightSideSupportFromSitOnOrigin
            
        let sideSupportDictionary =
            CreateOnePartOrSideSymmetricParts(
                measurementFor.sitOnArm,
                .arm,
                parentFromPrimaryOrigin[supportIndex],
                partFromParentOrigin,
                supportIndex)
            
       let sideSupportJointDictionary =
            CreateOnePartOrSideSymmetricParts(
                measurementFor.sideSupportJoint,
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
