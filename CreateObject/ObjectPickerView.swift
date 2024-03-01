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

        Picker("Equipment",selection: boundObjectType ) {
            ForEach(objectNames, id:  \.self)
            { equipment in
                Text(equipment)
            }
        }
        .onChange(of: objectName) {tag in
            self.objectName = tag
            objectPickVM.setCurrentObjectName(tag)
            objectPickVM.resetObjectByCreatingFromName()
            objectEditVM.setChoiceOfPartToEdit(Part.mainSupport.rawValue)
        }
    }
}



struct PickPartEdit: View {
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @State private var selectedItem = Part.mainSupport.rawValue
    
    var body: some View {
        //object creation and etc use Part for
        //Part have to be unique and are not so friendly
        //MenuName are friendly and as only subsets are present
        //Names can such as front wheel can represent caster or fixed
        //also names can be object sensitive
        let menuItemsUsingPart = objectShowMenuVM.getOneOfAllEditablePartForObjectBeforeEdit()
        let menuItemsUsingMenuName = objectShowMenuVM.getOneOfAllEditablePartWithMenuNamesForObjectBeforeEdit()
        
        Picker("", selection: $selectedItem) {
                ForEach(menuItemsUsingMenuName, id: \.self) { item in
                    Text(item)
                }
            }
            .onChange(of: selectedItem) {oldValue, newValue in
                guard let index = menuItemsUsingMenuName.firstIndex(where: { $0 == selectedItem }) else {
                       fatalError("no index for part \(menuItemsUsingPart)")
                   }
                objectEditVM.setChoiceOfPartToEdit(menuItemsUsingPart[index])
            }
            .onChange(of: objectPickVM.getCurrentObjectName()) {
                selectedItem = Part.mainSupport.rawValue
            }
    }
}



struct ConditionalBilateralPartEditMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    var body: some View {
        let selectedPartToEdit = objectEditVM.getChoiceOfPartToEdit()
        if objectShowMenuVM.getPartIsOneOfAllBilateralPartForObjectBeforeEdit(selectedPartToEdit)  {
            BilateralPartEditView(selectedPartToEdit)
        } else {
            EmptyView()
        }
    }
}




struct ConditionalOnePartTwoDimensionValueMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    
    
    var body: some View {
        let selectedPartToEdit = objectEditVM.getChoiceOfPartToEdit()
        let showmMenu = objectShowMenuVM.getDoesPartHaveDimensionalPropertyMenu(selectedPartToEdit)
        if showmMenu  {
            HStack{
                DimensionPropertyPickerMenu( selectedPartToEdit)
                
                OnePartTwoDimensionValueMenu( selectedPartToEdit, selectedPartToEdit.rawValue)
            }
           
        } else {
            EmptyView()
        }
    }
}






struct ConditionalTiltMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel

    var body: some View {
        let selectedPartToEdit = objectEditVM.getChoiceOfPartToEdit()
        if [Part.sitOnTiltJoint].contains(selectedPartToEdit)  {
            TiltView(selectedPartToEdit)
        } else {
            EmptyView()
        }
    }
}

///edit park picker is an object dependant list
///the list is of every part that can be edited for that object
///every part which can be edited is linked to a specific part edit menu

//struct EditInitialObjectView: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//
//
//   
//   
//    var body: some View {
//        PickPartEdit()
//        .font(.callout)
//
//
//    }
//}

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
