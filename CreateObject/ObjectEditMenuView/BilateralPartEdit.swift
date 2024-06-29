//
//  BilateralPartEdit.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/03/2024.
//

import SwiftUI


struct ConditionalPartMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    
    var body: some View {
        let partToEdit = objectEditVM.getPartToEdit()
        if objectShowMenuVM.getBilateralPartMenuStatus(partToEdit)  {
            PartMenu(partToEdit)
        } else {
            EmptyView()
        }
    }
}



struct PartMenu: View {
    let part: Part
    
    init (_ part: Part) {
        self.part = part
    }
        
    var body: some View {
        ZStack{
            VStack {
                DimensionPicker(
                    part)
                    
                OriginPicker(
                    part)
            }
        }
    }
}
 

struct DimensionPicker: View {
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
      
            
                DimensionStepper(
                    part, propertiesToEdit.wrappedValue)
            }
        }
    }
}




struct DimensionStepper: View {
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


struct OriginPicker: View {
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





struct OriginPickerX: View {
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectDataGetterVM: ObjectDataGetterViewModel
    
    @State private var propertyToEdit: PartTag = .xOrigin

    let part: Part
    var partOrLinkedPartForOrigin: Part {
        PartsRequiringLinkedPartUse(part).partForOriginEdit
    }
    var partOrLinkedPartForShow: Part {
        PartsRequiringLinkedPartUse(part).partForEditableOrigin
    }
    var editableOrigin: [PartTag] {// both or one of x y
        objectShowMenuVM.getPropertiesForOriginPicker(part)
    }
       
        
    init (
        _ part: Part) {
            self.part = part
        }
 
    var body: some View {
        
        if editableOrigin != [] {
            let sidesPresent =
            objectDataGetterVM.getSidesPresentGivenPossibleUserEdit(partOrLinkedPartForShow)[0]
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
                            objectPickVM.modifyObjectByCreatingFromName()
                                    } )
            HStack{
                    Picker("", selection: $propertyToEdit) {
                        ForEach(editableOrigin, id: \.self) { side in
                            Text(side.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    .onChange(of: propertyToEdit) { oldSelection, newSelection in
                        objectEditVM.setOriginPropertiesToEdit(newSelection)
                    }
                
                    Stepper("", value: boundStepperValue, step: 10.0)
                    .fixedSize()
                }
                .disabled(sidesPresent == .none)
        } else {
            EmptyView()
        }
        
    }
}






struct BilateralDimensionSlider: View {
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






