//
//  PartPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import SwiftUI

struct PartPickerView: View {
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var partPickerVM: PartPickerViewModel
    @State private var selectedMenuNameItem: String
    let useIndexZeroForInitialSelectedMenuNameItemToAvoidDisplayLookUp = 0
    var objectType: ObjectTypes

    
    init(_ objectType: ObjectTypes) {
        // as displayed names are object sensitive for the same part
        // eg the mainSupport is a seat for wheelchair but a top for stretcher
        // objectType must be accessed to determine displayed part name
        // it is injected in
        self.objectType = objectType
        let menuDisplayDefaultName = PartToDisplayInMenu([Part.mainSupport], objectType).name
        _selectedMenuNameItem = State(initialValue: menuDisplayDefaultName )
    }
    var body: some View {
        //object creation and etc use Part for
        //Part have to be unique and names are not menu friendly
        //MenuName are friendly and as only subsets are present
        //Names can such as front wheel can represent caster or fixed
        //also names can be object sensitive
        let menuItemsUsingPart = objectShowMenuVM.getOneOfAllEditablePartForObjectBeforeEdit()
        let menuItemsUsingDisplayName: [String] = objectShowMenuVM.getOneOfAllEditablePartWithMenuNamesForObjectBeforeEdit()
        
        HStack{
    
            ZStack {
                
                Picker("", selection: $selectedMenuNameItem) {
                    ForEach(menuItemsUsingDisplayName, id: \.self) { item in
                        Text(item)
                    }
                }
                .onChange(of: selectedMenuNameItem) {oldValue, newValue in
                    
                    let index = menuItemsUsingDisplayName.firstIndex(where: { $0 == selectedMenuNameItem }) ??
                    useIndexZeroForInitialSelectedMenuNameItemToAvoidDisplayLookUp
                    
                    objectEditVM.setPartToEdit(menuItemsUsingPart[index])
                    
                    resetForNewPartEdit()
                }
                .onChange(of: partPickerVM.objectType) { oldValue, newValue in
                    //reset if new object
                    selectedMenuNameItem = PartToDisplayInMenu([Part.mainSupport], newValue).name
                }
                
                //Start work around: removes grey background from
                //iPhone 13 mini physical device
                .opacityAndScaleToHidePickerLabel()
                
                DuplicatePickerText(name: selectedMenuNameItem)
                //End work around
            }
//            
//            Text(Image(systemName: "scissors"))
//                .colorScheme(.light)
        }
    }
    
    
    func resetForNewPartEdit(){
        //what to edit
        //objectEditVM.setSideToEdit(.both)
        
        partPickerVM.setSideToEdit(.both)
        
        //what can be edited
        partPickerVM.setBothOrLeftOrRightAsEditible(.both)
    }
}
