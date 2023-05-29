//
//  ObjectView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI


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
   }
}

struct PartView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var partEditVM: ObjectEditViewModel
    let uniquePartName: String
    var dictionary: PositionDictionary
    var partCornersDictionary: [String: [PositionAsIosAxes]] {

        PartNameAndItsCornerLocations(
            uniquePartName,
                .forScreen,
            dictionary).dictionaryFromPrimaryOrigin
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
  
    var zPosition: Double {
        var z = 0.0
      
        if partName.contains(Part.armSupport.rawValue) {z = 9}
        if partName.contains(Part.footSupport.rawValue) {z = 0}
       if partName.contains(Part.sitOn.rawValue) {z = 3}
        if partName.contains("Joint") {z = 10}
        if partName.contains("heel") {z = 0}
    return z
    }
    
    var body: some View {
        
      LocalOutlineRectangle.path(corners: partCorners, color)
            .zIndex(zPosition)

        .onTapGesture {
            partEditVM.setCurrentPartToEditName(uniquePartName)
        }
    }
}


struct ObjectView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
    
    //@GestureState private var startLocation: CGPoint? = nil
    @GestureState private var fingerLocation: CGPoint? = nil
    @State private var location = CGPoint (x: 200, y: 200)
    
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom = 0.1
    private var maximimumZoom = 3.0
    
    let dictionary: PositionDictionary
    
//    var defaultDictionary: PositionDictionary {
//        objectPickVM.getRelevantDictionary(.forMeasurement)
//    }
    var objectOptionsDictionary: OptionDictionary {
        objectPickVM.getObjectOptionsDictionary()
    }
    
    
    var twinSitOnOptionsDictionary: TwinSitOnOptions {
        twinSitOnVM.getTwinSitOnOptions()  //TWIN
    }
    
    var defaultDictionary: PositionDictionary {
        CreateDefaultObjectInitiated(
            baseName: objectName,
            objectOptionsDictionary,
            twinSitOnOptionsDictionary)  //TWIN
        .dictionary
    }
    
    var defaultScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject(dictionary)
    }

    var measurementScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject(defaultDictionary)
    }
    
    var zoom: CGFloat {
        getZoom()
    }
    
    var uniquePartNames: [String]
    
    var objectName: String
    
    let objectManipulationIsActive: Bool
    
    init(
        _ names: [String],
        _ dictionary: PositionDictionary,
        _ objectName: String,
        _ objectManipulationIsActive: Bool = false) {
        uniquePartNames = names
        self.dictionary = dictionary
        self.objectName = objectName
        self.objectManipulationIsActive = objectManipulationIsActive
    }
    

    func limitZoom (_ zoom: CGFloat) -> CGFloat {
       max(min(zoom, maximimumZoom),minimumZoom)
    }
    
    func getZoom() -> CGFloat {
        let zoom =
        limitZoom( (0.2 + currentZoom + lastCurrentZoom) * defaultScale/measurementScale)
       
     return zoom
    }
        
//    var objectDrag: some Gesture {
//        DragGesture()
//            .onChanged { value in
//                var newLocation = startLocation ?? location // 3
//                newLocation.x += value.translation.width
//                newLocation.y += value.translation.height
//                self.location = newLocation
//            }.updating($startLocation) { (value, startLocation, transaction) in
//                startLocation = startLocation ?? location // 2
//            }
//    }
    

    
    var body: some View {
        let currentDictionary = objectPickVM.getCurrentObjectDictionary()
        
        let dictionaryForScreen =
            objectPickVM.getObjectDictionaryForScreen(currentDictionary)
        
        let frameSize =
            objectPickVM.getScreenFrameSize()
        
       // GeometryReader { reader in
        ZStack{
            ForEach(uniquePartNames, id: \.self) { name in
                PartView(
                    uniquePartName: name,
                    dictionary: dictionaryForScreen
                )
            }
        }

        //}
        .border(.red, width: 5)
        //.frame(width: frameSize.width, height: frameSize.length)
//        if objectManipulationIsActive {
            .modifier(
                ForObjectInDefaultView (
                    frameSize: frameSize, active: objectManipulationIsActive)
                )
//        } else {
//
//        }

            
        //.background(Color.red.opacity(0.3) )
        //.position(location)
//        .gesture(
//            objectDrag
//        )
        
        
        .scaleEffect(zoom)
        .gesture(MagnificationGesture()
        .onChanged { value in
            currentZoom = value - 1
        }
        .onEnded { value in
            lastCurrentZoom += currentZoom
            currentZoom = 0.0
            }
         )
    }
}

////////////
//extension CGRect {
//    var midPoint: CGPoint {
//        CGPoint(x: self.midX, y: self.midY)
//    }
//}

////////////////////////
//struct ObjectView_Previews: PreviewProvider {
    
//    let uniquePartNames: [String]
//    
//    init() {
//        let uniquePartNames = ["footSupportHangerSitOnVerticalJoint_id0_sitOn_id0", "footSupport_id1_sitOn_id0", "fixedWheel_id1_sitOn_id0", "footSupportHangerLink_id0_sitOn_id0", "armVerticalJoint_id0_sitOn_id0", "footSupportHorizontalJoint_id0_sitOn_id0", "arm_id1_sitOn_id0", "casterVerticalJointAtFront_id0_sitOn_id0", "footSupportHangerLink_id1_sitOn_id0", "fixedWheel_id0_sitOn_id0", "arm_id0_sitOn_id0", "sitOn_id0", "casterWheelAtFront_id0_sitOn_id0", "casterWheelAtFront_id1_sitOn_id0", "footSupportHangerSitOnVerticalJoint_id1_sitOn_id0", "footSupport_id0_sitOn_id0", "footSupportHorizontalJoint_id1_sitOn_id0", "armVerticalJoint_id1_sitOn_id0", "casterVerticalJointAtFront_id1_sitOn_id0"]
//    }
//    static var previews: some View {
//        ObjectView(
//
//            [""]
//
//            )
//    }
//}
