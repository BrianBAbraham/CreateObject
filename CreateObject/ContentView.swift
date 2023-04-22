//
//  ContentView.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import SwiftUI







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
    @EnvironmentObject var vm: ObjectPickViewModel
    @State var defaultDictionaryAsList = [""]
    
   func getDefaultDictionaryAsList ()
    -> [String] {
        vm.getList()
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





struct ContentView: View {

    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @StateObject var cdVM = CoreDataViewModel()
    @State var objectName = "RearDriveWheelchair"
    @State var savedDictionaryAsList =  [""]
    @State private var savedAsName: String = ""
    
    var defaultDictionaryAsList: [String] {
        objectPickVM.getList()
    }

    let equipmentName: String

    init(_ equipmentName: String) {
        self.equipmentName = equipmentName
        UISegmentedControl.appearance().backgroundColor = .purple        //This will change the font size
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
            //Text ("Saved equipment")
            deleteAllButtonView
            List {
                ForEach(cdVM.savedEntities) {entity in
                    Button {
                       savedDictionaryAsList  =
                        objectPickVM.getPartCornersFromPrimaryOriginDictionary(entity)
                        objectPickVM.setCurrentObjectType(entity.objectName ?? BaseObjectTypes.fixedWheelRearDrive.rawValue)
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
                    objectType: objectPickVM.getCurrentObjectType(),
                objectName: objectName)
                cdVM.fetchNames()
    }
    


    
    var defaultDictionaryAsListView: some View {
        VStack{
            Text(equipmentName)
            List{
                Section(header: Text("Dictionary")) {
                    ForEach (0..<defaultDictionaryAsList.count, id: \.self) { index in
                        Text("\(defaultDictionaryAsList[index])")
                    }
                }
            }
        }

    }
    
    //let sizeToEnsureObjectRemainsOnScreen = Screen.smallestDimension
    @Environment(\.managedObjectContext) private var viewContext
      @Environment(\.undoManager) private var undoManager
    //@State var isPresented = true
    @State var isActive = true
    var body: some View {
        

        NavigationView {
            VStack {
                NavigationLink(destination:
                                VStack( spacing: -150) {
                                PickObjectView()
                                ObjectView(uniquePartNames)
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
                    HStack {
                            ObjectView(uniquePartNames)

                                EditObjectMenuView()
                        Spacer()
                        }
                        saveButtonView
                    }
                ) {
                    Text("Edit equipment")
                }
                
                .onAppear{
                    viewContext.undoManager = undoManager
                 }

                NavigationLink(destination: defaultDictionaryAsListView ) {
                 Text("View dictionary")
                }
                
                NavigationLink(destination: uniquePartNamesAsListView ) {
                    Text("View dictionary parts")
                }
                
                NavigationLink(destination: uniquePartNamesAsListView ) {
                    Text("Settings")
                }
                
            }
            .navigationBarTitle("Equipment manager")
            //.navigationViewStyle(StackNavigationViewStyle())
        }
        
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
