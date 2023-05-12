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
                    objectPickVM.setObjectOptionDictionary(ObjectOptions.recliningBackSupport, reclineToggle)
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

struct DoubleSitOnOption: View {
    @State private var doubleSitOnToggle: Bool
    
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    
    let showDoubleSitOn: Bool
    
    init(_ doubleSitOnState: Bool, _ name: String) {
        
        showDoubleSitOn =
            name.contains("wheelchair") ? true: false
        
        _doubleSitOnToggle
            = State(initialValue: doubleSitOnState)
    }
    
    var body: some View {
        if showDoubleSitOn {
            Toggle("Two seats",isOn: $doubleSitOnToggle)
                .onChange(of: doubleSitOnToggle) { value in
                   
                    if !doubleSitOnToggle {
                        objectPickVM.setObjectOptionWithDoubleSitOn(false)
                        
                        let name = objectPickVM.getCurrentObjectName()
                        
                        objectPickVM.setCurrentObjectDictionary(name)
                    }
                }
            
                let options =
                [ObjectOptions.doubleSeatSideBySide, ObjectOptions.doubleSeatFrontAndRear]
                        
            if doubleSitOnToggle {
                ExclusiveToggles(
                    objectPickVM.getCurrentOptionState(options),
                    options)
            }
            
        } else {
            EmptyView()
        }
    }
    
}
