//
//  MovementPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import Foundation
import Combine
import SwiftUI
class MovementOriginStepperViewModel: ObservableObject {

@Published var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation

@Published var staticPointUpdate: PositionAsIosAxes = ZeroValue.iosLocation {
    didSet {
        //print("detec")
        movementImageData = setAndGetMovementImageData()
    }
}

//intialise object data
var objectImageData =
   ObjectImageService.shared.objectImageData
    
    
    
//static single object
var movementImageData: MovementImageData =
    MovementImageService.shared.movementImageData


//EXTRACTIONS FROM DATA LAYER
//intialise movement data
//movement are single object data plus transformed object data
//showing movment or movments





private var cancellables: Set<AnyCancellable> = []


init(){

        MovementImageService.shared.$movementImageData
        .sink { [weak self] newData in
            self?.movementImageData = newData}
        .store(
            in: &cancellables
        )

    }
}


extension MovementOriginStepperViewModel {
    func setAndGetMovementImageData() -> MovementImageData{
        let newMovementImageData =
        MovementImageService.shared.setAndGetMovementImageData(
            objectImageData,
            .turn,
            staticPointUpdate,
            movementImageData.startAngle,
            movementImageData.endAngle,
            0.0
        )
        return newMovementImageData
    }


    func modifyStaticPointUpdateInX(
        _ increment: Double
    ) {
        staticPointUpdate = CreateIosPosition.addTwoTouples(
            staticPointUpdate,
            (
                x: increment,
                y: 0.0,
                z: 0.0
            )
        )
        
        modifyStaticPoint(
            increment
        )
        
        func modifyStaticPoint(
            _ increment: Double
        ) {
            staticPoint = CreateIosPosition.addTwoTouples(
                (
                    x: increment,
                    y: 0.0,
                    z: 0.0
                ),
                staticPoint
            )
        }
    }
}





class MovementPickerViewModel: ObservableObject {
    
    @Published var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation

    @Published var movementType: Movement = .none
  
    var staticPointUpdate: PositionAsIosAxes = ZeroValue.iosLocation {
        didSet {
            movementImageData = setAndGetMovementImageData()
        }
    }
    var startAngle: Double = 0.0 {//of turn
        didSet {
            movementImageData = setAndGetMovementImageData()
        }
    }
    var endAngle: Double = 30.0 {//of turn
        didSet {
            movementImageData = setAndGetMovementImageData()
        }
    }
    var forward: Double = 0.0//in direction facing
    
    var objectAngleType: WhichAngle = .end
    
    @Published var objectAngleName: String {
        didSet {
            setObjectAngleType()
        }
    }
    
    let menuItems = Movement.allCases.map {
        $0.rawValue
    }
    
    
    var binding: Binding<String> {
        Binding<String> (
            get: {self.movementName},
            set: { newValue in
                self.updateMovementImageData(
                    to: newValue)
                self.movementName = newValue
            }
        )
    }
    
    
    //intialise object data
    //static single object
    var objectImageData: ObjectImageData =
        ObjectImageService.shared.objectImageData
    
    @Published var movementName: String = Movement.none.rawValue{
        didSet {
            setMovementType()
        }
    }
    //EXTRACTIONS FROM DATA LAYER
    //intialise movement data
    //movement are single object data plus transformed object data
    //showing movment or movments
    //@Published private
    @Published  var movementImageData =
    MovementImageService.shared.movementImageData
    
    {
        didSet{
            
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(){
        objectAngleName = objectAngleType.rawValue
        
        //Initial build of movement data for image using a static image and default movement parameters
        ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
                
                //update movement if objectData changes
                self?.movementImageData = self?.setAndGetMovementImageData() ??
                
                MovementImageService.shared.setAndGetMovementImageData(            newData,//original
                    self?.movementType ?? .none,//transform original with following param
                  
                   self?.movementImageData.staticPoint ?? ZeroValue.iosLocation,
self?.startAngle ?? 0.0,
                    self?.endAngle ?? 0.0,
                    self?.forward ?? 0.0
                )
            }
            .store(
                in: &cancellables
            )
    }
}


extension MovementPickerViewModel {
    func setAndGetMovementImageData() -> MovementImageData{
        MovementImageService.shared.setAndGetMovementImageData(
            objectImageData,
            movementType,
            movementImageData.staticPoint,
            startAngle,
            endAngle,
            forward
        )
    }
    
    func setMovementType() {
        movementType = Movement(rawValue: movementName) ?? .none
    }
    
    
    func updateMovementImageData(
        to newMovement: String
    ) {
        movementName = newMovement
        movementImageData = setAndGetMovementImageData()
    }
    
    
    func setEndAngle(_ angleIncrement: Double) {
        endAngle += angleIncrement
    }
    
    
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
    
    
    
