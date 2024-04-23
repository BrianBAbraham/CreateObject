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
        willSet {
            // Capture the old origin offset before movementName changes
           oldOriginOffset = originOffset
        }
        didSet {
            setMovementType()
            
            
            
            
            
        }
    }
    
    @Published var objectAngleName: String {
        didSet {
            setObjectAngleType()
        }
    }

    @Published var turnOriginToObjectOrigin: PositionAsIosAxes {//of turn
        didSet {
            movementImageData = getMovementImageData()
        }
    }
    
    @Published var currentObjectType: ObjectTypes = DictionaryService.shared.currentObjectType
    
    //intialise object data
    var objectImageData: ObjectImageData =
        ObjectImageService.shared.objectImageData
    
    //intialise movement data
    //movement are object data plus transformed object data
    @Published private var movementImageData = MovementImageData (
        ObjectImageService.shared.objectImageData,//object data
        movementType: .turn, //transform data
        origin: ZeroValue.iosLocation, //transform data
        startAngle: 0.0, //transform data
        endAngle: 0.0, //transform data
        forward: 0.0 //transform data
    ) {
        didSet{
            uniquePartNames = getUniquePartNamesFromObjectDictionary()
            
            
            originOffset = getObjectZeroOrgin()
            
            
            
            print ("\(oldOriginOffset) \(originOffset)")
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
    
    var movementType: Movement = .none
    var objectAngleType: WhichAngle = .end
    var forward: Double //in direction facing
    
    @Published var oldOriginOffset = ZeroValue.iosLocation
    @Published var originOffset = ZeroValue.iosLocation
    
    
    @Published var uniquePartNames: [String] = []
    
    
    private var cancellables: Set<AnyCancellable> = []
    
    
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
        
        originOffset = getObjectZeroOrgin()
        
        uniquePartNames = getUniquePartNamesFromObjectDictionary()
    }
}
    

//MARK: Get State A - Z
extension MovementPickViewModel {
    
    func  getObjectDictionaryForScreen ()
        -> CornerDictionary {
            ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()
        let dic =
            ensureInitialObjectAllOnScreen.getObjectDictionaryForScreen()

        return dic
    }
    
    
    func getObjectZeroOrgin()  -> PositionAsIosAxes{
        let dic = getObjectDictionaryForScreen()
        let name = CreateNameFromIdAndPart(.id0, PartTag.origin).name
        let filteredDictionary =
        dic.filter { $0.key.contains(name) }
        let useAnyOfFour = 0
        guard let origin = filteredDictionary[name]?[useAnyOfFour] else {
            fatalError()
        }

        return origin
    }
    
    

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
       // print(turnOriginToObjectOrigin.x)
        return
        turnOriginToObjectOrigin.x
    }
    
    
    func getMovementImageData() -> MovementImageData{
        let movementImageData =
        MovementImageData(
            objectImageData,
            movementType: movementType,
            origin: turnOriginToObjectOrigin,
            startAngle: startAngle,
            endAngle: endAngle,
            forward: forward
        )
       // print(getObjectZeroOrgin())
        return movementImageData
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
    func createArcDictionary(_ dictionary: CornerDictionary) -> CornerDictionary {
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
    
    
//    func getObjectOrigins(_ dictionary: CornerDictionary) -> [PositionAsIosAxes] {
//        var origins: [PositionAsIosAxes] = []
//        let postTiltObjectToPartFourCornerPerKeyDic = dictionary
//       
//        let originDictionary = postTiltObjectToPartFourCornerPerKeyDic.filter { $0.key.contains(PartTag.origin.rawValue) }
//        let any = 0//four identical values; conforms to corners; disregard three
//        let numberOfOrigin = originDictionary.count
//    
//        for index in 0..<numberOfOrigin {
//            let name = Part.objectOrigin.rawValue + PartTag.stringLink.rawValue + "id" + String(index)
//            
//            for (key, value) in originDictionary {
//                if key.contains(name) {
//                    //print(value)
//                    origins.append(value[any])
//                }
//            }
//        }
//        if origins.count == 0 {
//            fatalError()
//        } else {
//            
//            return origins
//        }
//    }
    
    

    
    
    
    func getPostTiltOneCornerPerKeyDic() -> PositionDictionary {
        movementImageData.objectImageData.postTiltObjectToOneCornerPerKeyDic
    }
    
    
    func getPostTiltObjectToPartFourCornerPerKeyDic() -> CornerDictionary {
   
        let dictionary =
        movementImageData.objectImageData.postTiltObjectToPartFourCornerPerKeyDic
    
        return dictionary
    }
    
    
//    func getOriginNamesFromObjectDictionary() -> [String] {
//       
//        Array(getPostTiltObjectToPartFourCornerPerKeyDic().keys).filter { $0.contains(PartTag.origin.rawValue) }
//    }
    
    
    func getUniqueArcPointNamesFromObjectDictionary() -> [String] {
        let names =
             Array(getPostTiltObjectToPartFourCornerPerKeyDic().keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
       
        return names
    }
    
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
        Array(
            getPostTiltObjectToPartFourCornerPerKeyDic().keys
        ).filter { 
            !(
                $0.contains(
                    PartTag.arcPoint.rawValue //UI manages differently from parts
                )  || $0.contains(
                    PartTag.origin.rawValue// ditto
                )
            ) }
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

    
