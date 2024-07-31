//
//  ObjectViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 28/06/2024.
//

import Foundation
import Combine

class ObjectWithArcViewModel: ObservableObject, 
    SharedMovementType,
    SharedMovementDictionaryForScreen,
  SharedCenteredObjectZeroOriginData {

    @Published var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    
    var movementDictionaryForScreen: CornerDictionary =
       MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    
    var movementType = MovementEditService.shared.movementType
    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData
        
    var centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter = CenteredObjectZeroOriginService.shared.centeredObjectZeroOriginData

    internal var cancellables: Set<AnyCancellable> = []
    
    init(){ 
        
//        
//        MovementDictionaryForScreenService.shared.$movementDictionaryForScreen
//                    .sink { [weak self] newDictionary in
//                        self?.movementDictionaryForScreen = newDictionary
//                      // self?.updatePartModels()
//                    }
//                    .store(in: &cancellables)
        
        MovementImageService.shared.$movementImageData
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementImageData = newData
                self.updateData()
            }
            .store(in: &cancellables)
        
                (self as SharedMovementDictionaryForScreen).subscribeToService()
                //updateData()
            
        (self as SharedMovementType).subscribeToService()
        (self as SharedCenteredObjectZeroOriginData).subscribeToService()
        updateData()

    }

    
    private  func updateData() {
          
          let ensureObjectZeroOriginAtMovementCenter =
              EnsureObjectZeroOriginAtMovementCenter(
                  movementImageData
              )
              
          CenteredObjectZeroOriginService.shared.setCenteredObjectZeroOriginData(ensureObjectZeroOriginAtMovementCenter)
      
          let movementDictionaryForScreen = ensureObjectZeroOriginAtMovementCenter.movementDictionaryForScreen
          
          // Ensure the service is updated
          MovementDictionaryForScreenService.shared.setMovementDictionaryForScreen(
             movementDictionaryForScreen
          )
          
          onScreenMovementFrameSize = ensureObjectZeroOriginAtMovementCenter.onScreenMovementFrameSize
      }
    
}



