//
//  PartCreation.swift
//  CreateObject
//
//  Created by Brian Abraham on 22/02/2023.
//

import Foundation

struct PartCornerLocationFrom {

    let length: Double
    let primaryOriginLocation: PositionAsIosAxes
    let width: Double

    
    let itsOrigin: [PositionAsIosAxes]
    let primaryOrigin: [PositionAsIosAxes]
    //let primaryOriginForFront: LeftRightPositionAsIosAxis
    
    init(_ length: Double, _ originLocation: PositionAsIosAxes, _ width: Double) {
        self.length = length
        self.primaryOriginLocation = originLocation
        self.width = width
        itsOrigin = getForItsOrigin()
        primaryOrigin = getForPrimaryOrigin()
        //primaryOriginForFront = getForPrimaryOriginForFont()
        
        func getForItsOrigin() -> [PositionAsIosAxes]{
          [
                (x:  width/2, y: -length/2, z:0),
                (x:  width/2, y:  length/2, z:0),
                (x: -width/2, y: length/2, z:0),
                (x: -width/2, y: -length/2, z:0)
          ]
        }
        
        func getForItsOriginForFront() -> LeftRightPositionAsIosAxis{
            ( left: (x: -width/2, y: length/2, z:0),
              right: (x:  width/2, y:  length/2, z:0))
        }
               
        
        func getForPrimaryOrigin() -> [PositionAsIosAxes] {
            let offsetOriginLocation = CreateIosPosition.addTwoTouples((x: 500, y:200, z: 0 ), originLocation)
            var cornersFromPrimaryOrigin: [PositionAsIosAxes] = []
            let positionFromPartOrigin = getForItsOrigin()
            for item in positionFromPartOrigin{
                
                cornersFromPrimaryOrigin.append(
                CreateIosPosition.addTwoTouples(item, originLocation))
            }
            return cornersFromPrimaryOrigin
        }
    }
    
    static func primaryOriginForFrontOnly( _ positionFromPartOrigin: [PositionAsIosAxes] )
     -> LeftRightPositionAsIosAxis {
             (left: positionFromPartOrigin[2], right: positionFromPartOrigin[1])
     }
}

struct Corner {
    static let names = ["_corner0", "_corner1","_corner2","_corner3"]
    
    let cornerPositionsForBothSides: [[PositionAsIosAxes]]
    
    init (_ partForBothSidesFromPrimary: [PositionAsIosAxes],
          _ dimensions: (length: Double, width: Double)) {
        
        cornerPositionsForBothSides = getPositionForBothSides(partForBothSidesFromPrimary, dimensions)
        
        func getPositionForBothSides(
            _ partForBothSidesFromPrimary: [PositionAsIosAxes],
            _ dimensions: (length: Double, width: Double))
            -> [[PositionAsIosAxes]] {
                
           var cornerPositionsForBothSides =
           [[ZeroTouple.iosLocation], [ZeroTouple.iosLocation]]
    
           for position in partForBothSidesFromPrimary {
               cornerPositionsForBothSides.append(
               PartCornerLocationFrom(
                   dimensions.length,
                   position,
                  dimensions.width).primaryOrigin
               )
               
           }
        return cornerPositionsForBothSides
        }
    }
}
