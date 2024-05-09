//
//  DataServices.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/02/2024.
//

import Foundation
import Combine


class MeasurementSystemService {
    @Published var unitSystem: UnitSystem = .cm
    static let shared = MeasurementSystemService()
    
    
    func getMeasurementSytem() -> UnitSystem {
        unitSystem
    }
    
    
    func setMeasurementSystem(_ unitSystem: UnitSystem) {
    
        self.unitSystem = unitSystem
    }
}



class ObjectImageService {
    @Published var objectImageData: ObjectImageData = ObjectImageData(
        .fixedWheelRearDrive,
        nil
    )
    static let shared = ObjectImageService()
    
    
    func getObjectImage() -> ObjectImageData {
        objectImageData
    }
    
    
    func setObjectImage(_ objectImageData: ObjectImageData) {
   // print("set object image")
        self.objectImageData = objectImageData
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



class BilateralPartWithOnePropertyToChangeService {
   
    @Published var scopeOfEditForSide: SidesAffected = .both
    @Published var choiceOfEditForSide: SidesAffected = .both
    @Published var dimensionPropertyToEdit: PartTag = .length
    @Published var originPropertyToEdit: PartTag = .xOrigin
    
    
    static let shared = BilateralPartWithOnePropertyToChangeService()
    
    
    func setBothOrLeftOrRightAsEditible(_ sideChoice: SidesAffected) {
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


class DictionaryService {
    @Published var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionaries.shared
    @Published var partDataSharedDic: [Part: PartData] = [:]
    @Published var currentObjectType: ObjectTypes = .fixedWheelRearDrive
    @Published var screenDictionary: CornerDictionary = [:]

    static let shared = DictionaryService()
    
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
    }
    
    
    func originOffsetUserEdtiedDicModifier(_ entry: PositionDictionary) {
        userEditedSharedDics.parentToPartOriginOffsetUserEditedDic += entry
    }
    
    
    func originUserEdtiedDicModifier(_ entry: PositionDictionary) {
        userEditedSharedDics.parentToPartOriginUserEditedDic += entry
    }
    
    
    func partDataSharedDicModifier(_ initialised: [Part: PartData] ) {
        partDataSharedDic = initialised
    }
    
    
    func partIdsUserEditedDicModifier(_ entry: [Part: OneOrTwo<PartTag>]) {
        userEditedSharedDics.partIdsUserEditedDic += entry
    }
    
    
    func partIdsUserEditedDicReseter(_ part: Part) {
        userEditedSharedDics.partIdsUserEditedDic.removeValue(forKey: part)
    }
    
    
    func partIdsUserEditedDicReseter() {
        userEditedSharedDics.partIdsUserEditedDic = [:]
    }
    
    func getScreenDictionary() -> CornerDictionary {
        screenDictionary
    }
    
    func setScreenDictionary(_ dictionary: CornerDictionary) {
        //print("data service sets screen dic")
        screenDictionary = dictionary
    }
}
