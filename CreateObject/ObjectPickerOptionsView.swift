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


enum Side: String, CaseIterable {
    case left = "L"
    case right = "R"
    case both = "L & R"
    case none = "none"
    
    static let options: [String] = Self.allCases.map {$0.rawValue}

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

struct SideSelection: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @State private var selection: Side = .both
    let objectName: String
    //let twoSidedPart: Part
    var relevantCases: [Side]{
        objectPickVM.getSidesPresentGivenUserEdit(.footSupport)
    }
    var show: Bool {
        //objectPickVM.getViewStatus(.legLength)
        objectShowMenuVM.getShowMenuStatus(.footSupport, objectName)
    }
    var body: some View {
        
        if show {
            Picker("side", selection: $selection) {
                ForEach(relevantCases, id: \.self) { side in
                    Text(side.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .disabled(relevantCases == [.none])
            .fixedSize()
            .onChange(of: selection) { newSelection in
                objectEditVM.setSidesToBeEdited(newSelection)
            }
            .onChange(of: relevantCases) { newCases in
                if newCases == [.left] ||
                    newCases == [.right] {
                    objectEditVM.setSidesToBeEdited(newCases[0])
                }
            }
        } else {
            EmptyView()
        }

    }
}


struct DimensionSelection: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @State private var selection: PartTag = .length
  
    var relevantCases: [PartTag] = [.length, .width]

    var body: some View {
        Picker("side", selection: $selection) {
            ForEach(relevantCases, id: \.self) { side in
                Text(side.rawValue)
            }
        }
        .pickerStyle(.segmented)
        //.disabled(relevantCases == [.none])
        .fixedSize()
        .onChange(of: selection) { newSelection in
            objectEditVM.updateDimensionToBeEdited(newSelection)
        }
    }
}



struct LegLength: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @State private var sliderValue: Double = 400.0
    let objectName: String
    
    var show: Bool {
        objectShowMenuVM.getShowMenuStatus(.legLength, objectName)
    }
 
    var body: some View {
        
//        let aminMax =
//            objectPickVM.getAngleMinMaxDic(partName)
        let max = 1000.0//aminMax.max.value
        let min = 100.0//minMax.min.value
        if show {
            HStack{
                Text("leg length")
                Slider(value: $sliderValue, in: min...max, step: 10.0)
                Text(" mm: \(Int(sliderValue))")
                    .onChange(of: sliderValue) { newValue in
                        objectEditVM.setOneOrTwoDimensionForTwoInUserEditedDic(
                            sliderValue
                            ,Part.footSupportHangerLink)
                        
                        objectPickVM.modifyObjectByCreatingFromName()
                       }
            }
            .disabled(DataService.shared.presenceOfPartForSide == .none)
        } else {
            EmptyView()
        }
    }
}


struct SitOnDimension: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @State private var sliderValue: Double = 200.0
    let objectName: String
    var show: Bool {
        objectShowMenuVM.getShowMenuStatus(.supportWidth, objectName)
    }

    var minMaxLength: (min: Double, max: Double) {
        objectPickVM.getDimensionMinMax(.sitOn)
    }

    var min: Double { minMaxLength.min }
    var max: Double { minMaxLength.max }
    
    init (objectName: String) {
        self.objectName = objectName
    }

    var body: some View {
        let dimensionToEdit = objectPickVM.getDimensionToBeEdited()
        
        
        let boundObjectType = Binding(
            get: {objectPickVM.getInitialSliderValue(.id0, .sitOn)},
            set: {self.sliderValue = $0}
        )
       
        if show {
            HStack {
                Text("support")
                Slider(value: boundObjectType, in: min...max, step: 10.0)
                Text(" mm: \(Int(boundObjectType.wrappedValue))")
                    .onChange(of: sliderValue) { newValue in
                        objectEditVM.setOneOrTwoDimensionForOneInUserEditedDic(
                            sliderValue,
                            Part.sitOn,
                        dimensionToEdit)
                        objectPickVM.modifyObjectByCreatingFromName()
                    }
            }
            .onAppear {
                sliderValue = boundObjectType.wrappedValue

            }
        } else {
            EmptyView()
        }
    }
}





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



struct TiltX: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objecShowMenuVM: ObjectShowMenuViewModel
    @State private var sliderValue: Double = 0.0
    let chainLabelsRequiringAction: [Part] = [.sitOnTiltJoint]
    var show: Bool {
        objecShowMenuVM.defaultObjectHasOneOfTheseChainLabels(chainLabelsRequiringAction).show
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
                Text("tilt-in-space")
                Slider(value: $sliderValue, in: min...max, step: 1.0)
                Text(" deg: \(Int(max - sliderValue))")
                    .onChange(of: sliderValue) { newValue in
                        objectEditVM.setCurrentRotation( max - sliderValue
                        )
                        objectPickVM.modifyObjectByCreatingFromName()
                       }
            }

        } else {
            EmptyView()
        }
    }
}



struct HeadSupport: View {
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




struct Propeller: View {
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


struct FootSupport: View {
    @State private var isLeftSelected = true
    @State private var isRightSelected = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objecShowMenuVM: ObjectShowMenuViewModel
    let objectName: String
   
    var show: Bool {
        objecShowMenuVM.getShowMenuStatus(.footSupport, objectName)
        //objectPickVM.getViewStatus(.footSupport)
    }
    
    
    var body: some View {
        if show {
            HStack {
                Text("foot support:")
                Toggle("L", isOn: $isLeftSelected)
                    .onChange(of: isLeftSelected) { newValue in
                        objectEditVM.updatePartBeingOnBothSides(isLeftSelected: isLeftSelected, isRightSelected: isRightSelected)
                        objectPickVM.modifyObjectByCreatingFromName()
                    }
                Toggle("R", isOn: $isRightSelected)
                    .onChange(of: isRightSelected) { newValue in
                        objectEditVM.updatePartBeingOnBothSides(isLeftSelected: isLeftSelected, isRightSelected: isRightSelected)
                        objectPickVM.modifyObjectByCreatingFromName()
                    }
                    .padding(.leading, 30)

            }
            .onChange(of: objectPickVM.getCurrentObjectType()){ _ in
                isLeftSelected = true
                isRightSelected = true }
        }
        else {
            EmptyView()
        }

    }
}



//
//struct DoubleSitOnPreferenceKey: PreferenceKey {
//    static var defaultValue: Bool = false
//    static func reduce(value: inout Bool, nextValue: () -> Bool) {
//        value = nextValue()
//    }
//}




