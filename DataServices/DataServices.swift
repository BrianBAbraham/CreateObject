//
//  DataServices.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/02/2024.
//

import Foundation
import Combine


class MeasurementSystemService {
    @Published var unitSystem: UnitSystem = .cm
    static let shared = MeasurementSystemService()
    

    func setMeasurementSystem(_ unitSystem: UnitSystem) {
        self.unitSystem = unitSystem
    }
}

class RecenterObjectsOnScreenService {
    @Published var recenter = false
    
    static let initialRulerPosition = CGPoint(x:100, y: 350)
    static let shared = RecenterObjectsOnScreenService()
    
    func setRecenterTrue() {
        print(recenter)
        recenter.toggle()
    }
}





