//
//  CreateBaseWithAllCasters.swift
//  CreateObject
//
//  Created by Brian Abraham on 18/02/2023.
//

import Foundation

struct ForAllCasterBaseObject{
    let baseObjectType: BaseObjectTypes
    let baseMeasurement: InitialBaseMeasureFor

    let supportIndex = 0

    

    init( _ base: BaseObjectTypes,

          _ measurement: InitialBaseMeasureFor
    ) {
        self.baseObjectType = base

        baseMeasurement = measurement
    }
    
  func getDictionary()
    -> [String: PositionAsIosAxes ] {
        
        var dictionary: [String: PositionAsIosAxes ] = [:]
          
          let casterAtFrontDictionary =
          CreateCaster(
              .casterWheelAtFront,
              baseMeasurement.baseCornerFromPrimaryOriginForWidthAxisAt.rear.front
          ).dictionary
          
          dictionary += casterAtFrontDictionary
          
          let casterAtRearDictionary =
            CreateCaster(
              .casterWheelAtRear,
              baseMeasurement.baseCornerFromPrimaryOriginForWidthAxisAt.rear.rear
          ).dictionary
          
          dictionary += casterAtRearDictionary
      //}
        
        return dictionary
    }
}
