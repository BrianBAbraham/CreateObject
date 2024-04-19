//
//  ObjectView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI

struct LocalOutlineRectangleX: View {
    var corners: [CGPoint]
    var color: Color
    var opacity: Double
    var lineWidth: Double

    func path(corners: [CGPoint]) -> Path {
        var path = Path()
        
        guard corners.count > 1 else { return path }
        
        path.move(to: corners.first!) // Start from the first point
        
        // Draw lines to the rest of the points
        for corner in corners.dropFirst() {
            path.addLine(to: corner)
        }
        
        path.closeSubpath() // Connect the last point back to the first one
        
        return path
    }

    var body: some View {
        ZStack {
            path(corners: corners)
                .fill(color)
                .opacity(opacity)
            
            path(corners: corners)
                .stroke(Color.black, lineWidth: lineWidth)
        }
    }
}

struct LocalOutlineRectangle: View {
    var corners: [CGPoint]
    var color: Color
    var opacity: Double
    var lineWidth: Double
    var cornerRadius: CGFloat

    private func path(corners: [CGPoint], cornerRadius: CGFloat) -> Path {
        var path = Path()
        
        guard corners.count >= 3 else { return path }
        
        let distances = corners.indices.map { index -> CGFloat in
            let nextIndex = (index + 1) % corners.count
            return distance(corners[index], corners[nextIndex])
        }
        
        var adjustedPoints: [CGPoint] = []
        
        for i in corners.indices {
            let prevIndex = (i - 1 + corners.count) % corners.count
            let nextIndex = (i + 1) % corners.count
            
            let prevSegmentLength = min(cornerRadius, distances[prevIndex] / 2)
            let nextSegmentLength = min(cornerRadius, distances[i] / 2)
            
            let prevPoint = pointAlongLine(from: corners[prevIndex], to: corners[i], distance: prevSegmentLength)
            let nextPoint = pointAlongLine(from: corners[nextIndex], to: corners[i], distance: nextSegmentLength)
            
            adjustedPoints.append(prevPoint)
            adjustedPoints.append(corners[i])
            adjustedPoints.append(nextPoint)
        }
        
        for (i, point) in adjustedPoints.enumerated() where i % 3 == 0 {
            let nextI = (i + 2) % adjustedPoints.count
            let midI = (i + 1) % adjustedPoints.count
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
            
            path.addArc(tangent1End: adjustedPoints[midI], tangent2End: adjustedPoints[nextI], radius: cornerRadius)
        }
        
        path.closeSubpath()
        
        return path
    }
    
    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))
    }
    
    private func pointAlongLine(from: CGPoint, to: CGPoint, distance: CGFloat) -> CGPoint {
        let fullDistance = self.distance(from, to)
        let ratio = distance / fullDistance
        
        let newX = from.x + ratio * (to.x - from.x)
        let newY = from.y + ratio * (to.y - from.y)
        
        return CGPoint(x: newX, y: newY)
    }

    var body: some View {
        ZStack {
            path(corners: corners, cornerRadius: cornerRadius)
                .fill(color)
                .opacity(opacity)
            
            path(corners: corners, cornerRadius: cornerRadius)
                .stroke(Color.black, lineWidth: lineWidth)
        }
    }
}

struct LocalOutlineRectangleXX {
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



struct ArcPointView: View {
    let position: [PositionAsIosAxes]?
    var screenPosition: CGPoint {
        if let unwrapped = position {
            return CGPoint(x: unwrapped[0].x, y: unwrapped[0].y)
        } else {
            return CGPoint.zero
        }
    }
    
