//
//  ObjectPickerOptionsView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/05/2023.
//

import SwiftUI












struct ConditionaUniPartPresence: View {
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    var part: Part {
        objectEditVM.getPartToEdit()
    }
    
    var body: some View {
        if objectShowMenuVM.getOneIsEditable(part) {
            UniPartPresence(part)
        } else {
            EmptyView()
        }
    }
}











































struct ConditionalUniPartEditMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    
    var body: some View {
        let partToEdit = objectEditVM.getPartToEdit()
        let showmMenu = objectShowMenuVM.getDoesPartHaveDimensionalPropertyMenu(partToEdit)
        if showmMenu  {
            HStack{
                
                UniPartEdit(partToEdit)
            }
           
        } else {
            EmptyView()
        }
    }
}
struct UniPartEdit: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
   @State private var propertyToEdit: PartTag = .length
    var relevantCases: [PartTag] {
        objectShowMenuVM.getPropertyMenuForDimensionEdit(part)
    }
    let part: Part

    init(
        _ part: Part) {
        self.part = part
    }
    
    var body: some View {
        ZStack{
            HStack {
                Spacer()
                Picker("dimension", selection: $propertyToEdit) {
                    ForEach(relevantCases, id: \.self) { side in
                        Text(side.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .fixedSize()
                .onChange(of: propertyToEdit) { oldSelection, newSelection in
                    objectEditVM.setDimensionPropertyToBeEdited(newSelection)
                }
                
                UniDimensionMenu(part, propertyToEdit)
            }
        }
    }
}
struct UniDimensionMenu: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel

   
    var propertyToEdit: PartTag
    var minMaxValue : (min: Double, max: Double){
        objectPickVM.geMinMax(part, propertyToEdit, "OnePartTwoDimensionValueMenu")
    }
    let part: Part
  
    
    init(
        _ part: Part,
        _ property: PartTag) {
        self.part = part
        propertyToEdit = property
    }
    var body: some View {

        let boundSliderValue = Binding(
            get: {
                objectPickVM.getInitialSliderValue (
                    part, propertyToEdit)
            },
            set: { newValue in
                objectEditVM
                    .setDimensionPropertyValueForOnePartInUserEditedDic(
                        newValue,
                        part)
                
                objectPickVM.modifyObjectByCreatingFromName()
           
                }   
        )

            HStack {
                Slider(value: boundSliderValue,
                       in: minMaxValue.min...minMaxValue.max,
                       step: 10.0)
                
                MeasurementView(
                    Measurement(value: boundSliderValue.wrappedValue,
                        unit: .millimeters))
                .padding(.horizontal)
                }
    }
}
struct UniPartPresence: View {
    @State private var optionToggle = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
   
    let part: Part
    var pair : [Part] {
        PartSwapLabel(part).pair    }
    var swappedPair: [Part] {
        PartSwapLabel(part).swappedPair
    }
    
    init (_ part: Part) {
        self.part = part
    }
    
    var body: some View {
            Toggle(part.rawValue, isOn: $optionToggle)
                .onChange(of: optionToggle) { oldValue, newValue in
                    if !newValue {
                        objectEditVM.replaceChainLabelForObject(
                            pair
                        )
                    } else {
                        objectEditVM.replaceChainLabelForObject(
                          swappedPair
                        )
                    }
                    objectPickVM.modifyObjectByCreatingFromName()
                }
                .padding(.horizontal)
    }
}




struct TiltEdit: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objecShowMenuVM: ObjectShowMenuViewModel

    let description: String
    let joint:  Part
  
    init(_ joint: Part){
        self.joint = joint
        description = joint.rawValue
        
    }
 
    var body: some View {
        
        let angleMinMax =
            objectPickVM.getAngleMinMaxDic(joint)
        let max = angleMinMax.max.value
        let min = angleMinMax.min.value
        let boundSliderValue = Binding(
            get: {
                max -
                objectPickVM.getInitialSliderValue (
                    joint, .angle)
            },
            set: { newValue in
                objectEditVM.setCurrentRotation(
                   max - newValue
                )
                
                objectPickVM.modifyObjectByCreatingFromName()
                }
            )
    
            ZStack{
                HStack{
                    Text(description)
                    
                    Slider(value: boundSliderValue, in: min...max, step: 1.0)

                    Text(" deg: \( Int(max - boundSliderValue.wrappedValue))")
                        
                }
                .padding()
            }
    }
}