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
                   CreateNonSymmetrical(
                       initialOccupantBodySupportMeasure.overHead,
                       .overHeadSupport,
                       fromPrimaryOrigin,
                       partFromParentOrigin,
                       supportIndexIsAlways)
               
               let overHeadSupportJointDictionary =
                   CreateNonSymmetrical(
                       initialOccupantBodySupportMeasure.overHeadJoint,
                       .overHeadSupportVerticalJoint,
                       fromPrimaryOrigin,
                       partFromParentOrigin,
                       supportIndexIsAlways)

               let overHeadSupportHookDictionary =
                   CreateBothSidesFromRight(
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


   
