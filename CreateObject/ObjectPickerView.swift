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

    @State private var objectName = ObjectTypes.fixedWheelRearDrive.rawValue
   
    
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
        let menuItems = objectShowMenuVM.getOneOfAllEditablePartForObjectBeforeEdit()
        let selectedPartToEdit = objectEditVM.getChoiceOfPartToEdit()
       // HStack {
           
            Picker("Edit", selection: $selectedItem) {
                ForEach(menuItems, id: \.self) { item in
                        Text(item)
                }
            }
            .onChange(of: selectedItem) {oldValue, newValue in
                objectEditVM.setChoiceOfPartToEdit(selectedItem)
            }
            .onChange(of: objectPickVM.getCurrentObjectName()) {
                selectedItem = Part.mainSupport.rawValue
            }
        //}
        //.padding(.horizontal)

//        ConditionalBilateralPartEditMenu(part: selectedPartToEdit)
//        
//
//        ConditionalOnePartTwoDimensionValueMenu(part: selectedPartToEdit)
//
//        ConditionalTiltMenu(part: selectedPartToEdit)
    }
}


struct ConditionalOnePartTwoDimensionValueMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    //let part: Part
    var body: some View {
        let selectedPartToEdit = objectEditVM.getChoiceOfPartToEdit()
        if [Part.mainSupport].contains(selectedPartToEdit)  {
            OnePartTwoDimensionValueMenu( selectedPartToEdit, selectedPartToEdit.rawValue)
        } else {
            EmptyView()
        }
    }
}

struct ConditionalBilateralPartEditMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    //let part: Part
    var body: some View {
        let selectedPartToEdit = objectEditVM.getChoiceOfPartToEdit()
        if [Part.footSupport, Part.armSupport, Part.assistantFootLever, Part.fixedWheelAtRear, Part.casterForkAtFront].contains(selectedPartToEdit)  {
            BilateralPartEditView(selectedPartToEdit)
        } else {
            EmptyView()
        }
    }
}

struct ConditionalTiltMenu: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
   // let part: Part
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

struct EditInitialObjectView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var coreDataVM: CoreDataViewModel
    @EnvironmentObject var sceneVM: SceneViewModel

    var objectNames: [String] {
        let unsortedObjectNames =
        ObjectChainLabel.dictionary.keys.map{$0.rawValue}
        
        return unsortedObjectNames.sorted()
    }

    @State private var objectName = ObjectTypes.fixedWheelRearDrive.rawValue
   
    var body: some View {
        
        
        
//        TabView {
//            if objectShowMenuVM.getShowMenuStatus(.footSupport) {
//                TiltView(.sitOnTiltJoint)
//                    .tabItem {
//                        Image(systemName: "figure.seated.side")
//                        Text("Tilt")
//                    }
//                
//            } else {
//                EmptyView()
//            }
//
//
//            
//            
//            if objectShowMenuVM.getShowMenuStatus(.footSupport) {
//                FootRelatedView()
//                    .tabItem {
//                        Image(systemName: "figure.kickboxing")
//                        Text("leg")
//                    }
//            } else {
//                EmptyView()
//            }
//
//            
//            HStack{
//                PartPresence(.fixedWheelAtRearWithPropeller)
//                PartPresence(.backSupportHeadSupport)
//               
//            }
//            .backgroundModifier()
//            .tabItem{
//                Image(systemName: "wrench.and.screwdriver")
//                Text("options")
//            }
//            
//            
//            if objectShowMenuVM.getShowMenuStatus(.sitOn) {
//                OnePartTwoDimensionValueMenu(.sitOn, "seat")
//                    .tabItem {
//                        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
//                        Text("support")
//                    }
//            } else {
//                EmptyView()
//            }
//            
//            
//            if objectShowMenuVM.getShowMenuStatus(.sideSupport) {
//                HStack{
//                }
//                .tabItem{
//                    Image(systemName: "figure.wave")
//                    Text("arm")}
//                
//            } else {
//                EmptyView()
//            }
//            
//            
//            
//            if objectShowMenuVM.getShowAnyMenuStatus([
//                .footSupport, .sideSupport, .fixedWheelAtRear]) {
//                HStack{
//                    
//                }
//                .tabItem{
//                    Image(systemName: "person.2.fill")
//                    Text("assist")}
//                
//            } else {
//            EmptyView()
//            }
//        }
        PickPartEdit()
        .font(.caption)
       // .frame(height: 200)
        .onAppear{
            objectName = objectPickVM.getCurrentObjectName()
        }

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
