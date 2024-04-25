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
    @Published var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    
    @Published var movementName: String {
        willSet {
            // Capture the old origin offset before movementName changes
           oldOriginOffset = objectZeroOrigin
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
    
    @Published var dataToCentreObjectZeroOrigin: AddOrPad = (addX: 0.0, addY: 0.0, padX: 0.0, padY: 0.0 )
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
            movementDictionaryForScreen = getMovementDictionaryForScreen()
            objectZeroOrigin = getObjectZeroOrgin()
            dataToCentreObjectZeroOrigin = getDataToCentreObjectZeroOrigin()
            
            print(dataToCentreObjectZeroOrigin)
            onScreenMovementFrameSize = getObjectOnScreenFrameSize()
            
//            if dataToCentreObjectZeroOrigin.addX != 0.0 || dataToCentreObjectZeroOrigin.addY != 0.0 {
//                transformMovementDictionaryForScreenToCentreObjectZeroOrigin()
//
//            }
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
    @Published var objectZeroOrigin = ZeroValue.iosLocation
    
    
    @Published var uniquePartNames: [String] = []
    @Published var movementDictionaryForScreen: CornerDictionary = [:]
    
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    var ensureInitialObjectAllOnScreen =
        // drag will not work if coordinates are negative
        EnsureNoNegativePositions(
            fourCornerDic: [:],
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
               // print("New currentObjectType: \(newData)")
                self?.currentObjectType = newData
            }
            .store(in: &self.cancellables)
        
        movementImageData = getMovementImageData()
        
        ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()
        
        objectZeroOrigin = getObjectZeroOrgin()
        
        uniquePartNames = getUniquePartNamesFromObjectDictionary()
        
        onScreenMovementFrameSize = getObjectOnScreenFrameSize()
    }
}
    

//MARK: Get State A - Z
extension MovementPickViewModel {
    
    func  getMovementDictionaryForScreen ()
        -> CornerDictionary {
            ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()
        let dic =
            ensureInitialObjectAllOnScreen.getModifiedDictionary()

        return dic
    }
    
    
    func getObjectZeroOrgin()  -> PositionAsIosAxes{
        let dic = movementDictionaryForScreen
        let name = CreateNameFromIdAndPart(.id0, PartTag.origin).name
        let filteredDictionary =
        dic.filter { $0.key.contains(name) }
        let useAnyOfFour = 0
        guard let origin = filteredDictionary[name]?[useAnyOfFour] else {
            print(dic)
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
        -> EnsureNoNegativePositions {
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
                EnsureNoNegativePositions(
                    fourCornerDic: fourCornerDic,
                   // oneCornerDic: oneCornerDic,
                    objectDimension: objectDimension
                )
    }
    
    
    func getObjectOnScreenFrameSize ()
    -> Dimension {
        
        let ensureInitialObjectAllOnScreen =  getMakeWholeObjectOnScreen()
        let frameSize =
            ensureInitialObjectAllOnScreen.getObjectOnScreenFrameSize()
       
        return frameSize
    }

//    func getObjectOnScreenFrameSize() -> Dimension {
//        let position = getDictionaryMaxForScreenDictionary()
//        
//        return (width: position.x, length: position.y)
//    }
//    
    
    
    func getObjectDimension ( )
        -> Dimension {
            let dim =
            movementImageData.objectImageData.objectDimension
        
            return dim
    }
    
    
    func transformMovementDictionaryForScreenToCentreObjectZeroOrigin(){
        let addTouple = (x: dataToCentreObjectZeroOrigin.addX, y: dataToCentreObjectZeroOrigin.addY,z: 0.0)
        
        for (key, value) in movementDictionaryForScreen {
            if let value = movementDictionaryForScreen[key] {
                movementDictionaryForScreen[key] = CreateIosPosition.addToupleToArrayOfTouples(addTouple, value)
            }
        }
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

    
//MARK: Centre ObjectZeroOrigin

extension MovementPickViewModel {
    
    func getDictionaryMaxForScreenDictionary() -> PositionAsIosAxes{
        let dic = ConvertFourCornerPerKeyToOne(
            fourCornerPerElement: movementDictionaryForScreen
        ).oneCornerPerKey
        
        let minMax = CreateIosPosition.minMaxPosition(
            dic
        )
        let onlyMax = 1
        let max = minMax[onlyMax]
        
        return max
    }
    
    func getDataToCentreObjectZeroOrigin() -> AddOrPad{
        
//        let dic = ConvertFourCornerPerKeyToOne(
//            fourCornerPerElement: movementDictionaryForScreen
//        ).oneCornerPerKey
//        
//        let minMax = CreateIosPosition.minMaxPosition(
//            dic
//        )
//        
        let max = getDictionaryMaxForScreenDictionary() //minMax[1]
        
        var padX = 0.0
        var padY = 0.0
        var addX = 0.0
        var addY = 0.0
        
        (
            addX,
            padX
        ) = getCorrections(
            max.x,
            objectZeroOrigin.x
        )
        (
            addY,
            padY
        ) = getCorrections(
            max.y,
            objectZeroOrigin.y
        )
        
       return (addX: addX, addY: addY, padX: padX, padY: padY )
        
        func getCorrections(
            _ max: Double,
            _ origin: Double
        ) -> (
            Double,
            Double
        ) {
            var pad = 0.0
            var translate = 0.0
            switch (
                max,
                origin
            ) {
            case let (
                max,
                origin
            ) where max > 2 * origin:
                translate = max - origin
            case let (
                max,
                origin
            ) where max < 2 * origin:
                pad = 2 * origin
            case let (
                max,
                origin
            ) where max == origin:
                break
                //do nothing
            default:
                break
            }
            
            return (
                translate,
                pad
            )
        }
       
    }
    
    
}
