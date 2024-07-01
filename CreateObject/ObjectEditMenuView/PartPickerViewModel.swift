//
//  PartPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 01/07/2024.
//

import Foundation
import Combine

class PartPickerViewModel: ObservableObject {
    
    @Published var objectType = ObjectDataService.shared.objectType
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        
        ObjectDataService.shared.$objectType
            .sink { [weak self] newData in
                self?.objectType = newData
             
            }
            .store(in: &self.cancellables)
    }
    
    func setSideToEdit(
        _ sideChoice: SidesAffected
    ) {
        ObjectEditService.shared.setSideToEdit(
            sideChoice
        )
    }
    
    
    func setBothOrLeftOrRightAsEditible(
        _ sideChoice: SidesAffected
    ) {
        ObjectEditService.shared.setBothOrLeftOrRightAsEditible(
            sideChoice)
    }
    
    
    func setPartToEdit(_ partName: String) {
        guard let part = Part(rawValue: partName) else {
            fatalError("no part for that part name")
        }
        ObjectEditService.shared.setPartToEdit(part)
        
        //partToEdit = part
    }
}
