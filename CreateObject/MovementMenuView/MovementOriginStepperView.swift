//
//  MovementOriginSetterView.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import SwiftUI
import Combine
//
struct MovementOriginStepperView: View {
    @EnvironmentObject var movementOriginStepperVM: MovementOriginStepperViewModel

    var body: some View {
            Stepper("", value: movementOriginStepperVM.binding, step: 10.0)
                .colorScheme(.light)
    }
}

class MovementOriginStepperViewModel: ObservableObject, SharedMovementType, SharedStaticPoint, SharedObjectAngles {
    
    var binding: Binding<Double> {
        Binding<Double> (
            get: {0.0},
            set: { newValue in
                self.modifyStaticPointUpdateInX(newValue)
            }
        )
    }
    
    @Published var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation

    var movementType: Movement = MovementEditService.shared.movementType
    var staticPointUpdate: PositionAsIosAxes = ZeroValue.iosLocation {
        didSet {
            movementImageData = setAndGetMovementImageData()
            MovementEditService.shared.setStaticPoint(staticPointUpdate)
        }
    }
    var startAngle: Double = MovementEditService.shared.startAngle
    var endAngle: Double = MovementEditService.shared.endAngle
    var forward: Double = MovementEditService.shared.forward//in direction facing
  
    
    //intialise object data
    //static single object
    var objectImageData: ObjectImageData =
        ObjectImageService.shared.objectImageData

    //EXTRACTIONS FROM DATA LAYER
    //intialise movement data
    //movement are single object data plus transformed object data
    //showing movment or movments
    //@Published private
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
                        self?.staticPointUpdate ?? ZeroValue.iosLocation,
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


extension MovementOriginStepperViewModel {
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
        MovementEditService.shared.setStaticPoint(staticPoint)
        movementImageData = setAndGetMovementImageData()
    }
}
