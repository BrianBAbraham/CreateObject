//
//  ObjectPickerOptionsView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/05/2023.
//

import SwiftUI




struct BilateralPartEditView: View {
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
        //print(part)
        let partsRequiringLinkedPartUse =
                    PartsRequiringLinkedPartUse(part)
        
       
        partOrLinkedPartForDimension = partsRequiringLinkedPartUse.partForDimension
        partOrLinkedPartForOrigin = partsRequiringLinkedPartUse.partForOrigin
//        print(partOrLinkedPartForOrigin)
//        print("")
    }
        
    
    var body: some View {
        ZStack{
            VStack{
                HStack {
                    if objectShowMenuVM.getBilateralityIsEditable(part) {
                        BiLateralPartSidePicker()
                    } else {
                        EmptyView()
                    }
                    
                    
//                    if objectShowMenuVM.getBilateralityIsEditable(part) {
//                        BilateralPartPresence(part)
//                    } else {
//                        EmptyView()
//                    }
                    
                }
                    
                    VStack {
                        HStack {
                            DimensionPropertyPickerMenu(part)
                            
                            SliderForOneDimensionPropertyForBilateralPart(
                                partOrLinkedPartForDimension)
//                            ForEach(dimensionProperty, id: \.self) { property in
//                          SliderDimensionForBilateralPartWithOneValueToChange(
//                                    partOrLinkedPartForDimension,
//                                    property)
//                            }
                        }
                                
                        HStack {
                            ForEach(origins, id: \.self) { origin in
                                StepperOriginForBilateralPartWithOneValueToChange(
                                    partOrLinkedPartForOrigin,
                                    origin)
                            }
                        }
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
}

struct ConditionalBilateralPartPresence: View {
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    var part: Part {
        objectEditVM.getChoiceOfPartToEdit()
    }
    
    var body: some View {
        if objectShowMenuVM.getBilateralityIsEditable(part) {
            BilateralPartPresence(part)
        } else {
            EmptyView()
        }
    }
}



struct ConditionalOnePartPresence: View {
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    var part: Part {
        objectEditVM.getChoiceOfPartToEdit()
    }
    
    var body: some View {
        if objectShowMenuVM.getOneIsEditable(part) {
            SinglePartPresence(part)
        } else {
            EmptyView()
        }
    }
}



struct DimensionPropertyPickerMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
   @State private var propertyToBeEdited: PartTag = .length
    var relevantCases: [PartTag] {
        objectShowMenuVM.getPropertyMenuForDimensionEdit(part)
    }
    let part: Part
    var description: String {
        part.rawValue
    }
    
    init(
        _ part: Part) {
        self.part = part
    }
    
    
    var body: some View {
       
        ZStack{
            HStack {
                Spacer()
                Picker("dimension", selection: $propertyToBeEdited) {
                    ForEach(relevantCases, id: \.self) { side in
                        Text(side.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .fixedSize()
                .onChange(of: propertyToBeEdited) { oldSelection, newSelection in
                    objectEditVM.setDimensionPropertyToBeEdited(newSelection)
                }
            }
        }
    }
}




//struct SideSelection: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @State private var selection: Side = .both
//    let twoSidedPart: Part
//    let options = Side.options
//
//    var body: some View {
//        let boundEquipmentType = Binding(
//            get: {objectPickVM.getCurrentSidesForPart(twoSidedPart)},
//            set: {self.selection = $0}
//        )
//
//
//        Picker("side",selection: boundEquipmentType ) {
//            ForEach(Side.allCases, id:  \.self)
//                    { selection in
//                        Text(selection.rawValue)
//            }
//            .onChange(of: selection) { newSelection in
//
//                print (newSelection)}
//        }.pickerStyle(.segmented)
//    }
//
//}



//struct DimensionSelection: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @EnvironmentObject var objectEditVM: ObjectEditViewModel
//    @State private var selection: PartTag = .length
//    var relevantCases: [PartTag] = [.length, .width]
//
//    var body: some View {
//        Picker("dimension", selection: $selection) {
//            ForEach(relevantCases, id: \.self) { side in
//                Text(side.rawValue)
//            }
//        }
//        .pickerStyle(.segmented)
//        //.disabled(relevantCases == [.none])
//        .fixedSize()
//        .onChange(of: selection) { newSelection in
//            objectEditVM.updateDimensionToBeEdited(newSelection)
//
//        }
//    }
//}


struct GreenWithOpacity: ViewModifier {
    var opacity: Double
    
    init(opacity: Double = 0.1) {
        self.opacity = opacity
    }
    
    func body(content: Content) -> some View {
        content.background(Color.green.opacity(opacity))
    }
}

extension View {
    func backgroundModifier() -> some View {
        self.modifier(GreenWithOpacity())
    }
}




///Bilateral





struct BilateralPartPresence: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    let part: Part
    
    init (_ part: Part) {
        self.part = part
    }
    
    var body: some View {
        let boundIsLeftSelected = Binding (
            get: {objectPickVM.getSidesPresentGivenUserEditContainsLeft(part)},
            set: {newvalue in updateViewModelForLeftToggle(newvalue)
            }
         )
        
        let boundIsRightSelected = Binding (
           get: {objectPickVM.getSidesPresentGivenUserEditContainsRight(part)},
           set: {newvalue in updateViewModelForLRightToggle(newvalue)

           }
        )
        
        HStack {
            Toggle("", isOn: boundIsLeftSelected)

            Text("L")
         
            Toggle("", isOn: boundIsRightSelected)

            Text("R")
        }
    }
    

    private func updateViewModelForLeftToggle(_  left: Bool) {
        objectEditVM
            .changeOneOrTwoStatusOfPart(
                left,
                objectPickVM.getSidesPresentGivenUserEditContainsRight(part),
                part)
        objectPickVM.modifyObjectByCreatingFromName()
    }
    
    
    private func updateViewModelForLRightToggle(_  right: Bool) {
        objectEditVM
            .changeOneOrTwoStatusOfPart(
                objectPickVM.getSidesPresentGivenUserEditContainsLeft(part),
                right,
                part)
        objectPickVM.modifyObjectByCreatingFromName()
    }
}


enum SidesAffected: String, CaseIterable, Equatable {
    case both = "L & R"
    case left = "L"
    case right = "R"
    case none = "none"
    
}

struct BiLateralPartSidePicker: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
   
    var body: some View {
        var allCurrentOptionsForSidesAffected: [SidesAffected]{
            objectEditVM.getScopeOfEditForSide()
        }
        let boundSideValue = Binding(
                    get: {
                            objectEditVM.getChoiceOfEditForSide()},
                    set: {
                            newValue in
                               objectEditVM.setBothOrLeftOrRightAsEditibleChoice(newValue)
                                    } )
        HStack {
           // Text("select")
            
            Picker("", selection: boundSideValue
            ) {
                ForEach(allCurrentOptionsForSidesAffected, id: \.self) { side in
                    Text(side.rawValue)
                }
            }
            .onChange(of: boundSideValue.wrappedValue) { newSelection in
                objectEditVM.setBothOrLeftOrRightAsEditibleChoice( newSelection)
                }
            .pickerStyle(.segmented)
        }

    }
} 


struct SliderForOneDimensionPropertyForBilateralPart: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
//    var minMaxValue : (min: Double, max: Double){
//        objectPickVM.geMinMax(part, propertyToBeEdited, "SliderForOneDimensionPropertyForBilateralPart")
//    }
    let part: Part

//    var propertyToBeEdited: PartTag {
//        objectEditVM.getDimensionPropertyToBeEdited()
//    }
//    var description: String {
//        propertyToBeEdited.rawValue
//    }
    init (
        _ part: Part) {
            self.part = part
         
           
        }
 
    var body: some View {
        let propertyToBeEdited = objectEditVM.getDimensionPropertyToBeEdited()
        let minMaxValue =  objectPickVM.geMinMax(part, propertyToBeEdited, "SliderForOneDimensionPropertyForBilateralPart")
        let boundSliderValue =
            Binding(
                get: {
                        objectPickVM.getInitialSliderValue(
                            part,
                            propertyToBeEdited) },
                set: {
                    newValue in
                        objectEditVM
                            .setValueForBilateralPartInUserEditedDic(
                                newValue,
                                part,
                               propertyToBeEdited
                            )

                        objectPickVM.modifyObjectByCreatingFromName()
                                } )
        HStack{
                Slider(value: boundSliderValue ,
                       in: minMaxValue.min...minMaxValue.max,
                       step: 10.0)

            MeasurementView(
                Measurement(value: boundSliderValue.wrappedValue,
                    unit: .millimeters))
            }
            .disabled(objectEditVM.scopeOfEditForSide == .none)
    }
}


struct StepperOriginForBilateralPartWithOneValueToChange: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    let part: Part
    let propertyToBeEdited: PartTag
    var arrowImage: Image {
        propertyToBeEdited == .xOrigin ?
        Image(systemName: "arrow.left.and.right"):
        Image(systemName: "arrow.up.and.down")
    }
    
    init (
        _ part: Part,
        _ propertyToBeEdited: PartTag ) {
            self.part = part
           
            self.propertyToBeEdited = propertyToBeEdited
        }
 
    var body: some View {

        let boundStepperValue =
            Binding(
                get: {
                    0.0 },
                set: {
                    newValue in
                        objectEditVM
                            .setValueForBilateralPartInUserEditedDic(
                                newValue,
                                part,
                               propertyToBeEdited
                            )

                        objectPickVM.modifyObjectByCreatingFromName()
                                } )
        HStack{
            Stepper("", value: boundStepperValue, step: 10.0)
            arrowImage
            MeasurementView(
                Measurement(value: boundStepperValue.wrappedValue,
                    unit: .millimeters))
            }
//        .padding(.horizontal)
//        .alignmentGuide(HorizontalAlignment.center) { _ in
//                                UIScreen.main.bounds.size.width / 2 // Center the content
//                            }
            .disabled(objectEditVM.scopeOfEditForSide == .none)
    }
}




struct OnePartTwoDimensionValueMenu: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @State private var sliderValue = 0.0
   
    var propertyToBeEdited: PartTag {
        objectEditVM.getDimensionPropertyToBeEdited()
    }
    var minMaxValue : (min: Double, max: Double){
        objectPickVM.geMinMax(part, propertyToBeEdited, "OnePartTwoDimensionValueMenu")
    }
    let part: Part
    let description: String
    
    init(
        _ part: Part,
        _ description: String  ) {
        self.part = part
        self.description = description
    }
    var body: some View {
        let boundSliderValue = Binding(
            get: {
                objectPickVM.getInitialSliderValue (
                    part,
                    propertyToBeEdited
                ) 
            },
            set: {self.sliderValue = $0 }
            )
        ZStack{
            HStack {

             
      
                Slider(value: boundSliderValue,
                       in: minMaxValue.min...minMaxValue.max,
                       step: 10.0)
                MeasurementView(
                    Measurement(value: boundSliderValue.wrappedValue,
                        unit: .millimeters))
                .padding(.horizontal)
                }
                .onChange(of: sliderValue) { newValue in
                    objectEditVM
                        .setDimensionPropertyValueForOnePartInUserEditedDic(
                            newValue,
                            part)
                    objectPickVM.modifyObjectByCreatingFromName()
                    }
                .onChange(of: propertyToBeEdited) { _ in
                    //print("DETECT")
                    
                    
                    sliderValue =
                    objectPickVM.getInitialSliderValue(
                    part,
                    propertyToBeEdited)
                    }
        }
    }
}



