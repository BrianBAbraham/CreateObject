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
        Picker("dimension", selection: //dimensionPickerVM.dimensionPropertyBinding
        propertiesToEdit
        ) {
                ForEach(dimensionPickerVM.editableDimension, id: \.self) { side in
                    Text(side.rawValue)
                }
            }
           .pickerStyle(.segmented)
            .colorScheme(.light)
            .disabled(dimensionPickerVM.doNotShow)
    }
}



struct OriginStepperView: View {
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectDataGetterVM: ObjectDataGetterViewModel
    @EnvironmentObject var originPickerVM: OriginPickerViewModel
//    let part: Part
    var partOrLinkedPartForOrigin: Part {
        PartsRequiringLinkedPartUse(originPickerVM.partToEdit).partForOriginEdit
    }
    var partOrLinkedPartForShow: Part {
        PartsRequiringLinkedPartUse(originPickerVM.partToEdit).partForEditableOrigin
    }
   
       
//    init (
//        _ part: Part) {
//            self.part = part
//        }
// 
    var body: some View {
        let editableOrigin: [PartTag] =// both or one of x y
            objectShowMenuVM.getPropertiesForOriginPicker(originPickerVM.partToEdit)
        
        
        if editableOrigin != [] {
            let notPresent =
            objectDataGetterVM.getPartNotPresent(partOrLinkedPartForShow)
            
            let propertiesToEdit = Binding(
                get: {objectEditVM.originPropertiesToEdit},
                set: {objectEditVM.setOriginPropertiesToEdit($0)}
            )
            
            let boundStepperValue =
                Binding(
                    get: {
                        0.0},
                    set: {
                        newValue in
                            objectEditVM
                                .setValueForBilateralPartInUserEditedDic(
                                    newValue,
                                    partOrLinkedPartForOrigin,
                                    propertiesToEdit.wrappedValue
                                    )
                            objectPickVM.modifyObjectByCreatingFromName()
                                    } )
          
                    Stepper("", value: boundStepperValue, step: 10.0)
                    .colorScheme(.light)
                    .fixedSize()
                    .disabled(originPickerVM.doNotShow)
        } else {
            EmptyView()
        }
        
    }
}
