//
//  CreateBaseWithFixedWheels..swift
//  CreateObject
//
//  Created by Brian Abraham on 18/02/2023.
//

import Foundation

struct ForFixedWheelBaseObject {
    let measurement: InitialBaseMeasureFor
    let centreToFrontLength: Double
    let centreHalfWidth: Double
    let fixedWheelsFromPrimaryOriginsDictionary: [String: PositionAsIosAxes]    //CHANGE
    let rearToCentreLength: Double
    let rearToFrontLength: Double
    let occupantSupportTypes: [OccupantSupportTypes]
    let wheelBaseType: BaseObjectTypes
    let allSitOnFromPrimaryOrigin: [PositionAsIosAxes]
    let occupantSupport: CreateOccupantSupport

    init(
        _ wheelBaseType: BaseObjectTypes,
        _ occupantSupport: CreateOccupantSupport
    ) {
        
        measurement = InitialBaseMeasureFor()
        
        centreToFrontLength = measurement.centreToFrontLength
        
        centreHalfWidth = measurement.halfWidth
        
        self.occupantSupport = occupantSupport
        
        rearToCentreLength = measurement.rearToCentreLength
        
        rearToFrontLength = measurement.rearToFrontLength
        
        self.wheelBaseType = wheelBaseType
        
        self.allSitOnFromPrimaryOrigin = occupantSupport.allBodySupportFromPrimaryOrigin
        
        occupantSupportTypes = occupantSupport.occupantSupportTypes
            
        let fixedWheelOriginLocations =
        CreateIosPosition.forLeftRightAsArray(x:  centreHalfWidth)

        fixedWheelsFromPrimaryOriginsDictionary =
        DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToMany(
            .primaryOrigin,
            .fixedWheel,
            fixedWheelOriginLocations,
            firstOriginId:0)
    }
    
    func getDictionary() -> [String: PositionAsIosAxes ]{    //CHANGE
        
        var casterDictionary: PositionDictionary = [:]

        if wheelBaseType == .fixedWheelFrontDrive {
            
            let casterAtRearDictionary =
            CreateCaster(
                .casterWheelAtFront,
                measurement.baseCornerFromPrimaryOriginForWidthAxisAt.front.rear
            ).dictionary
            
            casterDictionary += casterAtRearDictionary
        }
        
        if wheelBaseType == .fixedWheelRearDrive {
            
            let casterAtFrontDictionary = CreateCaster(
                .casterWheelAtRear,
                measurement.baseCornerFromPrimaryOriginForWidthAxisAt.rear.front
            ).dictionary
            
            casterDictionary += casterAtFrontDictionary
        }
        
        
        if wheelBaseType == .fixedWheelMidDrive {
            
            let casterAtRearDictionary =
            CreateCaster(
                .casterWheelAtFront,
                measurement.baseCornerFromPrimaryOriginForWidthAxisAt.centre.rear
            ).dictionary
            
            let casterAtFrontDictionary = CreateCaster(
                .casterWheelAtRear,
                measurement.baseCornerFromPrimaryOriginForWidthAxisAt.centre.front
            ).dictionary
            
            casterDictionary += casterAtRearDictionary
            casterDictionary += casterAtFrontDictionary
        }
        
    let dictionary =
    Merge.these.dictionaries([
        casterDictionary,
        CreateFixedWheel(measurement.baseCornerFromPrimaryOriginForWidthAxisAt.centre.centre).dictionary,



        ])
//
    return dictionary
    }
}
