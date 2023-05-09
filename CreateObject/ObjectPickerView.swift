//
//  ObjectPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI

struct PickDefaultObjectView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objecEditVM: ObjectEditViewModel
    @EnvironmentObject var coreDataVM: CoreDataViewModel
    @EnvironmentObject var sceneVM: SceneViewModel
    
    var objectNames: [String] {
        BaseObjectTypes.allCases.map{$0.rawValue}
    }

    @State private var equipmentType = BaseObjectTypes.fixedWheelRearDrive.rawValue
    
    @State private var recline = false
    //@State private var reclineToggle = false
    
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
        
        VStack {
            //Text(String(recline))
            BackSupportRecline(objectPickVM.getCurrentObjectName())
                .onPreferenceChange(ReclinePreferenceKey.self, perform: {value in
                    self.recline = value
                })
                .padding(.horizontal)
            
            
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
}

struct ReclinePreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct BackSupportRecline: View {
    @State private var reclineToggle = false
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    let showRecline: Bool
    
    init(_ name: String) {
        showRecline = name.contains("air") ? true: false
    }
    
    var body: some View {
        if showRecline {
            Toggle("Reclining back",isOn: $reclineToggle)
                .onChange(of: reclineToggle) { value in
                    let name = objectPickVM.getCurrentObjectName()
                    objectPickVM.setObjectOptionDictionary(ObjectOptions.recliningBackSupport, reclineToggle)
                    objectPickVM.setCurrentObjectDictionary(name)
                    
                }
                .preference(key: ReclinePreferenceKey.self, value: reclineToggle)
        } else {
            EmptyView()
        }
    }
}


//struct ObjectPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PickDefaultObjectView()
//            .environmentObject(ObjectPickViewModel())
//    }
//}

struct PickSavedObjectView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objecEditVM: ObjectEditViewModel
    @EnvironmentObject var coreDataVM: CoreDataViewModel
    @EnvironmentObject var sceneVM: SceneViewModel
    
//    init() {
//        print(type(of: objectPickVM))
//    }
    
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
            Text("\(objectPickVM.getCurrentObjectName())")
            ObjectView(uniquePartNames, loadedDictionary, name)
                .scaleEffect(0.25)
        }
 
    }

    
    
    
}
