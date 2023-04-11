//
//  CreateBase.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation

struct CreateBase {
    var dictionary: [String: PositionAsIosAxes ] = [:]
    
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
        _ measurement: InitialBaseMeasureFor)  {
        if baseType.rawValue.contains(GroupsDerivedFromRawValueOfBaseObjectTypes.caster.rawValue){
            dictionary =
            ForAllCasterBaseObject(
                baseType,
                occupantSupport,
                measurement
            ).getDictionary()
        }
            
        if baseType.rawValue.contains(GroupsDerivedFromRawValueOfBaseObjectTypes.fixedWheel.rawValue) {
           dictionary =
           ForFixedWheelBaseObject(
                baseType,
                occupantSupport
            ).getDictionary()
        }
            
            if baseType.rawValue == BaseObjectTypes.showerTray.rawValue {
                dictionary = [:]
            }
            

    }
    
}








