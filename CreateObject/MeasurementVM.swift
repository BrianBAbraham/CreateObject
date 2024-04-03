//
//  MeasurementVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 28/03/2024.
//

import Foundation
import Combine

enum UnitSystem: String {
    case cm  = "cm"
    case mm = "mm"
    case imperial = "inch"

    
    func formatLengthAsString( _ measurement: Measurement<UnitLength>) -> String {
        switch self{
        case .cm:
            return String(format: "%.1f",measurement.value/10.0)
        case .mm:
            return String(Int(measurement.value))
        case .imperial:
            return String(
                measurement.converted(to: .inches).value.roundToNearest(0.25))
        }
    }
    
}



struct MeasurementModel{
    var unitSystem: UnitSystem = MeasurementSystemService.shared.unitSystem
    
    init(_ unitSystem: UnitSystem) {
        setUnitSystem(unitSystem)
    }
    
    mutating func setUnitSystem(_ unitSystem: UnitSystem) {
        print(unitSystem)
        self.unitSystem = unitSystem
    }
}


class Settings: ObservableObject {
    @Published var unitSystem: UnitSystem = MeasurementSystemService.shared.unitSystem
    @Published var measurementModel = MeasurementModel( .cm)
    
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        MeasurementSystemService.shared.$unitSystem
            .sink { [weak self] newData in
                self?.unitSystem = newData
            }
            .store(in: &self.cancellables)
    }
    
    func setUnitSystem(_ unitSystem: UnitSystem) {
        MeasurementSystemService.shared.setMeasurementSystem(unitSystem)
        measurementModel.unitSystem = unitSystem
    }
    
    
    func getUnitSystem() -> UnitSystem {
       unitSystem
    }
}



