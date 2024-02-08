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
                    .stroke(Color.black, lineWidth: 5)
                    
            }
    }
}

struct PartView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var partEditVM: ObjectShowMenuViewModel
    let uniquePartName: String
    var preTiltFourCornerPerKeyDic: CornerDictionary
    var postTiltObjectToFourCornerPerKeyDic: CornerDictionary
    
    var color: Color {
        .white
       // partEditVM.getColorForPart(uniquePartName)
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

//        .onTapGesture {
//            partEditVM.setCurrentPartToEditName(uniquePartName)
//        }
    }
}


struct ObjectView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @GestureState private var fingerLocation: CGPoint? = nil
    @State private var location = CGPoint (x: 200, y: 200)
    
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    @Binding var initialOrigin: CGPoint?
    private var  minimumZoom = 0.1
    private var maximimumZoom = 3.0
   
      
    var postTiltOneCornerPerKeyDic: PositionDictionary {
        objectPickVM.getPostTiltOneCornerPerKeyDic()
    }

    var defaultScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject(postTiltOneCornerPerKeyDic)
    }

    var measurementScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject(postTiltOneCornerPerKeyDic)
    }
    
    var zoom: CGFloat {
        getZoom()
    }
    
    var uniquePartNames: [String]
    
    var objectName: String
    
    let objectManipulationIsActive: Bool
    
    var preTiltFourCornerPerKeyDic: CornerDictionary {
        objectPickVM.getPreTiltFourCornerPerKeyDic()
    }
    
   //let geometry: GeometryProxy
    
    init(
        _ names: [String],
        _ objectName: String,
        _ objectManipulationIsActive: Bool = false,
        initialOrigin: Binding<CGPoint?>) {
            
        uniquePartNames = names
        self.objectName = objectName
        self.objectManipulationIsActive = objectManipulationIsActive
            
                self._initialOrigin = initialOrigin
        
    }
    

    func limitZoom (_ zoom: CGFloat) -> CGFloat {
       max(min(zoom, maximimumZoom),minimumZoom)
    }
    
    func getZoom() -> CGFloat {
        let zoom =
        limitZoom( (0.2 + currentZoom + lastCurrentZoom) * defaultScale/measurementScale)
       
     return zoom
    }


    
    var body: some View {
        let dictionaryForScreen: CornerDictionary =
            objectPickVM.getObjectDictionaryForScreen()
        var originOffset: CGPoint{
            let value =
                objectPickVM.getOriginOffSet()
            return CGPoint(x: 0.0, y: -value.y)
        }
       
       // let originOffsetInGlobal = geometry.frame(in: .global).origin
        let frameSize =
            objectPickVM.getScreenFrameSize()
        
       // GeometryReader { reader in
        //VStack{
            ZStack{
                Text("\(Int(initialOrigin?.y ?? 0.0)) ")
                    .font(.system(size: 100))
                    .zIndex(10000)
                ForEach(uniquePartNames, id: \.self) { name in
                    PartView(
                        uniquePartName: name,
                        preTiltFourCornerPerKeyDic: preTiltFourCornerPerKeyDic,
                        postTiltObjectToFourCornerPerKeyDic: dictionaryForScreen)
                }
            }
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: InitialOriginPreferenceKey.self, value: geometry.frame(in: .global).origin)
            })
            .onPreferenceChange(InitialOriginPreferenceKey.self) { initialOrigin in
                if self.initialOrigin == nil {
                    self.initialOrigin = initialOrigin
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



//        GeometryReader { geometry in
//
//
//            let originOffsetInGlobal = geometry.frame(in: .global).origin
//            let frameSize =
//            objectPickVM.getScreenFrameSize()
//
//            let dictionaryForScreen: CornerDictionary =
//            objectPickVM.getObjectDictionaryForScreen()
//            var originOffset: CGPoint{
//                let value =
//                objectPickVM.getOriginOffSet()
//                return CGPoint(x: 0.0, y: -value.y)
//            }
//
//            ZStack{
//
//                ForEach(uniquePartNames, id: \.self) { name in
//                    PartView(
//                        uniquePartName: name,
//                        preTiltFourCornerPerKeyDic: preTiltFourCornerPerKeyDic,
//                        postTiltObjectToFourCornerPerKeyDic: dictionaryForScreen)
//                }
//            }
//            .border(.red, width: 5)
//            .modifier(
//                ForObjectInDefaultView (
//                    frameSize: frameSize, active: objectManipulationIsActive)
//            )
//
//            .offset(CGSize(width: originOffsetInGlobal.x, height: originOffsetInGlobal.y))
//            .scaleEffect(zoom)
//            .gesture(MagnificationGesture()
//                .onChanged { value in
//                    currentZoom = value - 1
//                }
//                .onEnded { value in
//                    lastCurrentZoom += currentZoom
//                    currentZoom = 0.0
//                }
//            )
//        }
