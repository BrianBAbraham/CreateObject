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
    let wheelBaseType: BaseObjectTypes


    init(
        _ wheelBaseType: BaseObjectTypes,
        _ measurement: InitialBaseMeasureFor
    ) {
        
        self.measurement = measurement
        
        centreToFrontLength = measurement.centreToFrontLength
        
        centreHalfWidth = measurement.halfWidth
        
        //self.occupantSupport = occupantSupport
        
        rearToCentreLength = measurement.rearToCentreLength
        
        rearToFrontLength = measurement.rearToFrontLength
        
        self.wheelBaseType = wheelBaseType
        
        //self.allSitOnFromPrimaryOrigin = occupantSupport.allBodySupportFromPrimaryOrigin
        
        //occupantSupportTypes = occupantSupport.occupantSupportTypes
            
        let fixedWheelOriginLocations =
        CreateIosPosition.forLeftRightAsArray(x:  centreHalfWidth)

        let fixedWheelOriginIdIsAlways = 0
        
        fixedWheelsFromPrimaryOriginsDictionary =
        DimensionsBetweenFirstAndSecondOrigin.dictionaryForOneToMany(
            .objectOrigin,
            .fixedWheel,
            fixedWheelOriginLocations,
            firstOriginId: fixedWheelOriginIdIsAlways)
    }
    
    
    
    func getDictionary() -> [String: PositionAsIosAxes ]{    //CHANGE
        
        var casterDictionary: PositionDictionary = [:]

        if wheelBaseType == .fixedWheelFrontDrive {
            
            let casterAtRearDictionary =
            CreateCaster(
                .casterWheelAtRear,
                measurement.baseCornerFromPrimaryOriginForWidthAxisAt.front.rear
            ).dictionary
//print(casterAtRearDictionary.filter({$0.key.contains("Vertical")}))
            casterDictionary += casterAtRearDictionary
        }
        
        if wheelBaseType == .fixedWheelRearDrive {
            
            let casterAtFrontDictionary =
            CreateCaster(
                .casterWheelAtFront,
                measurement.baseCornerFromPrimaryOriginForWidthAxisAt.rear.front
            ).dictionary
//print(casterAtFrontDictionary.filter({$0.key.contains("Vertical")}))
            
//    print("")
//    print("createBase")
//            DictionaryInArrayOut().getNameValue(casterAtFrontDictionary).forEach{print($0)}
//    print("createBase")
//    print("")
            casterDictionary += casterAtFrontDictionary
        }
        
        if wheelBaseType == .fixedWheelManualRearDrive {
            
            let casterAtFrontDictionary =
            CreateCaster(
                .casterWheelAtFront,
                measurement.baseCornerFromPrimaryOriginForWidthAxisAt.rear.front
            ).dictionary
            
            casterDictionary += casterAtFrontDictionary
        }
        
        
        if wheelBaseType == .fixedWheelMidDrive {
            
            let casterAtRearDictionary =
            CreateCaster(
                .casterWheelAtRear,
                measurement.baseCornerFromPrimaryOriginForWidthAxisAt.centre.rear
            ).dictionary
            
            let casterAtFrontDictionary = CreateCaster(
                .casterWheelAtFront,
                measurement.baseCornerFromPrimaryOriginForWidthAxisAt.centre.front
            ).dictionary
            
            casterDictionary += casterAtRearDictionary
            casterDictionary += casterAtFrontDictionary
        }
        
    let dictionary =
    Merge.these.dictionaries([
        casterDictionary,
        CreateFixedWheel(
            measurement.baseCornerFromPrimaryOriginForWidthAxisAt.centre.centre,
            wheelBaseType
        ).dictionary,
        ])

    return dictionary
    }
}
