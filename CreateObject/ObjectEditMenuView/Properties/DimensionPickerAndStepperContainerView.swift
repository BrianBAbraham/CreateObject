//
//  DimensionPickerAndStepperView.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/07/2024.
//

import SwiftUI

struct DimensionPickerAndStepperContainerView: View {
    var body: some View {
        ZStack{
            HStack {
                DimensionPickerView()

                DimensionStepperView()
            }
        }
    }
}
