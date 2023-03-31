//
//  ContentView.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import SwiftUI



struct PartView: View {
    
    let partCornersDictionary: [String: [PositionAsIosAxes]]
    let onlyOneDictionaryMember = 0
    
    var partCorners: [CGPoint] {
        //getCornerLocations()
        
        DictionaryElementIn(partCornersDictionary).cgPointsOut()
    }
    
    var partName: String {
        partCornersDictionary.map {$0.0}[onlyOneDictionaryMember]
    }
    
    var color: Color {
        getColor()
    }
  
    
    var body: some View {
        LocalOutlineRectangle.path(corners: partCorners, color)
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
    
    
    func getColor() -> Color {
        var color: Color = .black
        
        
        if partName == Part.arm.rawValue {
            color = .green
        }
        if partName == Part.fixedWheel.rawValue {
            color = .orange
        }
        
        if partName == Part.footSupport.rawValue {
            color = .green
        }
        if partName == Part.sitOn.rawValue {
            color = .blue
        }
        
        if partName == Part.overHeadSupport.rawValue {
            color = .green
        }
        
        if partName.contains("caster") {
            color = .orange
        }
        if partName.contains("VerticalJoint") {
            color = .red
        }
        
        if partName.contains("HorizontalJoint") {
            color = .black
        }

        return color
    }
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
       Path { path in
           path.move(to: corners[0])
           path.addLine(to: corners[1])
           path.addLine(to: corners[2])
           path.addLine(to: corners[3])
           path.closeSubpath()
       }
//       .stroke(color)
    
       .fill(color)
       .opacity(0.9)
   }
}





/// add default to scene
/// add saved to scene
/// edit added
///




struct PickEquipmentView: View {
    @EnvironmentObject var vm: ObjectPickViewModel
    
    var objectNames: [String] {
        BaseObjectTypes.allCases.map{$0.rawValue}
    }
    
    
    @State private var equipmentType = BaseObjectTypes.fixedWheelRearDrive.rawValue//FixedWheelBase.Subtype.midDrive.rawValue
    
    var currentEqipmentType: String {
        getCurrentEquipmentType()
    }

    func getCurrentEquipmentType() -> String {
        //FixedWheelBase.Subtype.midDrive.rawValue
        BaseObjectTypes.fixedWheelRearDrive.rawValue
    }
    
    var body: some View {
        let boundEquipmentType = Binding(
            get: {vm.getCurrentObjectType()},
            set: {self.equipmentType = $0}
        )
        
        Picker("movements",selection: boundEquipmentType ) {
            ForEach(objectNames, id:  \.self)
                    { equipment in
                Text(equipment)
            }
           
        }
        .onChange(of: equipmentType) {tag in
            self.equipmentType = tag
//            modifyEquipmentType(tag.rawValue)
            vm.setCurrentObjectType(tag)
        }
    }

}


struct DefaultDictionaryAsList {
    @EnvironmentObject var vm: ObjectPickViewModel
    @State var defaultDictionaryAsList = [""]
    
   func getDefaultDictionaryAsList ()
    -> [String] {
        vm.getList()
    }
}

struct Object: View {
    
    @EnvironmentObject var vm: ObjectPickViewModel
    @State var defaultDictionaryAsList = [""]
    
    var uniquePartNames: [String] {
        vm.getUniquePartNamesFromObjectDictionary()
    }
    
        var addDefaultDictionaryButtonView: some View {
                Button(action: {
                    defaultDictionaryAsList =
                    vm.getList()
                }, label: {
                    Text("add")
                        .foregroundColor(.blue)
                } )
        }
    
    var body: some View {
        
        VStack {
        
            ZStack {
                ForEach(uniquePartNames, id: \.self) { name in
                    PartView(partCornersDictionary: vm.getPartNameAndItsCornerLocationsFromPrimaryOrigin(name))
                    
                }
                OriginView(originDictionary:  vm.getAllPartFromPrimaryOriginDictionary())
                MyCircle(fillColor: .red, strokeColor: .black, 40, CGPoint(x: 0, y:0))
            }
            .position(x: 1000, y: 500)
            .scaleEffect(0.2)
            
            
            PickEquipmentView()
                .padding()
            
//            addDefaultDictionaryButtonView
//                .padding()
        
        
        }
    }
}




struct ContentView: View {
    @EnvironmentObject var vm: ObjectPickViewModel
    @StateObject var cdVM = CoreDataViewModel()
    @State var objectName = "RearDriveWheelchair"
    @State var savedDictionaryAsList =  [""]
    //@State var defaultDictionaryAsList = [""]
    var defaultDictionaryAsList: [String] {
        vm.getList()
    }

    let equipmentName: String

    init(_ equipmentName: String) {
        self.equipmentName = equipmentName
print("INITATE CONTENT VIEW")
        }

    var saveButtonView: some View {
            Button(action: {
                saveData(equipmentName)
               // vm.getUniquePartNames(vm.getLoadedDictionary())
            }, label: {
                Text("save")
                    .foregroundColor(.blue)
            } )
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
            Text ("Saved equipment")
            deleteAllButtonView
            List {
                ForEach(cdVM.savedEntities) {entity in
                    Button {
                       savedDictionaryAsList  =
                        vm.getPartCornersFromPrimaryOriginDictionary(entity)
                        vm.setCurrentObjectType(entity.objectName ?? BaseObjectTypes.fixedWheelRearDrive.rawValue)
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
        vm.getUniquePartNamesFromObjectDictionary()
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
        
        DictionaryInArrayOut().getNameValue( vm.getAllPartFromPrimaryOriginDictionary(),"test")
       
    }

    func saveData (_ objectName: String) {
                cdVM.addObject(
                    names: vm.getAllOriginNames(),
                    values: vm.getAllOriginValues(),
                    objectType: vm.getCurrentObjectType(),
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
    
    var body: some View {
        NavigationView {
            VStack {
                
                NavigationLink(destination:  Object()) {
                    Text("Default equipment")
                }
 
                
                NavigationLink(destination: savedObjectDictionaryAsListButtonView ) {
                    Text("Saved equipment")
                }
                
                NavigationLink(destination: saveButtonView) {
                    Text("Edit equipment")
                }
                
                NavigationLink(destination: defaultDictionaryAsListView ) {
                 Text("View dictionary")
                }

                NavigationLink(destination: uniquePartNamesAsListView ) {
                    Text("View dictionary parts")
                }
                
            }
            .padding()
            
            

//
//                VStack {
//                    HStack {
//                        saveButtonView
//                            .padding()
//                        deleteAllButtonView
//                    }
//                    addSavedButtonView
//                    HStack{
//                        loadButtonView
//
//                    }
//
//                    HStack {
  
//                        List{
//                            Section(header: Text("Origins") ) {
//                                ForEach (0..<originDictionary.count, id: \.self) { index in
//                                    Text("\(originDictionary [index])")
//                                }
//                            }
//                        }
//                    }
//                }
            

                
                
           // }
            //.environmentObject(vm)
            .navigationBarTitle("Equipment")
        }
    }
}

   
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
