//
//  ScaleViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/05/2024.
//

import Foundation
import Combine


class ScaleViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

//        MeasurementSystemService.shared.$unitSystem
//            .sink { [weak self] newData in
//                self?.unitSystem = newData
//            }
//            .store(in: &self.cancellables)
    }

//    
//    func setUnitSystem(_ unitSystem: UnitSystem) {
//        MeasurementSystemService.shared.setMeasurementSystem(unitSystem)
//        measurementModel.unitSystem = unitSystem
//    }
//    
//    
//    func getUnitSystem() -> UnitSystem {
//       unitSystem
//    }
}
