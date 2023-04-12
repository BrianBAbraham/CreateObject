//
//  CreateOccupantFootSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/02/2023.
//

import Foundation
struct InitialOccupantFootSupportMeasure {
    
    static let jointLength = 20.0
    
    static let jointWidth = 20.0
    
    static let footSupportHangerJoint =
    (length: jointLength , width: jointWidth)
    
    static let footSupport = (length: 100.0, width: 150.0 )
    
    static let footSupportJoint =
    (length: footSupport.length , width: jointWidth )

    let sitOnLengthAndOffset: Double// =
    
    let sitOnWidthAndOffset: Double// =
    
    let rightFootSupportHangerJointFromSitOnOrigin: PositionAsIosAxes
    
    static let footSupportHanger =
    (length: 300.0, width: 20.0)
    
  let rightFootSupportJointFromHangerJointOrigin =
        (x: 0.0,
         y: footSupportHanger.length ,
         z: 0.0 )
    
    let rightFootSupportFromFootSupportJointOrigin =
        (x: -footSupport.width/2 ,
         y: 0.0 ,
         z: 0.0 )
    
    let rightFootSupportJointFromSitOnOrigin: PositionAsIosAxes
    
    let rightFootSupportFromFromSitOnOrigin: PositionAsIosAxes
    
    init(_ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure) {
        sitOnLengthAndOffset =
        initialOccupantBodySupportMeasure.sitOn.length/2 - 10
        sitOnWidthAndOffset =
        initialOccupantBodySupportMeasure.sitOn.width/2 - 50
        
        rightFootSupportHangerJointFromSitOnOrigin =
            (x: sitOnWidthAndOffset,
            y: sitOnLengthAndOffset,
            z: 0.0 )
        
        rightFootSupportJointFromSitOnOrigin =
        CreateIosPosition.addArrayOfTouples([
        rightFootSupportHangerJointFromSitOnOrigin,
        rightFootSupportJointFromHangerJointOrigin
        ])
        
        rightFootSupportFromFromSitOnOrigin =
        CreateIosPosition.addArrayOfTouples(
            [rightFootSupportJointFromSitOnOrigin,
            rightFootSupportFromFootSupportJointOrigin])
    }
}




struct CreateOccupantFootSupport {
    // INPUT FROM SEAT
    
    let initialOccupantFootSupportMeasure: InitialOccupantFootSupportMeasure
    
    var dictionary: [String: PositionAsIosAxes ] = [:]
    
    let supportIndex: Int
  
    init(
        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
        _ supportIndex: Int,
        _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure){
        
        self.supportIndex = supportIndex
        self.initialOccupantFootSupportMeasure = InitialOccupantFootSupportMeasure (initialOccupantBodySupportMeasure)
        
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
            initialOccupantFootSupportMeasure.rightFootSupportFromFromSitOnOrigin
            
        let footSupportDictionary =
            CreateOnePartOrSideSymmetricParts(
                InitialOccupantFootSupportMeasure.footSupport,
                .footSupport,
                parentFromPrimaryOrigin[supportIndex],
                partFromParentOrigin,
                supportIndex)
            
        let footSupportHangerJointDictionary =
            CreateOnePartOrSideSymmetricParts(
                InitialOccupantFootSupportMeasure.footSupportHangerJoint,
                .footSupportHangerSitOnVerticalJoint,
                parentFromPrimaryOrigin[supportIndex],
                initialOccupantFootSupportMeasure.rightFootSupportHangerJointFromSitOnOrigin,
                supportIndex)
            
        let footSupportJointDictionary =
            CreateOnePartOrSideSymmetricParts(
                InitialOccupantFootSupportMeasure.footSupportJoint,
                .footSupportHorizontalJoint,
                parentFromPrimaryOrigin[supportIndex],
                initialOccupantFootSupportMeasure.rightFootSupportJointFromSitOnOrigin,
                supportIndex)

        dictionary =
            Merge.these.dictionaries([
                footSupportDictionary.cornerDictionary,
                footSupportDictionary.originDictionary,
                footSupportHangerJointDictionary.originDictionary,
                footSupportHangerJointDictionary.cornerDictionary,
                footSupportJointDictionary.cornerDictionary
            ])

    }
}







