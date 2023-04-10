//
//  ContentView.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import SwiftUI




struct PartView: View {
    @EnvironmentObject var vm: ObjectPickViewModel
    @EnvironmentObject var partEditVM: PartEditViewModel
    let uniquePartName: String
    var partCornersDictionary: [String: [PositionAsIosAxes]] {
        vm.getPartNameAndItsCornerLocationsFromPrimaryOrigin(uniquePartName)
        
    }
    let onlyOneDictionaryMember = 0
    
    var partCorners: [CGPoint] {
        DictionaryElementIn(partCornersDictionary).cgPointsOut()
    }
    
    var partName: String {
        partCornersDictionary.map {$0.0}[onlyOneDictionaryMember]
    }
    
    var color: Color {
        
        partEditVM.getColorForPart(uniquePartName)

    }
  
    
    var body: some View {
      LocalOutlineRectangle.path(corners: partCorners, color)
        .onTapGesture {
            partEditVM.setCurrentPartToEditName(uniquePartName)
            
        }
    }

    //CGPoint(x: cornerLocation.x , y: cornerLocation.y)//    func localRectangle(_ manoeuvre: ChairManoeuvre.Movement, _ part: ChairManoeuvre.Part) -> some View {
//        ZStack{
//            LocalFilledRectangle.path(part.xLocal * scale
//                                ,part.yLocal * scale ,part.width * scale ,part.length * scale, partColor(), partOpacity())
//            LocalOutlineRectangle.path(part.xLocal * scale
//                                ,part.yLocal * scale,part.width * scale ,part.length * scale , partColor(), partOpacity())
//        }
//    }
//    func getCornerLocations() -> [CGPoint] {
//        var points: [CGPoint] = []
//        let cornerLocationsFromPrimaryOrigin = partCornersDictionary.map {$0.1}[onlyOneDictionaryMember]
//        for location in cornerLocationsFromPrimaryOrigin {
//            points.append(CGPoint(x: location.x , y: location.y))
//        }
//        return points
//    }
    
    

}


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


struct LocalOutlineRectangle {
    static func path(corners: [CGPoint], _ color: Color = .black) -> some View {
        
        ZStack {
            Path { path in
                path.move(to: corners[0])
                path.addLine(to: corners[1])
                path.addLine(to: corners[2])
                path.addLine(to: corners[3])
                path.closeSubpath()
            }
            .fill(color)
            .opacity(0.9)
            
            
            
            Path { path in
                path.move(to: corners[0])
                path.addLine(to: corners[1])
                path.addLine(to: corners[2])
                path.addLine(to: corners[3])
                path.closeSubpath()
            }
            .stroke(.black)
            
        }
        
//        func myPath(corners: [CGPoint], _ color: Color = .black)
//        -> some View { path in
//            path.move(to: corners[0])
//            path.addLine(to: corners[1])
//            path.addLine(to: corners[2])
//            path.addLine(to: corners[3])
//            path.closeSubpath()        }
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

    @EnvironmentObject var epVM: ObjectPickViewModel
    @StateObject var cdVM = CoreDataViewModel()
    @State var objectName = "RearDriveWheelchair"
    @State var savedDictionaryAsList =  [""]
    @State private var savedAsName: String = ""
    
    
    //@State var defaultDictionaryAsList = [""]
    var defaultDictionaryAsList: [String] {
        epVM.getList()
    }

    let equipmentName: String

    init(_ equipmentName: String) {
        self.equipmentName = equipmentName
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
                        epVM.getPartCornersFromPrimaryOriginDictionary(entity)
                        epVM.setCurrentObjectType(entity.objectName ?? BaseObjectTypes.fixedWheelRearDrive.rawValue)
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
        epVM.getUniquePartNamesFromObjectDictionary()
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
        
        DictionaryInArrayOut().getNameValue( epVM.getAllPartFromPrimaryOriginDictionary(),"test")
       
    }

    func saveData (_ objectName: String) {
                cdVM.addObject(
                    names: epVM.getAllOriginNames(),
                    values: epVM.getAllOriginValues(),
                    objectType: epVM.getCurrentObjectType(),
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
    
    //@State var isPresented = true
    @State var isActive = true
    var body: some View {
        

        NavigationView {
            VStack {
                NavigationLink(destination:
                                VStack( spacing: -150) {
                                PickObjectView()
                                ObjectView()
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
                            ObjectView()
                            EditObjectMenuView()
                        Spacer()
                        }
                        saveButtonView
                    }
                ) {
                    Text("Edit equipment")
                }

                NavigationLink(destination: defaultDictionaryAsListView ) {
                 Text("View dictionary")
                }
                NavigationLink(destination: uniquePartNamesAsListView ) {
                    Text("View dictionary parts")
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
                .environmentObject(PartEditViewModel())
           
        //}
        
    }
}
