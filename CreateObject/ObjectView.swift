//
//  ObjectView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI



struct LocalOutlineRectangle {
    static func path(
        corners: [CGPoint],
        _ color: Color,
        _ cornerRadius: Double,
        _ opacity: Double,
        _ lineWidth: Double
    ) -> some View {
    
    return
        ZStack {
            RoundedRectangle(
                cornerRadius: cornerRadius
            ) // Adjust the cornerRadius as needed
            .path(
                in: CGRect(
                    x: corners[0].x,
                    y: corners[0].y,
                    width: corners[2].x - corners[0].x,
                    height: corners[2].y - corners[0].y
                )
            )
            .fill(
                color
            )
            .opacity(
                opacity
            )
            
            RoundedRectangle(
                cornerRadius: cornerRadius
            ) // Adjust the cornerRadius as needed
            .path(
                in: CGRect(
                    x: corners[0].x,
                    y: corners[0].y,
                    width: corners[2].x - corners[0].x,
                    height: corners[2].y - corners[0].y
                )
            )
            .stroke(
                Color.black,
                lineWidth: lineWidth
            )
                    
        }
    }
}

struct PartView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var partEditVM: ObjectShowMenuViewModel
    let partToEdit: Part
    let uniquePartName: String
    var preTiltFourCornerPerKeyDic: CornerDictionary
    var postTiltObjectToFourCornerPerKeyDic: CornerDictionary
    
//    var color: Color {
//        .white
       // partEditVM.getColorForPart(uniquePartName)
//    }
    let fillColor: Color
    let cornerRadius: Double
    let opacity: Double
    let lineWidth: Double
    var dictionaryElementIn: DictionaryElementIn {
        DictionaryElementIn(
            postTiltObjectToFourCornerPerKeyDic,
            uniquePartName
        )
    }
    
    var partCorners: [CGPoint] {
        dictionaryElementIn.cgPointsOut()
    }
    
    var zPosition: Double {
        //ensures objects drawn in order of height
        dictionaryElementIn.maximumHeightOut()
    }
    
    init(
        uniquePartName: String,
        preTiltFourCornerPerKeyDic: CornerDictionary,
        postTiltObjectToFourCornerPerKeyDic: CornerDictionary,
        color: Color = .white,
        cornerRadius: Double = 30.0,
        opacity: Double = 0.9,
        lineWidth: Double = 5.0,
        _ partToEdit: Part
 
    ){
        self.partToEdit = partToEdit
        self.uniquePartName = uniquePartName
        self.preTiltFourCornerPerKeyDic = preTiltFourCornerPerKeyDic
        self.postTiltObjectToFourCornerPerKeyDic = postTiltObjectToFourCornerPerKeyDic
        fillColor = getColor()
        self.cornerRadius = cornerRadius
        self.opacity = opacity
        self.lineWidth = lineWidth
        //print("\(uniquePartName) ")
        
        func getColor() -> Color {
            if color == .white { // only change undefined colors, let ruler color remain
                if UniqueToGeneralName(uniquePartName).generalName.contains(partToEdit.rawValue) {
                    return .red
                } else {
                    return .white}
            } else {
                return color
            }
        }
    }
    
    
    var body: some View {
        LocalOutlineRectangle.path(
            corners: partCorners,
            fillColor,
            cornerRadius,
            opacity,
            lineWidth
        )
        .zIndex(
            zPosition
        )

//        .onTapGesture {
//            partEditVM.setCurrentPartToEditName(uniquePartName)
//        }
    }
}





struct ObjectView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var rulerVM: RulerViewModel
   // @EnvironmentObject var recenter: RecenterViewModel
    @GestureState private var fingerLocation: CGPoint? = nil
    @State private var location = CGPoint (x: 200, y: 0)
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom = 0.1
    private var maximimumZoom = 1.0
    
    
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
    
    var objectName: String {
        objectPickVM.getCurrentObjectName()
    }
    
    let objectManipulationIsActive: Bool
    
    var preTiltFourCornerPerKeyDic: CornerDictionary {
        objectPickVM.getPreTiltFourCornerPerKeyDic()
    }
    
    init(
        _ names: [String],
        _ objectManipulationIsActive: Bool = false
      
    ) {
            uniquePartNames = names
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
    
    var body: some View {
        let dictionaryForScreen: CornerDictionary =
        objectPickVM.getObjectDictionaryForScreen()
        let objectFrameSize =
        objectPickVM.getObjectOnScreenFrameSize()
        
        ZStack{
            
            ZStack{
                ForEach(uniquePartNames, id: \.self) { name in
                    PartView(
                        uniquePartName: name,
                        preTiltFourCornerPerKeyDic: preTiltFourCornerPerKeyDic,
                        postTiltObjectToFourCornerPerKeyDic: dictionaryForScreen,
                        objectEditVM.partToEdit
                    )
                }
            }
            .border(.red, width: 2)
            .modifier(
                ForObjectDrag (
                    frameSize: objectFrameSize, active: objectManipulationIsActive)
            )
            .position(x: 0.0, y: -300)
            .offset(CGSize(width: 0, height: objectPickVM.getOffsetToKeepObjectOriginStaticInLengthOnScreen()
                           ) )
        }
    }
}
