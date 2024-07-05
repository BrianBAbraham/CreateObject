//
//  DimensionPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/07/2024.
//

import SwiftUI

struct DimensionPickerView: View {
    @EnvironmentObject var dimensionPickerVM: DimensionPickerViewModel

    var body: some View {
        
        let propertiesToEdit = Binding(
            get: {dimensionPickerVM.dimensionPropertyToEdit},
            set: {dimensionPickerVM.setDimensionPropertyToEdit($0)}
        )

            Picker("dimension", selection: propertiesToEdit) {
                ForEach(dimensionPickerVM.editableDimension, id: \.self) { side in
                    Text(side.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .colorScheme(.light)
            .disabled(dimensionPickerVM.doNotShow)
    }
}



