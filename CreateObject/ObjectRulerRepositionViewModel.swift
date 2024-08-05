//
//  RulerAndObjectRecenterVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/04/2024.
//

import Foundation

struct RecenterModel {
   
    var recenterState = false
    
    mutating func resetState(){
       recenterState.toggle()
    }
}

class ObjectRulerRepositionViewModel: ObservableObject {
    @Published var recenterModel: RecenterModel
    
    init() {
        self.recenterModel = RecenterModel()
    }
    
    func getRecenterState() -> Bool {
        recenterModel.recenterState
    }
    
   
    func setRecenterState() {
        RecenterObjectsOnScreenService.shared.setRecenterTrue()
        recenterModel.resetState()
    }
}
