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
    static let footShowerSupport = (length: 900.0, width: 600.0 )
    
    static let footShowerSupportMaximumIncrease =
    (length: footShowerSupport.length, width: footShowerSupport.width * 1.5 )
    
    static let footSupportJoint =
    (length: footSupport.length , width: Joint.dimension.width )

    let sitOnLengthAndOffset: Double// =
    
    let sitOnWidthAndOffset: Double// =
    
    let rightFootSupportHangerJointFromSitOnOrigin: PositionAsIosAxes
    
    static let footSupportHanger =
    (length: 200.0, width: 20.0)
    
    static let footSupportHangerMaximumLength =
    footSupportHanger.length * 3.0
    
    static let footSupportHangerMinimumLength =
    -(footSupport.length + footSupportHangerJoint.length/2)
    
    static let footSupportHangerMaximumLengthIncrease =
    footSupportHangerMaximumLength - footSupportHanger.length
    
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
    
    init(_ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasurement) {
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

//struct DefaultFootSupportMeasurement: Measurements {
//    let nameCase = MeasurementParts.foot
//    let dictionary: MeasurementDictionary
//
//    let parts: [Part] =
//    [.footSupport, .footSupportHorizontalJoint, .footSupportHangerSitOnVerticalJoint]
//    let lengths: [Double] =
//    []
//}










/// width, length, height
/// x, y ,z
/// sitOn or base
/// "footSupportHangerSitOnVerticalJoint
/// "footSupportHorizontalJoint -footSupport
/// ("footSupportHangerLink)
/// _id0_sitOn_id0,
/// _id1_sitOn_id0,
/// _id0_sitOn_id1,
/// _id1_sitOn_id1,


struct CreateOccupantFootSupport {
    // INPUT FROM SEAT

    let initialOccupantFootSupportMeasure: InitialOccupantFootSupportMeasure
    var separateFootSupportRequired = true
    var hangerLinkRequired = true
    var footSupportDimension: Dimension
    var footSupportInOnePieceRequired  = false
    var footSupportJointRequired = true
    var footSupportHangerSitOnVerticalJointRequired = true
    var footSupportFromParent: PositionAsIosAxes
    
    var dictionary: PositionDictionary = [:]
    //var measurements: MeasurementDictionary
    
    let supportIndex: Int
  
    init(
        _ allBodySupportFromPrimaryOrigin: [PositionAsIosAxes],
        _ supportIndex: Int,
        _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasurement,
        _ baseType: BaseObjectTypes,
        _ defaultOrModifiedObjectDimensionDictionary: Part3DimensionDictionary
        ){
        
        self.supportIndex = supportIndex
        self.initialOccupantFootSupportMeasure = InitialOccupantFootSupportMeasure (initialOccupantBodySupportMeasure)
        //self.measurements = measurements
            
            switch baseType {
            case .showerTray:
                footSupportInOnePieceRequired = true
                separateFootSupportRequired = false
                hangerLinkRequired = false
                footSupportJointRequired = false
                footSupportHangerSitOnVerticalJointRequired = false
                footSupportFromParent = ZeroTouple.iosLocation
                
                
                footSupportDimension =
                    DimensionChange(
                        GetDimensionFromDictionary(
                            defaultOrModifiedObjectDimensionDictionary,
                            [.footSupport, .id0, .stringLink, .sitOn, [.id0, .id1][supportIndex]]).dimension3D
                    ).from3Dto2D
//                GetFromMeasurementDictionary(measurements, .footSupport, .foot).dimension
                //InitialOccupantFootSupportMeasure.footShowerSupport
            default:
                footSupportFromParent =
                initialOccupantFootSupportMeasure.rightFootSupportFromFromSitOnOrigin
                footSupportDimension =
                InitialOccupantFootSupportMeasure.footSupport
                break
            }
            
            
        getDictionary(
            supportIndex,
            allBodySupportFromPrimaryOrigin,
            defaultOrModifiedObjectDimensionDictionary
        )
    }
    

    mutating func getDictionary(
        _ supportIndex: Int,
        _ allBodySupportFromPrimaryOrigin: [PositionAsIosAxes],
        _ defaultOrModifiedObjectDimensionDictionary: Part3DimensionDictionary
        ) {
            let support: Part = footSupportInOnePieceRequired ? .footSupportInOnePiece: .footSupport
            
           
            
            
            footDictionary(
                footSupportDimension,
                support,
                footSupportFromParent)
            
            if footSupportHangerSitOnVerticalJointRequired {
                footDictionary(
                    Joint.dimension,
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
                        allBodySupportFromPrimaryOrigin[supportIndex],
                        partFromParentOrigin,
                        supportIndex)
                    
                    self.dictionary += dictionary.cornerDictionary
                    self.dictionary += dictionary.originDictionary
            }
    }
}