        func setObjectAngleType(){
            objectAngleType = WhichAngle(rawValue: objectAngleName) ?? .end
        }
    
    func setStartAngle(_ angle: Double) {
        startAngle += angle
    }
    
    
    func getMovementType() -> Movement {
        movementType
    }
    
    func getObjectIsTurning() -> Bool{
        movementType == .turn ? true: false
    }
    
    
//    func modifyStaticPoint(
//        _ increment: Double
//    ) {
//        staticPoint = CreateIosPosition.addTwoTouples(
//            (
//                x: increment,
//                y: 0.0,
//                z: 0.0
//            ),
//            staticPoint
//        )
//    }
//    
//    
//    func modifyStaticPointUpdateInX(
//        _ increment: Double
//    ) {
//        staticPointUpdate = CreateIosPosition.addTwoTouples(
//            staticPointUpdate,
//            (
//                x: increment,
//                y: 0.0,
//                z: 0.0
//            )
//        )
//        
//        modifyStaticPoint(
//            increment
//        )
//    }
}










class MovementPickerViewModelX: ObservableObject {
    
    @Published var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation

    @Published var movementType: Movement = .none
  
    var staticPointUpdate: PositionAsIosAxes = ZeroValue.iosLocation {
        didSet {
            movementImageData = setAndGetMovementImageData()
        }
    }
    var startAngle: Double = 0.0 {//of turn
        didSet {
            movementImageData = setAndGetMovementImageData()
        }
    }
    var endAngle: Double = 30.0 {//of turn
        didSet {
            movementImageData = setAndGetMovementImageData()
        }
    }
    var forward: Double = 0.0//in direction facing
    
    var objectAngleType: WhichAngle = .end
    
    @Published var objectAngleName: String {
        didSet {
            setObjectAngleType()
        }
    }
    
    let menuItems = Movement.allCases.map {
        $0.rawValue
    }
    
    
    var binding: Binding<String> {
        Binding<String> (
            get: {self.movementName},
            set: { newValue in
                self.updateMovementImageData(
                    to: newValue)
                self.movementName = newValue
            }
        )
    }
    
    
    //intialise object data
    //static single object
    var objectImageData: ObjectImageData =
        ObjectImageService.shared.objectImageData
    
    @Published var movementName: String = Movement.none.rawValue{
        didSet {
            setMovementType()
        }
    }
    //EXTRACTIONS FROM DATA LAYER
    //intialise movement data
    //movement are single object data plus transformed object data
    //showing movment or movments
    //@Published private
    var movementImageData =
    MovementImageService.shared.movementImageData
    
    {
        didSet{
            
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(){
        objectAngleName = objectAngleType.rawValue
        
        //Initial build of movement data for image using a static image and default movement parameters
        ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
                
                //update movement if objectData changes
                self?.movementImageData = self?.setAndGetMovementImageData() ??
                
                MovementImageService.shared.setAndGetMovementImageData(            newData,//original
                    self?.movementType ?? .none,//transform original with following param
                    self?.staticPointUpdate ?? ZeroValue.iosLocation,
                    self?.startAngle ?? 0.0,
                    self?.endAngle ?? 0.0,
                    self?.forward ?? 0.0
                )
            }
            .store(
                in: &cancellables
            )
    }
}


extension MovementPickerViewModelX {
    func setAndGetMovementImageData() -> MovementImageData{
        MovementImageService.shared.setAndGetMovementImageData(
            objectImageData,
            movementType,
            staticPointUpdate,
            startAngle,
            endAngle,
            forward
        )
    }
    
    func setMovementType() {
        movementType = Movement(rawValue: movementName) ?? .none
    }
    
    
    func updateMovementImageData(
        to newMovement: String
    ) {
        movementName = newMovement
        movementImageData = setAndGetMovementImageData()
    }
    
    
    func setEndAngle(_ angleIncrement: Double) {
        endAngle += angleIncrement
    }
    
    
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
    
    
    
        func setObjectAngleType(){
            objectAngleType = WhichAngle(rawValue: objectAngleName) ?? .end
        }
    
    func setStartAngle(_ angle: Double) {
        startAngle += angle
    }
    
    
    func getMovementType() -> Movement {
        movementType
    }
    
    func getObjectIsTurning() -> Bool{
        movementType == .turn ? true: false
    }
    
    
    func modifyStaticPoint(
        _ increment: Double
    ) {
        staticPoint = CreateIosPosition.addTwoTouples(
            (
                x: increment,
                y: 0.0,
                z: 0.0
            ),
            staticPoint
        )
    }
    
    
    func modifyStaticPointUpdateInX(
        _ increment: Double
    ) {
        staticPointUpdate = CreateIosPosition.addTwoTouples(
            staticPointUpdate,
            (
                x: increment,
                y: 0.0,
                z: 0.0
            )
        )
        
        modifyStaticPoint(
            increment
        )
    }
}
