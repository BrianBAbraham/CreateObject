//
//  BilateralPartEdit.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/03/2024.
//

import SwiftUI


struct ConditionalBilateralPartMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    
    var body: some View {
        let partToEdit = objectEditVM.getPartToEdit()
        if objectShowMenuVM.getBilateralPartMenuStatus(partToEdit)  {
            BilateralPartMenu(partToEdit)
        } else {
            EmptyView()
        }
    }
}



struct BilateralPartMenu: View {
    let part: Part
    
    init (_ part: Part) {
        self.part = part
    }
        
    var body: some View {
        ZStack{
            VStack {
                BilateralDimensionMenu(
                    part)
                    
                BilateralOriginMenu(
                    part)
            }
        }
    }
}
 

struct BilateralDimensionMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @State private var propertyToEdit: PartTag = .length
    
    let part: Part
    var editableDimension: [PartTag] {
        objectShowMenuVM.getPropertiesForDimensionMenu(part)
    }
    
    init(
        _ part: Part) {
        self.part = part
    }
    
    var body: some View {
        ZStack{
            HStack {
                Picker("dimension", selection: $propertyToEdit) {
                    ForEach(editableDimension, id: \.self) { side in
                        Text(side.rawValue)
                    }
                }
                .pickerStyle(.segmented)
      
                .onChange(of: propertyToEdit) { oldSelection, newSelection in
                    objectEditVM.setPropertyToEdit(newSelection)
                }
                
                BilateralDimensionStepper(
                    part, propertyToEdit)
            }
        }
    }
}


struct BilateralDimensionSlider: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
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
        
        let minMaxValue =  objectPickVM.geMinMax(partOrLinkedPartForDimension, propertyToEdit, "SliderForOneDimensionPropertyForBilateralPart")
        let boundSliderValue =
            Binding(
                get: {
                        objectPickVM.getInitialSliderValue(
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


struct BilateralDimensionStepper: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @State private var xStepperValue = 0.0
    @State private var yStepperValue = 0.0
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
            objectPickVM.getSidesPresentGivenPossibleUserEdit(partOrLinkedPartForShow, "bilateral edit")[0]
        let boundStepperValue =
            Binding(
                get: {
                        objectPickVM.getInitialSliderValue(
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
                    if propertyToEdit == .length {
                        yStepperValue += newValue
                    } else {
                        xStepperValue += newValue
                    }
                        objectPickVM.modifyObjectByCreatingFromName()
                                } )

                Stepper("", value: boundStepperValue, step: 10.0)
                .fixedSize()
            .disabled(sidesPresent == .none)
    }
}


struct BilateralOriginMenu: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @State private var propertyToEdit: PartTag = .xOrigin
    @State private var xStepperValue = 0.0
    @State private var yStepperValue = 0.0
    let part: Part
    var partOrLinkedPartForOrigin: Part {
        PartsRequiringLinkedPartUse(part).partForOriginEdit
    }
    var partOrLinkedPartForShow: Part {
        PartsRequiringLinkedPartUse(part).partForEditableOrigin
    }
    var editableOrigin: [PartTag] {// both or one of x y
        objectShowMenuVM.getScopeForOriginMenu(part)
    }
       
        
    init (
        _ part: Part) {
            self.part = part
        }
 
    var body: some View {
        let sidesPresent =
            objectPickVM.getSidesPresentGivenPossibleUserEdit(partOrLinkedPartForShow, "bilateral edit")[0]
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
                                propertyToEdit
                                )
                    if propertyToEdit == .xOrigin {
                        xStepperValue += newValue
                    } else {
                        yStepperValue += newValue
                    }
                        objectPickVM.modifyObjectByCreatingFromName()
                                } )
        HStack{
                Picker("", selection: $propertyToEdit) {
                    ForEach(editableOrigin, id: \.self) { side in
                        Text(side.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                //.fixedSize()
                
                .onChange(of: propertyToEdit) { oldSelection, newSelection in
                    objectEditVM.setPropertyToEdit(newSelection)
                }
                Stepper("", value: boundStepperValue, step: 10.0)
                .fixedSize()
            }
            .disabled(sidesPresent == .none)
    }
}


















