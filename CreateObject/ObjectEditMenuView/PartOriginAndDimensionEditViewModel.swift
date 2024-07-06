//
//  PartOriginAndDimensionEditViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/07/2024.
//

import Foundation
import Combine


class PartOriginAndDimensionEditViewModel: ObservableObject {
    
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
  
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        ObjectEditService.shared.$partToEdit
            .receive(on: DispatchQueue.main)
            .assign(to: \.partToEdit,on: self)
            .store(in: &cancellables)

    }
}
//







//protocol DimensionPickerAndStepper {
//    var dimensionPropertyToEdit: PartTag {get set}
//    func setPropertyToEdit(_ propertyToEdit: PartTag)
//}
//
//extension DimensionPickerAndStepper {
//    func setPropertyToEdit(_ propertyToEdit: PartTag) {
//        ObjectEditService.shared.setDimensionPropertyToEdit(propertyToEdit)
//    }
//}
//

