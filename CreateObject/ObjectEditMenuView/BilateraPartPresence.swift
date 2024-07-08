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
    @EnvironmentObject var partOriginAndDimensionEditViewModel: PartOriginAndDimensionEditViewModel
//    var part: Part {
//        objectEditVM.getPartToEdit()
//    }
    
    var body: some View {
        let part = partOriginAndDimensionEditViewModel.partToEdit
        let showMenuStatus = objectShowMenuVM.getBilateralPresenceMenuStatus(part)
        if  showMenuStatus {
            BilateralPartPresenceView(
            )
        } else {
            EmptyView()
        }
    }
}



struct BilateralPartPresenceView: View {

    @EnvironmentObject var bilateralPartPresenceVM: BilateralPartPresenceViewModel

    var body: some View {
        
        HStack {
            Toggle("", isOn: bilateralPartPresenceVM.leftBinding)

            Text("L")
         
            Toggle("", isOn: bilateralPartPresenceVM.rightBinding)

            Text("R")
        }
    }
}
