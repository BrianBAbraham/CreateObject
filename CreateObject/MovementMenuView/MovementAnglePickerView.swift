//
//  MovementAnglePickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 20/07/2024.
//

import SwiftUI

struct MovementAnglePickerView: View {
    @EnvironmentObject var movementPickerVM: MovementPickerViewModel
    
    let menuItems = WhichAngle.allCases.map {
        $0.rawValue
    }
    
    
    var body: some View {
        HStack {
            ZStack {
                Picker(
                    "",
                    selection: $movementPickerVM.objectAngleName
                ) {
                    ForEach(
                        menuItems,
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
                
                DuplicatePickerText(name: movementPickerVM.objectAngleName)
            }
            //End work around

            Text("angle")
                .colorScheme(.light)
        }
    }
}
