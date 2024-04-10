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



struct UnitSystemSelectionView: View {
    @EnvironmentObject var unitSystemVM: UnitSystemViewModel
    @EnvironmentObject var rulerVM: RulerViewModel
    @State private var selectMenuNameItem: String = "cm"

    var body: some View {
        Picker("Unit System", selection: $unitSystemVM.unitSystem) {
            Text("cm").tag(UnitSystem.cm)
            Text("mm").tag(UnitSystem.mm)
            Text("inch").tag(UnitSystem.imperial)
        }
        .pickerStyle(.segmented)
        .onChange(of: unitSystemVM.unitSystem) { oldValue, newValue in
          
            unitSystemChanged(newValue)
            selectMenuNameItem = newValue.rawValue
        }
        .padding(.horizontal)

    }

    func unitSystemChanged(_ newUnitSystem: UnitSystem) {
        unitSystemVM.setUnitSystem(newUnitSystem)
        rulerVM.updateDependentProperties()
    }
}
