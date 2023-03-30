//
//  CreateOccupantOverHeadSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/03/2023.
//

import Foundation

//struct InitialOccupantOverHeadSupportMeasure {
//
//    let lieOn: Dimension
//    let sitOn: Dimension
//    let sleepOn: Dimension
//    let standOn: Dimension
//
//    init(
//        lieOn: Dimension = (length: 1600 ,width: 600),
//        sitOn: Dimension = (length: 500 ,width: 400),
//        sleepOn: Dimension = (length: 1800 ,width: 900),
//        standOn: Dimension = (length: 300 ,width: 500)) {
//        self.lieOn = lieOn
//        self.sitOn = sitOn
//        self.sleepOn = sleepOn
//        self.standOn = standOn
//    }
//}



struct CreateOccupantOverHeadSupport {
    var dictionary: PositionDictionary = [:]
    
    init(
        _ fromPrimaryOrigin: PositionAsIosAxes
    ) {
        getDictionary(
            fromPrimaryOrigin
        )
            
           func getDictionary(
            _ fromPrimaryOrigin: PositionAsIosAxes
           ) {
               
               
               let partFromParentOrigin =
               Globalx.iosLocation
               
               let supportIndexIsAlways = 0
                   
               let overHeadSupportDictionary =
                   CreateNonSymmetrical(
                       InitialOccupantBodySupportMeasure().overHead,
                       .overHeadSupport,
                       fromPrimaryOrigin,
                       partFromParentOrigin,
                       supportIndexIsAlways)
               
               let overHeadSupportJointDictionary =
                   CreateNonSymmetrical(
                       InitialOccupantBodySupportMeasure().overHeadJoint,
                       .overHeadSupportVerticalJoint,
                       fromPrimaryOrigin,
                       partFromParentOrigin,
                       supportIndexIsAlways)

                   
//               let footSupportHangerJointDictionary =
//                   CreateBothSidesFromRight(
//                       InitialOccupantFootSupportMeasure.footSupportHangerJoint,
//                       .footSupportHangerSitOnVerticalJoint,
//                       parentFromPrimaryOrigin[supportIndex],
//                       initialOccupantFootSupportMeasure.rightFootSupportHangerJointFromSitOnOrigin,
//                       supportIndex)
//
//               let footSupportJointDictionary =
//                   CreateBothSidesFromRight(
//                       InitialOccupantFootSupportMeasure.footSupportJoint,
//                       .footSupportHorizontalJoint,
//                       parentFromPrimaryOrigin[supportIndex],
//                       initialOccupantFootSupportMeasure.rightFootSupportJointFromSitOnOrigin,
//                       supportIndex)

               dictionary =
                   Merge.these.dictionaries([
                       overHeadSupportDictionary.cornerDictionary,
                       overHeadSupportJointDictionary.cornerDictionary,
//                       footSupportHangerJointDictionary.cornerDictionary,
//                       footSupportJointDictionary.cornerDictionary
                   ])

               
           }
            
        
            
            
            
            
            
        }
}


   
