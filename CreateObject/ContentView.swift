//
//  ContentView.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import SwiftUI
import UIKit

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


struct EditMovementView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    @EnvironmentObject var recenterVM: RecenterViewModel
    var recenterPosition: CGPoint = CGPoint(x: 100, y: 350)
    @State private var uniqueKey = 0
    
    var body: some View {
        let movementName = movementPickVM.getMovementType().rawValue
        var postTiltOneCornerPerKeyDic: PositionDictionary {
            let dic =
            movementPickVM.getPostTiltOneCornerPerKeyDic()
            
            return dic
        }
        
        var preTiltFourCornerPerKeyDic: CornerDictionary {
            movementPickVM.getPostTiltObjectToPartFourCornerPerKeyDic()
        }

        var objectFrameSize: Dimension {
                movementPickVM.onScreenMovementFrameSize
        }
        
        var movement: Movement {
            movementPickVM.getMovementType()
        }
        var startAngle: Double {
            movementPickVM.getStartAngle()
        }
        
        
        VStack {
            //Object Menu
            VStack{
                ObjectRulerRecenter()
                
                ObjectAndRulerView(
                    movementPickVM.uniquePartNames,
                    preTiltFourCornerPerKeyDic,
                    movementPickVM.movementDictionaryForScreen,
                    objectFrameSize,
                    movement,
                    DisplayStyle.movement
                )
                .position(recenterPosition)
                .onChange(of: recenterVM.getRecenterState()) {
                    uniqueKey += 1
                }
                .id(uniqueKey)//ensures redraw
            }
           
            
            //Edit Menu
            VStack(spacing: 5 ){
                MovementPickerView(movementName)
                HStack {
                    AnglePickerView()
                       
                    AngleSetter(setAngle: movementPickVM.setObjectAngle)
                    Spacer()
                }
                .opacity(!movementPickVM.getObjectIsTurning() ? 0.3: 1.0)
                .disabled(!movementPickVM.getObjectIsTurning())
                
                HStack{
                    Spacer()
                    Text("turn tightness")
                        .foregroundColor(movement == .turn ? .primary : .gray)
                        .colorScheme(.light)
                    
                    OriginSetter(
                        setValue: movementPickVM.modifyStaticPointUpdateInX,
                        label: "origin X"
                    )
                    
                    Spacer()
                }
                .disabled(!movementPickVM.getObjectIsTurning())
            }
            .backgroundModifier()
            .transition(.move(edge: .bottom))
        }
    }
}



//Content view mediates data between view models
//All data is requested from view models
//All data is passed to view models to set model
struct ContentView: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    init(){
        
        //make segemented picker buttons brigher green when picked
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.green.withAlphaComponent(0.2)
        
        
        //Control the appearance of the navigation back button view
        let appearance = UINavigationBarAppearance()
       // appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 14)]
        appearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 18)]
        appearance.backgroundColor = .green
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.2)// Or any other color
        appearance.buttonAppearance.normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 12)]
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
  
    var body: some View {
        var preTiltFourCornerPerKeyDic: CornerDictionary {
            movementPickVM.getPostTiltObjectToPartFourCornerPerKeyDic()
        }
        
        NavigationView {
            VStack {
                
                
                NavigationLink(destination:
                    EditEquipmentView(
                        movementPickVM.uniquePartNames,
                        preTiltFourCornerPerKeyDic,
                        movementPickVM.movementDictionaryForScreen,
                        movementPickVM.onScreenMovementFrameSize,
                        movementPickVM.movementType
                    )
                )
                {Text("select-edit equipment")
                }
                .padding()
                  
                
                
                NavigationLink(destination:  EditMovementView() ) {
                    Text("edit movements")
                }
                
                
 
                NavigationLink(destination: Text("in development") ) {
                    Text("import plan from photos")}
                    .padding()
                
                Spacer()
                
                UnitSystemSelectionView()
            }
            .navigationBarTitle("main menu", displayMode: .inline)
           
        }
    }
}


enum DisplayStyle {
    case movement
    case edit
}

//
//struct Test: View {
//    @State private var sliderValue: CGFloat = 0
//    
//    var body: some View {
//        VStack {
//            Slider(value: $sliderValue, in: 0...100)
//            GeometryReader { geo in
//                Text("Move me!")
//                    .frame(width: 100 + sliderValue, height: 100)
//                    .background(Color.blue)
//                    .preference(key: CGFloatPreferenceKey.self, value: sliderValue)
//            }
//          
//        }
//        .padding()
//    }
//}
           
//struct CGFloatPreferenceKey: PreferenceKey {
//    
//    static var defaultValue: CGFloat = 0.0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//       print("activated")
//        value = nextValue()
//    }
//}
//                               
//struct ObjectGeometryPreferenceKey: PreferenceKey {
//    
//    static var defaultValue = CGRect(x: 10, y: 10, width: 100, height: 100)
//    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
//       // print("activated")
//        value = nextValue()
//    }
//}


