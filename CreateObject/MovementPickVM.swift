//
//  MovementPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2024.
//

import Foundation
import Combine
import SwiftUI

struct MovementPickModel {

    let forward: Double

    

}


class MovementPickViewModel: ObservableObject {
    //INPUTS TO VIEW
    @Published var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    @Published var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation
    

    
    
    @Published var objectZeroOrigin = ZeroValue.iosLocation
    @Published var uniquePartNames: [String] = []

    //@Published var uniqueStaticPointNames: [String] = []
    @Published var uniqueCanvasNames: [String] = [
        PartTag.canvas.rawValue + PartTag.origin.rawValue,
        PartTag.canvas.rawValue + PartTag.corner.rawValue
    ]
    @Published var movementDictionaryForScreen: CornerDictionary = MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    
    
    //EDITS BY VIEW FOR DATA LAYER INPUTS
    @Published var movementName: String = Movement.none.rawValue{
        didSet {
            setMovementType()
        }
    }
    var movementType: Movement = .none
    
    @Published var currentObjectType: ObjectTypes = DictionaryService.shared.currentObjectType
    
    @Published var objectAngleName: String {
        didSet {
            setObjectAngleType()
        }
    }
    var staticPointUpdate: PositionAsIosAxes = ZeroValue.iosLocation {
        didSet {
            movementImageData = getMovementImageData()
        }
    }
    var startAngle: Double = 0.0 {//of turn
        didSet {
            movementImageData = getMovementImageData()
        }
    }
    var endAngle: Double = 30.0 {//of turn
        didSet {
            movementImageData = getMovementImageData()
        }
    }
    var objectAngleType: WhichAngle = .end
    
    var forward: Double = 0.0//in direction facing
    
    
    //intialise object data
    //static single object
    var objectImageData: ObjectImageData =
        ObjectImageService.shared.objectImageData
    
    @Published var dataToCentreObjectZeroOrigin: AddOrPad = (
        addX: 0.0,
        addY: 0.0,
        padX: 0.0,
        padY: 0.0
    )
    
    
    //EXTRACTIONS FROM DATA LAYER
    //intialise movement data
    //movement are single object data plus transformed object data
    //showing movment or movments
    @Published private var movementImageData = MovementImageData (
        ObjectImageService.shared.objectImageData,//object data
        movementType: .turn, //transform data
        staticPoint: ZeroValue.iosLocation, //transform data
        startAngle: 0.0, //transform data
        endAngle: 0.0, //transform data
        forward: 0.0 //transform data
    ) {
        didSet{
                uniquePartNames = getUniquePartNamesFromObjectDictionary()

          
                
                movementDictionaryForScreen = getMovementDictionaryForScreen()
                objectZeroOrigin = getObjectZeroOrgin()
                staticPoint = objectZeroOrigin
                translateStaticPointForAllValuesPositive()
                dataToCentreObjectZeroOrigin = getDataToCentreObjectZeroOrigin()
                
                translateDictionaryToCentreObjectZeroOrigin()
            
            
               // print("on UI updatae before translate staticPoint \(staticPoint)")
                
                translateStaticPointForCentreObjectZeroOrigin()
   
            
            objectZeroOrigin = getObjectZeroOrgin()
                
                
                addCanvasOriginToDictionary()
                
                addCanvasCornerToDictionary()
                onScreenMovementFrameSize = getObjectOnScreenFrameSize()
            
            MovementDictionaryForScreenService.shared.setMovementDictionaryForScreen(movementDictionaryForScreen)
            
        }
    }
    
    //DATA MANIPULATION
    var ensureInitialObjectAllOnScreen =
        // drag will not work if coordinates are negative
        // must be repeated as movement can make negative
        EnsureNoNegativePositions(
            fourCornerDic: [:],
            objectDimension: ZeroValue.dimension
        )
    private var cancellables: Set<AnyCancellable> = []
    
    //all data to display object and its movement
    var movementFourCornerPerKeyDic: CornerDictionary = [:]

    init(){
        objectAngleName = objectAngleType.rawValue
        
        //Initial build of movement data for image using a static image and default movement parameters
        ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
                
                //update movement if objectData changes
                self?.movementImageData = self?.getMovementImageData() ?? MovementImageData(
                    newData,//original
                    movementType: self?.movementType ?? .none,//transform original with following param
                    staticPoint: self?.staticPointUpdate ?? ZeroValue.iosLocation,
                    startAngle: self?.startAngle ?? 0.0,
                    endAngle: self?.endAngle ?? 0.0,
                    forward: self?.forward ?? 0.0
                )
            }
            .store(
                in: &cancellables
            )
        