    init(position: [PositionAsIosAxes]?) {
        self.position = position
    }
    var body: some View {
        MyCircle(fillColor: .red, strokeColor: .black, 20, screenPosition)
    }
}



struct ArcView: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    let origin: CGPoint
    let position: [PositionAsIosAxes]
    let point1: CGPoint
    let point2: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle


    
    init(_ position: [PositionAsIosAxes], _ originOfObject: PositionAsIosAxes, _ objectToTurnOriginX: Double){
        self.position = position
        self.origin = CGPoint(x: originOfObject.x + objectToTurnOriginX, y: originOfObject.y)
        point1 = CGPoint( x: position[0].x, y: position[0].y)
        point2 = CGPoint( x: position[1].x, y: position[1].y)
        radius = distance(from: origin, to: point1)
        startAngle = angle(from: origin, to: point1)
        endAngle = angle(from: origin, to: point2)
        
        // Calculate the distance between two points
        func distance(from: CGPoint, to: CGPoint) -> CGFloat {
            sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
        }

        // Calculate the angle from the origin to a point
        func angle(from origin: CGPoint, to point: CGPoint) -> Angle {
            let dy = point.y - origin.y
            let dx = point.x - origin.x
            let angle = atan2(dy, dx)
           
            return Angle(radians: Double(angle))
        }
        
        
    }
    var body: some View {
        ZStack{
            MyCircle(fillColor: .green, strokeColor: .black, 50.0, origin )
               // .position(origin)
            Path { path in
                path.addArc(center: origin,
                            radius: radius,
                            startAngle: startAngle < endAngle ? startAngle: endAngle,
                            endAngle: endAngle > startAngle ? endAngle: startAngle,
                            clockwise: false)
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
    


}


//func getMarkAngleToConstraint() -> [Angle] {
//    var  markAngles: [Angle] = []
//    var angle = Angle(radians: 0.0)
//    var xDimension: CGFloat
//    var yDimension: CGFloat
//    let transformToCorrectSignum = ((bottomToTopFlip || leftToRightFlip)) ? -1.0 : 1.0
//    for location in locationOfMarkNameInLocal {
//
//            yDimension = (CGFloat(location[1] * scale) * transformToCorrectSignum + scaledConstraintToChairOriginBeforeTurn.y)
//            xDimension = (CGFloat(location[0] * scale) + scaledConstraintToChairOriginBeforeTurn.x * transformToCorrectSignum)
//            angle =
//            Angle(radians:
//            atan2(
//                yDimension ,
//                xDimension))
//
//
//        markAngles.append(angle)
//
//    }
//
//    return markAngles
//}




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
//        LocalOutlineRectangleX.path(
//            corners: partCorners,
//            fillColor,
//            cornerRadius,
//            opacity,
//            lineWidth
//        )
//        .zIndex(
//            zPosition
//        )
        LocalOutlineRectangle(
            corners: partCorners,
            color: fillColor,
            
            opacity: opacity,
            lineWidth: lineWidth,
            cornerRadius: 0        )
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
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    @EnvironmentObject var rulerVM: RulerViewModel
   
    @GestureState private var fingerLocation: CGPoint? = nil
    @State private var location = CGPoint (x: 200, y: 0)
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom = 0.1
    private var maximimumZoom = 1.0
    
    var defaultScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject()
    }
    
    var measurementScale: Double {
        Screen.smallestDimension / objectPickVM.getMaximumDimensionOfObject()
    }
    
    var zoom: CGFloat {
        getZoom()
    }
    
    let uniquePartNames: [String]
    let uniqueArcPointNames: [String]
    let uniqueOriginNames: [String]
    
    var objectName: String {
        objectPickVM.getCurrentObjectName()
    }
    
    let preTiltFourCornerPerKeyDic: CornerDictionary
    let dictionaryForScreen: CornerDictionary
    let objectFrameSize: Dimension
    let movement: Movement
    var objectOriginInScreen: PositionAsIosAxes {
        movementPickVM.getOffsetForObjectOrigin()}
    var circleGeometry: GeometryProxy
    
    init(
        _ partNames: [String],
        _ arcPointNames: [String],
        _ originNames: [String],
        _ preTiltFourCornerPerKeyDic: CornerDictionary,
        _ dictionaryForScreen: CornerDictionary,
        _ objectFrameSize: Dimension,
        _ movement: Movement,
        _ geometry: GeometryProxy
    ) {
        uniquePartNames = partNames
        uniqueArcPointNames = arcPointNames
        uniqueOriginNames = originNames
        self.preTiltFourCornerPerKeyDic = preTiltFourCornerPerKeyDic
        self.dictionaryForScreen = dictionaryForScreen
        self.objectFrameSize = objectFrameSize
        self.movement = movement
        circleGeometry = geometry
       
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
        let arcDictionary = movement == .turn ? movementPickVM.createArcDictionary(dictionaryForScreen): [:]
        let origins: [PositionAsIosAxes] =
        movementPickVM.getObjectOrigins(dictionaryForScreen)
        let uniqueArcNames = Array(arcDictionary.keys)
        
        let objectTurnOriginX = movementPickVM.getObjectTurnOriginX()
            ZStack{
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
                        //ForEach(Array(origins.enumerated()), id: \.offset) { index, origin in
                        
                        MyCircle(fillColor: .black, strokeColor: .black, 50.0, CGPoint(x: origins[0].x, y: origins[0].y))
                        // }
                            .zIndex(5000)
                        
                    }
                    ZStack{
                        ForEach(uniqueArcPointNames, id: \.self) { name in
                            ArcPointView(
                                
                                position: dictionaryForScreen[name]
                                
                            )
                        }
                    }
                    if movement == .turn {
                        ZStack{
                            ForEach(uniqueArcNames, id: \.self) { name in
                                ArcView(
                                    arcDictionary[name] ?? [ZeroValue.iosLocation, ZeroValue.iosLocation],
                                    objectOriginInScreen,
                                    objectTurnOriginX
                                    
                                )
                            }
                        }
                    }
                }
                .background(GeometryReader { circleGeometry in
                                Color.clear
                        .onChange(of: objectFrameSize.length) { _, _ in
                                        let circleFrame = circleGeometry.frame(in: .global)
                                        
                            print("MyCircle's global center on size change: \(Int(circleFrame.minX * 0.0 + origins[0].x )) \(Int(circleFrame.minY * 0.0 + origins[0].y ))")
                                    }
                            })
            .border(.red, width: 2)
            .modifier(
                ForObjectDrag (
                    frameSize: objectFrameSize, active: true)
            )
            .position(x: 0.0, y: -300)
            .offset(CGSize(width: 0, height: objectPickVM.getOffsetToKeepObjectOriginStaticInLengthOnScreen()
                           ) )
        }
    }
}


//struct ObjectOriginView: View {
//    //let position: PositionAsIosAxes
//    var body: some View {
//        OriginView()
//    }
//}

//
//struct CirclePositionKey: PreferenceKey {
//    static var defaultValue: CGRect = .zero
//
//    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
//        value = nextValue()
//    }
//}
