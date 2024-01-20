//
//  ObjectPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI

struct PickInitialObjectView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objecEditVM: ObjectEditViewModel
    @EnvironmentObject var coreDataVM: CoreDataViewModel
    @EnvironmentObject var sceneVM: SceneViewModel
   
    var objectNames: [String] {
        let unsortedObjectNames =
        ObjectChainLabel().dictionary.keys.map{$0.rawValue}
        
        return unsortedObjectNames.sorted()
    }

    @State private var equipmentType = ObjectTypes.fixedWheelRearDrive.rawValue
    @State private var recline = false
    
    var currentEqipmentType: String {
        getCurrentEquipmentType()
    }

    func getCurrentEquipmentType() -> String {
        ObjectTypes.fixedWheelRearDrive.rawValue
    }
    
    var body: some View {
        let boundEquipmentType = Binding(
            get: {objectPickVM.getCurrentObjectName()},
            set: {self.equipmentType = $0}
        )
        
        VStack {
            Picker("Equipment",selection: boundEquipmentType ) {
                ForEach(objectNames, id:  \.self)
                        { equipment in
                    Text(equipment)
                }
            }
            .onChange(of: equipmentType) {tag in

                self.equipmentType = tag
                objectPickVM.setCurrentObjectName(tag)
                
                objectPickVM.resetObjectByCreatingFromName()
            }
            .pickerStyle(DefaultPickerStyle())
           
            
            FootSupport()
                .padding(.horizontal)
            HStack{
                HeadSupport()
                    .padding(.horizontal)
                Propeller()
                    .padding(.horizontal)
            }
            TiltX()
                .padding(.horizontal)
            
            SeatWidth()
                .padding(.horizontal)
        }
        .scaleEffect(0.8)
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
