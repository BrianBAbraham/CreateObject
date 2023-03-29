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
        if baseType.rawValue.contains(BaseObjectGroups.caster.rawValue){
            dictionary =
            ForAllCasterBaseObject(
                baseType,
                occupantSupport,
                measurement
            ).getDictionary()
        }
            
        if baseType.rawValue.contains(BaseObjectGroups.fixedWheel.rawValue) {
           dictionary =
           ForFixedWheelBaseObject(
                baseType,
                occupantSupport
            ).getDictionary()
        }
            

    }
    
}








