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
    
  func getDictionary()  -> [String: PositionAsIosAxes ] {
        
        var dictionary: [String: PositionAsIosAxes ] = [:]
        var measurement = InitialBaseMeasureFor()

      switch baseObjectType {
          
        case .allCasterBed:
            measurement = InitialBaseMeasureFor(rearToFrontLength: 2200, halfWidth: 450)
       
          let casterAtFrontDictionary =
          CreateCaster(
              .casterWheelAtFront,
              (x: measurement.halfWidth, y: measurement.rearToFrontLength/2, z: 0.0 )
          ).dictionary
          
          dictionary += casterAtFrontDictionary
          
          let casterAtRearDictionary = CreateCaster(
              .casterWheelAtRear,
              (x: measurement.halfWidth, y: -measurement.rearToFrontLength/2, z: 0.0 )
          ).dictionary
          
          dictionary += casterAtRearDictionary
          
        case .allCasterChair:
          measurement = InitialBaseMeasureFor(rearToFrontLength: 500, halfWidth: 200)
          
          let casterAtFrontDictionary = CreateCaster(
              .casterWheelAtRear,
              measurement.baseCornerFromPrimaryOriginForWidthAxisAt.rear.front
          ).dictionary
          
          dictionary += casterAtFrontDictionary
          
          let casterAtRearDictionary = CreateCaster(
              .casterWheelAtRear,
              measurement.baseCornerFromPrimaryOriginForWidthAxisAt.rear.rear
          ).dictionary
          
          dictionary += casterAtRearDictionary
          
        case .allCaster4Hoist:
            break
        case .allCaster6Hoist:
            break
        case .allCasterStandAid:
            break
        case .allCasterStretcher:
          
          measurement = InitialBaseMeasureFor(rearToFrontLength: initialOccupantBodySupportMeasure.lieOn.length/2, halfWidth: initialOccupantBodySupportMeasure.lieOn.width/2)
          
          let casterAtFrontDictionary =
          CreateCaster(
              .casterWheelAtFront,
              (x: measurement.halfWidth, y: measurement.rearToFrontLength/3, z: 0.0 )
          ).dictionary
          
          dictionary += casterAtFrontDictionary
          
          let casterAtRearDictionary = CreateCaster(
              .casterWheelAtRear,
              (x: measurement.halfWidth, y: -measurement.rearToFrontLength/3, z: 0.0 )
          ).dictionary
          
          dictionary += casterAtRearDictionary

            //dictionary = usingUnique(measurement)
        default:
             break
   
        }
        
        
        return dictionary
    }
}