//enum BilateralOrOnePartDimensionEdit {
//    case one
//    case two
//}


//struct SitOnDimension: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @EnvironmentObject var objectEditVM: ObjectEditViewModel
//    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
//    @State private var sliderValue: Double = 200.0
//    var show: Bool {
//        objectShowMenuVM.getShowMenuStatus(.supportWidth)
//    }
//    var minMaxLength: (min: Double, max: Double) {
//        objectPickVM.getDimensionMinMax(.sitOn)
//    }
//    var min: Double { minMaxLength.min }
//    var max: Double { minMaxLength.max }
//
//    var body: some View {
//        let dimensionToEdit = objectEditVM.getDimensionToBeEdited()
//        let boundObjectType = Binding(
//            get: {objectPickVM.getInitialSliderValue(
//                .id0,
//                .sitOn,
//                dimensionToEdit)},
//            set: {self.sliderValue = $0}
//            )
//        if show {
//            HStack {
//                Text("support")
//                Slider(value: boundObjectType, in: min...max, step: 10.0)
//                MeasurementView(
//                    Measurement(value: boundObjectType.wrappedValue,
//                                unit: .millimeters) )
//                    .onChange(of: sliderValue) { newValue in
//                        objectEditVM.setEitherDimensionForOnePartInUserEditedDic(
//                            sliderValue,
//                            Part.sitOn,
//                            dimensionToEdit)
//                        objectPickVM.modifyObjectByCreatingFromName()
//                    }
//            }
//            .onAppear {
//                sliderValue = boundObjectType.wrappedValue
//            }
//        } else {
//            EmptyView()
//        }
//    }
//}





