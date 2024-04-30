//
//  ArcViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 30/04/2024.
//

import Foundation
import Combine

class ArcViewModel: ObservableObject {
    


    @Published var movementDictionaryForScreen: CornerDictionary = MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    @Published var uniqueArcPointNames: [String] = []
    @Published var uniqueArcNames: [String] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(){
        MovementDictionaryForScreenService.shared.$movementDictionaryForScreen
            .sink { [weak self] newData in
                self?.movementDictionaryForScreen = newData
            }
            .store(
                in: &cancellables
            )
        
        uniqueArcNames = getUniqueArcNames()
        uniqueArcPointNames = getUniqueArcPointNames()
    }
    
    func getUniqueArcPointNames() -> [String] {

        Array( movementDictionaryForScreen.keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
      
    }
    
    
    func getUniqueArcNames() -> [String] {
       var names = getUniqueArcPointNames()
        names = StringAfterSecondUnderscore.get(in: names)
    
    names = Array(Set(names))
    return names
        
    }
    
}
