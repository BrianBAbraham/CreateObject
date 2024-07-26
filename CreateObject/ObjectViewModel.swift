//
//  ObjectViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 28/06/2024.
//

import Foundation
import Combine

class ObjectViewModel: ObservableObject, 
    SharedMovementType//,
    //SharedPartToEdit
{
    @Published var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    
   // @Published var partToEdit: Part = ObjectEditService.shared.partToEdit
    
   // @Published var uniquePartNames: [String] = []
    
   // @Published var preTiltObjectToPartFourCornerDictionary: CornerDictionary = [:]
    
    @Published var movementDictionaryForScreen: CornerDictionary =
       MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    
    @Published var movementType = MovementEditService.shared.movementType
    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData
        
    var centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter = CenteredObjectZeroOriginService.shared.centeredObjectZeroOriginData

    internal var cancellables: Set<AnyCancellable> = []
    
    init(){ 
        
        MovementImageService.shared.$movementImageData
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementImageData = newData
               // self.uniquePartNames = getUniquePartNamesFromObjectDictionary()
             //   self.preTiltObjectToPartFourCornerDictionary = getPreTiltObjectToPartFourCornerPerKeyDic()
                // Call methods to update related data
                self.updateData()
            }
            .store(in: &cancellables)
        
        
        (self as SharedMovementType).subscribeToService()
       // (self as SharedPartToEdit).subscribeToService()
        
        updateData()

    }
    
//    func getUniquePartNamesFromObjectDictionary() -> [String] {
//        let dic = movementImageData.objectImageData.postTilt.objectToPartFourCornerPerKeyDic
//        let names =
//        Array(
//            dic.keys
//        ).filter {
//            !(
//                $0.contains(
//                    PartTag.arcPoint.rawValue //UI manages differently from parts
//                )  || $0.contains(
//                    PartTag.origin.rawValue// ditto
//                )  || $0.contains(
//                    PartTag.staticPoint.rawValue// ditto
//                ) //|| $0.contains(
//                    //Part.stabiliser.rawValue// fixed wheel edits this
//               // )
//            ) }
//      
//        return names
//    }
    
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
          
          onScreenMovementFrameSize = ensureObjectZeroOriginAtMovementCenter.onScreenMovementFrameSize
      }
    
}



