//
//  DimensionPickerAndStepperView.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/07/2024.
//

import SwiftUI

struct DimensionPickerAndStepperView: View {
    var body: some View {
        ZStack{
            HStack {
                DimensionPickerView()

                DimensionStepperView()
            }
        }
    }
}
