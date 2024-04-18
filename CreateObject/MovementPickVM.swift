//
//  MovementPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2024.
//

import Foundation
import Combine

struct MovementPickModel {

    let forward: Double

    

}


class MovementPickViewModel: ObservableObject {
    @Published var movementName: String {
        didSet {
            setMovementType()
        }
    }
    var movementType: Movement = .none
    
    @Published var objectAngleName: String {
        didSet {
            setObjectAngleType()
        }
    }

    var objectAngleType: WhichAngle = .end
    
    
    @Published var turnOriginToObjectOrigin: PositionAsIosAxes {//of turn
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
    
    
    //intialise object data
   var objectImageData: ObjectImageData =
        ObjectImageService.shared.objectImageData
    
    private var cancellables: Set<AnyCancellable> = []
    
   @Published var currentObjectType: ObjectTypes = DictionaryService.shared.currentObjectType
    {
        didSet{
            
            getObjectOrginDictionary()
        }
    }
    
    
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
        _ endAngle: Double = 30.0,
        _ forward: Double = 0.0
        
    ){
        self.movementName = movement
        self.turnOriginToObjectOrigin = origin
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.forward = forward
        
        
        objectAngleName = objectAngleType.rawValue
        
        
        ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
                self?.movementImageData = self?.getMovementImageData() ?? MovementImageData(//original and transformed original
                    newData,//original
                    movementType: self?.movementType ?? .none,//transform param
                    origin: self?.turnOriginToObjectOrigin ?? ZeroValue.iosLocation,
                    startAngle: self?.startAngle ?? 0.0,
                    endAngle: self?.endAngle ?? 0.0,
                    forward: self?.forward ?? 0.0
                )
            }
            .store(
                in: &cancellables
            )
        
        DictionaryService.shared.$currentObjectType
            .sink { [weak self] newData in
                print("New currentObjectType: \(newData)")
                self?.currentObjectType = newData
            }
            .store(in: &self.cancellables)
        
        movementImageData = getMovementImageData()
        
        ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()
        
    }
}
    

//MARK: Get State A - Z
extension MovementPickViewModel {
    

    func getObjectIsStatic() -> Bool{
        movementType == .none ? true: false
    }
    
    
    func getEndAngle() -> Double {
        endAngle
    }
    

    func getMovementType() -> Movement {
        movementType
    }
    
    
    func getStartAngle() -> Double {
        startAngle
    }
    
    
    func getObjectTurnOriginX() -> Double {
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
    
    func setObjectAngle(_ angleIncrement: Double) {
        switch objectAngleType {
        case .start:
            setStartAngle(angleIncrement)
        case .end:
            setEndAngle(angleIncrement)
        case .startAndEnd:
            setStartAngle(angleIncrement)
            setEndAngle(angleIncrement)
        }
    }
    
    
    func setEndAngle(_ angleIncrement: Double) {
        endAngle += angleIncrement
    }
    
    func setMovementType() {
        movementType = Movement(rawValue: movementName) ?? .none
    }
    
    
    func setObjectAngleType(){
        objectAngleType = WhichAngle(rawValue: objectAngleName) ?? .end
    }

    func setObjectTurnOriginX(_ increment: Double ) {
        let newValue = turnOriginToObjectOrigin.x + increment
        turnOriginToObjectOrigin = (x: newValue, y: turnOriginToObjectOrigin.y, z: turnOriginToObjectOrigin.z)
    }
    
    
    func setStartAngle(_ angle: Double) {
        startAngle += angle
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
    
    func getObjectOrginDictionary() {
        
        let origins: [PositionAsIosAxes] = []
        let filteredDictionary =
        getObjectDictionaryForScreen().filter { $0.key.contains(PartTag.origin.rawValue) }
        //print(filteredDictionary)
        //print(getObjectDictionaryForScreen())
//        let positions = filteredDictionary.map{$0.value}
//        if positions.count == 0 {
//            fatalError()
//        } else {
//            let fourDuplicates = 0
//            for position in positions {
//                
//            }
//            return positions[fourDuplicates]
//        }
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

    
