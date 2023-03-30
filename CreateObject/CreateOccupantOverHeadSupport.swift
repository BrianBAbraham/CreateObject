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
        _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure) {
            
        getDictionary(
            fromPrimaryOrigin,
            initialOccupantBodySupportMeasure
        )
            
           func getDictionary(
            _ fromPrimaryOrigin: PositionAsIosAxes,
            _ initialOccupantBodySupportMeasure: InitialOccupantBodySupportMeasure
           ) {
               
               let partFromParentOrigin =
               Globalx.iosLocation
               
               let supportIndexIsAlways = 0
               
               let jointAboveSupport = fromPrimaryOrigin.z + 50
                   
               let overHeadSupportDictionary =
               CreateOnePartOrSideSymmetricParts(
                       initialOccupantBodySupportMeasure.overHead,
                       .overHeadSupport,
                       fromPrimaryOrigin,
                       partFromParentOrigin,
                       supportIndexIsAlways)
               
               let overHeadSupportJointDictionary =
               CreateOnePartOrSideSymmetricParts(
                       initialOccupantBodySupportMeasure.overHeadJoint,
                       .overHeadSupportVerticalJoint,
                       fromPrimaryOrigin,
                       partFromParentOrigin,
                       supportIndexIsAlways)

               let overHeadSupportHookDictionary =
                   CreateOnePartOrSideSymmetricParts(
                    InitialOccupantBodySupportMeasure().overHeadHook,
                        .overHeadHookSupport,
                    fromPrimaryOrigin,
                    (x: initialOccupantBodySupportMeasure.overHead.width/2,
                     y: 0,
                     z: jointAboveSupport),
                    supportIndexIsAlways)

               dictionary =
                   Merge.these.dictionaries([
                       overHeadSupportDictionary.cornerDictionary,
                       overHeadSupportJointDictionary.cornerDictionary,
                       overHeadSupportHookDictionary.cornerDictionary
                   ])

           }
        }
}


   
