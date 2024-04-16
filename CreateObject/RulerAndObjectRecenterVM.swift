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

class RecenterViewModel: ObservableObject {
    @Published var recenterModel: RecenterModel
    
    init() {
     
        
        self.recenterModel = RecenterModel()
    }
    
    func getRecenterState() -> Bool {
        recenterModel.recenterState
    }
    
   
    func setRecenterState() {
        recenterModel.resetState()
    }
}
