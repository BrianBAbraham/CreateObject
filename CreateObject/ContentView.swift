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



extension Double {
    func roundToNearest(_ increment: Double) -> Double {
        return (self / increment).rounded() * increment
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



//Content view mediates data between view models
//All data is requested from view models
//All data is passed to view models to set model
struct ContentView: View {

    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var coreDataVM: CoreDataViewModel
    @EnvironmentObject var sceneVM: SceneViewModel
    
    
    @State var isActive = true
    @State var globalPosition: CGPoint?
    @State var position: CGPoint = .zero
    @State private var staticPositionOnObject = CGPoint(x: 200, y: 500)
    @State private var initialOrigin: CGPoint?
    
    
    @State var savedDictionaryAsList =  [""]
    @State private var savedAsName: String = ""
    
    var currentObjectDictionaryAsList: [String] {
        objectPickVM.getList(.useCurrent)
    }

    var initialObjectDictionaryAsList: [String] {
        objectPickVM.getList(.useInitial)
    }
    
    var loadedObjectDictionaryAsList: [String] {
        objectPickVM.getList(.useLoaded)
    }
    
    var dimensionsAsList: [String] {
        objectPickVM.getList(.useDimension)
    }
    
    var equipmentName: String  {
        objectPickVM.getCurrentObjectName()
    }

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


    var currentDictionary: PositionDictionary {
        objectPickVM.getPostTiltOneCornerPerKeyDic()
    }
    
    var name: String {
        objectPickVM.getCurrentObjectName()
    }
    
    func saveData (_ objectName: String) {
                coreDataVM.addObject(
                    names: objectPickVM.getAllOriginNames(),
                    values: objectPickVM.getAllOriginValues(),
                    objectType: objectPickVM.getCurrentObjectName(),
                objectName: objectName)
                coreDataVM.fetchNames()
    }

    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.green.withAlphaComponent(0.05)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected )
       
    }
   
    
    var body: some View {
        let objectManipulationIsActive = true
        NavigationView {
            VStack {
                NavigationLink(destination:
                    ZStack{
                        ObjectView(
                            uniquePartNames,
                            objectManipulationIsActive,
                            initialOrigin: $initialOrigin)
                        .zIndex(1000.9)
                       VStack {
                            Spacer()
                           VStack (alignment: .leading) {
                              
                                HStack{
                                    PickInitialObjectView()
                                    Spacer()
                                    PickPartEdit()
                                }
                                .padding(.bottom)
                                
                                HStack{
                                    ConditionalBilateralPartSidePicker()
                                    ConditionalBilateralPartPresence()
                                    ConditionaUniPartPresence()
                                }
                               
                                ConditionalBilateralPartEditMenu()
                                    
                                ConditionalUniPartEditMenu()

                                ConditionalTiltMenu()
                            }
                            .padding(.horizontal)
                            .transition(.move(edge: .bottom))
                            .backgroundModifier()
                        }
                   }) {
                        Text("Default equipment")
                    }
//                Spacer()
//                UnitSystemSelectionView()
            }
            .navigationBarTitle("Equipment manager")
            
        }
    }
}


// PreferenceKey to store the initial origin of the child view
//struct InitialOriginPreferenceKey: PreferenceKey {
//    static var defaultValue: CGPoint?
//
//    static func reduce(value: inout CGPoint?, nextValue: () -> CGPoint?) {
//        if let nextValue = nextValue() {
//            value = nextValue
//        }
//    }
//}


   
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//      
//            ContentView("RearDriveWheelchair")
//                .previewLayout(.fixed(width:1000, height: 1000))
//                .environmentObject(ObjectPickViewModel())
//                .environmentObject(ObjectEditViewModel())
//                .environmentObject(SceneViewModel())
//        
//    }
//}


