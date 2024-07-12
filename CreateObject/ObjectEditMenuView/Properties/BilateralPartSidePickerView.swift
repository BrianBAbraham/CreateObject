//
//  BilateralPartPicker.swift
//  CreateObject
//
//  Created by Brian Abraham on 11/03/2024.
//

import SwiftUI




struct BilateralPartSidePickerView: View {
    @EnvironmentObject var bilateralPartSidePickerVM: BilateralPartSidePickerViewModel
   
    var body: some View {

        if bilateralPartSidePickerVM.showMenu {
            Picker("", selection: bilateralPartSidePickerVM.binding//boundSideValue
            ) {
                ForEach(bilateralPartSidePickerVM.scopeOfEditForSide.asArray(), id: \.self) { side in
                    Text(side.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .colorScheme(.light)
            .fixedSize()
            //.padding(.top)
        } else {
            EmptyView()
        }

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
    
    func asArray() -> [SidesAffected] {
        switch self {
        case .both:
            return [.both, .left, .right]
        case .left:
            return [.left]
        case .right:
            return [.right]
        case .none:
            return [.none]
        }
    }
}