struct EditEquipmentView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var recenterVM: RecenterViewModel
    @EnvironmentObject var movementPickVM: MovementPickViewModel
   
    var recenterPosition: CGPoint = CGPoint(x:100, y:400)
    @State private var uniqueKey = 0
    
    let uniquePartNames: [String]
    let preTiltFourCornerPerKeyDic: CornerDictionary
    let dictionaryForScreen: CornerDictionary
    let objectFrameSize: Dimension
    let movement: Movement
    
    
    init(
        _ partNames: [String],
        _ preTiltFourCornerPerKeyDic: CornerDictionary,
        _ dictionaryForScreen: CornerDictionary,
        _ objectFrameSize: Dimension,
        _ movement: Movement
    ) {
            uniquePartNames = partNames
        self.preTiltFourCornerPerKeyDic = preTiltFourCornerPerKeyDic
        self.dictionaryForScreen = dictionaryForScreen
        self.objectFrameSize = objectFrameSize
        self.movement = movement
        
        
// DictionaryInArrayOut().getNameValue(preTiltFourCornerPerKeyDic
//                                        ).forEach{print($0)}
        }
    var body: some View {
        let objectType = objectPickVM.getCurrentObjectType()
        let movementName = movementPickVM.getMovementType().rawValue
        ZStack{
            ObjectAndRulerView(
                uniquePartNames,
                preTiltFourCornerPerKeyDic,
                dictionaryForScreen,
                objectFrameSize,
                movement,
                DisplayStyle.edit
            )
            .position(recenterPosition)
            .onChange(of: recenterVM.getRecenterState()) {
                uniqueKey += 1
            }
            .id(uniqueKey)//ensures redraw
            
     
            VStack {
                ObjectRulerRecenter()
                Spacer()
                
                ZStack{
                        VStack (alignment: .leading) {
                        
                        HStack{
                            MovementPickerView(movementName)
                            PickInitialObjectView()
                            PickPartEdit(objectType)
                        }
                        
                        HStack{
                            ConditionalBilateralPartSidePicker()
                            ConditionalBilateralPartPresence()
                            ConditionaUniPartPresence()
                        }
                        
                        ConditionalPartMenu()
                        
                        ConditionalTiltMenu()
                        
                        }
                    }
                    .padding(.horizontal)
                    .backgroundModifier()
                    .transition(.move(edge: .bottom))
            }
        }
    }
}



   
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
//struct ContentViewX: View {
//
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @EnvironmentObject var objectShowMenuVM: ObjectShowMenuViewModel
//    @EnvironmentObject var coreDataVM: CoreDataViewModel
//    @EnvironmentObject var sceneVM: SceneViewModel
//    
//    @State var isActive = true
//    @State var globalPosition: CGPoint?
//    @State var position: CGPoint = .zero
//    @State private var staticPositionOnObject = CGPoint(x: 200, y: 500)
//   
//    @State var savedDictionaryAsList =  [""]
//    @State private var savedAsName: String = ""
//    
//    var currentObjectDictionaryAsList: [String] {
//        objectPickVM.getList(.useCurrent)
//    }
//
//    var initialObjectDictionaryAsList: [String] {
//        objectPickVM.getList(.useInitial)
//    }
//    
//    var loadedObjectDictionaryAsList: [String] {
//        objectPickVM.getList(.useLoaded)
//    }
//    
//    var dimensionsAsList: [String] {
//        objectPickVM.getList(.useDimension)
//    }
//    
//    var equipmentName: String  {
//        objectPickVM.getCurrentObjectName()
//    }
//
//    var enterTextView: some View {
//        VStack(alignment: .leading) {
//            TextField(equipmentName, text: $savedAsName)
//                .textFieldStyle(.roundedBorder)
//        }
//    }
//
//    var saveButtonView: some View {
//        HStack{
//            Button(action: {
//                saveData(equipmentName + "_" + savedAsName)
//            }, label: {
//                Text("save")
//                    .foregroundColor(.blue)
//            } )
//            enterTextView
//        }
//        .padding()
//    }
//       
//    var uniquePartNames: [String] {
//        objectPickVM.getUniquePartNamesFromObjectDictionary()
//    }
//
//
//    var currentDictionary: PositionDictionary {
//        objectPickVM.getPostTiltOneCornerPerKeyDic()
//    }
//    
//    var name: String {
//        objectPickVM.getCurrentObjectName()
//    }
//    
//    func saveData (_ objectName: String) {
//                coreDataVM.addObject(
//                    names: objectPickVM.getAllOriginNames(),
//                    values: objectPickVM.getAllOriginValues(),
//                    objectType: objectPickVM.getCurrentObjectName(),
//                objectName: objectName)
//                coreDataVM.fetchNames()
//    }
//
//
//    @State private var initialOrigin: CGPoint?
//    
//    
//   
//    
//    var body: some View {
       // PickSavedObjectView()
        //let frameSize = objectPickVM.getScreenFrameSize()
//        let objectManipulationIsActive = true
//
//        NavigationView {
//            ZStack {
//                NavigationLink(destination:
//                    VStack{
//                            PickInitialObjectView()
//                            AddToSceneView(objectPickVM.getPostTiltOneCornerPerKeyDic(), name)
                              //  .environmentObject(objectPickVM)
//                            ObjectView(
//                                uniquePartNames,
//                                objectManipulationIsActive
                            //    ,
                              //  initialOrigin: $initialOrigin
//                            )
//                    } )
//                    { Text("Default equipment")
//                            .onTapGesture {
//                                print("hello")
//                            }
//                    }

                
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

//            }
//            .navigationBarTitle("Equipment manager")
//
//        }
//    }
//
//}
