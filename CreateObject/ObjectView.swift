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
    var dictionary: PositionDictionary //{
//        vm.getRelevantDictionary(.forScreen)
//    }
    var partCornersDictionary: [String: [PositionAsIosAxes]] {
//        vm.getPartNameAndItsCornerLocationsFromPrimaryOrigin(
//            uniquePartName,
//            .forScreen)
        PartNameAndItsCornerLocations(
            uniquePartName,
                .forScreen,
            dictionary).dictionaryFromPrimaryOrigin
        
    }
    
//    var dictionaryForScreen: PositionDictionary {
//        objectPickVM.getRelevantDictionary(.forScreen)
//    }
    
//    var partDictionary: PositionDictionary {
//        SuccessivelyFilteredDictionary([uniquePartName, Part.corner.rawValue], dictionaryForScreen).dictionary
//    }
//
//    var partDimension: Dimension {
//        objectPickVM.getDimensionOfObject(partDictionary)
//    }
    
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
        partName.contains("Joint") ? 10: 0
    }
    
    var body: some View {
        //let frameSize = objectPickVM.getScreenFrameSize(dictionary)
        
      LocalOutlineRectangle.path(corners: partCorners, color)
            //.frame(width: partDimension.width, height: partDimension.length)
            .zIndex(zPosition)

        .onTapGesture {
            partEditVM.setCurrentPartToEditName(uniquePartName)
            
            //vm.getDimensionOfPart(uniquePartName)
            
        }
    }
}

struct ObjectView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @State var defaultDictionaryAsList = [""]
    
    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var fingerLocation: CGPoint? = nil
    @State private var location = CGPoint (x: 200, y: 200)
    
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    

    private var  minimumZoom: Double {
        0.1
    }
    private var maximimumZoom = 3.0
    
    var dictionary: PositionDictionary {
        objectPickVM.getRelevantDictionary(.forScreen)
    }
    
    var defaultDictionary: PositionDictionary {
        objectPickVM.getRelevantDictionary(.forMeasurement)
    }
    
    
    var defaultScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject(dictionary)
    }
    
    var offset: PositionAsIosAxes {
        objectPickVM.getOffset()    }
    
    var offsetCorrection: CGSize {
        CGSize(width: 0, height: offset.y  )
    }
    var measurementScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject(defaultDictionary)
    }
    
    var zoom: CGFloat {
        getZoom()
        //limitZoom( (0.1 + currentZoom + lastCurrentZoom) * defaultScale/measurementScale)
    }
    
    var uniquePartNames: [String]
    
    var dictionaryForScreen: PositionDictionary {
        objectPickVM.getRelevantDictionary(.forScreen)
    }
    
//    var partDictionary: PositionDictionary {
//        SuccessivelyFilteredDictionary([uniquePartName, Part.corner.rawValue], dictionaryForScreen).dictionary
//    }
//
//    var partDimension: Dimension {
//        objectPickVM.getDimensionOfObject(partDictionary)
//    }
   
    
    
    init( _ names: [String] ) {
        uniquePartNames = names
        
        
    }
    

    
    func limitZoom (_ zoom: CGFloat) -> CGFloat {
       return max(min(zoom, maximimumZoom),minimumZoom)
        
        
    }
    
    func getZoom() -> CGFloat {
        
        let zoom =
        limitZoom( (0.1 + currentZoom + lastCurrentZoom) * defaultScale/measurementScale)
       
     return zoom
        
    }
    
    
    var objectDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location // 3
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location // 2
            }
    }
    
 
    let sizeToEnsureObjectRemainsOnScreen = Screen.smallestDimension
    


//        var addDefaultDictionaryButtonView: some View {
//                Button(action: {
//                    defaultDictionaryAsList =
//                    vm.getList()
//                }, label: {
//                    Text("add")
//                        .foregroundColor(.blue)
//                } )
//        }
    ///The response to object orgin location change on edit of length is either ignore or
    ///set the frame size to the maximum permissible dimension and nither show withh border or fill with color so that the tap area is confined to the parts
    
    var body: some View {

        let frameSize = objectPickVM.getScreenFrameSize()
        
        
        GeometryReader { reader in
            ZStack {
                ForEach(uniquePartNames, id: \.self) { name in
                    PartView(
                        uniquePartName: name,
                        dictionary: dictionary
                           
                    )
//                .frame(
//                        width: objectPickVM.getDimensionOfObject(SuccessivelyFilteredDictionary([name, Part.corner.rawValue], dictionaryForScreen).dictionary).width,
//                        height: objectPickVM.getDimensionOfObject(SuccessivelyFilteredDictionary([name, Part.corner.rawValue], dictionaryForScreen).dictionary).length
//
//                    )
                }
                Spacer()
            }

//            .ignoresSafeArea(.all, edges: .all)
//            .preference(key: CustomPreferenceKey.self,
//                        value: reader.frame(in: .global).midPoint)
            }

            //.border(.red, width: 5)
            .frame(width: frameSize.width, height: frameSize.length)
            //.background(Color.red.opacity(0.3) )
            .position(location)
            .gesture(
                objectDrag
            )

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
//            .border(.red, width: 5)
    }
}

////////////
//extension CGRect {
//    var midPoint: CGPoint {
//        CGPoint(x: self.midX, y: self.midY)
//    }
//}

////////////////////////
struct ObjectView_Previews: PreviewProvider {
    
//    let uniquePartNames: [String]
//    
//    init() {
//        let uniquePartNames = ["footSupportHangerSitOnVerticalJoint_id0_sitOn_id0", "footSupport_id1_sitOn_id0", "fixedWheel_id1_sitOn_id0", "footSupportHangerLink_id0_sitOn_id0", "armVerticalJoint_id0_sitOn_id0", "footSupportHorizontalJoint_id0_sitOn_id0", "arm_id1_sitOn_id0", "casterVerticalJointAtFront_id0_sitOn_id0", "footSupportHangerLink_id1_sitOn_id0", "fixedWheel_id0_sitOn_id0", "arm_id0_sitOn_id0", "sitOn_id0", "casterWheelAtFront_id0_sitOn_id0", "casterWheelAtFront_id1_sitOn_id0", "footSupportHangerSitOnVerticalJoint_id1_sitOn_id0", "footSupport_id0_sitOn_id0", "footSupportHorizontalJoint_id1_sitOn_id0", "armVerticalJoint_id1_sitOn_id0", "casterVerticalJointAtFront_id1_sitOn_id0"]
//    }
    static var previews: some View {
        ObjectView(
     
            [""]

            )
    }
}
