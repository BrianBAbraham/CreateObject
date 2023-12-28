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
            CreateNameFromParts( [.object, .id0, .stringLink, .sitOnTiltJoint, .id0, .stringLink, .sitOn, .id0]).name    }
        let angleMinMax =
            objectPickVM.getAngleMinMaxDic(angleName)
        let angleMax = angleMinMax.max.value
        let angleMin = angleMinMax.min.value
        if showTilt {

                Slider(value: $sliderValue, in: angleMin...angleMax, step: 1.0)
                Text("tilt-in-space angle: \(Int(angleMax - sliderValue))")
                    .onChange(of: sliderValue) { newValue in
                        objectPickVM.setCurrentObjectByCreatingFromName(
                            [angleName:
                                     (x:
                                Measurement(value: angleMax - sliderValue, unit: UnitAngle.degrees),
                                      y: ZeroValue.angle,
                                      z: ZeroValue.angle)]
                            //,angleName
                        )
                       
                       }
        } else {
            EmptyView()
        }
    }
}


struct HeadSupport: View {
    @State private var optionToggle = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
   // @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
    let showTilt: Bool
    
    init(_ name: String) {
        showTilt = name.contains("ilting") ? true: false
    }
    
    var body: some View {
        if showTilt {
            Toggle("Headrest",isOn: $optionToggle)
                .onChange(of: optionToggle) { value in
                    objectPickVM.setCurrentObjectWithToggledRelatedPartChainLabel(
                        Part.backSupportHeadSupport,
                        Part.backSupport)
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
                    objectPickVM.setCurrentObjectWithToggledRelatedPartChainLabel(
                        Part.backSupportHeadSupport,
                        Part.backSupport)
                }
        } else {
            EmptyView()
        }
    }
}


struct FootSupport: View {
    //@State private var footSuppportToggle = true
    @State private var laterality = "both"
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
  //  @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
    let objectNames = ["none", "both", "left", "right"]
    
    var body: some View {
        
//        Toggle("foot",isOn: $footSuppportToggle)
//            .onChange(of: footSuppportToggle) { value in
//
//                objectPickVM.setCurrentObjectWithEditedPartChainsId()
//            }
        HStack {
            Text("Footplate?")
            Picker("foot",selection: $laterality ) {
                ForEach(objectNames, id:  \.self)
                        { equipment in
                    Text(equipment)
                }
            }
            .onChange(of: laterality) {tag in
                objectPickVM.setCurrentObjectWithEditedPartChainsId(tag)
            }
        }

        
    }
}

struct DoubleSitOnPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}




//struct TwinSitOnView: View {
//    @State private var twinSitOnToggle: Bool
//
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    //@EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
//
//    let showTwinSitOn: Bool
//
//    init(_ twinSitOnState: Bool, _ name: String) {
//
//        showTwinSitOn =
//            name.contains("wheelchair") ? true: false
//
//        _twinSitOnToggle
//            = State(initialValue: twinSitOnState)
//    }
//
//    var body: some View {
//        if showTwinSitOn {
//            Toggle("Two seats",isOn: $twinSitOnToggle)
//                .onChange(of: twinSitOnToggle) { value in
//
//                    if !twinSitOnToggle {
//
//                        twinSitOnVM.setAllConfigurationFalse()
//
                       // let name = objectPickVM.getCurrentObjectName()
//                        let twinSitOnDictionary = twinSitOnVM.getTwinSitOnOptions()
//                        objectPickVM
//                            .setCurrentObjectByCreatingFromName(
                                //name,
//                                twinSitOnDictionary)
//                    }
//                    else {
//
//                        let objectType = objectPickVM.getCurrentObjectType()
//                        let twinSitOnDictionary = twinSitOnVM.getTwinSitOnOptions()
//                        objectPickVM.setDefaultObjectDictionary(
//                            objectType,
//                            twinSitOnDictionary)
//
//print(twinSitOnDictionary)
//                    }
             //   }
            
//            let options: [TwinSitOnOption] = [.leftAndRight, .frontAndRear]
//
//            if twinSitOnToggle {
//                ExclusiveToggles(
//                    twinSitOnVM.getManyState(options),
//                    options,
//                    .twinSitOn)
//
//
//
//            }
//
//        } else {
//            EmptyView()
//        }
//    }
//
//}
