//
//  MovementPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/04/2024.
//

import SwiftUI

struct MovementPickerView: View {
    @EnvironmentObject var movementPickerVM: MovementPickerViewModel
  
    var body: some View {
      
        ZStack{
            Picker(
                "",
                selection: movementPickerVM.binding
            ) {
                ForEach(
                    movementPickerVM.menuItems,
                    id: \.self
                ) { item in
                    Text(
                        item
                    )
                }
            }

            //Start work around: removes grey background from iPhone 13 mini
            //physical device
            .opacityAndScaleToHidePickerLabel()
            DuplicatePickerText(name: movementPickerVM.movementName )
            //End work around
        }
    }
}


