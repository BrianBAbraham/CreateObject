//
//  File.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/02/2024.
//

import Foundation
import SwiftUI


//struct MeasurementView: View {
//    @EnvironmentObject var settings: UnitSystemViewModel
//    var measurement: Measurement<UnitLength>
//    
//    init(_ measurement: Measurement<UnitLength>) {
//        self.measurement = measurement
//    }
//
//    var body: some View {
//        Text(
//            String(settings.unitSystem.formatLengthAsString(measurement)))
//    }
//}



struct MeasurementUnitView: View {
    @EnvironmentObject var settings: UnitSystemViewModel
   
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
    @EnvironmentObject var unitSystemVM: UnitSystemViewModel
    @EnvironmentObject var rulerVM: RulerViewModel

    var body: some View {
        Picker("Unit System", selection: $unitSystemVM.unitSystem) {
            Text("cm").tag(UnitSystem.cm)
            Text("mm").tag(UnitSystem.mm)
            Text("inch").tag(UnitSystem.imperial)
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(width: 130, height: 40)
        .onChange(of: unitSystemVM.unitSystem) { oldValue, newValue in
          
            unitSystemChanged(newValue)
        }
    }

    func unitSystemChanged(_ newUnitSystem: UnitSystem) {
        unitSystemVM.setUnitSystem(newUnitSystem)
        rulerVM.updateDependentProperties()
    }
}
