//
//  MovementDataVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import Foundation
import Combine
import SwiftUI


class MovementPickViewModel: ObservableObject {
    
   
    @Published var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation
    
  
    var movementType: Movement = .none
  
    
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
    var forward: Double = 0.0//in direction facing
    
    var objectAngleType: WhichAngle = .end
    
    @Published var objectAngleName: String {
        didSet {
            setObjectAngleType()
        }
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
        
        //print("MovementDataVM init")
        //Initial build of movement data for image using a static image and default movement parameters
        ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
                
                //update movement if objectData changes
                self?.movementImageData = self?.getMovementImageData() ?? //MovementImageData(
                MovementImageService.shared.setMovementImageData(            newData,//original
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


extension MovementPickViewModel {
    func getMovementImageData() -> MovementImageData{
        MovementImageService.shared.setMovementImageData(
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
        movementImageData = getMovementImageData()
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
