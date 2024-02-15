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
      // let dimensionValueToEdit = objectEditVM.getDimensionValueToBeEdited()
//        let boundObjectType = Binding(
//            get: {objectPickVM.getCurrentObjectName()},
//            set: {self.objectName = $0}
//        )
//        
        VStack {
           
            FootSupportPresence()
                .padding(.horizontal)
            
            if objectShowMenuVM.getShowMenuStatus(UserModifiers.legLength) {
                BiLateralPartWithOneValueChange(
                    .footSupportHangerLink,
                    "leg",
                    .dimension,
                    .length)
                .padding(.horizontal)
             
            } else {
                EmptyView()
            }
            
            HStack{
                ParttPresence(.fixedWheelAtRearWithPropeller)
                ParttPresence(.backSupportHeadSupport)
            }

            TiltView(.sitOnTiltJoint)

            
            if objectShowMenuVM.getShowMenuStatus(UserModifiers.supportWidth) {
                //HStack {
                    //DimensionSelection()
                    OnePartTwoDimensionValueMenu(.sitOn, "seat")
//                }
               // .padding(.horizontal)
            } else {
                EmptyView()
            }
           
                
        }
        .onAppear{objectName = objectPickVM.getCurrentObjectName()}
        .font(.caption)
       // .scaleEffect(0.8)
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
