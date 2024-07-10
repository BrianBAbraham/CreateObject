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



class CenteredObjectZeroOriginService {
    @Published var centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter = EnsureObjectZeroOriginAtMovementCenter(MovementImageService.shared.movementImageData)//?
    
    static let shared = CenteredObjectZeroOriginService()
    
    
    func setCenteredObjectZeroOriginData(_ centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter) {
    
        self.centeredObjectZeroOriginData = centeredObjectZeroOriginData
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
    

    
    func setAndGetMovementImageData(
        _ objectImageData: ObjectImageData,
        _ movementType: Movement,
        _ staticPoint: PositionAsIosAxes,
        _ startAngle: Double,
        _ endAngle: Double,
        _ forward: Double ) -> MovementImageData{
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
            return movementImageData
    }
}



class ObjectImageService {
    @Published var objectImageData: ObjectImageData = ObjectImageData(
        .fixedWheelRearDrive,
        nil
    )
    static let shared = ObjectImageService()
    
   
    func setObjectImage(_ objectImageData: ObjectImageData) {
        //print("new object created")
        self.objectImageData = objectImageData
    }
}


class ObjectDataService {

    @Published var angleMinMaxDic: AngleMinMaxDictionary = [:]
    @Published var objectDimension: Dimension = ZeroValue.dimension
    @Published var objectChainLabelsDefaultDic: ObjectChainLabelsDictionary = [:]
    @Published var postTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    @Published var preTiltObjectToPartFourCornerPerKeyDic:
        CornerDictionary = [:]
    @Published var postTiltObjectToPartOneCornerPerKeyDic:
        PositionDictionary = [:]
    @Published var partDataDic: [Part: PartData] = [:]
    @Published var objectType = ObjectTypes.fixedWheelRearDrive
    
    static let shared = ObjectDataService()
    
    func setMinMaxDic(_ value: AngleMinMaxDictionary) {
        angleMinMaxDic = value
    }
    
    
    func setObjectDimension(_ value: Dimension) {
        objectDimension = value
    }
        
    
    func setObjectChainLabelsDefaultDic(_ value: ObjectChainLabelsDictionary) {

        objectChainLabelsDefaultDic = value
    }
    
    
    func setObjectType(_ value: ObjectTypes) {
        objectType = value
    }
    
    
    func setPartDataDic(_ value: [Part: PartData] = [:]) {
        partDataDic = value
    }
    
    
    func setPostTiltObjectToPartFourCornerPerKeyDic( _ value: CornerDictionary) {
        postTiltObjectToPartFourCornerPerKeyDic = value
    }
    
    
    func setPreTiltObjectToPartFourCornerPerKeyDic(_ value: CornerDictionary) {
        preTiltObjectToPartFourCornerPerKeyDic = value
    }
    
    
    func setPostTiltObjectToPartOneCornerPerKeyDic(_ value: PositionDictionary) {
        postTiltObjectToPartOneCornerPerKeyDic = value
    }
    
    
   
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
       // print("SET")
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



class ObjectEditService {
    static let defaultPart = Part.mainSupport
    @Published var scopeOfEditForSide: SidesAffected = .both
    @Published var choiceOfEditForSide: SidesAffected = .both
    @Published var dimensionPropertyToEdit: PartTag = .length
    @Published var originPropertyToEdit: PartTag = .xOrigin
    @Published var partToEdit = ObjectEditService.defaultPart
    
    
    static let shared = ObjectEditService()
    
    
    func resetPartToEdit() {
        self.partToEdit = ObjectEditService.defaultPart
    }
    
    
    func setScopeOfEditForSide(_ sideChoice: SidesAffected) {
        scopeOfEditForSide = sideChoice
    }
    
    
    func setSideToEdit(_ sideChoice: SidesAffected) {
      
        choiceOfEditForSide = sideChoice
    }
    
    
    func setDimensionPropertyToEdit(_ propertyToEdit: PartTag) {
        dimensionPropertyToEdit = propertyToEdit
    }
    
    
    func setOriginPropertyToEdit(_ propertyToEdit: PartTag) {
        originPropertyToEdit = propertyToEdit
    }
    
    
    func setPartToEdit(_ partToEdit: Part) {
        self.partToEdit = partToEdit
    }
}

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





class UserEditedDictionariesService: ObservableObject {
    @Published var  userEditedSharedDics: UserEditedDictionaries = UserEditedDictionaries.shared 
//    {
//        didSet{
//            objectWillChange.send()
//        }
//    }
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
    
    
    func partIdsUserEditedDicReseter(_ part: Part) {
        userEditedSharedDics.partIdsUserEditedDic.removeValue(forKey: part)
        userEditedSharedDics = UserEditedDictionaries.shared
    }
    
    
    func partIdsUserEditedDicReseter() {
        userEditedSharedDics.partIdsUserEditedDic = [:]
    }
    

}
