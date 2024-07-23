//
//  MovementPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import Foundation
import Combine
import SwiftUI






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



class MovementPickerViewModel: ObservableObject, 
    SharedMovementType, SharedObjectAngles, SharedStaticPoint {
    
    @Published var movementType: Movement = MovementEditService.shared.movementType
  
    var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation
    
    var startAngle: Double =  MovementEditService.shared.startAngle

    var endAngle: Double =  MovementEditService.shared.endAngle

    var forward: Double =  MovementEditService.shared.forward//in direction facing
    
    let menuItems: [String] = Movement.allCases.map {
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

    var movementImageData =
        MovementImageService.shared.movementImageData
    
    internal var cancellables: Set<AnyCancellable> = []
    
    
    init(){
        
        //Initial build of movement data for image using a static image and default movement parameters
        ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
             
                //update movement if objectData changes
                self?.movementImageData = self?.setAndGetMovementImageData() ??
                    MovementImageService.shared.setAndGetMovementImageData(
                        newData,//original object
                        self?.movementType ?? .none,//transform original with following param
                        self?.staticPoint ?? ZeroValue.iosLocation,
                        self?.startAngle ?? 0.0,
                        self?.endAngle ?? 0.0,
                        self?.forward ?? 0.0
                    )
            }
            .store(
                in: &cancellables
            )
        
        (self as SharedObjectAngles).subscribeToService()
        (self as SharedMovementType).subscribeToService()
        (self as SharedStaticPoint).subscribeToService()
    }
}


extension MovementPickerViewModel {
    func setAndGetMovementImageData() -> MovementImageData{
        
        MovementImageService.shared.setAndGetMovementImageData(
            objectImageData,
            movementType,
            staticPoint,
            startAngle,
            endAngle,
            forward
        )
    }
    
    
    func setMovementType() {
        movementType = Movement(rawValue: movementName) ?? .none
        
        MovementEditService.shared.setMovementType(movementType)
    }
    
    
    func updateMovementImageData(
        to newMovement: String
    ) {
        movementName = newMovement
        movementImageData = setAndGetMovementImageData()
    }
 
}


