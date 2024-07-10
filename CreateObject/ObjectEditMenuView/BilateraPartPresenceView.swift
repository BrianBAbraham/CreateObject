//
//  SwiftUIView.swift
//  CreateObject
//
//  Created by Brian Abraham on 11/03/2024.
//

import SwiftUI





struct BilateralPartPresenceView: View {

    @EnvironmentObject var bilateralPartPresenceVM: BilateralPartPresenceViewModel

    var body: some View {
        if bilateralPartPresenceVM.showMenu {
            HStack {
                Toggle("", isOn: bilateralPartPresenceVM.leftBinding)
                
                Text("L")
                
                Toggle("", isOn: bilateralPartPresenceVM.rightBinding)
                
                Text("R")
            }
        } else {
            EmptyView()
        }
    }
}

