//
//  CreateOccupantFootSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/02/2023.
//

import Foundation
struct InitialOccupantFootSupportMeasure {
    

    
    
    
    
    static let footSupportHangerJoint = Joint.dimension
    
    static let footSupport = (length: 100.0, width: 150.0 )
    
    static let footSupportJoint =
    (length: footSupport.length , width: Joint.dimension.width )

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
        initialOccupantBodySupportMeasure.sitOn.width/2 + 30
        
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
    var separateFootSupportRequired = true
    var hangerLinkRequired = true
    var footSupportJointRequired = true
    var footSupportHangerSitOnVerticalJointRequired = true
    
    var dictionary: [String: PositionAsIosAxes ] = [:]
    
    let supportIndex: Int
  
    init(
        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
        _ supportIndex: Int,
        _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure,
        _ baseType: BaseObjectTypes){
        
        self.supportIndex = supportIndex
        self.initialOccupantFootSupportMeasure = InitialOccupantFootSupportMeasure (initialOccupantBodySupportMeasure)
        
            
            switch baseType {
            case .showerTray:
                separateFootSupportRequired = false
                hangerLinkRequired = false
                footSupportJointRequired = false
                footSupportHangerSitOnVerticalJointRequired = false
            default:
                break
            }
            
            
        getDictionary(
            supportIndex,
            parentFromPrimaryOrigin
        )
    }
    

    mutating func getDictionary(
        _ supportIndex: Int,
        _ parentFromPrimaryOrigin: [PositionAsIosAxes]
        ) {
            
            footDictionary(
                InitialOccupantFootSupportMeasure.footSupport,
                .footSupport,
                initialOccupantFootSupportMeasure.rightFootSupportFromFromSitOnOrigin)
            
            if footSupportHangerSitOnVerticalJointRequired {
                footDictionary(
                    InitialOccupantFootSupportMeasure.footSupportHangerJoint,
                    .footSupportHangerSitOnVerticalJoint,
                    initialOccupantFootSupportMeasure.rightFootSupportHangerJointFromSitOnOrigin)
            }
            
            if footSupportJointRequired {
                footDictionary(
                    InitialOccupantFootSupportMeasure.footSupportJoint,
                    .footSupportHorizontalJoint,
                    initialOccupantFootSupportMeasure.rightFootSupportJointFromSitOnOrigin)
            }
            
            
            if hangerLinkRequired {
                let hangerLinkDictionary =
                    CreateCornerDictionaryForLinkBetweenTwoPartsOnOneOrTWoSides(
                        .footSupportHangerSitOnVerticalJoint,
                        .footSupportHorizontalJoint,
                        .footSupportHangerLink,
                        dictionary,
                        supportIndex)

                dictionary += hangerLinkDictionary.newCornerDictionary
            }

            func footDictionary(
                _ dimension: Dimension,
                _ part: Part,
                _ partFromParentOrigin: PositionAsIosAxes) {
                    let dictionary =
                    CreateOnePartOrSideSymmetricParts(
                        dimension,
                        part,
                        parentFromPrimaryOrigin[supportIndex],
                        partFromParentOrigin,
                        supportIndex)
                    
                    self.dictionary += dictionary.cornerDictionary
                    self.dictionary += dictionary.originDictionary
            }
    }
}







