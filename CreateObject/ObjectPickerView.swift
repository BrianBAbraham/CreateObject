//
//  ObjectPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI

struct PickInitialObjectView: View {
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
        
        VStack {
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
            }
            .pickerStyle(DefaultPickerStyle())
        }
    }
}

struct PickPartEdit: View {
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @State private var selectedItem = "sitOn"

    var body: some View {
      let menuItems = objectShowMenuVM.getOneOfAllEditablePartForObjectBeforeEdit()

        HStack {
           // Text("edit part")
            Picker("", selection: $selectedItem) {
                ForEach(menuItems, id: \.self) { item in
                        Text(item)
                }
            }
           
            .pickerStyle(MenuPickerStyle())
           
            //.scaleEffect(0.8)
        }
        .padding(.horizontal)
//
            ConditionalBilateralPartEditView(part: Part(rawValue: selectedItem)!)
//
        ConditionalOnePartTwoDimensionValueMenu(part: Part(rawValue: selectedItem)!)
//
        if [Part.sitOnTiltJoint].contains(Part(rawValue: selectedItem)!)  {
            TiltView(Part(rawValue: selectedItem)!)
        } else {
            EmptyView()
        }
        
//        if [Part.sitOn].contains(menuItems[selectedItem])  {
//            OnePartTwoDimensionValueMenu(menuItems[selectedItem], Part.sitOn.rawValue)
//        } else {
//            EmptyView()


    }
}


struct ConditionalOnePartTwoDimensionValueMenu: View {
    let part: Part
    var body: some View {
        if [Part.sitOn].contains(part)  {
            OnePartTwoDimensionValueMenu( part, part.rawValue)
        } else {
            EmptyView()
        }
    }
}

struct ConditionalBilateralPartEditView: View {
    let part: Part
    var body: some View {
        if [Part.footSupport, Part.armSupport, Part.assistantFootLever].contains(part)  {
            BilateralPartEditView(part)
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
        .frame(height: 200)
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
