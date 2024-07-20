//
//  MovementPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/04/2024.
//

import SwiftUI

struct MovementPickerView: View {
    @EnvironmentObject var movementPickVM: MovementPickerViewModel
  
    var body: some View {
      
        ZStack{
            Picker(
                "",
                selection: movementPickVM.binding
            ) {
                ForEach(
                    movementPickVM.menuItems,
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
            DuplicatePickerText(name: movementPickVM.movementName )
            //End work around
        }
    }
}


