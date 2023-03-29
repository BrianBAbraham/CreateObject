//
//  CreateBaseWithAllCasters.swift
//  CreateObject
//
//  Created by Brian Abraham on 18/02/2023.
//

import Foundation

struct ForAllCasterBaseObject{
    let baseObjectType: BaseObjectTypes
    let initialOccupantBodySupportMeasure = InitialOccupantBodySupportMeasure()
    let supportIndex = 0
    let supportTypes: [OccupantSupportTypes]
    let occupantSupport: CreateOccupantSupport
    

    init( _ base: BaseObjectTypes,
          _ occupantSupport: CreateOccupantSupport
    ) {
        self.baseObjectType = base
        self.occupantSupport = occupantSupport
        supportTypes = occupantSupport.occupantSupportTypes
    }
    
  func getDictionary()
    -> [String: PositionAsIosAxes ] {
        
        var dictionary: [String: PositionAsIosAxes ] = [:]
        var measurement = InitialBaseMeasureFor()

      switch baseObjectType {
        case .allCasterBed:
            measurement = InitialBaseMeasureFor(rearToFrontLength: 2200, halfWidth: 450)
        case .allCasterChair:
            measurement = InitialBaseMeasureFor(rearToFrontLength: 500, halfWidth: 200)
        case .allCasterHoist:
            measurement = InitialBaseMeasureFor(rearToFrontLength: 1200, halfWidth: 300)
        case .allCasterStandAid:
            break
        case .allCasterStretcher:
            measurement = InitialBaseMeasureFor(rearToFrontLength: initialOccupantBodySupportMeasure.lieOn.length/2, halfWidth: initialOccupantBodySupportMeasure.lieOn.width/2)

        default:
             break
   
        }
      fourCasterBase(measurement)
      
      func fourCasterBase(_ measure: InitialBaseMeasureFor) {
          let casterAtFrontDictionary = CreateCaster(
              .casterWheelAtFront,
              measurement.baseCornerFromPrimaryOriginForWidthAxisAt.rear.front
          ).dictionary
          
          dictionary += casterAtFrontDictionary
          
          let casterAtRearDictionary = CreateCaster(
              .casterWheelAtRear,
              measurement.baseCornerFromPrimaryOriginForWidthAxisAt.rear.rear
          ).dictionary
          
          dictionary += casterAtRearDictionary
      }
        
        return dictionary
    }
}
