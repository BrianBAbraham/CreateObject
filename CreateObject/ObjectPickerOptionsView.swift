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

struct BackSupportRecline: View {
    @State private var reclineToggle = false
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
    let showRecline: Bool
    
    init(_ name: String) {
        showRecline =
        (name.contains("air") && !name.contains("ilting")) ?
            true: false
    }
    
    var body: some View {
        if showRecline {
            Toggle("Reclining back",isOn: $reclineToggle)
                .onChange(of: reclineToggle) { value in
                    let twinSitOnDictionary = twinSitOnVM.getTwinSitOnOptions()
                    //let name = objectPickVM.getCurrentObjectName()
                    objectPickVM.setObjectOptionDictionary(
                        ObjectOptions.angleBackSupport,
                        reclineToggle) //RECLINE
                    objectPickVM.setCurrentObjectByCreatingFromName(
                        //name,
                        twinSitOnDictionary)
                        
                        //.setCurrentObjectWithInitialOrEditedDictionary(
                        //name,
                         //twinSitOnOptions: dictionary)
                    
                }
//                .preference(key: ReclinePreferenceKey.self, value: reclineToggle)
        } else {
            EmptyView()
        }
    }
}

struct Tilt: View {
    @State private var tiltToggle = true
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
    @State private var sliderValue: Double = 0.0
    let showTilt: Bool
    var twinSitOnDictionary: TwinSitOnOptionDictionary {
        twinSitOnVM.getTwinSitOnOptions()}
    var angleName: String {
        CreateNameFromParts( [.sitOnBackFootTiltJointAngle, .stringLink, .sitOn, .id0]).name    }
//    var angleMinMax: AngleMinMax {
//        objectPickVM.getAngleMinMaxDic()[angleName] ?? ZeroValue.angleMinMax
//    }
    init(_ name: String) {
        showTilt = name.contains("ilting") ? true: false
    }
    
    var body: some View {
        let angleMinMax =
            objectPickVM.getAngleMinMaxDic()[angleName] ?? ZeroValue.angleMinMax
        let angleMax = angleMinMax.max.value
        let angleMin = angleMinMax.min.value
        if showTilt {
            //VStack {
//                Toggle("Tilt", isOn: $tiltToggle)
//                    .onChange(of: tiltToggle) { value in
//                        objectPickVM.setObjectOptionDictionary(
//                            ObjectOptions.tiltInSpace,
//                            tiltToggle)
//                        objectPickVM.setCurrentObjectByCreatingFromName(
//                            twinSitOnDictionary,
//                            [angleName:
//                                Measurement(value: tiltToggle ? 40.0: 0.0, unit: UnitAngle.degrees)] )
                    //}
                Slider(value: $sliderValue, in: angleMin...angleMax, step: 1.0)
                Text("tilt-in-space angle: \(Int(angleMax - sliderValue))")
                    .onChange(of: sliderValue) { newValue in
                        objectPickVM.setCurrentObjectByCreatingFromName(
                            twinSitOnDictionary,
                            [angleName:
                                Measurement(value: angleMax - sliderValue, unit: UnitAngle.degrees)] )
                       }
            //}
        } else {
                EmptyView()
            }
        }
    }


struct HeadSupport: View {
    @State private var headSuppportToggle = false
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
    let showTilt: Bool
    
    init(_ name: String) {
        showTilt = name.contains("ilting") ? true: false
    }
    
    var body: some View {
        if showTilt {
            Toggle("Headrest",isOn: $headSuppportToggle)
                .onChange(of: headSuppportToggle) { value in
                    let twinSitOnDictionary = twinSitOnVM.getTwinSitOnOptions()
                    //let name = objectPickVM.getCurrentObjectName()
                    objectPickVM.setObjectOptionDictionary(
                        ObjectOptions.headSupport,
                        headSuppportToggle)
                    objectPickVM.setCurrentObjectByCreatingFromName(
                        //name,
                        twinSitOnDictionary)
                    //.setCurrentObjectWithInitialOrEditedDictionary(
                       // name)
                    
                }
        } else {
            EmptyView()
        }
    }
}

struct DoubleSitOnPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}




struct TwinSitOnView: View {
    @State private var twinSitOnToggle: Bool
    
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
    
    let showTwinSitOn: Bool
    
    init(_ twinSitOnState: Bool, _ name: String) {
        
        showTwinSitOn =
            name.contains("wheelchair") ? true: false
        
        _twinSitOnToggle
            = State(initialValue: twinSitOnState)
    }
    
    var body: some View {
        if showTwinSitOn {
            Toggle("Two seats",isOn: $twinSitOnToggle)
                .onChange(of: twinSitOnToggle) { value in
                   
                    if !twinSitOnToggle {
                        
                        twinSitOnVM.setAllConfigurationFalse()
                        
                       // let name = objectPickVM.getCurrentObjectName()
                        let twinSitOnDictionary = twinSitOnVM.getTwinSitOnOptions()
                        objectPickVM
                            .setCurrentObjectByCreatingFromName(
                                //name,
                                twinSitOnDictionary)
                    }
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
                }
            
            let options: [TwinSitOnOption] = [.leftAndRight, .frontAndRear]
                        
            if twinSitOnToggle {
                ExclusiveToggles(
                    twinSitOnVM.getManyState(options), 
                    options,
                    .twinSitOn)
                

                
            }
            
        } else {
            EmptyView()
        }
    }
    
}
