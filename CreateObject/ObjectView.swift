//
//  ObjectView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI


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
        MyCircle(fillColor: .red, strokeColor: .black, dimension
                 :20, position: screenPosition)
    }
}



struct PartView: View {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var partEditVM: ObjectShowMenuViewModel
    let partToEdit: Part
    let uniquePartName: String
    var preTiltFourCornerPerKeyDic: CornerDictionary
    var postTiltObjectToFourCornerPerKeyDic: CornerDictionary
    
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
    let movement: Movement
    let displayStyle: DisplayStyle
    
    init(
        uniquePartName: String,
        preTiltFourCornerPerKeyDic: CornerDictionary,
        postTiltObjectToFourCornerPerKeyDic: CornerDictionary,
        color: Color = .white,
        cornerRadius: Double = 30.0,
        opacity: Double = 0.9,
        lineWidth: Double = 5.0,
        _ partToEdit: Part,
        _ movement: Movement,
        _ displayStyle: DisplayStyle
 
    ){
        self.partToEdit = partToEdit
        self.uniquePartName = uniquePartName
        self.preTiltFourCornerPerKeyDic = preTiltFourCornerPerKeyDic
        self.postTiltObjectToFourCornerPerKeyDic = postTiltObjectToFourCornerPerKeyDic
        fillColor = getColor()
        self.cornerRadius = cornerRadius
        self.opacity = opacity
        self.lineWidth = lineWidth
        self.movement = movement
        self.displayStyle = displayStyle
        
        func getColor() -> Color {
            if color == .white { // only change undefined colors, let ruler color remain
                if UniqueToGeneralName(uniquePartName).generalName.contains(partToEdit.rawValue) {
                    return Color(displayStyle == .movement ? "movement" :"selectedPart")
                } else {
                    return Color(displayStyle == .movement ? "movement" :"unselectedPart")}
            } else {
                return color
            }
        }
    }
    
    
    var body: some View {

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
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    @EnvironmentObject var movementDataVM: MovementDataViewModel
    @EnvironmentObject var arcVM: ArcViewModel
  
    let uniquePartNames: [String]
    let preTiltFourCornerPerKeyDic: CornerDictionary
    let dictionaryForScreen: CornerDictionary
    let objectFrameSize: Dimension
    //let movement: Movement
    let displayStyle: DisplayStyle
//    var objectOriginInScreen: PositionAsIosAxes {
//        movementDataVM.getOffsetForObjectOrigin()}

  
    init(
        _ partNames: [String],
        _ preTiltFourCornerPerKeyDic: CornerDictionary,
        _ dictionaryForScreen: CornerDictionary,
        _ objectFrameSize: Dimension,
        _ movement: Movement,
        _ displayStyle: DisplayStyle
    ) {
        uniquePartNames = partNames

        self.preTiltFourCornerPerKeyDic = preTiltFourCornerPerKeyDic
        self.dictionaryForScreen = dictionaryForScreen
        self.objectFrameSize = objectFrameSize
       // self.movement = movement
        self.displayStyle = displayStyle

    }
    
    var body: some View {
        let movement = movementPickVM.getMovementType()
        let staticPointDictionary = movement == .turn ? arcVM.staticPointDictionary: [:]
       // let uniqueArcPointNames = arcVM.uniqueArcPointNames
        let uniqueStaticPointNames = arcVM.uniqueStaticPointNames
        let anglesRadiae: [AnglesRadius] = arcVM.angles
            ZStack{
                ForEach(uniquePartNames, id: \.self) { name in
                    PartView(
                        uniquePartName: name,
                        preTiltFourCornerPerKeyDic: preTiltFourCornerPerKeyDic,
                        postTiltObjectToFourCornerPerKeyDic: dictionaryForScreen,
                        objectEditVM.partToEdit,
                        movement,
                        displayStyle
                    )
                }
         
//                ForEach(uniqueArcPointNames, id: \.self) { name in
//                    ArcPointView(
//                        position: dictionaryForScreen[name]
//                    )
//                }
                

                if movement == .turn {
                    
                    ForEach(uniqueStaticPointNames, id: \.self) { staticPointName in
                        StaticPointView(
                            position: staticPointDictionary[staticPointName] ?? [ZeroValue.iosLocation]
                        )
                        .zIndex(5000)
                        
                        ForEach(anglesRadiae, id: \.id) { anglesRadius in
                                ArcView(
                                    anglesRadius,
                                    dictionaryForScreen[staticPointName] ?? [ZeroValue.iosLocation]
                                )
                        }
                    }
                    
                }
            }
            .modifier(
                ForObjectDrag (
                    frameSize: objectFrameSize, active: true)
            )
        }
}



struct ArcView: View {
   // @EnvironmentObject var movementPickVM: MovementPickViewModel
    let origin: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    init(
        _ anglesRadius: AnglesRadius,
        _ staticPoint: [PositionAsIosAxes]
    ){
        
        self.origin = CGPoint(x: staticPoint[0].x, y: staticPoint[0].y)
        radius = anglesRadius.radius
        startAngle = Angle(radians: Double(anglesRadius.start))
        endAngle = Angle(radians: Double(anglesRadius.end))
        clockwise = anglesRadius.clockwise
    }
        
    var body: some View {
        ZStack{
            Path { path in
                path.addArc(center: origin,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: !clockwise
                )
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}



struct StaticPointView: View {
    let position: [PositionAsIosAxes]
    var body: some View {
        MyCircle(fillColor: .black, strokeColor: .black, dimension
                         :40, position: CGPoint(x: position[0].x ,y: position[0].y))
        MyCircle(fillColor: .white, strokeColor: .black, dimension
                         :20, position: CGPoint(x: position[0].x ,y: position[0].y))
    }
}


    
struct MyCircle: View {
   
    let fillColor: Color?
    let strokeColor: Color
    let dimension: Double
    let position: CGPoint
    var body: some View {
        ZStack {
            if let fillColorUnwrapped = fillColor {
                Circle()
                    .fill(fillColorUnwrapped)
                    .frame(width: dimension, height: dimension)
                    .position(position)

                Circle()
                    .fill(.black)
                    .frame(width: 10, height: 10)
                    .position(position)
                    .opacity(0.0001)
            }
            Circle()
                .stroke(strokeColor)
                .frame(width: dimension, height: dimension)
                .position(position)
        }
    }
}
