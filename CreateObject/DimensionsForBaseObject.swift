//
//  DimensionsForBaseObject.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/02/2023.
//

import Foundation





struct BaseDimensionAndSupportPosition {

    var fromPrimaryToSitOnOrign: [PositionAsIosAxes]
    let rearToFront: Double
    let rearToCentre: Double
    let baseWidth: Double

    init (
        _ stability: Double,
        _ sitOnLength: [Double],
        _ sitOnWidth: [Double],
        _ armSupportWidth: [Double],
        _ hangerLength: Double,
        _ baseType: BaseObjectTypes) {
            
        rearToFront = getBaseLength()
        rearToCentre = 0.5 * rearToFront
        baseWidth = getBaseWidth()
            
        fromPrimaryToSitOnOrign =
            getOriginPosition(
                baseType,
                rearToFront,
                baseWidth)

        func getOriginPosition(
            _ baseType: BaseObjectTypes,
            _ baseLength: Double,
            _ baseWidth: Double)
            -> [PositionAsIosAxes ] {
            let rear = 0
            let front = 1
  
            let onlyOneSitOnFrontToRear = sitOnLength.count == 1
            let onlyOneSitOnLeftToRight = sitOnWidth.count == 1
            var fromPrimaryToSitOnLength: [Double] = [0.0]
                            
            switch baseType {
                
            case .fixedWheelFrontDrive:
                if onlyOneSitOnFrontToRear {
                    fromPrimaryToSitOnLength =
                    [ -0.5 * sitOnLength[rear]]
                } else {
                    fromPrimaryToSitOnLength =
                    [ -0.5 * sitOnLength[rear] - sitOnLength[front] - hangerLength,
                      -0.5 * sitOnLength[front]
                    ]
                }
                
            case .fixedWheelRearDrive:
                fromPrimaryToSitOnLength = fixedWheelRearDrive()

            case .fixedWheelMidDrive:
                if onlyOneSitOnFrontToRear {
                    fromPrimaryToSitOnLength =
                    [0.5 * (baseLength - sitOnLength[rear])]
                } else {
                    fromPrimaryToSitOnLength =
                    [ 0.5 * (baseLength - sitOnLength[rear]) - sitOnLength[front] - hangerLength,
                      0.5 * (baseLength - sitOnLength[front])
                    ]
                }
                
            case .fixedWheelManualRearDrive:
                fromPrimaryToSitOnLength = fixedWheelRearDrive()
                
            default:
                break
            }
                
            let potentiallyOneSitOn = 0
            var fromPrimaryToSitOnOriginPosition: [PositionAsIosAxes] = []
                
            if onlyOneSitOnFrontToRear && onlyOneSitOnLeftToRight {
                fromPrimaryToSitOnOriginPosition =
                    [(x: 0.0, y: fromPrimaryToSitOnLength[potentiallyOneSitOn], z: 0.0 )]
            }
            
            if !onlyOneSitOnFrontToRear {
                fromPrimaryToSitOnOriginPosition = []
                for length in fromPrimaryToSitOnLength {
                    fromPrimaryToSitOnOriginPosition.append( (x: 0.0, y: length, z: 0.0) )
                }
            }

            if !onlyOneSitOnLeftToRight {
                fromPrimaryToSitOnOriginPosition = []
                let widths = getWidth()
                for width in widths {
                    fromPrimaryToSitOnOriginPosition.append( (x: width, y: fromPrimaryToSitOnLength[0], z: 0.0) )
                }
            }
            
                
        
//print(fromPrimaryToSitOnOriginPosition)
                return fromPrimaryToSitOnOriginPosition
                
            func getWidth()
                -> [Double] {
                    [-(baseWidth - sitOnWidth[0])/2, (baseWidth - sitOnWidth[1])/2]
            }
            
            func fixedWheelRearDrive()
                -> [Double] {
                if onlyOneSitOnFrontToRear {
                    fromPrimaryToSitOnLength =
                    [ baseLength - 0.5 * sitOnLength[rear]]
                } else {
                    fromPrimaryToSitOnLength =
                    [ baseLength - 0.5 * sitOnLength[rear] - sitOnLength[front] - hangerLength,
                      baseLength - 0.5 * sitOnLength[front]
                    ]
                }
                return fromPrimaryToSitOnLength
            }
        }
            
        func getBaseLength()
            -> Double {
            let rear = 0
            let front = 1
            
           var rearToFront =
                 stability + sitOnLength[rear]
            rearToFront +=
                sitOnLength.count == 2 ?
                (hangerLength + sitOnLength[front]) : 0.0
            return rearToFront
        }
            
        func getBaseWidth()
            -> Double {
                let rightArmOfLeftSitOn = 0
                let leftArmOfRightSitOn = 1
                let potentiallyOneSitOn = 0
                let right = 1
                var baseWidth =
                sitOnWidth[potentiallyOneSitOn]

                baseWidth +=
                sitOnWidth.count == 2 ?
                sitOnWidth[right] +
                armSupportWidth[rightArmOfLeftSitOn] +
                armSupportWidth [leftArmOfRightSitOn ]: 0.0

                return baseWidth
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
