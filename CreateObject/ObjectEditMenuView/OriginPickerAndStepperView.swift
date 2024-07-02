//
//  OriginPickerAndStepperView.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/07/2024.
//

import SwiftUI

struct OriginPickerAndStepperView: View {
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectDataGetterVM: ObjectDataGetterViewModel
    let part: Part
    var partOrLinkedPartForOrigin: Part {
        PartsRequiringLinkedPartUse(part).partForOriginEdit
    }
    var partOrLinkedPartForShow: Part {
        PartsRequiringLinkedPartUse(part).partForEditableOrigin
    }
   
       
    init (
        _ part: Part) {
            self.part = part
        }
 
    var body: some View {
        let editableOrigin: [PartTag] =// both or one of x y
            objectShowMenuVM.getPropertiesForOriginPicker(part)
        
        
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
            HStack{
                    Picker("", selection: propertiesToEdit) {
                        ForEach(editableOrigin, id: \.self) { property in
                            Text(property.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .colorScheme(.light)
                    .onChange(of: objectEditVM.partToEdit) {
                       //always make the first origin the intial active choice
                        if let firstOrigin = editableOrigin.first {
                            objectEditVM.setOriginPropertiesToEdit(
                                firstOrigin
                            )
                        }
                    }
                
                    Stepper("", value: boundStepperValue, step: 10.0)
                    .colorScheme(.light)
                    .fixedSize()
                }
                .disabled(notPresent)
        } else {
            EmptyView()
        }
        
    }
}
