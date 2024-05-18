//
//  ObjectDataProcessorVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 16/05/2024.
//

import Foundation
import Combine

class ObjectDataProcessorViewModel: ObservableObject {
    var objectImageData: ObjectImageData = ObjectImageService.shared.objectImageData
    
    var ensureInitialObjectAllOnScreen =
        EnsureNoNegativePositions(
            fourCornerDic: [:],
           objectDimension: ZeroValue.dimension)
    
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
            }
            .store(in: &self.cancellables)
        
    }
    
//    func getObjectDimension ( )
//        -> Dimension {
//            objectImageData.objectDimension
//    }
    
//    func getOffsetForObjectOrigin() -> PositionAsIosAxes {
//        let offset =
//        ensureInitialObjectAllOnScreen.getOriginOffsetWhenAllPositionValueArePositive()
//
//    return offset
//    }
    
    
//    func getMakeWholeObjectOnScreen()
//        -> EnsureNoNegativePositions {
//            let objectDimension: Dimension =
//                getObjectDimension()
//            let fourCornerDic: CornerDictionary =
//                objectImageData
//                    .postTiltObjectToPartFourCornerPerKeyDic
//            return
//                EnsureNoNegativePositions(
//                    fourCornerDic: fourCornerDic,
//                    objectDimension: objectDimension
//                )
//    }
    
    
//    func getObjectOnScreenFrameSize ()
//    -> Dimension {
//        let frameSize =
//          ensureInitialObjectAllOnScreen.getObjectOnScreenFrameSize()
//        return frameSize
//    }
    
}
