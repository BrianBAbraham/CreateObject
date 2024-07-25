//
//  LocalOutlineRectangleViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 25/07/2024.
//

import SwiftUI
import Combine
class AllArcViewModel: ObservableObject {
    
    @Published var movementDictionaryForScreen: CornerDictionary =
       MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    @Published var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData
        
    var centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter = CenteredObjectZeroOriginService.shared.centeredObjectZeroOriginData
    
    init() {
        MovementImageService.shared.$movementImageData
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementImageData = newData
//                self.preTiltObjectToPartFourCornerDictionary = getPreTiltObjectToPartFourCornerPerKeyDic()
                // Call methods to update related data
                self.updateData()
            }
    }
    
    private  func updateData() {
          
          let ensureObjectZeroOriginAtMovementCenter =
              EnsureObjectZeroOriginAtMovementCenter(
                  movementImageData
              )
              
          CenteredObjectZeroOriginService.shared.setCenteredObjectZeroOriginData(ensureObjectZeroOriginAtMovementCenter)
      
          movementDictionaryForScreen = ensureObjectZeroOriginAtMovementCenter.movementDictionaryForScreen
          
          // Ensure the service is updated
          MovementDictionaryForScreenService.shared.setMovementDictionaryForScreen(
             movementDictionaryForScreen
          )
          
          onScreenMovementFrameSize = ensureObjectZeroOriginAtMovementCenter.onScreenMovementFrameSize
      }
}

class PartViewModel: ObservableObject ,
                        SharedMovementType,
                        SharedPartToEdit {
    
    @Published var preTiltObjectToPartFourCornerDictionary: CornerDictionary = [:]
    @Published var movementDictionaryForScreen: CornerDictionary =
       MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    @Published var partToEdit: Part = ObjectEditService.shared.partToEdit
    @Published var movementType = MovementEditService.shared.movementType
   var movementDictionaryInCGPointsForScreen: [String: [CGPoint]] = [:]
    var movementDictionaryZHeightForScreen: [String: Double] = [:]

    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData
    var centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter = CenteredObjectZeroOriginService.shared.centeredObjectZeroOriginData

    internal var cancellables: Set<AnyCancellable> = []
    
    init(){
        
        MovementImageService.shared.$movementImageData
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementImageData = newData
                self.preTiltObjectToPartFourCornerDictionary = getPreTiltObjectToPartFourCornerPerKeyDic()
                // Call methods to update related data
                self.movementDictionaryInCGPointsForScreen = CreateIosPosition.cornerToCGPointDic(movementDictionaryForScreen)
                self.movementDictionaryZHeightForScreen = CreateIosPosition.cornerToZHeightDic(movementDictionaryForScreen)
                
                self.updateData()
                
               
            }
            .store(in: &cancellables)
     
        
        (self as SharedMovementType).subscribeToService()
        (self as SharedPartToEdit).subscribeToService()
        
        updateData()

    }
    
    func getCGPoints(_ uniqueName: String) -> [CGPoint]{
        movementDictionaryInCGPointsForScreen[uniqueName] ?? Array( repeating: CGPoint.zero, count: 4)
    }

    
    func getZHeight(_ uniqueName: String) -> Double {
        movementDictionaryZHeightForScreen[uniqueName] ?? 0.0
    }
    
    
    func getPreTiltObjectToPartFourCornerPerKeyDic() -> CornerDictionary {
        movementImageData.objectImageData.preTilt.objectToPartFourCornerPerKeyDic
    }
    
    private  func updateData() {
          
          let ensureObjectZeroOriginAtMovementCenter =
              EnsureObjectZeroOriginAtMovementCenter(
                  movementImageData
              )
              
          CenteredObjectZeroOriginService.shared.setCenteredObjectZeroOriginData(ensureObjectZeroOriginAtMovementCenter)
      
          movementDictionaryForScreen = ensureObjectZeroOriginAtMovementCenter.movementDictionaryForScreen
          
          // Ensure the service is updated
          MovementDictionaryForScreenService.shared.setMovementDictionaryForScreen(
             movementDictionaryForScreen
          )

      }
    
    
//    func cgPointsOut(_ uniqueName: String) -> [CGPoint] {
//        var points: [CGPoint] = []
//        for corner in corners {
//            points.append(CGPoint(x: corner.x , y: corner.y))
//        }
//        return points
//    }
    
}



class LocalOutlineRectangleViewModel: ObservableObject {
    @Published var corners: [CGPoint]
    @Published var color: Color
    @Published var opacity: Double
    @Published var lineWidth: Double
    @Published var cornerRadius: CGFloat

    init(corners: [CGPoint], color: Color, opacity: Double, lineWidth: Double, cornerRadius: CGFloat) {
        self.corners = corners
        self.color = color
        self.opacity = opacity
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
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

