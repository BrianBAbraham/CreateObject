//
//  MovementPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2024.
//

import Foundation
import Combine

struct MovementPickModel {
    let origin: PositionAsIosAxes
    let startAngle: Double = 0.0
    let endAngle: Double = 0.0
    let forward: Double = 0.0
    
    
}


class MovementPickViewModel: ObservableObject {
    //@Published private
    @Published private var movement: Movement
    var origin: PositionAsIosAxes // of turn
    var startAngle: Double //of turn
    var endAngle: Double // of turn

    var forward: Double //in direction facing
    
    @Published private var movementPickModel: MovementPickModel
    
    @Published var objectImageData: ObjectImageData =
    ObjectImageService.shared.objectImageData
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private var movementImageData = MovementImageData (
        ObjectImageService.shared.objectImageData,
        movementType: .turn,
        origin: ZeroValue.iosLocation,
        startAngle: 0.0,
        endAngle: 0.0,
        forward: 0.0
    )
    
    var ensureInitialObjectAllOnScreen =
    EnsureInitialObjectAllOnScreen(
        fourCornerDic: [:],
        oneCornerDic: [:],
        objectDimension: ZeroValue.dimension
    )
    
    init(
        _ movement: Movement = .none,
        _ origin: PositionAsIosAxes = ZeroValue.iosLocation,
        _ startAngle: Double = 0.0,
        _ endAngle: Double = 0.0,
        _ forward: Double = 0.0
        
    ){
        
        self.movement = movement
        self.origin = origin
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.forward = forward
        
        movementPickModel = MovementPickModel(
        origin: ZeroValue.iosLocation
        )
        
        ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
                self?.movementImageData = self?.getMovementImageData() ?? MovementImageData(
                    newData,
                    movementType: movement,
                    origin: self?.origin ?? ZeroValue.iosLocation,
                    startAngle: self?.startAngle ?? 0.0,
                    endAngle: self?.endAngle ?? 0.0,
                    forward: self?.forward ?? 0.0
                )
            }
            .store(
                in: &cancellables
            )

        movementImageData = getMovementImageData()
        
        ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()

    }
    
    
    func updateMovement(
        to newMovement: String,
        origin: Double,
        startAngle: Double,
        endAngle: Double,
        forward: Double
    ) {
        
        let newMovement = Movement(
            rawValue: newMovement
        ) ?? .none
        
        movement = newMovement
        
        self.origin = PositionAsIosAxes(x: origin, y: 0.0, z: 0.0)
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.forward = forward
        
        movementImageData = getMovementImageData()
//        ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()
//        
//       
//        cancellables.forEach {
//            $0.cancel()
//        }
//        cancellables.removeAll()
//        
//        ObjectImageService.shared.$objectImageData
//            .sink { [weak self] newData in
//                self?.objectImageData = newData
//                self?.movementImageData = self?.getMovementImageData() ?? MovementImageData(
//                    newData,
//                    movementType: newMovement,
//                    origin: (x: origin, y: 0.0, z: 0.0),
//                    startAngle: startAngle,
//                    endAngle: endAngle,
//                    forward: forward
//                )
//            }
//            .store(
//                in: &cancellables
//            )
        }
    func getCurrentMovement() -> Movement {
       // print(movement)
        return
        movement
    }
    
    func test() -> String {
        "test"
    }

    func getMovementImageData() -> MovementImageData{
        MovementImageData(
            objectImageData,
            movementType: movement,
            origin: origin,
            startAngle: startAngle,
            endAngle: endAngle,
            forward: forward
        )
    }
    
    
    func getPostTiltOneCornerPerKeyDic() -> PositionDictionary {
        movementImageData.objectImageData.postTiltObjectToOneCornerPerKeyDic
    }
    
    
    func getPostTiltObjectToPartFourCornerPerKeyDic() -> CornerDictionary {
   
        let dictionary =
        movementImageData.objectImageData.postTiltObjectToPartFourCornerPerKeyDic
     
        return dictionary
    }
    
    
    func getUniqueArcPointNamesFromObjectDictionary() -> [String] {
        let names =
             Array(getPostTiltObjectToPartFourCornerPerKeyDic().keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
       
        return names
    }
    
    
    func createArcDictionary(_ dictionary: CornerDictionary, _ movement: Movement) -> CornerDictionary {
        print(movement)
        var arcDictionary: CornerDictionary = [:]
        let postTiltObjectToPartFourCornerPerKeyDic = dictionary
        let names = Array(postTiltObjectToPartFourCornerPerKeyDic.keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
        let namesWithoutPrefix = Array(Set(RemovePrefix.get(PartTag.arcPoint.rawValue, names)))
        let prefixNames = SubstringBefore.get(substring: PartTag.arcPoint.rawValue, in: names)
        let anyPrefixName = prefixNames[0]
        
        for name in namesWithoutPrefix {
           // print(names)
            let firstPointName = prefixNames[0] + name
            let secondPointName = prefixNames[1] + name
            guard let firstPointValue = postTiltObjectToPartFourCornerPerKeyDic[firstPointName] else {
                fatalError("\(names)")
            }
            guard let secondPointValue = postTiltObjectToPartFourCornerPerKeyDic[secondPointName] else {
                fatalError()
            }
            let any = 0//four identical values are created for arc point
            arcDictionary += [name: [firstPointValue[any], secondPointValue[any]]]
        }
        
      
        return arcDictionary
    }
    
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
   
        return
            Array(getPostTiltObjectToPartFourCornerPerKeyDic().keys).filter { !$0.contains(PartTag.arcPoint.rawValue) }
    }
    
    
}



extension MovementPickViewModel {
    
    func  getObjectDictionaryForScreen ()
        -> CornerDictionary {
            ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()
        var dic =
            ensureInitialObjectAllOnScreen.getObjectDictionaryForScreen()

    return dic
    }
    
    
    func getOffsetToKeepObjectOriginStaticInLengthOnScreen() -> Double{
            ensureInitialObjectAllOnScreen
                .getOffsetToKeepObjectOriginStaticInLengthOnScreen()
    }
    
    
    func getOffsetForObjectOrigin() -> PositionAsIosAxes {
        let offset =
        ensureInitialObjectAllOnScreen.originOffset
        //print(offset)
    return offset
    }
    
    
    func getMakeWholeObjectOnScreen()
        -> EnsureInitialObjectAllOnScreen {
            let objectDimension: Dimension =
                getObjectDimension()
            let fourCornerDic: CornerDictionary =
            movementImageData.objectImageData
                    .postTiltObjectToPartFourCornerPerKeyDic
            
           // print(fourCornerDic)
            let oneCornerDic: PositionDictionary =
            movementImageData.objectImageData
                    .postTiltObjectToOneCornerPerKeyDic
            return
                EnsureInitialObjectAllOnScreen(
                    fourCornerDic: fourCornerDic,
                    oneCornerDic: oneCornerDic,
                    objectDimension: objectDimension
                )
    }
    
    
    func getObjectOnScreenFrameSize ()
    -> Dimension {
        let frameSize =
        getMakeWholeObjectOnScreen().getObjectOnScreenFrameSize()
       
        return frameSize
    }

    func getObjectDimension ( )
        -> Dimension {
            let dim =
            movementImageData.objectImageData.objectDimension
        
            return dim
    }

}
    
