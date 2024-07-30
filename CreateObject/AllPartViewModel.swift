//
//  AllPartViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 25/07/2024.
//

import SwiftUI
import Combine



struct PartModel: Identifiable {
    let id: String
    let points: [CGPoint]
    let screenDepth: Double
    let color: Color
    let cornerRadius: Double
    let lineWidth: Double
    let opacity: Double
}

class AllPartViewModel: ObservableObject ,
                        SharedPartToEditFunc
{
   
    
    @Published var partModels: [PartModel] = []
  
    @Published var movementDictionaryForScreen: CornerDictionary =
       MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    
    @Published var partToEdit: Part = ObjectEditService.shared.partToEdit
    
    @Published var uniquePartNames: [String] = []
    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData
    
    func handlePartToEditChange( _ newData: Part){
        // newData is not passed in this use of func
        
        updatePartModels()
    }
    
    
    internal var cancellables: Set<AnyCancellable> = []
    
    init(){
        
        MovementImageService.shared.$movementImageData
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementImageData = newData
                self.uniquePartNames = getUniquePartNamesFromObjectDictionary()
                self.updateData()
                self.updatePartModels()
            }
            .store(in: &cancellables)
        
        (self as SharedPartToEditFunc).subscribeToService()
        
        updateData()
    }
    
    func updatePartModels(){
        // Create a new array of PointsModel from the dictionary
        partModels = []
        
        for name in uniquePartNames {
            
            _ =  DictionaryElementIn(
                movementDictionaryForScreen,
                name
            )
          
            let value =  movementDictionaryForScreen[name]!
            var points: [CGPoint] = []
            for corner in value {
                points.append(CGPoint(x: corner.x , y: corner.y))
            }
            
            let screenDepth = value[0].z// all four heights are equal
            let color = isPartToEdit(name, partToEdit) ? Color("selectedPart"): .white
            
            let partModel =
            PartModel(
                id: name,
                points: points
                ,
                screenDepth: screenDepth,
                color:Color(
                    color
                ),
                cornerRadius: 10.0,
                lineWidth: 5.0,
                opacity: 0.9
            )
            
            partModels.append(partModel)
        }
     }
    
    
    func isPartToEdit(_ uniquePartName: String, _ partToEdit: Part) -> Bool {
        let partName = partToEdit.rawValue
        let generalName = UniqueToGeneralName(uniquePartName).generalName
        return partName == generalName
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
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
        let dic = movementImageData.objectImageData.postTilt.objectToPartFourCornerPerKeyDic
        let names =
        Array(
            dic.keys
        ).filter {
            !(
                $0.contains(
                    PartTag.arcPoint.rawValue //UI manages differently from parts
                )  || $0.contains(
                    PartTag.origin.rawValue// ditto
                )  || $0.contains(
                    PartTag.staticPoint.rawValue// ditto
                ) //|| $0.contains(
                    //Part.stabiliser.rawValue// fixed wheel edits this
               // )
            ) }
      
        return names
    }
}


//
//class LocalOutlineRectangleViewModel: ObservableObject {
//    @Published var corners: [CGPoint]
//    @Published var color: Color
//    @Published var opacity: Double
//    @Published var lineWidth: Double
//    @Published var cornerRadius: CGFloat
//
//    init(corners: [CGPoint], color: Color, opacity: Double, lineWidth: Double, cornerRadius: CGFloat) {
//        self.corners = corners
//        self.color = color
//        self.opacity = opacity
//        self.lineWidth = lineWidth
//        self.cornerRadius = cornerRadius
//    }
//
//    func path() -> Path {
//        var path = Path()
//        
//        guard corners.count >= 3 else { return path }
//        
//        let distances = corners.indices.map { index -> CGFloat in
//            let nextIndex = (index + 1) % corners.count
//            return distance(corners[index], corners[nextIndex])
//        }
//        
//        var adjustedPoints: [CGPoint] = []
//        
//        for i in corners.indices {
//            let prevIndex = (i - 1 + corners.count) % corners.count
//            let nextIndex = (i + 1) % corners.count
//            
//            let prevSegmentLength = min(cornerRadius, distances[prevIndex] / 2)
//            let nextSegmentLength = min(cornerRadius, distances[i] / 2)
//            
//            let prevPoint = pointAlongLine(from: corners[prevIndex], to: corners[i], distance: prevSegmentLength)
//            let nextPoint = pointAlongLine(from: corners[nextIndex], to: corners[i], distance: nextSegmentLength)
//            
//            adjustedPoints.append(prevPoint)
//            adjustedPoints.append(corners[i])
//            adjustedPoints.append(nextPoint)
//        }
//        
//        for (i, point) in adjustedPoints.enumerated() where i % 3 == 0 {
//            let nextI = (i + 2) % adjustedPoints.count
//            let midI = (i + 1) % adjustedPoints.count
//            
//            if i == 0 {
//                path.move(to: point)
//            } else {
//                path.addLine(to: point)
//            }
//            
//            path.addArc(tangent1End: adjustedPoints[midI], tangent2End: adjustedPoints[nextI], radius: cornerRadius)
//        }
//        
//        path.closeSubpath()
//        
//        return path
//    }
//
//    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
//        sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))
//    }
//    
//    private func pointAlongLine(from: CGPoint, to: CGPoint, distance: CGFloat) -> CGPoint {
//        let fullDistance = self.distance(from, to)
//        let ratio = distance / fullDistance
//        
//        let newX = from.x + ratio * (to.x - from.x)
//        let newY = from.y + ratio * (to.y - from.y)
//        
//        return CGPoint(x: newX, y: newY)
//    }
//}

