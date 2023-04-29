//
//  ContentView.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import SwiftUI



//struct ObjectNameKey: EnvironmentKey {
//    static var defaultValue: String = "RearDriveWheelchair"
//}
//
//extension EnvironmentValues {
//    var objectName: String {
//        get {
//            self[ObjectNameKey.self]
//        }
//        set {
//            self[ObjectNameKey.self] = newValue
//        }
//    }
//}
//
//
//extension View {
//    func objectName( _ name: String) -> some View {
//
//        environment(\.objectName, name)
//
//    }
//}

struct OriginView: View {
    let originDictionary: [String: PositionAsIosAxes]
    
//    var originDictionaryValuesAsArray: [String: [PositionAsIosAxes]] {
//        DictionaryWithValue(originDictionary).asArray()
//    }
    var originDictionaryWithCGPointValues: [String: CGPoint] {
        DictionaryWithValue(originDictionary).asCGPoint()
    }
    
   var keys: [String] {
        originDictionaryWithCGPointValues.map {$0.key}
    }
    var values: [CGPoint] {
        originDictionaryWithCGPointValues.map {$0.value}
    }
    

    
    var body: some View {
        ForEach(0..<keys.count, id: \.self) {index in
            MyCircle(fillColor: .black, strokeColor: .black, 10, values[index])
        }
    }
}

struct MyCircle: View {
    let strokeColor: Color
    let fillColor: Color?
    let dimension: Double
    let position: CGPoint
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    init(fillColor: Color?, strokeColor: Color,  _ dimension: Double, _ position: CGPoint) {
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.dimension = dimension
        self.position = position
    }
    var body: some View {
        ZStack{
            if let fillColorUnwrapped = fillColor {
                ZStack{
                    Circle()
                        .fill(fillColorUnwrapped)
                        .modifier(CircleModifier( dimension: dimension, position: position))
                    Circle()
                        .fill(.black)
//                        .modifier(CircleModifier( dimension: dimension * (horizontalSizeClass == .compact ? 2:2), position: position))
                        .modifier(CircleModifier( dimension: 10, position: position))
                        .opacity(0.0001)
                }
            }
            Circle()
                .stroke(self.strokeColor)
                .modifier(CircleModifier( dimension: dimension, position: position))
        }
    }
}

struct CircleModifier: ViewModifier {
    let dimension: Double
    let position: CGPoint
    
    func body(content: Content) -> some View {
        content
            .frame(width: self.dimension, height: self.dimension)
            .position(self.position)
    }
}







/// add default to scene
/// add saved to scene
/// edit added
///







struct DefaultDictionaryAsList {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @State var defaultDictionaryAsList = [""]
    
   func getDefaultDictionaryAsList ()
    -> [String] {
        objectPickVM.getList(.useDefault)
    }
}



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
    @StateObject var cdVM = CoreDataViewModel()
   
    @State var savedDictionaryAsList =  [""]
    @State private var savedAsName: String = ""
    
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

    init(_ equipmentName: String) {
        self.equipmentName = equipmentName
        //UISegmentedControl.appearance().backgroundColor = .purple        //This will change the font size
//        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .caption2)], for: .highlighted)
//
//        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .footnote)], for: .normal)
        
        //print("INITATE CONTENT VIEW")
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
               // vm.getUniquePartNames(vm.getLoadedDictionary())
            }, label: {
                Text("save")
                    .foregroundColor(.blue)
            } )
            
            enterTextView
        }
        .padding()

    }
    
    var deleteAllButtonView: some View {
            Button(action: {
                cdVM.deleteAllObjects()
            }, label: {
                Text("delete all")
                    .foregroundColor(.blue)
            } )
    }
    
    
    var savedObjectDictionaryAsListButtonView: some View {
        VStack {
            deleteAllButtonView
            List {
                ForEach(cdVM.savedEntities) {entity in
                    Button {
                       savedDictionaryAsList  =
                        objectPickVM.getPartCornersFromPrimaryOriginDictionary(entity)
                        objectPickVM.setCurrentObjectName(entity.objectName ?? BaseObjectTypes.fixedWheelRearDrive.rawValue)
                    } label: {
                        HStack{
                            Text(entity.objectType ?? "")
                            Text(entity.objectName ?? "")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.primary)
                }
                .onDelete(perform: cdVM.deleteObject)
            }

        }

    }
    
    var uniquePartNames: [String] {
        objectPickVM.getUniquePartNamesFromObjectDictionary()
    }
    
    var uniquePartNamesAsListView: some View {
        VStack{
            Text(equipmentName)
            List{
                Section(header: Text("Dictionary")) {
                    ForEach (0..<uniquePartNames.count, id: \.self) { index in
                        Text("\( uniquePartNames[index])")
                    }
                }
            }
        }

    }
    
    var originDictionary: [String] {
        
        DictionaryInArrayOut().getNameValue( objectPickVM.getAllPartFromPrimaryOriginDictionary(),"test")
       
    }

    func saveData (_ objectName: String) {
                cdVM.addObject(
                    names: objectPickVM.getAllOriginNames(),
                    values: objectPickVM.getAllOriginValues(),
                    objectType: objectPickVM.getCurrentObjectName(),
                objectName: objectName)
                cdVM.fetchNames()
    }
    
    @Environment(\.managedObjectContext) private var viewContext
      @Environment(\.undoManager) private var undoManager
    //@State var isPresented = true
    @State var isActive = true
    @State var globalPosition: CGPoint? // = CGPoint(x: 0, y: 0)
    @State var position: CGPoint = .zero
    //let initialObjectPosition = globalPosition
    
    var body: some View {
    
        NavigationView {
            VStack {
                NavigationLink(destination:
                    VStack( spacing: -150) {
                    PickObjectView()
                    ObjectView(uniquePartNames)
                        .scaleEffect(0.5)
                    
                    }
                ) {
                    Text("Default equipment")
                    }

                NavigationLink(destination: savedObjectDictionaryAsListButtonView , isActive: self.$isActive ) {
                    Text("Saved equipment")
                        .font(isActive ? .headline:.body)
                }

                NavigationLink(destination:
                    VStack {
                    DemoExclusiveToggles()
                            ObjectView(uniquePartNames)
                                .onPreferenceChange(CustomPreferenceKey.self, perform: {value in
                                    self.globalPosition = value
                                })
                    //Text("x: \(Int(globalPosition.x))   y:\(Int(globalPosition.y))  ")
                    EditObjectMenuView()
                        saveButtonView
                    }
                ) {
                    Text("Edit equipment")
                }

                .onAppear{
                    viewContext.undoManager = undoManager
                 }

                NavigationLink(destination: ListView(equipmentName, currentObjectDictionaryAsList)){
                 Text("View current dictionary")
                }

                NavigationLink(destination: ListView(equipmentName, defaultObjectDictionaryAsList)){
                 Text("View default dictionary")
                }
                
                NavigationLink(destination: uniquePartNamesAsListView ) {
                    Text("View dictionary parts")
                }

                NavigationLink(destination: uniquePartNamesAsListView ) {
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
   
//
struct ContentView_Previews: PreviewProvider {
   // @StateObject var epVM: ObjectPickViewModel
//    @StateObject var partEditVM = PartEditViewModel()

    
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
