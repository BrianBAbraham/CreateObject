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


struct SeatWidth: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @State private var sliderValue: Double = 0.0
    let chainLabelsRequiringAction: [Part] = [.sitOn]
    var show: Bool {
        objectPickVM.defaultObjectHasThisChainLabel(chainLabelsRequiringAction)
    }
 
    var body: some View {
        var partName: String {
            let parts: [Parts] = [Part.objectOrigin, PartTag.id0, PartTag.stringLink, Part.sitOn, PartTag.id0, PartTag.stringLink, Part.sitOn, PartTag.id0]
           return
            CreateNameFromParts(parts ).name    }
//        let aminMax =
//            objectPickVM.getAngleMinMaxDic(partName)
        let max = 1000.0//aminMax.max.value
        let min = 300.0//minMax.min.value
        if show {
            HStack{
                Text("seat width")
                Slider(value: $sliderValue, in: min...max, step: 1.0)
                Text(" mm: \(Int(max - sliderValue))")
                    .onChange(of: sliderValue) { newValue in
                        objectPickVM.setCurrentWidth(
                            max - sliderValue
                            , partName)
                       }
            }

        } else {
            EmptyView()
        }
    }
}


struct TiltX: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @State private var sliderValue: Double = 0.0
    let chainLabelsRequiringAction: [Part] = [.sitOnTiltJoint]
    var show: Bool {
        objectPickVM.defaultObjectHasThisChainLabel(chainLabelsRequiringAction)
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
                        objectPickVM.setCurrentRotation(
                            [partName:
                                     (x:
                                Measurement(value: max - sliderValue, unit: UnitAngle.degrees),
                                      y: ZeroValue.angle,
                                      z: ZeroValue.angle)]
                        )
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
    let chainLabelsRequiringAction: [Part] = [.backSupportHeadSupport]
    var chainLabelRequiringAction: Part {
        objectPickVM.defaultObjectHasOneOFTheseChainLabels(chainLabelsRequiringAction)
    }
    var show: Bool {
        chainLabelRequiringAction == Part.notFound ? false: true
    }

    
    var body: some View {
        if show {
            Toggle("headrest", isOn: $optionToggle)
                .onChange(of: optionToggle) { value in
                    if !value {
                        objectPickVM.replaceChainLabelForObject(
                            chainLabelRequiringAction,
                            .backSupport)
                    } else {
                        objectPickVM.replaceChainLabelForObject(
                            .backSupport,
                            chainLabelRequiringAction)
                    }
                }
        } else {
            EmptyView()
        }
    }
}




struct Propeller: View {
    @State private var optionToggle = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    var chainLabelsRequiringAction: [Part] = [.fixedWheelAtRearWithPropeller, .fixedWheelAtFrontWithPropeller]
    var chainLabelRequiringAction: Part {
        objectPickVM.defaultObjectHasOneOFTheseChainLabels(chainLabelsRequiringAction)
    }
    var show: Bool {
        chainLabelRequiringAction == Part.notFound ? false: true
    }
    
    
    var body: some View {
        if show {
            Toggle("propellers", isOn: $optionToggle)
                .onChange(of: optionToggle) { value in
                    if !value {
                        objectPickVM.replaceChainLabelForObject(chainLabelRequiringAction,.fixedWheelAtRear)
                    } else {
                        objectPickVM.replaceChainLabelForObject( .fixedWheelAtRear, chainLabelRequiringAction)
                    }
                }
        } else {
            EmptyView()
        }
    }
}


struct FootSupportX: View {
    @State private var laterality = "both"
    @EnvironmentObject var objectPickVM: ObjectPickViewModel

    let partSymmetry = ["no", "both", "left", "right"]

    var body: some View {
        HStack {
            Text("Show")
            Picker("anyString", selection: $laterality) {
                ForEach(partSymmetry, id: \.self) { equipment in
                    Text(equipment)
                }

            }
            .onChange(of: laterality) { tag in
                objectPickVM.setChangeToPartBeingOnBothSides(tag, Part.footSupport)
            }
            Text("foot support")
        }
    }
}


struct FootSupport: View {
    @State private var isLeftSelected = true
    @State private var isRightSelected = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    var objectsRequiringView: [ObjectTypes] = [
    .fixedWheelSolo,
    .fixedWheelMidDrive,
    .fixedWheelRearDrive,
    .fixedWheelFrontDrive,
    .fixedWheelManualRearDrive,
    .fixedWheelRearDriveAssisted,
    .allCasterTiltInSpaceShowerChair,
    .allCasterChair
    ]
    var show: Bool {
        objectsRequiringView.contains(objectPickVM.getCurrentObjectType()) ? true: false
    }
    
    
    var body: some View {
        if show {
            HStack {
                Text("foot support:")
                Toggle("L", isOn: $isLeftSelected)
                    .onChange(of: isLeftSelected) { newValue in
                        objectPickVM.updatePartBeingOnBothSides(isLeftSelected: isLeftSelected, isRightSelected: isRightSelected)
                    }
                Toggle("R", isOn: $isRightSelected)
                    .onChange(of: isRightSelected) { newValue in
                        objectPickVM.updatePartBeingOnBothSides(isLeftSelected: isLeftSelected, isRightSelected: isRightSelected)
                    }
                    .padding(.leading, 30)
            }
            .onAppear {
                objectPickVM.updatePartBeingOnBothSides(isLeftSelected: isLeftSelected, isRightSelected: isRightSelected)
            }
        } else {
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




