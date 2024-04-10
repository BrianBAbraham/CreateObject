//
//  MovementImageData.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/04/2024.
//

import Foundation

///create duplicates of ObjectImageData
///renaming object with index as required
struct MovementImageData {
    var objectImageData: ObjectImageData
    
    init(
        _ objectType: ObjectTypes,
        _ userEditedDic: UserEditedDictionaries?) {
            
            objectImageData = ObjectImageData(
                objectType,
                userEditedDic
            )
            
//            translateObject(1,                    
//            (
//                x:0.0 ,
//                1000.0,
//                z:0.0
//            ))//adds to dictionary
            
//            
            rotateObject(1, Measurement(value: 60.0, unit: UnitAngle.degrees))
            
            updateOneCornerPerKeyDictionary()
            
            
//            DictionaryInArrayOut().getNameValue(objectImageData.postTiltObjectToOneCornerPerKeyDic
//            ).forEach{print($0)}
            
            getSize()
        }
    

    mutating  func translateObject(_ objectIndex: Int, _ movement: PositionAsIosAxes) {
        for (
            key,
            value
        ) in objectImageData.postTiltObjectToPartFourCornerPerKeyDic {
            objectImageData.postTiltObjectToPartFourCornerPerKeyDic +=
            [ReplaceCharBeforeSecondUnderscore.get(
                in: key,
                with: String(objectIndex)
            ):
                CreateIosPosition.addToupleToArrayOfTouples(
                    (
                        movement
                    ),
                    value
                )]
        }
    }
    
    mutating func rotateObject(_ objectIndex: Int, _ angle: Measurement<UnitAngle>) {
        for (
            key,
            value
        ) in objectImageData.postTiltObjectToPartFourCornerPerKeyDic {
            
           var newValues = rotatePart(value, angle)
            //newValues = (newValues.x, newValues.y, value.z)
            newValues = CreateIosPosition.addToupleToArrayOfTouples((x: 0.0, y: 0.0, z: 0.0), newValues)
           
            
            objectImageData.postTiltObjectToPartFourCornerPerKeyDic +=
            [ReplaceCharBeforeSecondUnderscore.get(
                in: key,
                with: String(objectIndex) //change name of object
            ):
                newValues
             ]
        }
        
        func rotatePart(_ positions: [PositionAsIosAxes], _ angle: Measurement<UnitAngle>) -> [PositionAsIosAxes]{
            var rotatedPositions: [PositionAsIosAxes] = []
            for position in positions {
                let rotatedPosition =
                    PositionOfPointAfterRotationAboutPoint(
                        staticPoint: (x: 0, y: 0, position.z),
                        movingPoint: position,
                        angleChange: angle,
                        rotationAxis: .zAxis
                    ).fromObjectOriginToPointWhichHasMoved
                
                rotatedPositions.append(rotatedPosition)
            }
            return rotatedPositions
        }
    }
    
    
    mutating func getSize() {
        let  postTiltObjectToOneCornerPerKeyDic =
        ConvertFourCornerPerKeyToOne(
            fourCornerPerElement: objectImageData.postTiltObjectToPartFourCornerPerKeyDic
        ).oneCornerPerKey
        let minMax =
        CreateIosPosition.minMaxPosition(
            postTiltObjectToOneCornerPerKeyDic
        )
        
        objectImageData.objectDimension =
        (
            width: minMax[1].x - minMax[0].x,
            length: minMax[1].y - minMax[0].y
        )
    }
    
    
    mutating func updateOneCornerPerKeyDictionary() {
        objectImageData.postTiltObjectToOneCornerPerKeyDic =
        ConvertFourCornerPerKeyToOne(
            fourCornerPerElement: objectImageData.postTiltObjectToPartFourCornerPerKeyDic
        ).oneCornerPerKey
    }

    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
     // GetUniqueNames(  getPostTiltFourCornerPerKeyDic()).forPart
        
        Array(objectImageData.postTiltObjectToOneCornerPerKeyDic.keys)
    }
    
    
    enum Movement {
        case linear
        case turn
    }
    
}

