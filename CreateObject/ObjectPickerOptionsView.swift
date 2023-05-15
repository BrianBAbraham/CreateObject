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
    let showRecline: Bool
    
    init(_ name: String) {
        showRecline = name.contains("air") ? true: false
    }
    
    var body: some View {
        if showRecline {
            Toggle("Reclining back",isOn: $reclineToggle)
                .onChange(of: reclineToggle) { value in
                    let name = objectPickVM.getCurrentObjectName()
                    objectPickVM.setObjectOptionDictionary(ObjectOptions.recliningBackSupport, reclineToggle) //RECLINE
                    objectPickVM.setCurrentObjectDictionary(name)
                    
                }
//                .preference(key: ReclinePreferenceKey.self, value: reclineToggle)
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




struct TwinSitOn: View {
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
                        
                        let name = objectPickVM.getCurrentObjectName()
                        
                        objectPickVM.setCurrentObjectDictionary(name)
                    }
                }
            
            let options = [TwinSitOnOption.leftAndRight, TwinSitOnOption.frontAndRear]
                        
            if twinSitOnToggle {
                ExclusiveToggles(
                    twinSitOnVM.getManyState(options), 
                    options,
                    .doubleSitOn)
            }
            
        } else {
            EmptyView()
        }
    }
    
}
