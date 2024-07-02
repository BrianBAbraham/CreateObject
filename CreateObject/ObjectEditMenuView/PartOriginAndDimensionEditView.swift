//
//  PartOriginAndDimensionEditView.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/03/2024.
//

import SwiftUI


struct PartOriginAndDimensionEditView: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    
    var body: some View {
        let part = objectEditVM.getPartToEdit()
        if objectShowMenuVM.getBilateralPartMenuStatus(part)  {
            //PartMenu(partToEdit)
            VStack {
                DimensionPickerView(
                    part)
                    
                OriginPickerAndStepperView(
                    part)
            }
        } else {
            EmptyView()
        }
    }
}












