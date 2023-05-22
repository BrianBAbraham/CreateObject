//
//  DimensionsForBaseObject.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/02/2023.
//

import Foundation





struct BaseAndSupport {

    let fromPrimaryToSitOnOrign: [Double]
    let rearToFront: Double
    let rearToCentre: Double

    init (
        _ stability: Double,
        _ sitOnLength: [Double],
        _ hangerLength: Double,
      //  _ recline: Double,
        _ baseType: BaseObjectTypes) {
            
        rearToFront = baseLength()
        rearToCentre = 0.5 * rearToFront
            
        fromPrimaryToSitOnOrign =
            getOriginLength(
                baseType,
                rearToFront)

        func getOriginLength(
            _ baseType: BaseObjectTypes,
            _ baseLength: Double
        )
            -> [Double ]{
            let rear = 0
            let front = 1

            let onlyOneSitOn = sitOnLength.count == 1
                var fromPrimaryToSitOnOrigin: [Double] = [0.0]
                            
            switch baseType {
                
            case .fixedWheelFrontDrive:
                if onlyOneSitOn {
                    fromPrimaryToSitOnOrigin =
                    [ -0.5 * sitOnLength[rear]]
                } else {
                    fromPrimaryToSitOnOrigin =
                    [ -0.5 * sitOnLength[rear] - sitOnLength[front] - hangerLength,
                      -0.5 * sitOnLength[front]
                    ]
                }
                
            case .fixedWheelRearDrive:
                if onlyOneSitOn {
                    fromPrimaryToSitOnOrigin =
                    [ -0.5 * sitOnLength[rear]]
                } else {
                    fromPrimaryToSitOnOrigin =
                    [-0.5 * sitOnLength[front],
                    -stability - sitOnLength[rear] - hangerLength - sitOnLength[front]]
                }
            case .fixedWheelMidDrive:
                if onlyOneSitOn {
                    fromPrimaryToSitOnOrigin =
                    [0.5 * (baseLength - sitOnLength[rear])]
                } else {
                    fromPrimaryToSitOnOrigin =
                    [ 0.5 * (baseLength - sitOnLength[rear]) - sitOnLength[front] - hangerLength,
                      0.5 * (baseLength - sitOnLength[front])
                    ]
                }
            default:
                break
            }
            return fromPrimaryToSitOnOrigin
        }
            
        func baseLength()
            -> Double {
            let rear = 0
            let front = 1
            
           var rearToFront =
                 stability + sitOnLength[rear]
            rearToFront +=
                sitOnLength.count == 2 ?
                (hangerLength + sitOnLength[front]) : 0.0
            
//print(rearToFront)
            return rearToFront
        }
    }
}

struct InitialBaseMeasureFor {
   
    let centreToFrontLength: Double
    let frameTubeWidth: Double
    let rearToCentreLength: Double
    let rearToFrontLength: Double
    let halfWidth : Double

    let baseCornerFromPrimaryOriginForWidthAxisAt:
    (centre: BasePositionAsIosAxes,
     front: BasePositionAsIosAxes,
     rear: BasePositionAsIosAxes)
    
    init(
        frameTubeWidth: Double = 20,
        rearToCentreLength: Double = 200,
        rearToFrontLength: Double = 500,
        halfWidth: Double = 300) {
        
        self.frameTubeWidth = frameTubeWidth
        self.rearToCentreLength = rearToCentreLength
        self.rearToFrontLength = rearToFrontLength
        self.halfWidth = halfWidth
        
        centreToFrontLength = rearToFrontLength - rearToCentreLength
            
        baseCornerFromPrimaryOriginForWidthAxisAt.rear =
        getBaseCornersFromPrimaryOriginForWidthAxisAtRear()

        
        baseCornerFromPrimaryOriginForWidthAxisAt.centre =
            CreateIosPosition.forDisplacementOfBaseOriginTopToBottomBy(
                rearToCentreLength,
                from: baseCornerFromPrimaryOriginForWidthAxisAt.rear)
    
        baseCornerFromPrimaryOriginForWidthAxisAt.front =
            CreateIosPosition.forDisplacementOfBaseOriginTopToBottomBy(
                rearToFrontLength,
                from: baseCornerFromPrimaryOriginForWidthAxisAt.rear)
            

        func getBaseCornersFromPrimaryOriginForWidthAxisAtRear()
        -> BasePositionAsIosAxes {
            (centre: (x: halfWidth, y: rearToCentreLength, z: 0.0),
             front: (x: halfWidth, y: rearToFrontLength, z: 0.0),
             rear: (x: halfWidth, y: 0.0, z:0.0 ) )
        }
    }
    
    
    
}
