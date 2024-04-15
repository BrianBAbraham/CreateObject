//
//  MovementPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/04/2024.
//

import SwiftUI

struct MovementPickerView: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    
    @State private var selectedMenuNameItem: String = Movement.none.rawValue
    
    let menuItems = Movement.allCases.map {
        $0.rawValue
    }
    
    
    var body: some View {
        Picker(
            "",
            selection: $selectedMenuNameItem
        ) {
            ForEach(
                menuItems,
                id: \.self
            ) { item in
                Text(
                    item
                )
            }
        }
        .onChange(
            of: selectedMenuNameItem
        ) {
            oldValue,
            newValue in
            
            movementPickVM.updateMovement(
                to: newValue,
                origin: 500.0,
                startAngle: 0.0,
                endAngle: -90.0,
                forward: 0.0
            )
        }
    }
}

struct MovementPickerViewX: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    @State private var selectedMenuNameItem: String = Movement.none.rawValue
    let menuItems = Movement.allCases.map { $0.rawValue }
    
    // Binding to a Bool? which can trigger a reset
    @Binding var resetSelection: Bool?
    
    var body: some View {
        Picker("", selection: $selectedMenuNameItem) {
            ForEach(menuItems, id: \.self) { item in
                Text(item)
            }
        }
        .onChange(of: selectedMenuNameItem) { oldValue, newValue in
            movementPickVM.updateMovement(
                to: newValue,
                origin: 500.0,
                startAngle: 0.0,
                endAngle: 90.0,
                forward: 0.0
            )
        }
        .onChange(of: resetSelection) {_, _ in
            if resetSelection == true {
                selectedMenuNameItem = Movement.none.rawValue
                // Optionally reset the Boolean to nil after acting on it
                resetSelection = nil
            }
        }
    }
}

//
//#Preview {
//    MovementPickerView()
//}
