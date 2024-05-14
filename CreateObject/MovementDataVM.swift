//
//  MovementPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2024.
//

import Foundation
import Combine
import SwiftUI

struct MovementPickModel {

    let forward: Double

    

}

//gets the picked movement
//passes for transformsation into View suitable form
//supplies the ViewModel with the View suitable form
class MovementDataViewModel: ObservableObject {

    @Published var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    @Published var uniquePartNames: [String] = []
    @Published var movementDictionaryForScreen: CornerDictionary =
        MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData 
    
    var postTiltObjectToOneCornerPerKeyDic: PositionDictionary = [:]
    var postTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    
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
    
    private func updateData() {
        
    var ensureObjectZeroOriginAtMovementCenter =
        EnsureObjectZeroOriginAtMovementCenter(
            movementImageData
        )
        
        CenteredObjectZeroOriginService.shared.setCenteredObjectZeroOriginData(ensureObjectZeroOriginAtMovementCenter)
        
        uniquePartNames = ensureObjectZeroOriginAtMovementCenter.getUniquePartNamesFromObjectDictionary()
        
        onScreenMovementFrameSize = ensureObjectZeroOriginAtMovementCenter.onScreenMovementFrameSize
        
        movementDictionaryForScreen = ensureObjectZeroOriginAtMovementCenter.movementDictionaryForScreen
        
        postTiltObjectToOneCornerPerKeyDic =
        ensureObjectZeroOriginAtMovementCenter.getPostTiltOneCornerPerKeyDic()
        
        postTiltObjectToPartFourCornerPerKeyDic =
        ensureObjectZeroOriginAtMovementCenter.getPostTiltObjectToPartFourCornerPerKeyDic()
        
        // Ensure the service is updated
        MovementDictionaryForScreenService.shared.setMovementDictionaryForScreen(
            movementDictionaryForScreen
        )
    }
}
    


class MovementDataGiverViewModel: ObservableObject {
    @Published var movementDictionaryForScreen: CornerDictionary =
        MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    
    //@Published
    var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    
    @Published var uniquePartNames: [String] = []
   
    var postTiltObjectToOneCornerPerKeyDic: PositionDictionary = [:]
    var postTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData
    
    var centeredObjectZeroOriginData: EnsureObjectZeroOriginAtMovementCenter?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        print("MOVMENTdTAGIVER")
        MovementDictionaryForScreenService.shared.$movementDictionaryForScreen
            .receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementDictionaryForScreen = newData
                // Call methods to update related data
                
            }
            .store(in: &cancellables)
        
        MovementImageService.shared.$movementImageData
            .receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementImageData = newData
               
            }
            .store(in: &cancellables)
        
        CenteredObjectZeroOriginService.shared.$centeredObjectZeroOriginData
            //.receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.centeredObjectZeroOriginData = newData
               
            }
            .store(in: &cancellables)
        
        if let data = centeredObjectZeroOriginData {
            update(data)
        } else {
            print ("MOVMENTdTAGIVER NIL")
        }
    }
    
    func update(_ data: EnsureObjectZeroOriginAtMovementCenter ) {
        postTiltObjectToOneCornerPerKeyDic = data.getPostTiltOneCornerPerKeyDic()
        
        postTiltObjectToPartFourCornerPerKeyDic = data.getPostTiltObjectToPartFourCornerPerKeyDic()
        
        uniquePartNames = data.getUniquePartNamesFromObjectDictionary()
        
        onScreenMovementFrameSize = data.onScreenMovementFrameSize
//        print(onScreenMovementFrameSize)
//        print("TEST")
        
    }
    
    func getPostTiltOneCornerPerKeyDic() -> PositionDictionary {
        movementImageData.objectImageData.postTiltObjectToOneCornerPerKeyDic
    }
    
    
    func getPostTiltObjectToPartFourCornerPerKeyDic() -> CornerDictionary {
        movementImageData.objectImageData.postTiltObjectToPartFourCornerPerKeyDic
    }

    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
        let dic = getPostTiltObjectToPartFourCornerPerKeyDic()
      
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
