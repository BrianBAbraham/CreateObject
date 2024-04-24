//
//  MotionPositionVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 24/04/2024.
//

import Foundation

class MotionPositionViewModel: ObservableObject {
    @Published var applyOffset = true
   
    func getOffsetState() -> Bool {
        let currentOffsetState = applyOffset
        applyOffset.toggle()
        return currentOffsetState
    }
}
