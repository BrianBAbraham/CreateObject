//
//  File.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/02/2024.
//

import Foundation
import SwiftUI


struct MeasurementView: View {
    @EnvironmentObject var settings: Settings
    var measurement: Measurement<UnitLength>
    
    init(_ measurement: Measurement<UnitLength>) {
        self.measurement = measurement
    }

    var body: some View {
        Text(formatLength())
    }

    private func formatLength() -> String {
        switch settings.unitSystem {
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

struct MeasurementUnitView: View {
    @EnvironmentObject var settings: Settings
   

    var body: some View {
        Text(settings.unitSystem.rawValue)
    }
}



//struct UnitSystemSelectionView: View {
//    @EnvironmentObject var settings: Settings
//
//    var body: some View {
//        Picker("Unit System", selection: $settings.unitSystem) {
//            Text("cm").tag(UnitSystem.cm)
//            Text("mm").tag(UnitSystem.mm)
//            Text("\"").tag(UnitSystem.imperial)
//        }
//        .pickerStyle(SegmentedPickerStyle())
//        .frame(width: 100, height: 40)
//    }
//}


struct UnitSystemSelectionView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        Picker("Unit System", selection: $settings.unitSystem) {
            Text("cm").tag(UnitSystem.cm)
            Text("mm").tag(UnitSystem.mm)
            Text("inch").tag(UnitSystem.imperial)
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(width: 130, height: 40)
        .onChange(of: settings.unitSystem) { oldValue, newValue in
          
            unitSystemChanged(newValue)
        }
    }

    func unitSystemChanged(_ newUnitSystem: UnitSystem) {
        settings.setUnitSystem(newUnitSystem)
    }
}
