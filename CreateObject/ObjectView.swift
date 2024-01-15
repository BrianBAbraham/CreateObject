//
//  ObjectView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI


//struct LocalOutlineRectangle {
//    static func path(corners: [CGPoint], _ color: Color = .black) -> some View {
//        ZStack {
//            Path { path in
//                path.move(to: corners[0])
//                path.addLine(to: corners[1])
//                path.addLine(to: corners[2])
//                path.addLine(to: corners[3])
//                path.closeSubpath()
//            }
//            .fill(color)
//            .opacity(0.9)
//
//            Path { path in
//                path.move(to: corners[0])
//                path.addLine(to: corners[1])
//                path.addLine(to: corners[2])
//                path.addLine(to: corners[3])
//                path.closeSubpath()
//            }
//            .stroke(.black)
//        }
//   }
//}

struct LocalOutlineRectangle {
    static func path(corners: [CGPoint], _ color: Color = .black) -> some View {
        let cornerRadius = 30.0
        return
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius) // Adjust the cornerRadius as needed
                    .path(in: CGRect(
                        x: corners[0].x,
                        y: corners[0].y,
                        width: corners[2].x - corners[0].x,
                        height: corners[2].y - corners[0].y
                    ))
                    .fill(color)
                    .opacity(0.9)
                
                RoundedRectangle(cornerRadius: cornerRadius) // Adjust the cornerRadius as needed
                    .path(in: CGRect(
                        x: corners[0].x,
                        y: corners[0].y,
                        width: corners[2].x - corners[0].x,
                        height: corners[2].y - corners[0].y
                    ))
                    .stroke(Color.black)
            }
    }
}

struct PartView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var partEditVM: ObjectEditViewModel
    let uniquePartName: String
    var preTiltFourCornerPerKeyDic: CornerDictionary
    var postTiltObjectToFourCornerPerKeyDic: CornerDictionary
    
    var color: Color {
        partEditVM.getColorForPart(uniquePartName)
    }
    
    var dictionaryElementIn: DictionaryElementIn {
        DictionaryElementIn(postTiltObjectToFourCornerPerKeyDic, uniquePartName)
    }
    
    var partCorners: [CGPoint] {
        dictionaryElementIn.cgPointsOut()
    }
  
    var zPosition: Double {
        //ensures objects drawn in order of height
        dictionaryElementIn.maximumHeightOut()
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
    //@EnvironmentObject var twinSitOnVM: TwinSitOnViewModel
    
    //@GestureState private var startLocation: CGPoint? = nil
    @GestureState private var fingerLocation: CGPoint? = nil
    @State private var location = CGPoint (x: 200, y: 200)
    
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom = 0.1
    private var maximimumZoom = 3.0
   
    
  //MARK: - ALWAYS UNIT SCALE 
    
    var postTiltOneCornerPerKeyDic: PositionDictionary {
        objectPickVM.getPostTiltOneCornerPerKeyDic()
    }
    
    var defaultScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject(postTiltOneCornerPerKeyDic)
    }

    var measurementScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject(postTiltOneCornerPerKeyDic)
    }
    
    
//    var objectOptionsDictionary: OptionDictionary {
//        objectPickVM.getObjectOptionsDictionary()
//    }
    
    
//    var twinSitOnOptionsDictionary: TwinSitOnOptionDictionary {
//        twinSitOnVM.getTwinSitOnOptions()  //TWIN
//    }
    
    var zoom: CGFloat {
        getZoom()
    }
    
    var uniquePartNames: [String]
    
    var objectName: String
    
    let objectManipulationIsActive: Bool
    
    var preTiltFourCornerPerKeyDic: CornerDictionary {
        objectPickVM.getPreTiltFourCornerPerKeyDic()
    }
    init(
        _ names: [String],
        _ objectName: String,

        _ objectManipulationIsActive: Bool = false) {
            
        uniquePartNames = names
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
        let dictionaryForScreen: CornerDictionary =
            objectPickVM.getObjectDictionaryForScreen()
        //objectPickVM.getCurrentObjectDictionary()
        
//        let dictionaryForScreen =
//            objectPickVM.getObjectDictionaryForScreen(currentDictionary)
        
        let frameSize =
            objectPickVM.getScreenFrameSize()
        
       // GeometryReader { reader in
        //VStack{
            ZStack{
                ForEach(uniquePartNames, id: \.self) { name in
                    PartView(
                        uniquePartName: name,
                        preTiltFourCornerPerKeyDic: preTiltFourCornerPerKeyDic,
                        postTiltObjectToFourCornerPerKeyDic: dictionaryForScreen//,
                        //                    pretTiltObjectToAllPartCorner: pretTiltObjectToAllPartCorner
                    )
                }
            }
//            Text(String(Int(defaultScale/measurementScale)))
//                .font(.largeTitle)
//        }
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
        
        .offset(CGSize(width: 0, height:300))
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

