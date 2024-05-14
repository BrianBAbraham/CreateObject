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
            }
    }
}
