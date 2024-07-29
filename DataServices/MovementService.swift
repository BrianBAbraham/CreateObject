//
//  MovementService.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/07/2024.
//

import Foundation
import Combine

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
}



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


class CenteredObjectZeroOriginService {
    @Published var centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter = EnsureObjectZeroOriginAtMovementCenter(MovementImageService.shared.movementImageData)//?
    
    static let shared = CenteredObjectZeroOriginService()
    
    
    func setCenteredObjectZeroOriginData(_ centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter) {
    
        self.centeredObjectZeroOriginData = centeredObjectZeroOriginData
    }
}
