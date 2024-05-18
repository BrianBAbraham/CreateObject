//
//  MovementDataGetterVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2024.
//

import Foundation
import Combine

//struct MovementPickModel {
//
//    let forward: Double
//
//    
//
//}

//gets the picked movement
//provides the raw data from movmentImageData
class MovementDataGetterViewModel: ObservableObject {
    
   var movementDictionaryForScreen: CornerDictionary =
        MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData

    var uniquePartNames: [String] = []
    
    var preTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    
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
        
        
        MovementDictionaryForScreenService.shared.$movementDictionaryForScreen
            .receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementDictionaryForScreen = newData
                // Call methods to update related data
                self.updateData()
            }
            .store(in: &cancellables)

        updateData()
    }
    
    
    private func updateData() {
        uniquePartNames = getUniquePartNamesFromObjectDictionary()
        
        preTiltObjectToPartFourCornerPerKeyDic = getPreTiltObjectToPartFourCornerPerKeyDic()
    }
    
    
    func getPreTiltObjectToPartFourCornerPerKeyDic() -> CornerDictionary {
        movementImageData.objectImageData.preTiltObjectToPartFourCornerPerKeyDic
    }
    
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
        let dic = movementImageData.objectImageData.postTiltObjectToPartFourCornerPerKeyDic
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
    
    
    func getMaximumDimensionOfMotion() -> Double {
        let dic =  ConvertFourCornerPerKeyToOne(
            fourCornerPerElement: movementDictionaryForScreen).oneCornerPerKey
        
        
        
        let minMax = CreateIosPosition.minMaxPosition(dic)
        
        let motionDimension =
        CreateIosPosition.convertMinMaxToDimension(minMax)
        
        
        return motionDimension.width > motionDimension.length ? motionDimension.width: motionDimension.length
    }
    
}
    

