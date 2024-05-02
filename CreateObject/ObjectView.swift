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
        MyCircle(fillColor: .red, strokeColor: .black, dimension
                 :20, position: screenPosition)
    }
}






//import SwiftUI

//struct ArcView: View {
//    @EnvironmentObject var movementPickVM: MovementPickViewModel
//    @State private var lastClockwise: Bool // No need for default value here since it's set within the initializer
//
//    let origin: CGPoint
//    let position: [PositionAsIosAxes]
//    let point1: CGPoint
//    let point2: CGPoint
//    let radius: CGFloat
//    var startAngle: Angle
//    var endAngle: Angle
//
//    init(
//        _ position: [PositionAsIosAxes],
//        _ staticPoint: [PositionAsIosAxes]
//    ) {
//        self.position = position
//        self.origin = CGPoint(x: staticPoint[0].x, y: staticPoint[0].y)
//        self.point1 = CGPoint(x: position[0].x, y: position[0].y)
//        self.point2 = CGPoint(x: position[1].x, y: position[1].y)
//        
//        // Calculate the distance from origin to point1
//        self.radius = sqrt(pow(point1.x - origin.x, 2) + pow(point1.y - origin.y, 2))
//
//        // Calculate the angle from origin to point1
//        let dy1 = point1.y - origin.y
//        let dx1 = point1.x - origin.x
//        self.startAngle = Angle(radians: Double(atan2(dy1, dx1)))
//
//        // Calculate the angle from origin to point2
//        let dy2 = point2.y - origin.y
//        let dx2 = point2.x - origin.x
//        self.endAngle = Angle(radians: Double(atan2(dy2, dx2)))
//
//        let deltaAngle = (self.endAngle.radians - self.startAngle.radians).truncatingRemainder(dividingBy: 2 * .pi)
//        self.lastClockwise = deltaAngle > 0 ? deltaAngle > .pi : -deltaAngle <= .pi
//    }
//
//    var body: some View {
//        ZStack {
//            Path { path in
//                path.addArc(center: origin,
//                            radius: radius,
//                            startAngle: startAngle,
//                            endAngle: endAngle,
//                            clockwise: lastClockwise)
//            }
//            .stroke(Color.blue, lineWidth: 2)
//        }
//    }
//}






struct ArcViewXX: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    let origin: CGPoint
    let position: [PositionAsIosAxes]
    let point1: CGPoint
    let point2: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle
    @State private var lastClockwise: Bool? // State to keep track of the last direction only if not set

    init(
        _ position: [PositionAsIosAxes],
        _ staticPoint: [PositionAsIosAxes]
    ) {
        self.position = position
        self.origin = CGPoint(x: staticPoint[0].x, y: staticPoint[0].y)
        self.point1 = CGPoint(x: position[0].x, y: position[0].y)
        self.point2 = CGPoint(x: position[1].x, y: position[1].y)
        
        // Calculate the distance from origin to point1
        self.radius = sqrt(pow(point1.x - origin.x, 2) + pow(point1.y - origin.y, 2))

        // Calculate the angle from origin to point1
        let dy1 = point1.y - origin.y
        let dx1 = point1.x - origin.x
        let angle1 = atan2(dy1, dx1)
        self.startAngle = Angle(radians: Double(angle1))

        // Calculate the angle from origin to point2
        let dy2 = point2.y - origin.y
        let dx2 = point2.x - origin.x
        let angle2 = atan2(dy2, dx2)
        self.endAngle = Angle(radians: Double(angle2))
    }

    var body: some View {
        ZStack {
            Path { path in
                let clockwise: Bool
                let deltaAngle = (endAngle.radians - startAngle.radians).truncatingRemainder(dividingBy: 2 * .pi)

//                // Determine if clockwise direction is the shortest path
//                if deltaAngle > 0 {
//                    clockwise = deltaAngle > .pi
//                } else {
//                    clockwise = -deltaAngle <= .pi
//                }

                
                // If lastClockwise is set, use it, otherwise determine new direction
                if let lastClockwise = lastClockwise {
                    clockwise = lastClockwise
                } else {
                    if deltaAngle > 0 {
                        clockwise = deltaAngle > .pi
                    } else {
                        clockwise = -deltaAngle <= .pi
                    }
                    //self.lastClockwise = clockwise // Set the state if it's not already set
                }
                path.addArc(center: origin,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: clockwise)
            }
            .stroke(Color.blue, lineWidth: 2)
        }
        .onAppear {
            if lastClockwise == nil { // Set the initial direction only once when the view appears
                let deltaAngle = (endAngle.radians - startAngle.radians).truncatingRemainder(dividingBy: 2 * .pi)
                let initialClockwise = deltaAngle > 0 ? deltaAngle > .pi : -deltaAngle <= .pi
                lastClockwise = initialClockwise
            }
        }
    }
}



import SwiftUI

