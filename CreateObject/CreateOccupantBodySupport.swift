//
//  CreateOccupantBodySupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 25/03/2023.
//

import Foundation


struct InitialOccupantBodySupportMeasurement {

    let lieOn: Dimension
    let overHead: Dimension
    let overHeadHook: Dimension
    let overHeadJoint: Dimension
    let sitOn: Dimension
    let sleepOn: Dimension
    let standOn: Dimension
    
    init(
        lieOn: Dimension = (length: 1600 ,width: 600),
        sitOn: Dimension = (length: 400 ,width: 400),
        overHead: Dimension = (length: 40 ,width: 550),
        overHeadHook: Dimension = (length: 100 ,width: 10),
        overHeadJoint: Dimension = Joint.dimension,
        sleepOn: Dimension = (length: 2000 ,width: 900),
        standOn: Dimension = (length: 300 ,width: 500)) {
        self.lieOn = lieOn
        self.overHead = overHead
        self.overHeadHook = overHeadHook
        self.overHeadJoint = overHeadJoint
        self.sitOn = sitOn
        self.sleepOn = sleepOn
        self.standOn = standOn
    }
}



















struct CreateOccupantBodySupport {
    let oneBodySupportFromPrimaryOrigin: PositionAsIosAxes
    var dictionary: PositionDictionary = [:]

    init(
        _ oneBodySupportFromPrimaryOrigin: PositionAsIosAxes,
        _ bodySupportCorners: [PositionAsIosAxes],
        _ supportIndex: Int,
        _ baseType: BaseObjectTypes,
        _ occupantSupportMeasure: Dimension) {
            
        self.oneBodySupportFromPrimaryOrigin =
            oneBodySupportFromPrimaryOrigin
            
            let bodySupportDictionary =
            CreateOnePartOrSideSymmetricParts(
                occupantSupportMeasure,
                .sitOn,
                oneBodySupportFromPrimaryOrigin,
                Globalx.iosLocation,
                supportIndex)

            
            dictionary += bodySupportDictionary.originDictionary
            dictionary += bodySupportDictionary.cornerDictionary
            
    }

}



