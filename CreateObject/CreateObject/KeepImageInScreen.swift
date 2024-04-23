//
//  KeepImageInScreen.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/04/2024.
//

import Foundation

struct EnsureInitialObjectAllOnScreen {
    let fourCornerDic: CornerDictionary
    let oneCornerDic: PositionDictionary
    let objectDimension: Dimension
    var originOffset = ZeroValue.iosLocation
    
    
    
    //MARK: DEVELOPMENT scale = 1
    ///objects larger than screen size behaviour not known
  mutating func getObjectDictionaryForScreen ()
        -> CornerDictionary {

        originOffset = getOriginOffsetWhenAllPositionValueArePositive()
//print("offset \(originOffset)")
        let scale = getScale()
            
            //INPUT DIC FOUR CORNER
        let dictionary =
            makeAllPositionsPositive(
                fourCornerDic,
                scale,
                originOffset
            )
            
        return dictionary
            
            func makeAllPositionsPositive(
                _ actualSize: CornerDictionary,
                _ scale: Double,
                _ offset: PositionAsIosAxes)
            -> CornerDictionary {
                let scaleFactor = scale/scale
                var postTiltObjectToPartFourCornerAllPositivePerKeyDic: CornerDictionary = [:]
                for item in actualSize {
                    var positivePositions: [PositionAsIosAxes] = []
                    for position in item.value {
                        positivePositions.append(
                            (x: (position.x + offset.x) * scaleFactor,
                         y: (position.y + offset.y) * scaleFactor,
                         z: (position.z * scaleFactor) )  )
                    }
                    postTiltObjectToPartFourCornerAllPositivePerKeyDic[item.key] = positivePositions
                }
                return postTiltObjectToPartFourCornerAllPositivePerKeyDic
            }
            
            func getScale() -> Double{
                let objectDimension = getObjectDimensions()
                let maximumObjectDimension = getMaximumOfObject(objectDimension)
                let scale = Screen.smallestDimension / maximumObjectDimension
                return scale
                
                func getObjectDimensions() -> Dimension{
                    let minThenMax =
                        CreateIosPosition
                           .minMaxPosition(
                               oneCornerDic
                               )
                    return
                        (width: minThenMax[1].x - minThenMax[0].x,length: minThenMax[1].y - minThenMax[0].y )
                }
                
                func getMaximumOfObject(_ objectDimensions: Dimension)
                    -> Double {
                      [objectDimensions.length, objectDimensions.width].max()  ?? objectDimensions.length
                         
                }
            }
    }
    

    func getOffsetToKeepObjectOriginStaticInLengthOnScreen() -> Double {
        let halfFrameHeight = getObjectOnScreenFrameSize().length/2
        
        // objects are created with origin at 0,0
        // setting all part corner position value >= 0
        // determines the most negative corner position is translated to 0,0
        // so that translation is the transformed origin position
        let offSetOfOriginFromFrameTop = getOriginOffsetWhenAllPositionValueArePositive().y
        
        return halfFrameHeight - offSetOfOriginFromFrameTop
    }

    
    func getOriginOffsetWhenAllPositionValueArePositive() -> PositionAsIosAxes{
        
        //INPUT DIC ONE CORNER
        let minThenMax =
            CreateIosPosition
               .minMaxPosition(
                   oneCornerDic
                   )
        return
            CreateIosPosition.negative(minThenMax[0])
    }
    
    func getObjectOnScreenFrameSize ()
        -> Dimension {
        let objectDimension = objectDimension
        var frameSize: Dimension =
            (width: Screen.smallestDimension,
            length: Screen.smallestDimension
             )

        if objectDimension.length < objectDimension.width {
            frameSize =
            (width: Screen.smallestDimension,
            length: objectDimension.length
             )
        }
    
        if objectDimension.length > objectDimension.width {
            frameSize = (
                width: objectDimension.width,
                length: Screen.smallestDimension
                                 )
        }
            frameSize = objectDimension
        return frameSize
    }
}
