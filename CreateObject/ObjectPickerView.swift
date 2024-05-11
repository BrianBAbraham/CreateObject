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


struct DuplicatePickerText: View {
    let name: String
    var body: some View {
        Text(name)
            .allowsHitTesting(false)
            .foregroundColor(Color.blue)    }
}



struct PickPartEdit: View {
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
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
                .onChange(of: objectPickVM.getCurrentObjectType()) { oldValue, newValue in
                    //reset if new object
                    selectedMenuNameItem = PartToDisplayInMenu([Part.mainSupport], newValue).name
                }
                
                //Start work around: removes grey background from
                //iPhone 13 mini physical device
                .opacityAndScaleToHidePickerLabel()
                
                DuplicatePickerText(name: selectedMenuNameItem)
                //End work around
            }
            
            Text(Image(systemName: "scissors"))
                .colorScheme(.light)
        }
    }
    
    
    func resetForNewPartEdit(){
        //what to edit
        objectEditVM.setSideToEdit(.both)
        
        //what can be edited
        objectEditVM.setBothOrLeftOrRightAsEditible(.both)
    }
}

















//struct ObjectPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PickDefaultObjectView()
//            .environmentObject(ObjectPickViewModel())
//    }
//}

//struct PickSavedObjectView: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @EnvironmentObject var objecEditVM: ObjectEditViewModel
//    @EnvironmentObject var coreDataVM: CoreDataViewModel
//    @EnvironmentObject var sceneVM: SceneViewModel
//    
//
//    
//    var deleteAllButtonView: some View {
//            Button(action: {
//                coreDataVM.deleteAllObjects()
//            }, label: {
//                Text("delete all")
//                    .foregroundColor(.blue)
//            } )
//    }
//    
//    var addToEditButtonView: some View {
//            Button(action: {
//                
//            }, label: {
//                Text("add to edit")
//                    .foregroundColor(.blue)
//            } )
//    }
//    
//    var name: String {
//        objectPickVM.getCurrentObjectName()
//    }
//
//    var uniquePartNames: [String] {
//        objectPickVM.getUniquePartNamesFromLoadedDictionary()
//    }
//    
//    var loadedDictionary: PositionDictionary {
//        objectPickVM.getLoadedDictionary()
//    }
//    
//    var body: some View {
//        VStack {
//            HStack {
//                deleteAllButtonView
//                Spacer()
//                addToEditButtonView
//                Spacer()
//                AddToSceneView(loadedDictionary, name)
//            }
//            .padding()
//            
//            List {
//                ForEach(coreDataVM.savedEntities) {entity in
//                    Button {
//                        objectPickVM.setLoadedDictionary(entity)
//                        
//                    } label: {
//                        HStack{
//                            Text(entity.objectType ?? "")
//                            Text(entity.objectName ?? "")
//                        }
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    .foregroundColor(.primary)
//                }
//                .onDelete(perform: coreDataVM.deleteObject)
//            }
//            Text("\(objectPickVM.getCurrentObjectName())")
//            ObjectView(
//                uniquePartNames,
//                
//                name)
//            .scaleEffect(0.25)
//        }
//        
//    }
//    
//}
