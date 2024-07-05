//
//  PartOriginAndDimensionEditView.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/03/2024.
//

import SwiftUI


struct PartOriginAndDimensionEditView: View {
    @EnvironmentObject var partOriginAndDimensionEditViewModel: PartOriginAndDimensionEditViewModel
    
    var body: some View {
        let part = partOriginAndDimensionEditViewModel.partToEdit
            VStack {
//                DimensionPickerView(
//                   )
                DimensionPickerAndStepperView()
                    
                OriginPickerAndStepperView(
                    part)
            }
    }
}












