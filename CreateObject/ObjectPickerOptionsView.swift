//
//  ObjectPickerOptionsView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/05/2023.
//

import SwiftUI


//struct ReclinePreferenceKey: PreferenceKey {
//    static var defaultValue: Bool = false
//    static func reduce(value: inout Bool, nextValue: () -> Bool) {
//        value = nextValue()
//    }
//}

//struct BackSupportRecline: View {
//    @State private var reclineToggle = false
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
//    let showRecline: Bool
//    
//    init(_ name: String) {
//        showRecline =
//        (name.contains("air") && !name.contains("ilting")) ?
//            true: false
//    }
//    
//    var body: some View {
//        if showRecline {
//            Toggle("Reclining back",isOn: $reclineToggle)
//                .onChange(of: reclineToggle) { value in
//                    let twinSitOnDictionary = twinSitOnVM.getTwinSitOnOptions()
//                    //let name = objectPickVM.getCurrentObjectName()
//                    objectPickVM.setObjectOptionDictionary(
//                        ObjectOptions.angleBackSupport,
//                        reclineToggle) //RECLINE
//                    objectPickVM.setCurrentObjectByCreatingFromName(
//                        //name,
//                        twinSitOnDictionary)
//                        
//                        //.setCurrentObjectWithInitialOrEditedDictionary(
//                        //name,
//                         //twinSitOnOptions: dictionary)
//                    
//                }
////                .preference(key: ReclinePreferenceKey.self, value: reclineToggle)
//        } else {
//            EmptyView()
//        }
//    }
//}


enum SidesAffected: String, CaseIterable {
    case left = "L"
    case right = "R"
    case both = "L & R"
    case none = "none"
    
    static let allOptions: [String] = Self.allCases.map {$0.rawValue}

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

//struct SideSelection: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @EnvironmentObject var objectEditVM: ObjectEditViewModel
//    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
//    @State private var selection: Side = .both
//    let objectName: String
//    //let twoSidedPart: Part
//    var relevantCases: [Side]{
//        objectPickVM.getSidesPresentGivenUserEdit(.footSupport)
//    }
//    var show: Bool {
//        //objectPickVM.getViewStatus(.legLength)
//        objectShowMenuVM.getShowMenuStatus(.footSupport
//                                           //, objectName
//        )
//    }
//    var body: some View {
//
//        if show {
//            Picker("side", selection: $selection) {
//                ForEach(relevantCases, id: \.self) { side in
//                    Text(side.rawValue)
//                }
//            }
//            .pickerStyle(.segmented)
//            .disabled(relevantCases == [.none])
//            .fixedSize()
//            .onChange(of: selection) { newSelection in
//                objectEditVM.setSidesToBeEdited(newSelection)
//            }
//            .onChange(of: relevantCases) { newCases in
//                if newCases == [.left] ||
//                    newCases == [.right] {
//                    objectEditVM.setSidesToBeEdited(newCases[0])
//                }
//            }
//        } else {
//            EmptyView()
//        }
//
//    }
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
struct FootSupportPresence: View {
    @State private var isLeftSelected = true
    @State private var isRightSelected = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objecShowMenuVM: ObjectShowMenuViewModel
    
    var show: Bool {
        objecShowMenuVM.getShowMenuStatus(.footSupport)
    }
    
    var body: some View {
        if show {
            HStack {
                Text("foot support:")
                Toggle("L", isOn: $isLeftSelected)
                    .onChange(of: isLeftSelected) { newValue in
                        updateViewModel()
                    }
                Toggle("R", isOn: $isRightSelected)
                    .onChange(of: isRightSelected) { newValue in
                        updateViewModel()
                    }
                    .padding(.leading, 30)
                
            }
            .onChange(of: objectPickVM.getCurrentObjectType()) { _ in
                isLeftSelected = true
                isRightSelected = true
            }
        } else {
            EmptyView()
        }
    }
    
