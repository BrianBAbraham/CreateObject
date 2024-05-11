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
        if objectShowMenuVM.getUniPresenceMenuStatus(part) {
            UniPartPresence(part)
        } else {
            EmptyView()
        }
    }
}
//struct ConditionalUniPartEditMenu: View {
//    @EnvironmentObject var objectEditVM: ObjectEditViewModel
//    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
//    
//    var body: some View {
//        let partToEdit = objectEditVM.getPartToEdit()
//        let showmMenu = objectShowMenuVM.getUniEditMenuStatus(partToEdit)
//        if showmMenu  {
//            HStack{
//                
//                UniDimensionPicker(partToEdit)
//            }
//           
//        } else {
//            EmptyView()
//        }
//    }
//}
//struct UniDimensionPicker: View {
//    @EnvironmentObject var objectEditVM: ObjectEditViewModel
//    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
//   @State private var propertyToEdit: PartTag = .length
//    var relevantCases: [PartTag] {
//        objectShowMenuVM.getPropertiesForDimensionPicker(part)
//    }
//    let part: Part
//
//    init(
//        _ part: Part) {
//        self.part = part
//    }
//    
//    var body: some View {
//        ZStack{
//            HStack {
//                Spacer()
//                Picker("dimension", selection: $propertyToEdit) {
//                    ForEach(relevantCases, id: \.self) { side in
//                        Text(side.rawValue)
//                    }
//                }
//                .pickerStyle(.segmented)
//                .fixedSize()
//                .onChange(of: propertyToEdit) { oldSelection, newSelection in
//                    objectEditVM.setPropertyToEdit(newSelection)
//                }
//                
//                UniDimensionSlider(part, propertyToEdit)
//            }
//        }
//    }
//}
struct UniDimensionSlider: View {
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
                Slider(value: boundSliderValue,
                       in: minMaxValue.min...minMaxValue.max,
                       step: 10.0)
    }
}
//struct UniPartEditX: View {
//    @EnvironmentObject var objectEditVM: ObjectEditViewModel
//    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
//   @State private var propertyToEdit: PartTag = .length
//    var relevantCases: [PartTag] {
//        objectShowMenuVM.getPropertiesForDimensionPicker(part)
//    }
//    let part: Part
//
//    init(
//        _ part: Part) {
//        self.part = part
//    }
//    
//    var body: some View {
//        ZStack{
//            HStack {
//                Spacer()
//                Picker("dimension", selection: $propertyToEdit) {
//                    ForEach(relevantCases, id: \.self) { side in
//                        Text(side.rawValue)
//                    }
//                }
//                .pickerStyle(.segmented)
//                .fixedSize()
//                .onChange(of: propertyToEdit) { oldSelection, newSelection in
//                    objectEditVM.setPropertyToEdit(newSelection)
//                }
//                
//                UniDimensionSliderX(part, propertyToEdit)
//            }
//        }
//    }
//}

struct UniDimensionSliderX: View {
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

//            HStack {
                Slider(value: boundSliderValue,
                       in: minMaxValue.min...minMaxValue.max,
                       step: 10.0)
                
//                MeasurementView(
//                    Measurement(value: boundSliderValue.wrappedValue,
//                        unit: .millimeters))
//                .padding(.horizontal)
//                }
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
                .colorScheme(.light)
              //  .padding([.horizontal, .top])
    }
}



struct ConditionalTiltMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objecPickVM: ObjectPickViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    
    var body: some View {
        let selectedPartToEdit = objectEditVM.getPartToEdit()
        if let tiltPart = objectShowMenuVM.getTiltMenuPart(selectedPartToEdit)  {
            TiltEdit(tiltPart)
        } else {
            EmptyView()
        }
    }
}
struct TiltEdit: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objecShowMenuVM: ObjectShowMenuViewModel

    let description: String = "tilt"
    let joint:  Part
  
  
    init(_ joint: Part){
        self.joint = joint
        
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
                   max - newValue,
                   joint
                )
                
                objectPickVM.modifyObjectByCreatingFromName()
                }
            )
    
            ZStack{
                HStack{
                    Text(description)
                        .colorScheme(.light)
                    
                    Slider(value: boundSliderValue, in: min...max, step: 1.0)

                    Text(" deg: \( Int(max - boundSliderValue.wrappedValue))")
                        .colorScheme(.light)
                        
                }
               // .padding()
            }
    }
}
