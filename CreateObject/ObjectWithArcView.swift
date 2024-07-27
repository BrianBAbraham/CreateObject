//
//  ObjectView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI
import SwiftUI
import Combine

class PartViewModel: ObservableObject {
    @Published var corners: [CGPoint]
    @Published var color: Color
    @Published var opacity: Double
    @Published var lineWidth: Double
    @Published var cornerRadius: CGFloat
    var displayStyle: ObjectDisplayStyle
    
    init(
        corners: [CGPoint],
        color: Color,
        opacity: Double,
        lineWidth: Double,
        cornerRadius: CGFloat,
        displayStyle: ObjectDisplayStyle
    ) {
        self.corners = corners
        self.color = displayStyle == .edit ? color: .white
        self.opacity = opacity
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.displayStyle = displayStyle
    }
    
    func path() -> Path {
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

//struct LocalOutlineRectangle: View {
//    @ObservedObject var viewModel: LocalOutlineRectangleViewModel
//
//    var body: some View {
//        ZStack {
//            viewModel.path()
//                .fill(viewModel.color)
//                .opacity(viewModel.opacity)
//            
//            viewModel.path()
//                .stroke(Color.black, lineWidth: viewModel.lineWidth)
//        }
//    }
//}


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


import SwiftUI

import SwiftUI

struct AllPartView: View {
    @EnvironmentObject var allPartVM: AllPartViewModel
    let displayStyle: ObjectDisplayStyle
    
    var body: some View {
        ForEach(allPartVM.partModels) { partModel in
            let partVM = PartViewModel(
                corners: partModel.points,
                color: partModel.color,//getColor(partModel.id),
                opacity: partModel.opacity,
                lineWidth: partModel.lineWidth,
                cornerRadius: partModel.cornerRadius, 
                displayStyle: displayStyle
            )
            
            PartView(vm: partVM)
                .zIndex(partModel.screenDepth)
        }
    }
    

}


struct PartView: View {
    @ObservedObject var vm: PartViewModel
    var body: some View {
        ZStack {
            vm.path()
                .fill(vm.color)
                .opacity(vm.opacity)
            
            vm.path()
                .stroke(Color.black, lineWidth: vm.lineWidth)
        }
    }
}

//struct PartView: View {
//  @EnvironmentObject var partVM: PartViewModel
//    let displayStyle: ObjectDisplayStyle
//    
//    var body: some View {
//        ForEach(partVM.partModels) {partModel in
//            LocalOutlineRectangle(
//                corners: partModel.points,
//                color: getColor(partModel.id),
//                opacity: partModel.opacity,
//                lineWidth: partModel.lineWidth,
//                cornerRadius: partModel.cornerRadius)
//            .zIndex(
//                partModel.screenDepth
//            )
//        }
//    }
//    func getColor(_ uniquePartName: String) -> Color {
//            if UniqueToGeneralName(uniquePartName).generalName.contains(partVM.partToEdit.rawValue) {
//                return Color(displayStyle == .movement ? "movement" :"selectedPart")
//            } else {
//                return .white
//
//        }
//    }
//}




struct PartViewX: View {
    @EnvironmentObject var objectPickVM: ObjectPickerViewModel
  @EnvironmentObject var partVM: AllPartViewModel
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
    let displayStyle: ObjectDisplayStyle
    
    init(
        uniquePartName: String,
        preTiltFourCornerPerKeyDic: CornerDictionary,
        dictionaryForScreen: CornerDictionary,
        color: Color = .white,
        cornerRadius: Double = 30.0,
        opacity: Double = 0.9,
        lineWidth: Double = 5.0,
        _ partToEdit: Part,
        _ movement: Movement,
        _ displayStyle: ObjectDisplayStyle
 
    ){
        self.partToEdit = partToEdit
        self.uniquePartName = uniquePartName
        self.preTiltFourCornerPerKeyDic = preTiltFourCornerPerKeyDic
        self.postTiltObjectToFourCornerPerKeyDic = dictionaryForScreen
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



enum ObjectDisplayStyle {
    case movement
    case edit
}


struct ObjectWithArcView: View {
    @EnvironmentObject var vm: ObjectWithArcViewModel

    let displayStyle: ObjectDisplayStyle
    
    var body: some View {
        ZStack{
            AllPartView(displayStyle: displayStyle)
            
//                ForEach(uniqueArcPointNames, id: \.self) { name in
//                    ArcPointView(
//                        position: dictionaryForScreen[name]
//                    )
//                }
                
            AllArcWithStaticPointView()

            }
            .modifier(
                ForObjectDrag (
                    frameSize: vm.onScreenMovementFrameSize, active: true)
            )
    }
}






struct AllArcWithStaticPointView: View {
    @EnvironmentObject var vm: AllArcWithStaticPointViewModel
    var dictionaryForScreen: CornerDictionary {
        vm.movementDictionaryForScreen
    }
    var body: some View {
        
        if vm.movementType == .turn {
                
            ForEach(vm.staticPointModel) {staticPointModel in
                StaticPointView(
                    position: vm.staticPointDictionary[staticPointModel.name] ?? [ZeroValue.iosLocation]
                )
                .zIndex(5000)
                               
                ForEach(vm.arcDataModels) {arcDataModel in
                    ArcView(
                        arcDataModel.arcData,
                        dictionaryForScreen[staticPointModel.name] ?? [ZeroValue.iosLocation]
                    )
                }
            }
            
        }
    }
}


struct ArcView: View {
    let origin: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    init(
        _ anglesRadius: ArcData,
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
