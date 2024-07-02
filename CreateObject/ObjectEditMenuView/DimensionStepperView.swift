//
//  DimensionStepperView.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/07/2024.
//

import SwiftUI



struct DimensionStepperView: View {
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectDataGetterVM: ObjectDataGetterViewModel

    let part: Part
    var partOrLinkedPartForDimension: Part {
        PartsRequiringLinkedPartUse(part).partForDimensionEdit
    }
    var partOrLinkedPartForShow: Part {
        PartsRequiringLinkedPartUse(part).partForEditableOrigin
    }
    let propertyToEdit: PartTag
    

    init (
        _ part: Part, _ propertyToEdit: PartTag) {
            self.part = part
            self.propertyToEdit = propertyToEdit
        }
 
    var body: some View {
        let sidesPresent =
        objectDataGetterVM.getSidesPresentGivenPossibleUserEdit(partOrLinkedPartForShow)[0]
        let boundStepperValue =
            Binding(
                get: {
                    objectDataGetterVM.getInitialSliderValue(
                            partOrLinkedPartForDimension, propertyToEdit)
                }
                ,
                set: {
                    newValue in
                        objectEditVM
                            .setValueForBilateralPartInUserEditedDic(
                                newValue,
                                partOrLinkedPartForDimension,
                                propertyToEdit
                                )
                        objectPickVM.modifyObjectByCreatingFromName()
                                } )

                Stepper("", value: boundStepperValue, step: 10.0)
                .colorScheme(.light)
                .fixedSize()
            .disabled(sidesPresent == .none)
    }
}

