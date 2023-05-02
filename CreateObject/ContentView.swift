//
//  ContentView.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import SwiftUI


struct EnterTextView: View {
    @State private var name: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            TextField("", text: $name)
            //Text("Hello, \(name)!")
        }
    }
}


struct ListView: View {
    
    let equipmentName: String
    let list: [String]
    
    init(
        _ equipmentName: String,
        _ list: [String]) {
            self.equipmentName = equipmentName
            self.list = list
        }
    
    var body: some View {
        VStack{
            Text(equipmentName)
            List{
                Section(header: Text("Dictionary")) {
                    ForEach (0..<list.count, id: \.self) { index in
                        Text("\(list[index])")
                    }
                }
            }
        }
    }
}


struct ContentView: View {

    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objecEditVM: ObjectEditViewModel
    @EnvironmentObject var coreDataVM: CoreDataViewModel
    @EnvironmentObject var sceneVM: SceneViewModel
    
    @State var isActive = true
    @State var globalPosition: CGPoint?
    @State var position: CGPoint = .zero
   
    @State var savedDictionaryAsList =  [""]
    @State private var savedAsName: String = ""
    
    init(_ equipmentName: String) {
        self.equipmentName = equipmentName
        }
    
    var currentObjectDictionaryAsList: [String] {
        objectPickVM.getList(.useCurrent)
    }

    var defaultObjectDictionaryAsList: [String] {
        objectPickVM.getList(.useDefault)
    }
    
    var loadedObjectDictionaryAsList: [String] {
        objectPickVM.getList(.useLoaded)
    }
    
    
    let equipmentName: String

    var enterTextView: some View {
        VStack(alignment: .leading) {
            TextField(equipmentName, text: $savedAsName)
                .textFieldStyle(.roundedBorder)
        }
    }

    var saveButtonView: some View {
        HStack{
            Button(action: {
                saveData(equipmentName + "_" + savedAsName)
            }, label: {
                Text("save")
                    .foregroundColor(.blue)
            } )
            enterTextView
        }
        .padding()
    }
       
    var uniquePartNames: [String] {
        objectPickVM.getUniquePartNamesFromObjectDictionary()
    }

    var originDictionary: [String] {
        DictionaryInArrayOut().getNameValue( objectPickVM.getAllPartFromPrimaryOriginDictionary(),"test")
    }

    func saveData (_ objectName: String) {
                coreDataVM.addObject(
                    names: objectPickVM.getAllOriginNames(),
                    values: objectPickVM.getAllOriginValues(),
                    objectType: objectPickVM.getCurrentObjectName(),
                objectName: objectName)
                coreDataVM.fetchNames()
    }


   
    
    var body: some View {
    
        NavigationView {
            VStack {
                NavigationLink(destination: SceneView()){
                 Text("Scene")
                }
                
                NavigationLink(destination:
                    VStack( spacing: -150) {
                 
                    PickDefaultObjectView()
                    ObjectView(uniquePartNames)
                        .scaleEffect(0.5)
                    AddToSceneView()
                    }
                ) {
                    Text("Default equipment")
                    }
                
                
                NavigationLink(destination: PickSavedObjectView() , isActive: self.$isActive ) {
                    Text("Saved equipment")
                        .font(isActive ? .headline:.body)
                }

                
                NavigationLink(destination:
                    VStack {
                    Text( objectPickVM.getCurrentObjectName())
                    //DemoExclusiveToggles()
                    ObjectView(uniquePartNames)
                        .onPreferenceChange(CustomPreferenceKey.self, perform: {value in
                            self.globalPosition = value
                        })
                    
                    EditObjectMenuView()
                    saveButtonView
                    }
                ) {
                    Text("Edit equipment")
                }

                NavigationLink(destination: ListView(equipmentName, currentObjectDictionaryAsList)){
                 Text("View current dictionary")
                }

                NavigationLink(destination: ListView(equipmentName, defaultObjectDictionaryAsList)){
                 Text("View default dictionary")
                }
                
                NavigationLink(destination: ListView(equipmentName, loadedObjectDictionaryAsList)){
                 Text("View saved dictionary")
                }
                
                NavigationLink(destination: ListView(equipmentName, uniquePartNames) ) {
                    Text("View dictionary parts")
                }

                NavigationLink(destination: ListView(equipmentName, uniquePartNames)) {
                    Text("Settings")
                }

            }
            .navigationBarTitle("Equipment manager")
        }
        
    }
  
}
   
struct CustomPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}
   
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       // VStack {
            ContentView("RearDriveWheelchair")
                .previewLayout(.fixed(width:1000, height: 1000))
                .environmentObject(ObjectPickViewModel())
                .environmentObject(ObjectEditViewModel())
           
        //}
        
    }
}
struct DemoExclusiveToggles: View {
    let toggleNames = ["foot support distance", "overall width", "rear distance"]
   
    @State var flags = Array(repeating: false, count: 3)
    
    var body: some View {
        ScrollView {
            ForEach(flags.indices, id: \.self) { i in
                ToggleItem(storage: self.$flags, tag: i, label: toggleNames[i] + " edit")
                    .padding(.horizontal)
            }
        }
    }
}

struct ToggleItem: View {
    @Binding var storage: [Bool]
    var tag: Int
    var label: String = ""

    var body: some View {
        let isOn = Binding (get: { self.storage[self.tag] },
            set: { value in
                withAnimation {
                    self.storage = self.storage.enumerated().map { $0.0 == self.tag }
                }
            })
        return Toggle(label, isOn: isOn)
    }
}
