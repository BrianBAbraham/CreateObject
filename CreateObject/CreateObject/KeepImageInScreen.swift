//
//  KeepImageInScreen.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/04/2024.
//

import Foundation

struct EnsureNoNegativePositions {
    let fourCornerDic: CornerDictionary
    let objectDimension: Dimension
    var originOffset = ZeroValue.iosLocation
    

    //MARK: DEVELOPMENT scale = 1
    ///objects larger than screen size behaviour not known
  mutating func getModifiedDictionary()
        -> CornerDictionary {

        originOffset = getOriginOffsetWhenAllPositionValueArePositive()

        let dictionary =
            makeAllPositionsPositive(
                fourCornerDic,
                originOffset
            )
            
        return dictionary
            
            func makeAllPositionsPositive(
                _ actualSizeDic: CornerDictionary,
                _ offset: PositionAsIosAxes)
            -> CornerDictionary {
                let scaleFactor = 1.0
                var postTiltObjectToPartFourCornerAllPositivePerKeyDic: CornerDictionary = [:]
                for item in actualSizeDic {
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
            
            
//            func getScale() -> Double{
//                let objectDimension = getObjectDimensions()
//                let maximumObjectDimension = getMaximumOfObject(objectDimension)
//                let scale = Screen.smallestDimension / maximumObjectDimension
//                
//                print(scale)
//                return scale
//                
//                func getObjectDimensions() -> Dimension{
//                    let minThenMax = // max - mins for x and y for the dictionary
//                        CreateIosPosition
//                           .minMaxPosition(
//                               oneCornerDic
//                               )
//                    return
//                        (width: minThenMax[1].x - minThenMax[0].x,length: minThenMax[1].y - minThenMax[0].y )
//                }
//                
//                func getMaximumOfObject(_ objectDimensions: Dimension)
//                    -> Double {
//                      [objectDimensions.length, objectDimensions.width].max()  ?? objectDimensions.length
//                        
//                }
//            }
    }
    

    func getOffsetToKeepObjectOriginStaticInLengthOnScreen() -> Double {
        let halfFrameHeight = getObjectOnScreenFrameSize().length/2
        // frame size changes due to UI edit will move object origin screen position
        // it looks bad so do this
        // objectZero is created with origin at 0,0
        // setting all part corner position value >= 0
        // determines the most negative position is translated to 0,0
        // so that translation is the transformed origin position
        let offSetOfOriginFromFrameTop = getOriginOffsetWhenAllPositionValueArePositive().y
        
        return halfFrameHeight - offSetOfOriginFromFrameTop
    }

    
    func getOriginOffsetWhenAllPositionValueArePositive() -> PositionAsIosAxes{
        //INPUT DIC ONE CORNER
        let oneCornerDic = ConvertFourCornerPerKeyToOne(fourCornerPerElement: fourCornerDic).oneCornerPerKey
        let minThenMax =
            CreateIosPosition
               .minMaxPosition(
                   oneCornerDic
                   )
        //the minimum values of the translated object is the offset for all part positions including origin
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



struct MakeObjectStaticWhenEdited {
    let fourCornerDic: CornerDictionary
    let objectDimension: Dimension
    
    func getOffsetToKeepObjectOriginStaticInLengthOnScreen() -> Double {
        let halfFrameHeight = getObjectOnScreenFrameSize().length/2
        // frame size changes due to UI edit will move object origin screen position
        // it looks bad so do this
        // objectZero is created with origin at 0,0
        // setting all part corner position value >= 0
        // determines the most negative position is translated to 0,0
        // so that translation is the transformed origin position
        let offSetOfOriginFromFrameTop = getOriginOffsetWhenAllPositionValueArePositive().y
        
        return halfFrameHeight - offSetOfOriginFromFrameTop
    }

    
    func getOriginOffsetWhenAllPositionValueArePositive() -> PositionAsIosAxes{
        //INPUT DIC ONE CORNER
        let oneCornerDic = ConvertFourCornerPerKeyToOne(fourCornerPerElement: fourCornerDic).oneCornerPerKey
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
