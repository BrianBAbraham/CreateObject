//
//  AllArcWithStaticPointView.swift
//  CreateObject
//
//  Created by Brian Abraham on 30/04/2024.
//

import Foundation
import SwiftUI

struct AllArcWithStaticPointView: View {
    @EnvironmentObject var vm: AllArcWithStaticPointViewModel
    var dictionaryForScreen: CornerDictionary {
        vm.movementDictionaryForScreen
    }
    var body: some View {
        
        if vm.movementType == .turn {
                
            ForEach(vm.staticPointModel) {staticPointModel in
                StaticPointView(
                    position: vm.staticPointDictionary[staticPointModel.name] ?? [ZeroValue.iosLocation]
                )
                .zIndex(5000)
                               
                ForEach(vm.arcDataModels) {arcDataModel in
                    ArcView(
                        arcDataModel.arcData,
                        dictionaryForScreen[staticPointModel.name] ?? [ZeroValue.iosLocation]
                    )
                }
            }
            
        }
    }
}
