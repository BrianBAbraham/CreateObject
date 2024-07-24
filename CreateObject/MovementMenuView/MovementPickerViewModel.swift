//
//  MovementPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import Foundation
import Combine
import SwiftUI

protocol SharedObjectImageDataFunc: AnyObject {
    var objectImageData: ObjectImageData { get set}
    func setMovementImageData()
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedObjectImageDataFunc {
    func subscribeToService() {
        ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
                //update movement if objectData changes
                self?.setMovementImageData()
            }
            .store(
                in: &cancellables
            )
    }
}


protocol SharedSetMovementImageDataFuncOnly {
    var objectImageData: ObjectImageData { get }
    var movementType: Movement { get }
    var staticPoint: PositionAsIosAxes { get }
    var startAngle: Double { get }
    var endAngle: Double { get }
    var forward: Double { get }

    func setMovementImageData()
}

extension SharedSetMovementImageDataFuncOnly {
    func setMovementImageData() {
        MovementImageService.shared.setMovementImageData(
            objectImageData,
            movementType,
            staticPoint,
            startAngle,
            endAngle,
            forward
        )
    }
}



protocol  SharedMovementType: AnyObject {
    var movementType: Movement {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedMovementType {
    func subscribeToService() {
        MovementEditService.shared.$movementType
            .receive(on: DispatchQueue.main)
            .assign(to: \.movementType,on: self)
            .store(in: &cancellables)
    }
}


protocol  SharedStaticPoint: AnyObject {
    var staticPoint: PositionAsIosAxes {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedStaticPoint {
    func subscribeToService() {
        MovementEditService.shared.$staticPoint
            .receive(on: DispatchQueue.main)
            .assign(to: \.staticPoint,on: self)
            .store(in: &cancellables)
    }
}

protocol  SharedObjectAngles: AnyObject {
    var endAngle: Double {get set}
    var startAngle: Double {get set}
  
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedObjectAngles {
    func subscribeToService() {
        MovementEditService.shared.$endAngle
            .receive(on: DispatchQueue.main)
            .assign(to: \.endAngle,on: self)
            .store(in: &cancellables)
 
        MovementEditService.shared.$startAngle
            .receive(on: DispatchQueue.main)
            .assign(to: \.startAngle,on: self)
            .store(in: &cancellables)
    }
}



protocol SharedObjectAngleType: AnyObject {
         var objectAngleType: WhichAngle {get set}
         var cancellables: Set<AnyCancellable> { get set }
    }
extension SharedObjectAngleType {
    func subscribeToService() {
        MovementEditService.shared.$objectAngleType
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectAngleType,on: self)
            .store(in: &cancellables)
    }
}


protocol SharedMovementImageData: AnyObject {
    var movementImageData: MovementImageData {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedMovementImageData {
    func subscribeToService() {
        MovementImageService.shared.$movementImageData
            .receive(on: DispatchQueue.main)
            .assign(to: \.movementImageData,on: self)
            .store(in: &cancellables)
    }
}




class MovementPickerViewModel: ObservableObject,
    SharedMovementType, 
    SharedObjectAngles,
    SharedStaticPoint,
    SharedMovementImageData,
    SharedSetMovementImageDataFuncOnly, 
    SharedObjectImageDataFunc {
    
    @Published var movementType: Movement = MovementEditService.shared.movementType
    @Published var movementName: String = Movement.none.rawValue{
        didSet {
            setMovementType()
        }
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

    var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation
    var startAngle: Double =  MovementEditService.shared.startAngle
    var endAngle: Double =  MovementEditService.shared.endAngle
    var forward: Double =  MovementEditService.shared.forward//in direction facing
    let menuItems: [String] = Movement.allCases.map {
        $0.rawValue
    }
    

    //intialise object data
    //static single object
    var objectImageData: ObjectImageData =
        ObjectImageService.shared.objectImageData
    
    //EXTRACTIONS FROM DATA LAYER
    //intialise movement data
    //movement are single object data plus transformed object data
    //showing movment or movments
    var movementImageData =
        MovementImageService.shared.movementImageData
    
    internal var cancellables: Set<AnyCancellable> = []
    
    init(){
        (self as SharedObjectAngles).subscribeToService()
        (self as SharedMovementType).subscribeToService()
        (self as SharedStaticPoint).subscribeToService()
        (self as SharedMovementImageData).subscribeToService()
        (self as SharedSetMovementImageDataFuncOnly).setMovementImageData()
        (self as SharedObjectImageDataFunc).subscribeToService()
    }
}


extension MovementPickerViewModel {
    
    func setMovementType() {
        movementType = Movement(rawValue: movementName) ?? .none
        
        MovementEditService.shared.setMovementType(movementType)
    }
    
    
    func updateMovementImageData(
        to newMovement: String
    ) {
        movementName = newMovement
        setMovementImageData()
    }
 
}


