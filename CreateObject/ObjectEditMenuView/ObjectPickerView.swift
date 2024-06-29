//
//  ObjectPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI


struct ObjectPickerView: View {
    @EnvironmentObject var objectPickerVM: ObjectPickerViewModel

    let objectNames: [String]  =
            ObjectChainLabel.sortedNames
    
    @State private var objectName: String =     ObjectDataService.shared.objectType.rawValue
    
    var body: some View {
        let boundObjectType = Binding(
            get: {objectPickerVM.objectName},
            set: {self.objectName = $0}
        )
     
        ZStack{
            Picker("Equipment",selection: boundObjectType ) {
                ForEach(objectNames, id:  \.self)
                { equipment in
                    Text(equipment)
                }
            }
            .onChange(of: objectName) {oldTag, newTag in
                self.objectName = newTag
               
                objectPickerVM.onChangeOfPicker(newTag)
            }
            //Start work around: removes grey background from iPhone 13 mini
            //physical device
            .opacityAndScaleToHidePickerLabel()
            DuplicatePickerText(name: objectName)
            //End work around
        }
    }
}


















