//
//  SwiftUIView.swift
//  CreateObject
//
//  Created by Brian Abraham on 11/03/2024.
//

import SwiftUI


struct ConditionalBilateralPartPresence: View {
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    var part: Part {
        objectEditVM.getPartToEdit()
    }
    
    var body: some View {
        if objectShowMenuVM.getBilateralPresenceMenuStatus(part) {
            BilateralPartPresence(part)
        } else {
            EmptyView()
        }
    }
}
struct BilateralPartPresence: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    let part: Part
    
    init (_ part: Part) {
        self.part = part
    }
    
    var body: some View {
        let boundIsLeftSelected = Binding (
            get: {objectPickVM.getSidesPresentGivenUserEditContainsLeft(part)},
            set: {newvalue in updateViewModelForLeftToggle(newvalue)
            }
         )
        
        let boundIsRightSelected = Binding (
           get: {objectPickVM.getSidesPresentGivenUserEditContainsRight(part)},
           set: {newvalue in updateViewModelForLRightToggle(newvalue)

           }
        )
        
        HStack {
            Toggle("", isOn: boundIsLeftSelected)

            Text("L")
         
            Toggle("", isOn: boundIsRightSelected)

            Text("R")
        }
    }

    private func updateViewModelForLeftToggle(_  left: Bool) {
        objectEditVM
            .changeOneOrTwoStatusOfPart(
                left,
                objectPickVM.getSidesPresentGivenUserEditContainsRight(part),
                part)
        objectPickVM.modifyObjectByCreatingFromName()
    }
    
    
    private func updateViewModelForLRightToggle(_  right: Bool) {
        objectEditVM
            .changeOneOrTwoStatusOfPart(
                objectPickVM.getSidesPresentGivenUserEditContainsLeft(part),
                right,
                part)
        objectPickVM.modifyObjectByCreatingFromName()
    }
}