        //Object may change
        DictionaryService.shared.$currentObjectType
            .sink { [weak self] newData in
                self?.currentObjectType = newData
            }
            .store(in: &self.cancellables)
        
        //Final build of movement data for image using a static image and UI movement parameters
       // movementImageData = getMovementImageData()
        
        //All dictionary values dervied from data image must be positive
        movementDictionaryForScreen = getMovementDictionaryForScreen()
        
        //With all positive values find objectZeroOrigin
        objectZeroOrigin = getObjectZeroOrgin()
        //staticPoint = objectZeroOrigin
        dataToCentreObjectZeroOrigin = getDataToCentreObjectZeroOrigin()
        translateStaticPointForAllValuesPositive()
        
        //staticPointCG = CGPoint(x: staticPoint.x, y: staticPoint.y)
        
        
        //Dictionary values refer to key which are handled differently in view
        //Part
        //Arc
        //Canvas: zero orgin and maximum position are static
        //Extract these names
        uniquePartNames = getUniquePartNamesFromObjectDictionary()

        
        //To avoid manipulating View to make objectZeroOrigin static during movement edits
        //Effect in data
        translateDictionaryToCentreObjectZeroOrigin()
        objectZeroOrigin = getObjectZeroOrgin()
        
        addCanvasOriginToDictionary()
        addCanvasCornerToDictionary()
       // print("on initialisation before translate staticPoint \(staticPoint)")
        translateStaticPointForCentreObjectZeroOrigin()
        
      //  print("on intilialisation after translate staticPoint \(staticPoint)\n")
        onScreenMovementFrameSize = getObjectOnScreenFrameSize()
        
        MovementDictionaryForScreenService.shared.setMovementDictionaryForScreen(movementDictionaryForScreen)
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
    
//    func getStaticPoint () -> PositionAsIosAxes {
//        staticPoint
//    }
    

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
    
//    
//    func getObjectTurnOriginX() -> Double {
//        staticPoint.x
//    }
    
//    func getStaticPointCG() -> CGPoint {
//        //print(staticPointCG)
//        return
//            staticPointCG
//    }
    
