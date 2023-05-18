//
//  DimensionsForBaseObject.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/02/2023.
//

import Foundation

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
