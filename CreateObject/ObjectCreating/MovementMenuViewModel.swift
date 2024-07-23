//
//  MovementMenuViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 22/07/2024.
//

import Foundation
import Combine


class MovementMenuViewModel: ObservableObject, SharedMovementType {
    @Published var movementType = MovementEditService.shared.movementType {
        
            didSet {
                isNotTurning = movementType != .turn
            }
        
    }
    
    @Published var isNotTurning = false
    
    internal var cancellables: Set<AnyCancellable> = []
    
    init() {
        (self as SharedMovementType).subscribeToService()
    }
    
}
