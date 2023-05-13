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
        
        let doubleSitOnState = objectPickVM.getCurrentOptionThereAreDoubleSitOn()
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
                objectPickVM.setDefaultObjectDictionary(tag)
                objectPickVM.setCurrentObjectName(tag)
                objectPickVM.setCurrentObjectDictionary(tag)
                //objectPickVM.setObjectOptionDictionaryToAllFalse()
            }
            //.pickerStyle(.wheel)
            .scaleEffect(0.8)
            
            
            BackSupportRecline(objectPickVM.getCurrentObjectName())
//                .onPreferenceChange(ReclinePreferenceKey.self, perform: {value in
//                    self.recline = value
//                })
                .padding(.horizontal)
            
            DoubleSitOnOption(doubleSitOnState, objectPickVM.getCurrentObjectName())
//                .onPreferenceChange(DoubleSitOnPreferenceKey.self, perform: {value in
//                    self.recline = value
//                })
                .padding(.horizontal)
            
            

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
