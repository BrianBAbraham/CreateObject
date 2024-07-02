//
//  Retired.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/07/2024.
//

import SwiftUI

struct RetiredBilateralDimensionSlider: View {
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectDataGetterVM: ObjectDataGetterViewModel
    let part: Part
    var partOrLinkedPartForDimension: Part {
        PartsRequiringLinkedPartUse(part).partForDimensionEdit
    }
    let propertyToEdit: PartTag
    

    init (
        _ part: Part, _ propertyToEdit: PartTag) {
            self.part = part
            self.propertyToEdit = propertyToEdit
        }
 
    var body: some View {
        
        let minMaxValue =  objectDataGetterVM.geMinMax(partOrLinkedPartForDimension, propertyToEdit)
        let boundSliderValue =
            Binding(
                get: {
                        objectDataGetterVM.getInitialSliderValue(
                            partOrLinkedPartForDimension, propertyToEdit) },
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
                Slider(value: boundSliderValue ,
                       in: minMaxValue.min...minMaxValue.max,
                       step: 10.0)
    }
}

