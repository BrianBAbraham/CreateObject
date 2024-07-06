//
//  OriginPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 06/07/2024.
//

import Foundation
import SwiftUI



struct OriginPickerView: View {
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectDataGetterVM: ObjectDataGetterViewModel
    @EnvironmentObject var originPickerVM: OriginPickerViewModel

    var partOrLinkedPartForOrigin: Part {
        PartsRequiringLinkedPartUse(originPickerVM.partToEdit).partForOriginEdit
    }
    var partOrLinkedPartForShow: Part {
        PartsRequiringLinkedPartUse(originPickerVM.partToEdit).partForEditableOrigin
    }
   
    var body: some View {
        
        if originPickerVM.editableOriginExist {
            
          
            Picker("", selection: originPickerVM.originPropertyBinding) {
                ForEach(originPickerVM.editableOrigin, id: \.self) { property in
                            Text(property.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .colorScheme(.light)
                    .disabled(originPickerVM.doNotShow)
        } else {
            EmptyView()
        }
        
    }
}
