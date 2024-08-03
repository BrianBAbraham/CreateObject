//
//  ObjectViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 28/06/2024.
//

import Foundation
import Combine

///determine the frame size of movement
///excluding the space required by the arcs
class AllPartWithArcViewModel: ObservableObject {

    @Published var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    
      
    //  @Published
    var objectZeroStaticPointAtMovementFrameCenter: ObjectZeroStaticPointAtMovementFrameCenter = ObjectZeroStaticPointAtMovementFrameCenterService.shared.objectZeroStaticPointAtMovementFrameCenter

    internal var cancellables: Set<AnyCancellable> = []
    
    init(){
        ObjectZeroStaticPointAtMovementFrameCenterService.shared.$objectZeroStaticPointAtMovementFrameCenter
            .receive(on: DispatchQueue.main)
            .sink { [weak self] new in
                self?.objectZeroStaticPointAtMovementFrameCenter = new
                self?.onScreenMovementFrameSize = new.onScreenMovementFrameSize
            }
            .store(in: &cancellables)
        
    }
    
}