    func getMovementImageData() -> MovementImageData{
        let movementImageData =
        MovementImageData(
            objectImageData,
            movementType: movementType,
            staticPoint: staticPointUpdate,
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

    
    func modifyStaticPointUpdateInX(_ increment: Double ) {
        staticPointUpdate = CreateIosPosition.addTwoTouples(staticPointUpdate, (x: increment, y: 0.0, z: 0.0))
        
        modifyStaticPoint(increment)
    }
    
    func modifyStaticPoint(_ increment: Double) {
        staticPoint = CreateIosPosition.addTwoTouples((x: increment, y: 0.0, z: 0.0), staticPoint)
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
    
    
//    func createArcDictionary(_ dictionary: CornerDictionary) -> CornerDictionary {
//        var arcDictionary: CornerDictionary = [:]
//        let postTiltObjectToPartFourCornerPerKeyDic = dictionary
//        let names = Array(postTiltObjectToPartFourCornerPerKeyDic.keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
//        let namesWithoutPrefix = Array(Set(RemovePrefix.get(PartTag.arcPoint.rawValue, names)))
//        let prefixNames = SubstringBefore.get(substring: PartTag.arcPoint.rawValue, in: names)
//        
//        for name in namesWithoutPrefix {
//           
//            let firstPointName = prefixNames[0] + name
//            let secondPointName = prefixNames[1] + name
//            guard let firstPointValue = postTiltObjectToPartFourCornerPerKeyDic[firstPointName] else {
//                fatalError("\(names)")
//            }
//            guard let secondPointValue = postTiltObjectToPartFourCornerPerKeyDic[secondPointName] else {
//                fatalError()
//            }
//            let any = 0//four identical values; conforms to corners; disregard three
//            arcDictionary += [name: [firstPointValue[any], secondPointValue[any]]]
//        }
//    //    print(arcDictionary)
//        return arcDictionary
//    }
    
    
//    func createStaticPointTurnDictionary(_ dictionary: CornerDictionary) -> CornerDictionary {
//        let dic =
//        dictionary.filter{$0.key.contains(PartTag.staticPoint.rawValue)}
//    // print(dic)
//        
//        return dic
//       //return dic.filter{$0.key.contains("0")}
//    }
    
    
    func getPostTiltOneCornerPerKeyDic() -> PositionDictionary {
        movementImageData.objectImageData.postTiltObjectToOneCornerPerKeyDic
    }
    
    
    func getPostTiltObjectToPartFourCornerPerKeyDic() -> CornerDictionary {
   
        let dictionary =
        movementImageData.objectImageData.postTiltObjectToPartFourCornerPerKeyDic
    
        return dictionary
    }

        
    
    
    
    
//    func getUniqueArcPointNamesFromObjectDictionary() -> [String] {
//       
//       Array(getPostTiltObjectToPartFourCornerPerKeyDic().keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
////        Array( movementDictionaryForScreen.keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
//      
//    }
    
    
//    func getUniqueArcNames() -> [String] {
//       var names = getUniqueArcPointNamesFromObjectDictionary()
//        names = StringAfterSecondUnderscore.get(in: names)
//    
//    names = Array(Set(names))
//        //print(names)
// 
//    
//    return names
//        
//    }
    
    
    
    
    
    
    
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
        Array(
            getPostTiltObjectToPartFourCornerPerKeyDic().keys
        ).filter {
            !(
                $0.contains(
                    PartTag.arcPoint.rawValue //UI manages differently from parts
                )  || $0.contains(
                    PartTag.origin.rawValue// ditto
                )  || $0.contains(
                    PartTag.staticPoint.rawValue// ditto
                )
            ) }
    }
    
    
//    func getUniqueStaticPointNamesFromObjectDictionary() -> [String] {
//        Array(
//            getPostTiltObjectToPartFourCornerPerKeyDic().keys
//        ).filter {
//            $0.contains(
//                PartTag.staticPoint.rawValue) }
//    }
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
            
            return
                EnsureNoNegativePositions(
                    fourCornerDic: fourCornerDic,
                    objectDimension: objectDimension
                )
    }
    
    
    func getObjectOnScreenFrameSize ()
    -> Dimension {
        FourCornerDictionryTo(movementDictionaryForScreen).valueSize
    }


    
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
        let oneCornerDic = ConvertFourCornerPerKeyToOne(fourCornerPerElement: movementDictionaryForScreen).oneCornerPerKey
        let minThenMax =
            CreateIosPosition
               .minMaxPosition(
                   oneCornerDic
                   )
        //the minimum values of the translated object is the offset for all part positions including origin
        return
            CreateIosPosition.negative(minThenMax[0])
        
        
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
            var pad = max
            var translate = 0.0
            switch (
                max,
                origin
            ) {
            case let (
                max,
                origin
            ) where max > 2 * origin:
                translate = max - 2 * origin
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
    
    
    func getTranslationToCentreObjectZeroOrigin() -> PositionAsIosAxes {
        (dataToCentreObjectZeroOrigin.addX, y: dataToCentreObjectZeroOrigin.addY, z: 0.0)
    }
    
    
    func translateStaticPointForAllValuesPositive() {
       
        //print(objectZeroOrigin)
        //staticPoint =
        //print(CreateIosPosition.addTwoTouples(originOffset, staticPoint))
    }
    
    
    func translateStaticPointForCentreObjectZeroOrigin(){
        let translation = getTranslationToCentreObjectZeroOrigin()
       staticPoint = CreateIosPosition.addTwoTouples(translation, staticPoint)
//        print("translation \(translation)")
//        print("staticPoint \(staticPoint)")
//        print("staticPointUpdate \(staticPointUpdate)")
//        print("")
        //print(CreateIosPosition.addTwoTouples(translation, staticPoint))
    }
    
    
    func translateDictionaryToCentreObjectZeroOrigin() {
        let translation = getTranslationToCentreObjectZeroOrigin()
                for (key, value) in movementDictionaryForScreen {
                    let currentValue = value
                    let newValue =
                        CreateIosPosition.addToupleToArrayOfTouples(translation, currentValue)
                    movementDictionaryForScreen[key] = newValue
                }
    }
    
    
    func addCanvasCornerToDictionary() {
        
        let canvasCornerName = uniqueCanvasNames[1]
        
        let origin = getCanvasOrigin()
        let max = getDictionaryMaxForScreenDictionary()
        
        let data = dataToCentreObjectZeroOrigin
        let corner = (x: data.padX, y: data.padY, z: 0.0)
        let corners = CreateIosPosition.addToupleToArrayOfTouples(corner, origin)

        movementDictionaryForScreen[canvasCornerName] = corners
        //print(movementDictionaryForScreen)
    }
    
    func getCanvasOrigin() -> [PositionAsIosAxes] {
        let size = 0.5
        return
            [(x: 0.0, y: 0.0, z: 0.0), (x: size, y: 0.0, z: 0.0), (x: size, y: size, z: 0.0), (x: 0.0, y: size, z: 0.0)]
    }
    
    func addCanvasOriginToDictionary() {
        let canvasOriginName = uniqueCanvasNames[0]

        movementDictionaryForScreen[canvasOriginName] = getCanvasOrigin()

    }
}