    private func updateViewModel() {
        objectEditVM.setWhenPartChangesOneOrTwoStatus(isLeftSelected, isRightSelected, .footSupport)
        objectPickVM.modifyObjectByCreatingFromName()
    }
}


struct BiLateralPartWithOneValueChange: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @State private var sliderValue: Double = 400.0
    @State private var sidesAffected: SidesAffected = .both
    var minMaxValue : (min: Double, max: Double){
        objectPickVM.getDimensionMinMax(part)
    }

    let part: Part
    let description: String
    let dimensionOrOrigin: PartTag
    let valueToBeChanged: PartTag
    init (
        _ part: Part,
        _ description: String,
        _ dimensionOrOrigin: PartTag,
        _ valueToBeChanged: PartTag ) {
            self.part = part
            self.description = description
            self.dimensionOrOrigin = dimensionOrOrigin
            self.valueToBeChanged = valueToBeChanged
    }
 
    var body: some View {
        var allCurrentOptionsForSidesAffected: [SidesAffected]{
            objectPickVM.getSidesPresentGivenUserEdit(.footSupport)
        }
        let boundObjectType = Binding(
            get: {
//                let present = objectEditVM.getScopeOfEditForSide()
//                let id = present == .left ? PartTag.id0: PartTag.id1
                return
                    objectPickVM.getInitialSliderValue(
                        //id,
                        part,
                        .length
                        )},
            set: {// self.sliderValue = $0
                 //alt form
                    newValue in
                        sliderValue = newValue
                            } )
        ///when slider is slid
        ///get sidesAffected which is one of allCurrentOptionsForSidesAffected
        ///update allCurrentOptionsForSidesAffected
        ///if
        HStack{
            Picker("side", selection: $sidesAffected) {
                ForEach(allCurrentOptionsForSidesAffected, id: \.self) { side in
                    Text(side.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .disabled(allCurrentOptionsForSidesAffected == [.none])
            .fixedSize()
            .onChange(of: sidesAffected) { newSelection in
                objectEditVM.setSidesToBeEdited( newSelection)
               
                //print(newSelection)
                if newSelection == .left ||
                    newSelection == .right {
                    objectEditVM.setSidesToBeEdited(sidesAffected)
                }
                    
            }
//            .onChange(of: allCurrentOptionsForSidesAffected) { _ in
//                //print( objectEditVM.getScopeOfEditForSide())
//            }
            
            
            Text(description)
            
            Slider(value: boundObjectType,
                   in: minMaxValue.min...minMaxValue.max,
                   step: 10.0)
            MeasurementView(
                Measurement(value: boundObjectType.wrappedValue,
                    unit: .millimeters))
            }
            .onChange(of: sliderValue) { newValue in
                objectEditVM
                    .setValueForBilateralPartInUserEditedDic(
                        newValue,
                        part,
                        dimensionOrOrigin,
                        valueToBeChanged)
                
                objectPickVM.modifyObjectByCreatingFromName()
                }
            .disabled(objectEditVM.scopeOfEditForSide == .none)
    }
}


struct OnePartTwoDimensionValueMenu: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @State private var sliderValue = 0.0
    @State private var selection: PartTag = .length
    var relevantCases: [PartTag] = [.length, .width]
    var minMaxValue : (min: Double, max: Double){
        objectPickVM.getDimensionMinMax(part)
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
       
        let boundObjectType = Binding(
            get: {
                objectPickVM.getInitialSliderValue(
                   // .id0,
                    part,
                    selection
                    )},
            set: {// self.sliderValue = $0
                 //alt form
                    newValue in
                        sliderValue = newValue
                            }
            )
        HStack {
            Picker("dimension", selection: $selection) {
                ForEach(relevantCases, id: \.self) { side in
                    Text(side.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .fixedSize()
            .onChange(of: selection) { newSelection in
                objectEditVM.updateDimensionToBeEdited(newSelection)
            }
            
            Text(description)
  
            Slider(value: boundObjectType,
                   in: minMaxValue.min...minMaxValue.max,
                   step: 10.0)
            MeasurementView(
                Measurement(value: boundObjectType.wrappedValue,
                    unit: .millimeters))
            }
            .onChange(of: sliderValue) { newValue in
                objectEditVM
                    .setEitherDimensionForOnePartInUserEditedDic(
                        newValue,
                        part)
                objectPickVM.modifyObjectByCreatingFromName()
                }
            .onChange(of: selection) { _ in
                sliderValue =
                objectPickVM.getInitialSliderValue(
               // .id0,
                part,
                selection)
                }
            .padding(.horizontal)
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



struct Tilt: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objecShowMenuVM: ObjectShowMenuViewModel
    @State private var sliderValue: Double = 0.0
   
    let userModifier: UserModifiers
    let title: String
    var show: Bool {
        objecShowMenuVM.getShowMenuStatus(userModifier) }
    
    init(_ userModifier: UserModifiers){
        self.userModifier = userModifier
        title = userModifier.rawValue
    }
 
    var body: some View {
        var partName: String {
            let parts: [Parts] = [Part.objectOrigin, PartTag.id0, PartTag.stringLink, Part.sitOnTiltJoint, PartTag.id0, PartTag.stringLink, Part.sitOn, PartTag.id0]
           return
            CreateNameFromParts(parts ).name    }
        let angleMinMax =
            objectPickVM.getAngleMinMaxDic(partName)
        let max = angleMinMax.max.value
        let min = angleMinMax.min.value
        
        if show {
            HStack{
                Text(title)
                Slider(value: $sliderValue, in: min...max, step: 1.0)
                Text(" deg: \(Int(max - sliderValue))")
                    .onChange(of: sliderValue) { newValue in
                        objectEditVM.setCurrentRotation( max - sliderValue
                        )
                        objectPickVM.modifyObjectByCreatingFromName()
                       }
            }
            .padding()
        } else {
            EmptyView()
        }
    }
}



struct HeadSupportPresence: View {
    @State private var optionToggle = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    let chainLabelsRequiringAction: [Part] = [.backSupportHeadSupport]
    var show: Bool {
        objectShowMenuVM.defaultObjectHasOneOfTheseChainLabels(chainLabelsRequiringAction).show
    }

    
    var body: some View {
        if show {
            Toggle("headrest", isOn: $optionToggle)
                .onChange(of: optionToggle) { value in
                    if !value {
                        objectEditVM.replaceChainLabelForObject(
                            .backSupportHeadSupport,
                            .backSupport)
                    } else {
                        objectEditVM.replaceChainLabelForObject(
                            .backSupport,
                            .backSupportHeadSupport)
                    }
                    objectPickVM.modifyObjectByCreatingFromName()
                }
        } else {
            EmptyView()
        }
    }
}




struct PropellerPresence: View {
    @State private var optionToggle = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    let chainLabelsRequiringAction: [Part] = [.fixedWheelAtRearWithPropeller, .fixedWheelAtFrontWithPropeller]
    var chainLabelRequiringAction: Part {
        objectShowMenuVM.defaultObjectHasOneOfTheseChainLabels(chainLabelsRequiringAction).part
    }
    var show: Bool {
        objectShowMenuVM.defaultObjectHasOneOfTheseChainLabels(chainLabelsRequiringAction).show
    }
    
    
    var body: some View {
        if show {
            Toggle("propellers", isOn: $optionToggle)
                .onChange(of: optionToggle) { value in
                    if !value {
                        objectEditVM.replaceChainLabelForObject(
                            chainLabelRequiringAction,
                            .fixedWheelAtRear)
                        objectPickVM.modifyObjectByCreatingFromName()
                    } else {
                        objectEditVM.replaceChainLabelForObject(
                            .fixedWheelAtRear,
                            chainLabelRequiringAction)
                        objectPickVM.modifyObjectByCreatingFromName()
                    }
                }
        } else {
            EmptyView()
        }
    }
}


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




