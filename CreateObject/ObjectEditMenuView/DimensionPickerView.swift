//
//  DimensionPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/07/2024.
//

import SwiftUI

struct DimensionPickerView: View {
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectDataGetterVM: ObjectDataGetterViewModel
    
    var partOrLinkedPartForShow: Part {
        PartsRequiringLinkedPartUse(part).partForEditableOrigin
    }
    let part: Part

    
    init(
        _ part: Part) {
        self.part = part
    }
    
    var body: some View {
     
        let notPresent =
        objectDataGetterVM.getPartNotPresent(partOrLinkedPartForShow)
        
        let editableDimension: [PartTag] =
            objectShowMenuVM.getPropertiesForDimensionPicker(part)
     
        let propertiesToEdit = Binding(
            get: {objectEditVM.dimensionPropertyToEdit},
            set: {objectEditVM.setDimensionPropertyToEdit($0)}
        )
        
        ZStack{
            HStack {
                Picker("dimension", selection: propertiesToEdit) {
                    ForEach(editableDimension, id: \.self) { side in
                        Text(side.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .colorScheme(.light)
                .onChange(of: objectEditVM.partToEdit) {
                   //always make the first dimension the intialy active choice
                    if let firstDimension = editableDimension.first {
                        objectEditVM.setDimensionPropertyToEdit(
                            firstDimension
                        )
                    }
                }
                .disabled(notPresent)
      
            
                DimensionStepperView(
                    part, propertiesToEdit.wrappedValue)
            }
        }
    }
}
