//
//  MovementDataProcessorVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 16/05/2024.
//

import Foundation
import Combine


//gets the picked movement
// provides the processed movementImageData
//so that the objectZero origin is in the view center
class MovementDataProcessorViewModel: ObservableObject {
    @Published var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    
    @Published var movementDictionaryForScreen: CornerDictionary =
       MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData
    
    var centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter = CenteredObjectZeroOriginService.shared.centeredObjectZeroOriginData

    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        
        MovementImageService.shared.$movementImageData
            .receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementImageData = newData
                // Call methods to update related data
                self.updateData()
            }
            .store(in: &cancellables)
        
        updateData()
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
