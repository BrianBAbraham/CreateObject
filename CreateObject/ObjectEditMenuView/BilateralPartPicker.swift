//
//  BilateralPartPicker.swift
//  CreateObject
//
//  Created by Brian Abraham on 11/03/2024.
//

import SwiftUI

struct ConditionalBilateralPartSidePicker: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    var body: some View {
        let partToEdit = objectEditVM.getPartToEdit()
        if objectShowMenuVM.getSidePickerMenuStatus(partToEdit)  {
            BilateralPartSidePicker()
        } else {
            EmptyView()
        }
    }
}
struct BilateralPartSidePicker: View {
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
   
    var body: some View {
        var allCurrentOptionsForSidesAffected: [SidesAffected]{
            objectEditVM.getScopeOfEditForSide()
        }
        let boundSideValue = Binding(
            get: {
                objectEditVM.getChoiceOfEditForSide()},
            set: {
                newValue in
                objectEditVM.setSideToEdit(newValue)
            } )
        
        Picker("", selection: boundSideValue
        ) {
            ForEach(allCurrentOptionsForSidesAffected, id: \.self) { side in
                Text(side.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .colorScheme(.light) 
        .fixedSize()
        //.padding(.top)
    }
}
enum SidesAffected: String, CaseIterable, Equatable {
    case both = "L&R"
    case left = "L"
    case right = "R"
    case none = "none"
    
    
    func getOneId() -> PartTag {
        switch self {
        case .both:
            return .id0
        case .left:
            return .id0
        case .right:
            return .id1
        case .none:
            fatalError("sides required but none exists")
        }
    }
}
