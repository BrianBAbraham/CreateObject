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
    @EnvironmentObject var vm: ObjectPickViewModel
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
      LocalOutlineRectangle.path(corners: partCorners, color)
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
    @State private var location = CGPoint (x: 300, y: 300)
    
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom: Double {
        0.1
    }
    private var maximimumZoom = 3.0
    var zoom: CGFloat {
        limitZoom( 0.6 + currentZoom + lastCurrentZoom)
    }
    
    var uniquePartNames: [String]
    
    init( _ names: [String] ) {
        uniquePartNames = names
    }
    
    var dictionary: PositionDictionary {
        objectPickVM.getRelevantDictionary(.forScreen)
    }
    
    func limitZoom (_ zoom: CGFloat) -> CGFloat {
       return max(min(zoom, maximimumZoom),minimumZoom)
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
    
    var body: some View {

            ZStack {
                ForEach(uniquePartNames, id: \.self) { name in
                    PartView(
                        uniquePartName: name,
                        dictionary: dictionary
                    )
                }
            //OriginView(originDictionary:  vm.getAllPartFromPrimaryOriginDictionary())
            //MyCircle(fillColor: .red, strokeColor: .black, 40, CGPoint(x: 0, y:0))
            }
            .frame(width: sizeToEnsureObjectRemainsOnScreen , height: sizeToEnsureObjectRemainsOnScreen )
            .background(Color.white.opacity(0.0001) )
 
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



    }
}

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
