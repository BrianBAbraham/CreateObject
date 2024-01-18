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

struct TiltX: View {
    @State private var tiltToggle = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
 
    @State private var sliderValue: Double = 0.0
    
    var showTilt: Bool = true
 
    init (_ partChainLabels: [Part]){
        showTilt = partChainLabels.contains(.sitOnTiltJoint) ? true: false
    }
    
    var body: some View {
        var angleName: String {
            let parts: [Parts] = [Part.objectOrigin, PartTag.id0, PartTag.stringLink, Part.sitOnTiltJoint, PartTag.id0, PartTag.stringLink, Part.sitOn, PartTag.id0]
           return
            CreateNameFromParts(parts ).name    }
        let angleMinMax =
            objectPickVM.getAngleMinMaxDic(angleName)
        let angleMax = angleMinMax.max.value
        let angleMin = angleMinMax.min.value
        if showTilt {
            HStack{
                Slider(value: $sliderValue, in: angleMin...angleMax, step: 1.0)
                Text("tilt-in-space deg: \(Int(angleMax - sliderValue))")
                    .onChange(of: sliderValue) { newValue in
                        objectPickVM.setCurrentRotation(
                            [angleName:
                                     (x:
                                Measurement(value: angleMax - sliderValue, unit: UnitAngle.degrees),
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

//struct HeadSupport: View {
//    @State private var optionToggle = true
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    let showTilt: Bool
//
//    init(_ name: String) {
//        showTilt = true
//    }
//
//    var body: some View {
//        if showTilt {
//            Toggle("Headrest", isOn: $optionToggle)
//                .onChange(of: optionToggle) { value in
//
//                        objectPickVM.replaceChainLabelForObject(Part.backSupportHeadSupport, Part.backSupport )
//
//                }
//        } else {
//            EmptyView()
//        }
//    }
//}


struct HeadSupport: View {
    @State private var optionToggle = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    let showTilt: Bool
    
    init(_ name: String) {
        showTilt = true
    }
    
    var body: some View {
        if showTilt {
            Toggle("Headrest", isOn: $optionToggle)
                .onChange(of: optionToggle) { value in
                    if !value {
                        objectPickVM.replaceChainLabelForObject(Part.backSupportHeadSupport, Part.backSupport)
                    } else {
                            
                            objectPickVM.replaceChainLabelForObject( Part.backSupport, Part.backSupportHeadSupport )
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
   // @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
    let showTilt: Bool
    
    init(_ name: String) {
        showTilt = name.contains("propel") ? true: false
    }
    
    var body: some View {
        if showTilt {
            Toggle("Propellers",isOn: $optionToggle)
                .onChange(of: optionToggle) { value in
//                    objectPickVM.setCurrentObjectWithToggledRelatedPartChainLabel(
//                        Part.backSupportHeadSupport,
//                        Part.backSupport)
                }
        } else {
            EmptyView()
        }
    }
}


struct FootSupport: View {
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





struct DoubleSitOnPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}




