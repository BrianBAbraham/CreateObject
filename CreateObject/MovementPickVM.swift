//
//  MovementVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2024.
//

import Foundation


struct MovementModel {
    let origin: PositionAsIosAxes
}


class MovementViewModel: ObservableObject {
    @Published private var movementModel: MovementModel
    
    init(){
        movementModel = MovementModel(origin: ZeroValue.iosLocation)
    }
}