struct ArcView: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    let origin: CGPoint
    let position: [PositionAsIosAxes]
    let point1: CGPoint
    let point2: CGPoint
    let radius: CGFloat
    var startAngle: Angle
    var endAngle: Angle
   var drawLongestArc: Bool //= false

    init(
        _ position: [PositionAsIosAxes],
        _ staticPoint: [PositionAsIosAxes],
       drawLongestArc: Bool = false
    ){
        self.position = position
        self.origin = CGPoint(x: staticPoint[0].x, y: staticPoint[0].y)
        self.point1 = CGPoint(x: position[0].x, y: position[0].y)
        self.point2 = CGPoint(x: position[1].x, y: position[1].y)
        self.radius = ArcView.distance(from: origin, to: point1)
        let tempStartAngle = ArcView.angle(from: origin, to: point1)
        let tempEndAngle = ArcView.angle(from: origin, to: point2)
        self.drawLongestArc = drawLongestArc

        let angleDifference = ArcView.normalizedAngleDifference(tempStartAngle, tempEndAngle)

        
        let adjustedDrawLongestArc = angleDifference == .pi ? !drawLongestArc : drawLongestArc

            self.drawLongestArc = adjustedDrawLongestArc
            self.startAngle = tempStartAngle
        
//                if angleDifference == .pi {
//                    print("was longest? \(drawLongestArc)")
//                    print("now longest? \(adjustedDrawLongestArc)")
//                   // self.drawLongestArc.toggle()
//                    //print(drawLongestArc)
//                    print("")
//                    
//                    //angleDifference = angleDifference - 0.0001
//                }
        
       // print(Int(angleDifference / .pi * 180))
        self.startAngle = tempStartAngle
        self.endAngle = Angle(radians: tempEndAngle.radians + (tempStartAngle.radians == tempEndAngle.radians ? 0.001 : 0))
    }

    // Static methods remain unchanged
    // Calculate the distance between two points
    static func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
    }

    // Calculate the angle from the origin to a point
    static func angle(from origin: CGPoint, to point: CGPoint) -> Angle {
        let dy = point.y - origin.y
        let dx = point.x - origin.x
        let angle = atan2(dy, dx)
        return Angle(radians: Double(angle))
    }

    // Calculate normalized angle difference
    static func normalizedAngleDifference(_ angle1: Angle, _ angle2: Angle) -> Double {
        var diff = (angle2.radians - angle1.radians).truncatingRemainder(dividingBy: 2 * .pi)
        if diff < 0 {
            diff += 2 * .pi
        }
        return diff
    }

    var body: some View {
        ZStack {
            Path { path in
                let diff = ArcView.normalizedAngleDifference(startAngle, endAngle)
                let shouldDrawClockwise = (diff > .pi) != drawLongestArc
                path.addArc(center: origin,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: shouldDrawClockwise)
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}






struct ArcViewX: View {
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    let origin: CGPoint
    let position: [PositionAsIosAxes]
    let point1: CGPoint
    let point2: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle

    init(
        _ position: [PositionAsIosAxes],
        _ staticPoint: [PositionAsIosAxes]
    ){
        self.position = position
        self.origin = CGPoint(x: staticPoint[0].x, y: staticPoint[0].y)

        point1 = CGPoint(
            x: position[0].x,
            y: position[0].y
        )
        point2 = CGPoint(
            x: position[1].x,
            y: position[1].y
        )
        radius = distance(
            from: origin,
            to: point1
        )
        startAngle = angle(
            from: origin,
            to: point1
        )
        endAngle = angle(
            from: origin,
            to: point2
        )
        
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
            Path { path in
                path.addArc(center: origin,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
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

//struct CanvasView: View {
//    @EnvironmentObject var objectPickVM: ObjectPickViewModel
//    @EnvironmentObject var partEditVM: ObjectShowMenuViewModel
// 
//    var origin: CGPoint
//    
//    
//    init(
//        _ origin: PositionAsIosAxes
//    ){
//        
//        self.origin = CGPoint(x: origin.x, y: origin.y)
//        }
//        
//    
//    var body: some View {
//
//        MyCircle(fillColor: .green, strokeColor: .black, dimension: 40.0, position: origin )
//
//    }
//}



struct ObjectView: View {
    @EnvironmentObject var objectEditVM: ObjectEditViewModel
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    @EnvironmentObject var arcVM: ArcViewModel
  
    let uniquePartNames: [String]
   // let uniqueArcPointNames: [String]
    //let uniqueStaticPointNames: [String]
    let preTiltFourCornerPerKeyDic: CornerDictionary
    let dictionaryForScreen: CornerDictionary
    let objectFrameSize: Dimension
    let movement: Movement
    var objectOriginInScreen: PositionAsIosAxes {
        movementPickVM.getOffsetForObjectOrigin()}
  
    init(
        _ partNames: [String],
        //_ arcPointNames: [String],
      //  _ staticPointNames: [String],
        _ preTiltFourCornerPerKeyDic: CornerDictionary,
        _ dictionaryForScreen: CornerDictionary,
        _ objectFrameSize: Dimension,
        _ movement: Movement
    ) {
        uniquePartNames = partNames
//        uniqueArcPointNames = staticPointNames
       // uniqueStaticPointNames = staticPointNames
        
        //print("view \(uniqueStaticPointNames) ")
        self.preTiltFourCornerPerKeyDic = preTiltFourCornerPerKeyDic
        self.dictionaryForScreen = dictionaryForScreen
        self.objectFrameSize = objectFrameSize
        self.movement = movement
        
       // print(uniqueArcPointNames)
    }
    
    var body: some View {
        let arcDictionary = movement == .turn ? arcVM.arcDictionary: [:]
        let staticPointDictionary = movement == .turn ? arcVM.staticPointDictionary: [:]//movementPickVM.createStaticPointTurnDictionary(dictionaryForScreen) : [:]
        
        let uniqueArcNames = arcVM.getUniqueArcNames()  //movementPickVM.getUniqueArcNames()
        let uniqueArcPointNames = arcVM.uniqueArcPointNames
        let uniqueStaticPointNames = arcVM.uniqueStaticPointNames
        let anglesRadiae: [AnglesRadius] = arcVM.angles
            ZStack{
                ForEach(uniquePartNames, id: \.self) { name in
                    PartView(
                        uniquePartName: name,
                        preTiltFourCornerPerKeyDic: preTiltFourCornerPerKeyDic,
                        postTiltObjectToFourCornerPerKeyDic: dictionaryForScreen,
                        objectEditVM.partToEdit
                    )
                }
         
                ForEach(uniqueArcPointNames, id: \.self) { name in
                    ArcPointView(
                        position: dictionaryForScreen[name]
                    )
                }
                

                if movement == .turn {
                    
                    ForEach(uniqueStaticPointNames, id: \.self) { staticPointName in
                        StaticPointView(
                            position: staticPointDictionary[staticPointName] ?? [ZeroValue.iosLocation]
                        )
                        .zIndex(5000)
                        
//                        ForEach(uniqueArcNames, id: \.self) { name in
//                            ArcViewX(
//                                arcDictionary[name] ?? [ZeroValue.iosLocation, ZeroValue.iosLocation],
//                                dictionaryForScreen[staticPointName] ?? [ZeroValue.iosLocation]
//                            )
//                        }
                        ForEach(anglesRadiae, id: \.id) { anglesRadius in
                                ArcViewXXX(
                                    anglesRadius,
                                    dictionaryForScreen[staticPointName] ?? [ZeroValue.iosLocation]
                                )
                            }
                        .zIndex(5000)
                        
                    }
                    
                }
            }
          //  .border(.red, width: 2)
            .modifier(
                ForObjectDrag (
                    frameSize: objectFrameSize, active: true)
            )
            .position(x: 0.0, y: -300)
            .offset(CGSize(width: 0.0, height: objectPickVM.getOffsetToKeepObjectOriginStaticInLengthOnScreen()
                           ) )
        }
}

//
struct ArcViewXXX: View {
 
    @EnvironmentObject var movementPickVM: MovementPickViewModel
    let origin: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle
    

    init(
        _ anglesRadius: AnglesRadius,
        _ staticPoint: [PositionAsIosAxes]
    ){
        
        self.origin = CGPoint(x: staticPoint[0].x, y: staticPoint[0].y)
        
        radius = anglesRadius.radius
        
        
        
        
        
        startAngle = Angle(radians: Double(anglesRadius.start))
        endAngle = Angle(radians: Double(anglesRadius.end))
    }
        
    var body: some View {
        ZStack{
            Path { path in
                path.addArc(center: origin,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false
                )
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}

//import SwiftUI

//import SwiftUI

//import SwiftUI


//
//struct ArcViewXXX: View {
//    @EnvironmentObject var movementPickVM: MovementPickViewModel
//    let origin: CGPoint
//    let radius: CGFloat
//    var startAngle: Angle
//    var endAngle: Angle
//
//    init(_ anglesRadius: AnglesRadius, _ staticPoint: [PositionAsIosAxes]) {
//        self.origin = CGPoint(x: staticPoint[0].x, y: staticPoint[0].y)
//        self.radius = anglesRadius.radius
//
//        let startRadians = Double(anglesRadius.start).truncatingRemainder(dividingBy: 2 * .pi)
//        var endRadians = Double(anglesRadius.end).truncatingRemainder(dividingBy: 2 * .pi)
//
//        // Ensure endRadians adjusts correctly if crossing 0 radians from the anticlockwise direction
//        if endRadians < startRadians {
//            endRadians += 2 * .pi
//        }
//
//        self.startAngle = Angle(radians: startRadians)
//        self.endAngle = Angle(radians: endRadians)
//    }
//
//    var body: some View {
//        ZStack {
//            Path { path in
//                path.addArc(center: origin,
//                            radius: radius,
//                            startAngle: startAngle,
//                            endAngle: endAngle,
//                            clockwise: false)
//            }
//            .stroke(Color.blue, lineWidth: 2)
//        }
//    }
//}


// Usage of ArcView might look like this:
// ArcView(origin: CGPoint(x: 100, y: 100), radius: 50, staticAngleRadians: viewModel.staticAngle, movingAngleRadians: viewModel.movingAngle)







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
