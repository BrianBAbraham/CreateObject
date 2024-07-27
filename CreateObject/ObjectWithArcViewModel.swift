//
//  ObjectViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 28/06/2024.
//

import Foundation
import Combine

class ObjectWithArcViewModel: ObservableObject, 
    SharedMovementType//,
    //SharedPartToEdit
{
    @Published var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    
    //@Published
    var movementDictionaryForScreen: CornerDictionary =
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

                self.updateData()
            }
            .store(in: &cancellables)
        
        
        (self as SharedMovementType).subscribeToService()
 
        updateData()

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
          
          onScreenMovementFrameSize = ensureObjectZeroOriginAtMovementCenter.onScreenMovementFrameSize
      }
    
}



