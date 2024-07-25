//
//  DataServices.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/02/2024.
//

import Foundation
import Combine


//class ScaleService {
//    @Published var scale = 1.0
//    static let shared = ScaleService()
//     
//    
//    func setScale(_ scale: Double) {
//        self.scale = scale
//    }
//}


class MeasurementSystemService {
    @Published var unitSystem: UnitSystem = .cm
    static let shared = MeasurementSystemService()
    

    func setMeasurementSystem(_ unitSystem: UnitSystem) {
        self.unitSystem = unitSystem
    }
}

class RecenterObjectsOnScreenService {
    @Published var recenter = false
    
    static let initialRulerPosition = CGPoint(x:100, y: 350)
    static let shared = RecenterObjectsOnScreenService()
    
    func setRecenterTrue() {
        print(recenter)
        recenter.toggle()
    }
}

class CenteredObjectZeroOriginService {
    @Published var centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter = EnsureObjectZeroOriginAtMovementCenter(MovementImageService.shared.movementImageData)//?
    
    static let shared = CenteredObjectZeroOriginService()
    
    
    func setCenteredObjectZeroOriginData(_ centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter) {
    
        self.centeredObjectZeroOriginData = centeredObjectZeroOriginData
    }
    
}




class ObjectImageService {
    @Published var objectImageData: ObjectImageData = ObjectImageData(
        .fixedWheelRearDrive,
        nil
    )
    static let shared = ObjectImageService()
    
   
    func setObjectImage(_ objectImageData: ObjectImageData) {

        self.objectImageData = objectImageData
    }
}



//enum ObjectDisplayStyle {
//    case movement
//    case edit
//}
//class ObjectDisplayStyleService {
//    @Published var objectDisplayStyle: ObjectDisplayStyle = .movement
//    
//    static let shared = ObjectDisplayStyleService()
//    
//    func setObjectDisplayStyleToEdit() {
//        objectDisplayStyle = .edit
//    }
//    
//    
//    func setObjectDisplayStyleToMovement() {
//        objectDisplayStyle = .movement
//    }
//}
//
//
//
//protocol  SharedObjectDisplayStyle: AnyObject {
//    var objectDisplayStyle: ObjectDisplayStyle {get set}
//    var cancellables: Set<AnyCancellable> { get set }
//}
//extension SharedObjectDisplayStyle {
//    func subscribeToService() {
//        ObjectDisplayStyleService.shared.$objectDisplayStyle
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.objectDisplayStyle,on: self)
//            .store(in: &cancellables)
//    }
//}

class MovementEditService {
    @Published var movementType: Movement = .none
    @Published var staticPoint = ZeroValue.iosLocation
    @Published var endAngle = 30.0
    @Published var startAngle = 0.0
    @Published var objectAngleType: WhichAngle = .end
    @Published var forward = 0.0
    static let shared = MovementEditService()
    
    func setMovmentTypeToNone(){
        movementType = .none
    }
    
    func setMovmentTypeToTurn(){
        movementType = .turn
    }
    
    func setMovementTypeToForward(){
        movementType = .linear
    }
    
    func setMovementType(_ value: Movement) {
        movementType = value
    }
    
    func setStaticPoint(_ value: PositionAsIosAxes) {
        staticPoint = value
    }
    
    func setEndAngle(_ value: Double) {
        
        endAngle = value
    }
    
    
    func setStartAngle(_ value: Double) {
        startAngle = value
    }
    
    func setObjectAngleType(_ value: WhichAngle) {
        objectAngleType = value
    }
}






class MovementImageService {
    @Published var movementImageData: MovementImageData = MovementImageData (
        ObjectImageService.shared.objectImageData,//object data
        movementType: .turn, //transform data
        staticPoint: ZeroValue.iosLocation, //transform data
        startAngle: 0.0, //transform data
        endAngle: 0.0, //transform data
        forward: 0.0 //transform data
    )
    
    
    static let shared = MovementImageService()
//    private var cancellables = Set<AnyCancellable>()
//    init() {
//        movementImageData.$staticPoint
//            .assign(to: \.staticPoint, on: self)
//            .store(in: &cancellables)
//    }
//    

    func setMovementImageData(
        _ objectImageData: ObjectImageData,
        _ movementType: Movement,
        _ staticPoint: PositionAsIosAxes,
        _ startAngle: Double,
        _ endAngle: Double,
        _ forward: Double ) {
          //  print("set MovementImageService")
            movementImageData =
            MovementImageData (
                objectImageData,//object data
                movementType: movementType, //transform data
                staticPoint: staticPoint, //transform data
                startAngle: startAngle, //transform data
                endAngle: endAngle, //transform data
                forward: forward //transform data
                )
           
    }
    
//    func setStaticPoint(_ value: PositionAsIosAxes) {
//        staticPoint = value
//        movementImageData = MovementImageData.shared
//        
//    }
}



class MovementDataService {
    @Published var uniquePartNames: [String] = []
    @Published var preTiltObjectToPartFourCornerDictionary: CornerDictionary = [:]
    @Published var dictionaryForScreen: CornerDictionary = [:]
    @Published var maximumnDimensionOfMotion = 0.0
    @Published var objectFrameSize: Dimension = ZeroValue.dimension
    
    static let shared = MovementDataService()
    
