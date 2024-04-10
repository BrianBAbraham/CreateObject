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
        let showMenuStatus = objectShowMenuVM.getBilateralPresenceMenuStatus(part)
        if  showMenuStatus {
            BilateralPartPresence(part
        //                          , showMenuStatus
            )
        } else {
            EmptyView()
        }
    }
}


struct BilateralPartPresence: View {
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    let part: Part
 
    init (_ part: Part
    ) {
        self.part = part
       // print("\n BilateralPartPresence \(part.rawValue)\n")
    }
    
    var body: some View {

        let boundIsLeftSelected = Binding (
            get: {objectPickVM.getSidesPresentGivenUserEditContainsLeft(part,"bilateral presence")},
            set: {   newvalue in
                   updateViewModelForLeftToggle(newvalue
                   )
            }
         )
        
        let boundIsRightSelected = Binding (
           get: {objectPickVM.getSidesPresentGivenUserEditContainsRight(part,"bilateral presence")},
           set: {newvalue in
                   updateViewModelForLRightToggle(newvalue

                   )
           }
        )
        
        HStack {
            Toggle("", isOn: boundIsLeftSelected)

            Text("L")
         
            Toggle("", isOn: boundIsRightSelected)

            Text("R")
        }
    }
        

    private func updateViewModelForLeftToggle(_  left: Bool
    ) {

            objectEditVM
                .changeOneOrTwoStatusOfPart(
                    left,
                    objectPickVM.getSidesPresentGivenUserEditContainsRight(part,"bilateral"),
                    part)
        
            objectPickVM.modifyObjectByCreatingFromName()
    }
    
    
    private func updateViewModelForLRightToggle(_  right: Bool
                                              
    ) {
            objectEditVM
                .changeOneOrTwoStatusOfPart(
                    objectPickVM.getSidesPresentGivenUserEditContainsLeft(part,"bilateral"),
                    right,
                    part)
        
            objectPickVM.modifyObjectByCreatingFromName()

    }
}
