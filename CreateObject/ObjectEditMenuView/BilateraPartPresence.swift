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
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectDataGetterVM: ObjectDataGetterViewModel
    let part: Part
 
    init (_ part: Part
    ) {
        self.part = part
       // print("\n BilateralPartPresence \(part.rawValue)\n")
    }
    
    var body: some View {

        let boundIsLeftSelected = Binding (
            get: {objectDataGetterVM.getSidesPresentGivenUserEditContainsLeft(part)},
            set: {   newvalue in
                   updateViewModelForLeftToggle(newvalue
                   )
            }
         )
        
        let boundIsRightSelected = Binding (
           get: {objectDataGetterVM.getSidesPresentGivenUserEditContainsRight(part)},
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
                    objectDataGetterVM.getSidesPresentGivenUserEditContainsRight(part),
                    part)
        
            objectPickVM.modifyObjectByCreatingFromName()
    }
    
    
    private func updateViewModelForLRightToggle(_  right: Bool
                                              
    ) {
            objectEditVM
                .changeOneOrTwoStatusOfPart(
                    objectDataGetterVM.getSidesPresentGivenUserEditContainsLeft(part),
                    right,
                    part)
        
            objectPickVM.modifyObjectByCreatingFromName()

    }
}
