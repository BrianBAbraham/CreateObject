//
//  ObjectPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI

struct PickDefaultObjectView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    
    var objectNames: [String] {
        BaseObjectTypes.allCases.map{$0.rawValue}
    }

    @State private var equipmentType = BaseObjectTypes.fixedWheelRearDrive.rawValue
    
    var currentEqipmentType: String {
        getCurrentEquipmentType()
    }

    func getCurrentEquipmentType() -> String {
        BaseObjectTypes.fixedWheelRearDrive.rawValue
    }
    
    var body: some View {
        let boundEquipmentType = Binding(
            get: {objectPickVM.getCurrentObjectName()},
            set: {self.equipmentType = $0}
        )
        
        Picker("Equipment",selection: boundEquipmentType ) {
            ForEach(objectNames, id:  \.self)
                    { equipment in
                Text(equipment)
            }
        }
        .onChange(of: equipmentType) {tag in
            self.equipmentType = tag
            objectPickVM.setDefaultObjectDictionary(tag)
            objectPickVM.setCurrentObjectName(tag)
            objectPickVM.setCurrentObjectDictionary(tag)
        }
        
        .pickerStyle(.wheel)
        .scaleEffect(0.8)
    }
}

struct ObjectPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickDefaultObjectView()
            .environmentObject(ObjectPickViewModel())
    }
}

struct PickSavedObjectView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var coreDataVM: CoreDataViewModel
    var deleteAllButtonView: some View {
            Button(action: {
                coreDataVM.deleteAllObjects()
            }, label: {
                Text("delete all")
                    .foregroundColor(.blue)
            } )
    }
    
    var addToEditButtonView: some View {
            Button(action: {
                
            }, label: {
                Text("add to edit")
                    .foregroundColor(.blue)
            } )
    }
    
    var name: String {
        objectPickVM.getCurrentObjectName()
    }

    var uniquePartNames: [String] {
        objectPickVM.getUniquePartNamesFromLoadedDictionary()
    }
    
    var loadedDictionary: PositionDictionary {
        objectPickVM.getLoadedDictionary()
    }
    
    var body: some View {
        VStack {
            HStack {
                deleteAllButtonView
                Spacer()
             addToEditButtonView
                Spacer()
                AddToSceneView(loadedDictionary, name)
            }
            .padding()

            List {
                ForEach(coreDataVM.savedEntities) {entity in
                    Button {
                        objectPickVM.setLoadedDictionary(entity)
//                        let objectName =
//                        entity.objectName ?? BaseObjectTypes.fixedWheelRearDrive.rawValue
//                        objectPickVM.setCurrentObjectName(objectName)

                    } label: {
                        HStack{
                            Text(entity.objectType ?? "")
                            Text(entity.objectName ?? "")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.primary)
                }
                .onDelete(perform: coreDataVM.deleteObject)
            }
            
            ObjectView(uniquePartNames, loadedDictionary, name)
                .scaleEffect(0.25)
        }
    }
    
    
    
}