    func setDictionaryForScreen(_ value: CornerDictionary) {
        dictionaryForScreen = value
    }
    
    
    func setMaximumDimensionOfMotion(_ value: Double) {
        maximumnDimensionOfMotion = value
    }
        
    
    func setObjectFrameSize(_ value: Dimension) {
        objectFrameSize = value
    }
    
    
    func setPreTiltObjectToPartFourCornerDictionary( _ value: CornerDictionary) {
        preTiltObjectToPartFourCornerDictionary = value
    }
    
    
    func setUniquePartNames(_ value: [String]) {
        uniquePartNames = value
    }
    
    
    
}


class MovementDictionaryForScreenService {
    @Published var movementDictionaryForScreen: CornerDictionary = [:]
    
    static let shared = MovementDictionaryForScreenService()
    
    
    func setMovementDictionaryForScreen(_ dic: CornerDictionary) {
        movementDictionaryForScreen = dic
    }
}


//
//class ObjectTypeService {
//    @Published var objectType: ObjectTypes = .fixedWheelRearDrive
//    
//    static let shared = ObjectTypeService()
//    
//    
//    func setObjectType(_ value: ObjectTypes) {
//        objectType = value
//    }
//    
//}


//class ObjectOriginOffsetService {
//    @Published var objectOriginOffset: PositionAsIosAxes = ZeroValue.iosLocation
//    static let shared = ObjectOriginOffsetService()
//    
//    func setObjectOriginOffset(_ offset: PositionAsIosAxes) {
//        objectOriginOffset = offset
//    }
//    
//}
//class ScreenDictionaryService {
//    static let shared = ScreenDictionaryService()
//    
//    @Published var screenDictionary: CornerDictionary = [:]
//    
//    func setScreenDictionary(_ dictionary: CornerDictionary) {
//        screenDictionary = dictionary
//    }
//}



protocol  SharedUserEditedDictionaries: AnyObject {
    var userEditedSharedDics: UserEditedDictionaries {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedUserEditedDictionaries {
    func subscribeToService() {
        UserEditedDictionariesService.shared.$userEditedSharedDics
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEditedSharedDics,on: self)
            .store(in: &cancellables)
    }
}

class UserEditedDictionariesService: ObservableObject {
    @Published var  userEditedSharedDics: UserEditedDictionaries = UserEditedDictionaries.shared 

    @Published var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] = [:]
    
    @Published var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] = [:]

    static let shared = UserEditedDictionariesService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        userEditedSharedDics.$partIdsUserEditedDic
            .assign(to: \.partIdsUserEditedDic, on: self)
            .store(in: &cancellables)
        
        userEditedSharedDics.$objectChainLabelsUserEditDic
            .assign(to: \.objectChainLabelsUserEditDic, on: self)
            .store(in: &cancellables)
    }
    
    
    func angleUserEditedDicModifier(_ entry: AnglesDictionary){
       
        userEditedSharedDics.angleUserEditedDic += entry
    }
    
    
    func angleUserEditedDicReseter(){
        userEditedSharedDics.angleUserEditedDic = [:]
    }
    
    
    func dimensionUserEditedDicModifier(_ entry: Part3DimensionDictionary){
        userEditedSharedDics.dimensionUserEditedDic += entry
    }
    
    
    func dimensionUserEditedDicReseter(){
        userEditedSharedDics.dimensionUserEditedDic = [:]
    }
    

    func objectChainLabelsUserEditDicReseter(_ objectType: ObjectTypes) {
        userEditedSharedDics.objectChainLabelsUserEditDic.removeValue(forKey: objectType)
        
        userEditedSharedDics = UserEditedDictionaries.shared
    }
    
    
    func objectChainLabelsUserEditDicModifier(_ objectType: ObjectTypes, _ chainLabels: [Part]) {
        userEditedSharedDics.objectChainLabelsUserEditDic += [objectType: chainLabels]
        
        userEditedSharedDics = UserEditedDictionaries.shared
    }
    
    
    func originOffsetUserEdtiedDicModifier(_ entry: PositionDictionary) {
        userEditedSharedDics.parentToPartOriginOffsetUserEditedDic += entry
    }
    
    
    func originUserEdtiedDicModifier(_ entry: PositionDictionary) {
        userEditedSharedDics.parentToPartOriginUserEditedDic += entry
    }
    

    func partIdsUserEditedDicModifier(_ entry: [Part: OneOrTwo<PartTag>]) {
        userEditedSharedDics.partIdsUserEditedDic += entry
        userEditedSharedDics = UserEditedDictionaries.shared
    }
    
    
    func partIdsUserEditedDicReseterForBilateralPart(_ part: Part, _ oneOrTwo: OneOrTwo<PartTag>) {
        
        userEditedSharedDics.partIdsUserEditedDic += [part: oneOrTwo]
        userEditedSharedDics = UserEditedDictionaries.shared
    }
    
    
//    func partIdsUserEditedDicReseterForUnilateralPart(_ part: Part) {
//        print(part)
//        userEditedSharedDics.partIdsUserEditedDic.removeValue(forKey: part)
//        userEditedSharedDics = UserEditedDictionaries.shared
//    }
//    
    
    func partIdsUserEditedDicReseter(_ part: Part) {
        userEditedSharedDics.partIdsUserEditedDic.removeValue(forKey: part)
        userEditedSharedDics = UserEditedDictionaries.shared
    }
    
    
    func partIdsUserEditedDicReseter() {
        userEditedSharedDics.partIdsUserEditedDic = [:]
    }
    

}
