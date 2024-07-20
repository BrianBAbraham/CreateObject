//
//  ObjectPickerOptionsView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/05/2023.
//

import SwiftUI

struct PropertyAngleEditView: View {
    @EnvironmentObject var propertyAngleVM: PropertyAngleViewModel
    var body: some View {
        ZStack{
            HStack{
                Text("angle")
                    .colorScheme(.light)

                Slider(value: propertyAngleVM.sliderValueBinding, in: propertyAngleVM.min...propertyAngleVM.max, step: 1.0)

                Text(" deg: \( Int(propertyAngleVM.max - propertyAngleVM.sliderValueBinding.wrappedValue))")
                    .colorScheme(.light)

            }
        }
        .opacity(propertyAngleVM.showMenu ? 1 : 0)
    }
}