//struct SitOnDimension: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @State private var sliderValue: Double = 400.0
//    var show: Bool {
//        objectPickVM.getShowViewStatus(.supportWidth)
//    }
//    var minMaxLength: (min: Double, max: Double){
//        objectPickVM.getDimensionMinMax(.sitOn)
//    }
//
//    var min: Double { minMaxLength.min}
//    var max: Double { minMaxLength.max}
//
//    var body: some View {
//        let dimensionToEdit = objectPickVM.getDimensionToBeEdited()
//
//        if show {
//            HStack{
//                Text("support")
//                Slider(value: $sliderValue, in: min...max, step: 10.0)
//                Text(" mm: \(Int(sliderValue))")
//                    .onChange(of: sliderValue) { newValue in
//                        objectPickVM.setWidthInUserEditedDictionary(
//                            sliderValue,
//                            .sitOn,
//                            dimensionToEdit)
//                       }
//            }
//        } else {
//            EmptyView()
//        }
//    }
//}



struct TiltView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objecShowMenuVM: ObjectShowMenuViewModel
    @State private var sliderValue: Double = 0.0

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
            get: {max -
                (objectPickVM.getInitialSliderValue (
                    joint,
                    .angle))
            },
            set: {self.sliderValue = $0 }
            )
    
            ZStack{
                HStack{
                    Text(description)
                    
                    Slider(value: boundSliderValue, in: min...max, step: 1.0)
                    
                    Text(" deg: \( Int(max - boundSliderValue.wrappedValue))")
                        .onChange(of: sliderValue) { newValue in
                            objectEditVM.setCurrentRotation(
                               max - sliderValue
                            )
                            objectPickVM.modifyObjectByCreatingFromName()
                           }
                }
                .padding()
            }
    }
}



struct SinglePartPresence: View {
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
                .onChange(of: optionToggle) { value in
                    if !value {
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



///Bilateral removal of seat attachment without replacement
///Unilateral removal with replacement



//struct FootSupportX: View {
//    @State private var laterality = "both"
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//
//    let partSymmetry = ["no", "both", "left", "right"]
//
//    var body: some View {
//        HStack {
//            Text("Show")
//            Picker("anyString", selection: $laterality) {
//                ForEach(partSymmetry, id: \.self) { equipment in
//                    Text(equipment)
//                }
//
//            }
//            .onChange(of: laterality) { tag in
//                objectPickVM.setChangeToPartBeingOnBothSides(tag, Part.footSupport)
//            }
//            Text("foot support")
//        }
//    }
//}







//
//struct DoubleSitOnPreferenceKey: PreferenceKey {
//    static var defaultValue: Bool = false
//    static func reduce(value: inout Bool, nextValue: () -> Bool) {
//        value = nextValue()
//    }
//}




