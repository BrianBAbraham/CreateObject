//
//  CreateOccupantOverHeadSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/03/2023.
//

import Foundation




struct CreateOccupantOverHeadSupport {
    var dictionary: PositionDictionary = [:]
    
    init(
        _ fromPrimaryOrigin: PositionAsIosAxes,
        _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasurement,
        _ defaultOrModifiedObjectDimensionDictionary: Part3DimensionDictionary) {
            
        getDictionary(
            fromPrimaryOrigin,
            initialOccupantBodySupportMeasure,
            defaultOrModifiedObjectDimensionDictionary
        )
            
           func getDictionary(
            _ fromPrimaryOrigin: PositionAsIosAxes,
            _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasurement,
            _ defaultOrModifiedObjectDimensionDictionary: Part3DimensionDictionary
           ) {
               
               let partFromParentOrigin =
               ZeroValue.iosLocation
               
               let supportIndexIsAlways = 0
               
               let jointAboveSupport = fromPrimaryOrigin.z + 50
               
               let overheadDimension =
                   DimensionChange(
                       GetDimensionFromDictionary(
                           defaultOrModifiedObjectDimensionDictionary,
                           [.overheadSupport, .id0, .stringLink, .sitOn, .id0]).dimension3D
                   ).from3Dto2D
               
               let hookDimension =
                   DimensionChange(
                       GetDimensionFromDictionary(
                           defaultOrModifiedObjectDimensionDictionary,
                           [.overheadSupportHook, .id0, .stringLink, .sitOn, .id0]).dimension3D
                   ).from3Dto2D
                   
               
               let overHeadSupportDictionary =
               CreateOnePartOrSideSymmetricParts(
                        overheadDimension,
                       .overheadSupport,
                       fromPrimaryOrigin,
                       partFromParentOrigin,
                       supportIndexIsAlways)
               
               let overHeadSupportJointDictionary =
               CreateOnePartOrSideSymmetricParts(
                Joint.dimension,
                       .overheadSupportJoint,
                       fromPrimaryOrigin,
                       partFromParentOrigin,
                       supportIndexIsAlways)

               let overHeadSupportHookDictionary =
                   CreateOnePartOrSideSymmetricParts(
                    overheadDimension,
                        .overheadSupportHook,
                    fromPrimaryOrigin,
                    (x: initialOccupantBodySupportMeasure.overHead.width/2 - 50,
                     y: 0,
                     z: jointAboveSupport),
                    supportIndexIsAlways)

               dictionary =
                   Merge.these.dictionaries([
                       overHeadSupportDictionary.cornerDictionary,
                       overHeadSupportJointDictionary.cornerDictionary,
                       overHeadSupportJointDictionary.originDictionary,
                       overHeadSupportHookDictionary.cornerDictionary
                   ])

           }
        }
}


   