//struct ExclusiveToggles: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//
//    let toggleCases: [ObjectOptions]
//
//    let toggleFor: Toggles
//
//    @State var flags: [Bool]
//
//
//    init(_ optionStates: [Bool], _ toggleCases: [ObjectOptions], _ toggleFor: Toggles) {
//
//        self.toggleCases = toggleCases
//        _flags = State(initialValue: optionStates)
//        self.toggleFor = toggleFor
//    }
//
//    var body: some View {
//        ScrollView {
//            ForEach(flags.indices, id: \.self) { i in
//                ToggleItem(
//                    storage: self.$flags,
//                    tag: i,
//                    label: toggleCases[i].rawValue,
//                    toggleCases: toggleCases,
//                    toggleFor: toggleFor)
//                        .padding(.horizontal)
//            }
//        }
//    }
//}
//
//struct ExclusiveToggles: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
   // @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel

   // let toggleCases: [TwinSitOnOption]
    
//    let toggleFor: Toggles
//
//    @State var flags: [Bool]
//
    
//    init(_ optionStates: [Bool],
//         _ toggleCases: [TwinSitOnOption],
//         _ toggleFor: Toggles) {
//
//        self.toggleCases = toggleCases
//        _flags = State(initialValue: optionStates)
//        self.toggleFor = toggleFor
//
//
//
//    }
//
//    var body: some View {
//        HStack {
//            ForEach(flags.indices, id: \.self) { i in
//                ToggleItem(
//                    storage: self.$flags,
//                    tag: i,
//                    label: toggleCases[i].rawValue,
//                    toggleCases: toggleCases,
//                    toggleFor: toggleFor)
//                        .padding(.horizontal)
//            }
//        }
//    }
//}


//struct ToggleItem: View {
//    @Binding var storage: [Bool]
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//   // @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
//    var tag: Int
//    var label: String = ""
//    let toggleCases: [TwinSitOnOption]
//    let toggleFor: Toggles
//    
//    var body: some View {
//        
//
//        
//        
//        let isOn = Binding (get: { self.storage[self.tag] },
//            set: { value in
//            
//            for index in 0..<toggleCases.count {
//
//                let setOption = index == tag ? true: false
//
//                switch toggleFor {
//                case .twinSitOn:
//                    twinSitOnVM.setTwinSitOnToFalse(toggleCases[index], setOption)
//                    
//
//let twinSitOnOptions =
//twinSitOnVM.getTwinSitOnOptions()
//                    
//                
//objectPickVM.setCurrentObjectByCreatingFromName(
//    twinSitOnOptions)
//
//                    
//                case .sitOnPosition:
//                    twinSitOnVM.setTwinSitOnOption(
//                        toggleCases[index],
//                        setOption
//                    )
//                }
//            }
//
//                withAnimation {
//                    self.storage = self.storage.enumerated().map { $0.0 == self.tag }
//                }
//            })
//        return Toggle(label, isOn: isOn)
//    }
//
//}

//struct ToggleItem: View {
//    @Binding var storage: [Bool]
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
//    var tag: Int
//    var label: String = ""
//    let toggleCases: [ObjectOptions]
//    let toggleFor: Toggles
//
//    var body: some View {
//        let isOn = Binding (get: { self.storage[self.tag] },
//            set: { value in
//
//            for index in 0..<toggleCases.count {
//
//                let setOption = index == tag ? true: false
//
//                switch toggleFor {
//                case .doubleSitOn:
//                    objectPickVM.setObjectOptionDictionaryForDoubleSitOn(toggleCases[index], setOption)
//
//                    objectPickVM.setCurrentObjectDictionary(
//                        objectPickVM.getCurrentObjectName (),
//                        twinSitOnOptions: twinSitOnVM.getTwinSitOnOptions())
//
//                case .sitOnChoice:
//                    objectPickVM.setObjectOptionDictionary(
//                        toggleCases[index],
//                        setOption
//
//                    )
//                }
//            }
//
//                withAnimation {
//                    self.storage = self.storage.enumerated().map { $0.0 == self.tag }
//                }
//            })
//        return Toggle(label, isOn: isOn)
//    }
//
//}
struct ContentViewX: View {

    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
    @EnvironmentObject var coreDataVM: CoreDataViewModel
    @EnvironmentObject var sceneVM: SceneViewModel
    
