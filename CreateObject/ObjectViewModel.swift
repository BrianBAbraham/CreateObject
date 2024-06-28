//
//  ObjectViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 28/06/2024.
//

import Foundation
import Combine

class ObjectViewModel: ObservableObject {
    
    @Published var partToEdit: Part = ObjectEditService.shared.partToEdit
    @Published var uniquePartNames: [String] = []
    @Published var preTiltObjectToPartFourCornerDictionary: CornerDictionary = [:]
    @Published var dictionaryForScreen: CornerDictionary = [:]
    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData
    


//    @Published var objectType: ObjectTypes = ObjectTypeService.shared.objectType
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        ObjectEditService.shared.$partToEdit
        .sink { [weak self] newData in
            self?.partToEdit = newData
          
        }
        .store(in: &cancellables)
        
        
        MovementImageService.shared.$movementImageData
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementImageData = newData
                self.uniquePartNames = getUniquePartNamesFromObjectDictionary()
                self.preTiltObjectToPartFourCornerDictionary = getPreTiltObjectToPartFourCornerPerKeyDic()
                // Call methods to update related data
            }
            .store(in: &cancellables)
        
//        ObjectTypeService.shared.$objectType
//        .sink { [weak self] newData in
//            self?.objectType = newData
//          
//        }
//        .store(in: &cancellables)
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
    
    func getPreTiltObjectToPartFourCornerPerKeyDic() -> CornerDictionary {
        movementImageData.objectImageData.preTilt.objectToPartFourCornerPerKeyDic
    }
    
}
