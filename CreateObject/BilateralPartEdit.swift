//
//  BilateralPartEdit.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/03/2024.
//

import SwiftUI









struct ConditionalBilateralPartEditMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    
    var body: some View {
        let partToEdit = objectEditVM.getPartToEdit()
        if objectShowMenuVM.getBilateralPartMenuStatus(partToEdit)  {
            BilateralPartEdit(partToEdit)
        } else {
            EmptyView()
        }
    }
}



struct BilateralPartEdit: View {
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    let part: Part
    var origins: [PartTag] {
        objectShowMenuVM.getEditableOrigin(part) }
    let dimensionProperty: [PartTag] = [.width, .length]
    let partOrLinkedPartForDimension: Part
    let partOrLinkedPartForOrigin: Part

    
    init (_ part: Part) {
        self.part = part

        //print("\n BilateralPartEdit \(part.rawValue)\n")
        
        let partsRequiringLinkedPartUse =
                    PartsRequiringLinkedPartUse(part)
        partOrLinkedPartForDimension = partsRequiringLinkedPartUse.partForDimension
        partOrLinkedPartForOrigin = partsRequiringLinkedPartUse.partForOrigin

    }
        
    var body: some View {
        ZStack{
                VStack {
                        BilateralDimensionMenu(
                            part, partOrLinkedPartForDimension)
                            
                        BilateralOriginMenu(part)
                }
        }
    }
}
 


struct BilateralDimensionMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @State private var propertyToEdit: PartTag = .length
    var relevantCases: [PartTag] {
        objectShowMenuVM.getPropertiesForDimensionMenu(part)
    }
    let part: Part
    let partOrLinkedPart: Part

    init(
        _ part: Part, _ partOrLinkedPart: Part) {
        self.part = part
        self.partOrLinkedPart = partOrLinkedPart
    }
    
    var body: some View {
        ZStack{
            HStack {
                Text("size")
                Picker("dimension", selection: $propertyToEdit) {
                    ForEach(relevantCases, id: \.self) { side in
                        Text(side.rawValue)
                    }
                }
              
                .pickerStyle(.segmented)
                .fixedSize()
                .onChange(of: propertyToEdit) { oldSelection, newSelection in
                    objectEditVM.setPropertyToEdit(newSelection)
                }
                
                BilateralDimensionSlider(
                    partOrLinkedPart, propertyToEdit)
            }
        }
    }
}




struct BilateralDimensionSlider: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel

    let part: Part
    let propertyToEdit: PartTag
    

    init (
        _ part: Part, _ propertyToEdit: PartTag) {
            self.part = part
            self.propertyToEdit = propertyToEdit
        }
 
    var body: some View {
        
        let minMaxValue =  objectPickVM.geMinMax(part, propertyToEdit, "SliderForOneDimensionPropertyForBilateralPart")
        let boundSliderValue =
            Binding(
                get: {
                        objectPickVM.getInitialSliderValue(
                            part, propertyToEdit) },
                set: {
                    newValue in
                        objectEditVM
                            .setValueForBilateralPartInUserEditedDic(
                                newValue,
                                part,
                               propertyToEdit
                            )

                        objectPickVM.modifyObjectByCreatingFromName()
                                } )
       // HStack{
                Slider(value: boundSliderValue ,
                       in: minMaxValue.min...minMaxValue.max,
                       step: 10.0)

//            MeasurementView(
//                Measurement(value: boundSliderValue.wrappedValue,
//                    unit: .millimeters))
//            }
//            .disabled(objectEditVM.scopeOfEditForSide == .none)
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
    var relevantOrigin: [PartTag] {// both or one of x y
        objectShowMenuVM.getScopeForOriginMenu(part)
    }
  
    init (
        _ part: Part) {
            self.part = part
           // print("\n BilateralOriginMenu \(part.rawValue)\n")
            
        }
 
    var body: some View {
        let sidesPresent =
            objectPickVM.getSidesPresentGivenPossibleUserEdit(part, "bilateral edit")[0]
        let boundStepperValue =
            Binding(
                get: {
                    0.0},
                set: {
                    newValue in
                        objectEditVM
                            .setValueForBilateralPartInUserEditedDic(
                                newValue,
                                part,
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
                Text("origin")
                Picker("", selection: $propertyToEdit) {
                    ForEach(relevantOrigin, id: \.self) { side in
                        Text(side.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .fixedSize()
                
                .onChange(of: propertyToEdit) { oldSelection, newSelection in
                    objectEditVM.setPropertyToEdit(newSelection)
                }
                Stepper("", value: boundStepperValue, step: 10.0)
                .fixedSize()
            }
            .disabled(sidesPresent == .none)
    }
}


