    @State var isActive = true
    @State var globalPosition: CGPoint?
    @State var position: CGPoint = .zero
    @State private var staticPositionOnObject = CGPoint(x: 200, y: 500)
   
    @State var savedDictionaryAsList =  [""]
    @State private var savedAsName: String = ""
    
    var currentObjectDictionaryAsList: [String] {
        objectPickVM.getList(.useCurrent)
    }

    var initialObjectDictionaryAsList: [String] {
        objectPickVM.getList(.useInitial)
    }
    
    var loadedObjectDictionaryAsList: [String] {
        objectPickVM.getList(.useLoaded)
    }
    
    var dimensionsAsList: [String] {
        objectPickVM.getList(.useDimension)
    }
    
    var equipmentName: String  {
        objectPickVM.getCurrentObjectName()
    }

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


    var currentDictionary: PositionDictionary {
        objectPickVM.getPostTiltOneCornerPerKeyDic()
    }
    
    var name: String {
        objectPickVM.getCurrentObjectName()
    }
    
    func saveData (_ objectName: String) {
                coreDataVM.addObject(
                    names: objectPickVM.getAllOriginNames(),
                    values: objectPickVM.getAllOriginValues(),
                    objectType: objectPickVM.getCurrentObjectName(),
                objectName: objectName)
                coreDataVM.fetchNames()
    }


    @State private var initialOrigin: CGPoint?
    
    
   
    
    var body: some View {
       // PickSavedObjectView()
        //let frameSize = objectPickVM.getScreenFrameSize()
        let objectManipulationIsActive = true

        NavigationView {
            ZStack {
                NavigationLink(destination:
                    VStack{
                            PickInitialObjectView()
//                            AddToSceneView(objectPickVM.getPostTiltOneCornerPerKeyDic(), name)
                              //  .environmentObject(objectPickVM)
                            ObjectView(
                                uniquePartNames,
                                objectManipulationIsActive,
                                initialOrigin: $initialOrigin)
                    } )
                    { Text("Default equipment")
//                            .onTapGesture {
//                                print("hello")
//                            }
                    }

                
//                NavigationLink(destination:
//                                PickSavedObjectView()
//                                .environmentObject(objectPickVM)
//                                .environmentObject(coreDataVM)
//                              // , isActive: self.$isActive
//                )
//                    { Text("Saved equipment") }
                
                
//                NavigationLink(destination:
//                    VStack {
//                    Text( objectPickVM.getCurrentObjectName())
//                        ObjectView(
//                            uniquePartNames,
//                            name,
//                            objectManipulationIsActive
//                           )
//
//                    EditObjectMenuView()
//                    saveButtonView
//                    }
//                )
//                { Text("Edit equipment") }

                
                
//                NavigationLink(destination: ListView(equipmentName, currentObjectDictionaryAsList)){
//                 Text("View current dictionary")
//                }
//
//                NavigationLink(destination: ListView(equipmentName, initialObjectDictionaryAsList)){
//                 Text("View initial dictionary")
//                }
//
//                NavigationLink(destination: ListView(equipmentName, dimensionsAsList)){
//                 Text("View initial dimensions")
//                }
//
//
//                NavigationLink(destination: ListView(equipmentName, loadedObjectDictionaryAsList)){
//                 Text("View saved dictionary")
//                }
//
//                NavigationLink(destination: ListView(equipmentName, uniquePartNames) ) {
//                    Text("View dictionary parts")
//                }
//
//                NavigationLink(destination: ListView(equipmentName, uniquePartNames)) {
//                    Text("Settings")
//                }

            }
            .navigationBarTitle("Equipment manager")

        }
    }

}
