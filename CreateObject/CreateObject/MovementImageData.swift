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
    let origin: PositionAsIosAxes
    let startAngle: Double
    let endAngle: Double
    let angleChange: Double
    
    init(
        _ objectImageData: ObjectImageData,
        movementType: Movement,
        origin: PositionAsIosAxes,
        startAngle: Double,
        endAngle: Double,
        forward: Double ){
            
        self.objectImageData = objectImageData
        self.origin = origin
        self.startAngle = startAngle
        self.endAngle = endAngle
        angleChange = endAngle - startAngle
            
        switch movementType {
        case .none:
            return
            
        case .linear:
            translateObject(1,
                            (x: forward, y: 0.0, z: 0.0))
           
            
        case .turn:
            for index in 0...1 {
                let newObjectId = index
                let rotationAngle = Measurement(
                    value: [startAngle, angleChange][index],
                    unit: UnitAngle.degrees
                )
                let aboutPosition: PositionAsIosAxes =
                origin
                
                rotateObject(newObjectId, rotationAngle,aboutPosition)
                
                updateOneCornerPerKeyDictionary()
            }

            
       default:
            return
            
        }
            
            
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
    
    mutating func rotateObject(
        _ objectIndex: Int,
        _ angle: Measurement<UnitAngle>,
        _ aboutPosition: PositionAsIosAxes
    ) {
        for (
            key,
            value
        ) in objectImageData.postTiltObjectToPartFourCornerPerKeyDic {
            
            var newValues = rotatePart(
                value,
                angle,
                aboutPosition
            )
            
            newValues = CreateIosPosition.addToupleToArrayOfTouples(
                (
                    x: 0.0,
                    y: 0.0,
                    z: 1000.0
                ),
                newValues
            )
            
            
            objectImageData.postTiltObjectToPartFourCornerPerKeyDic +=
            [ReplaceCharBeforeSecondUnderscore.get(
                in: key,
                with: String(
                    objectIndex
                ) //change name of object
            ):
                newValues
            ]
        }
        
        func rotatePart(
            _ positions: [PositionAsIosAxes],
            _ angle: Measurement<UnitAngle>,
            _ aboutPosition: PositionAsIosAxes
        ) -> [PositionAsIosAxes]{
            var rotatedPositions: [PositionAsIosAxes] = []
            for position in positions {
                let rotatedPosition =
                PositionOfPointAfterRotationAboutPoint(
                    staticPoint: (
                        aboutPosition
                    ),
                    movingPoint: position,
                    angleChange: angle,
                    rotationAxis: .zAxis
                ).fromObjectOriginToPointWhichHasMoved
                
                rotatedPositions.append(
                    rotatedPosition
                )
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

        
        Array(objectImageData.postTiltObjectToOneCornerPerKeyDic.keys)
    }
    

    
}

struct IdentifiableDictionary: Identifiable {
    let id: UUID // Provides a unique identifier for each instance
    var dictionary: CornerDictionary // Example dictionary, can be of any type

    init(dictionary: CornerDictionary) {
        self.id = UUID() // Generate a new UUID for each new instance
        self.dictionary = dictionary
    }
}
enum Movement: String, CaseIterable {
    case none = "static"
    case linear = "forward"
    case turn = "turn"
    case slalom = "slalom"
    case t = "T-turn"
    case incremental = "off wall"
}
