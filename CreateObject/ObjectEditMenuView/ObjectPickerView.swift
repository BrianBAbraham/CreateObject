//
//  ObjectPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI


struct PickInitialObjectView: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var coreDataVM: CoreDataViewModel
    @EnvironmentObject var sceneVM: SceneViewModel
    var objectNames: [String] {
        let unsortedObjectNames =
        ObjectChainLabel.dictionary.keys.map{$0.rawValue}
        
        return unsortedObjectNames.sorted()
    }
    @State private var objectName = DictionaryService.shared.currentObjectType.rawValue
    
    var body: some View {
        let boundObjectType = Binding(
            get: {objectPickVM.getCurrentObjectName()},
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
                objectEditVM.setPartToEdit(Part.mainSupport.rawValue)
                objectPickVM.setCurrentObjectName(newTag)
                objectPickVM.resetObjectByCreatingFromName()
                }
            //Start work around: removes grey background from iPhone 13 mini
            //physical device
            .opacityAndScaleToHidePickerLabel()
            DuplicatePickerText(name: objectName)
            //End work around
        }
    }
}


















