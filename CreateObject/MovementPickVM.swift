//
//  MovementPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2024.
//

import Foundation
import Combine

struct MovementPickModel {
    var turnOriginToObjectOrigin: PositionAsIosAxes
    let startAngle: Double
    var endAngle: Double
    let forward: Double
    
    mutating func setEndAngle(_ angleIncrement: Double) {
        endAngle += angleIncrement
    }
    
    
    mutating func setTurnOriginToObjectOriginX( _ increment: Double) {
        let p = turnOriginToObjectOrigin
        turnOriginToObjectOrigin = CreateIosPosition.addToToupleX(p, increment)
    }
}


class MovementPickViewModel: ObservableObject {
    @Published var movementName: String = Movement.none.rawValue
    
    var movementType: Movement {
        Movement(rawValue: movementName) ?? .none
    }
    
    var turnOriginToObjectOrigin: PositionAsIosAxes {//of turn
        didSet {
            movementImageData = getMovementImageData()
        }
    }
    var startAngle: Double {//of turn
        didSet {
            movementImageData = getMovementImageData()
        }
    }
    var endAngle: Double {//of turn
        didSet {
            movementImageData = getMovementImageData()
        }
    }

    var forward: Double //in direction facing
    
    @Published private var movementPickModel: MovementPickModel
    
    //intialise object data
   var objectImageData: ObjectImageData =
        ObjectImageService.shared.objectImageData
    
    private var cancellables: Set<AnyCancellable> = []
    
    //intialise movement data
    //movement are object data plus transformed object data
    @Published private var movementImageData = MovementImageData (
        ObjectImageService.shared.objectImageData,
        movementType: .turn,
        origin: ZeroValue.iosLocation,
        startAngle: 0.0,
        endAngle: 0.0,
        forward: 0.0
    )
    
    var ensureInitialObjectAllOnScreen =
        // drag will not work if coordinates are negative
        EnsureInitialObjectAllOnScreen(
            fourCornerDic: [:],
            oneCornerDic: [:],
            objectDimension: ZeroValue.dimension
        )
    
    init(
        _ movement: String = Movement.none.rawValue,
        _ origin: PositionAsIosAxes = ZeroValue.iosLocation,
        _ startAngle: Double = 0.0,
        _ endAngle: Double = 10.0,
        _ forward: Double = 0.0
        
    ){
        self.movementName = movement
        self.turnOriginToObjectOrigin = origin
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.forward = forward
        
        movementPickModel = MovementPickModel(
            turnOriginToObjectOrigin: origin,
            startAngle: startAngle,
            endAngle: endAngle,
            forward: forward
        )
        
        ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
                self?.movementImageData = self?.getMovementImageData() ?? MovementImageData(
                    newData,
                    movementType: self?.movementType ?? .none,
                    origin: self?.turnOriginToObjectOrigin ?? ZeroValue.iosLocation,
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
}
    

//MARK: Get State A - Z
extension MovementPickViewModel {
    
    func getMovementType() -> Movement {
        movementType
    }
    
    
    func getEndAngle() -> Double {
        movementPickModel.endAngle
    }
    

    func getStartAngle() -> Double {
        startAngle
    }
    
    
    func getObjectTurnOriginX() -> Double {
        
//        movementPickModel.turnOriginToObjectOrigin.x
        turnOriginToObjectOrigin.x
    }
    
    
    func getMovementImageData() -> MovementImageData{
        MovementImageData(
            objectImageData,
            movementType: movementType,
            origin: turnOriginToObjectOrigin,
            startAngle: startAngle,
            endAngle: endAngle,
            forward: forward
        )
    }
}
    


//MARK: Set State A - Z
extension MovementPickViewModel {
   
    
    func setEndAngle(_ angleIncrement: Double) {
        movementPickModel.setEndAngle(angleIncrement)
    }
    
    
    func setMovementName(_ movementName: String) {
        self.movementName = movementName
    }
    

    func setObjectTurnOriginX(_ increment: Double ) {
        let newValue = turnOriginToObjectOrigin.x + increment
        turnOriginToObjectOrigin = (x: newValue, y: turnOriginToObjectOrigin.y, z: turnOriginToObjectOrigin.z)
        
//        movementPickModel.setTurnOriginToObjectOriginX(increment)
    }
    
    
    func setStartAngle(_ angle: Double) {
        startAngle += angle
    }
    
   
    func setStartAndEndAngle(_ angle: Double) {
        startAngle += angle
        endAngle += angle
    }
    
    
    func updateMovementImageData(
        to newMovement: String
    ) {
        movementName = newMovement
        movementImageData = getMovementImageData()
    }
    
}


    
//MARK: Names and Dictionaries
extension MovementPickViewModel {
    func createArcDictionary(_ dictionary: CornerDictionary, _ movement: Movement) -> CornerDictionary {
        var arcDictionary: CornerDictionary = [:]
        let postTiltObjectToPartFourCornerPerKeyDic = dictionary
        let names = Array(postTiltObjectToPartFourCornerPerKeyDic.keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
        let namesWithoutPrefix = Array(Set(RemovePrefix.get(PartTag.arcPoint.rawValue, names)))
        let prefixNames = SubstringBefore.get(substring: PartTag.arcPoint.rawValue, in: names)
        
        for name in namesWithoutPrefix {
           
            let firstPointName = prefixNames[0] + name
            let secondPointName = prefixNames[1] + name
            guard let firstPointValue = postTiltObjectToPartFourCornerPerKeyDic[firstPointName] else {
                fatalError("\(names)")
            }
            guard let secondPointValue = postTiltObjectToPartFourCornerPerKeyDic[secondPointName] else {
                fatalError()
            }
            let any = 0//four identical values; conforms to corners; disregard three
            arcDictionary += [name: [firstPointValue[any], secondPointValue[any]]]
        }
        
        return arcDictionary
    }
    
    
    func  getObjectDictionaryForScreen ()
        -> CornerDictionary {
            ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()
        let dic =
            ensureInitialObjectAllOnScreen.getObjectDictionaryForScreen()

        return dic
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
    
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
            Array(getPostTiltObjectToPartFourCornerPerKeyDic().keys).filter { !$0.contains(PartTag.arcPoint.rawValue) }
    }
}


//MARK: Transform for Screen
extension MovementPickViewModel {
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
    

//MARK: Movement Information
extension MovementPickViewModel {
    func getOffsetToKeepObjectOriginStaticInLengthOnScreen() -> Double{
            ensureInitialObjectAllOnScreen
                .getOffsetToKeepObjectOriginStaticInLengthOnScreen()
    }
    
    
    func getOffsetForObjectOrigin() -> PositionAsIosAxes {
        let offset =
        ensureInitialObjectAllOnScreen.originOffset
    return offset
    }
}

    
