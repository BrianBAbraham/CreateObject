//
//  CreateBase.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation

struct CreateBase {
    var dictionary: [String: PositionAsIosAxes ] = [:]
    //var measurement: InitialBaseMeasureFor
    
    init(
        _ baseType: BaseObjectTypes,
        _ occupantSupport: CreateOccupantSupport,
        _ measurement: InitialBaseMeasureFor
        ) {
            
            makeBase(
                baseType,
                occupantSupport,
                measurement)
            }
    
    mutating func makeBase(
        _ baseType: BaseObjectTypes,
        _ occupantSupport: CreateOccupantSupport,
        _ measurement: InitialBaseMeasureFor
        )  {
        
        if baseType.rawValue.contains(GroupsDerivedFromRawValueOfBaseObjectTypes.caster.rawValue){
            
            dictionary =
            ForAllCasterBaseObject(
                baseType,
                measurement
            ).getDictionary()
        }
            
        if baseType == .allCasterHoist {
            let onlyOneSupportIndex = 0
            let casterLinkDictionary =
                CreateCornerDictionaryForLinkBetweenTwoPartsOnOneOrTWoSides(
                    .casterVerticalJointAtRear,
                    .casterVerticalJointAtFront,
                    .casterFrontToRearLink,
                    dictionary,
                    onlyOneSupportIndex).newCornerDictionary
            
         dictionary += casterLinkDictionary
        }
            
        if baseType.rawValue.contains(GroupsDerivedFromRawValueOfBaseObjectTypes.fixedWheel.rawValue) {
           dictionary =
           ForFixedWheelBaseObject(
                baseType,
                measurement
            ).getDictionary()
        }
            
        if baseType.rawValue == BaseObjectTypes.showerTray.rawValue {
            dictionary = [:]
        }
    }
    
    

}








