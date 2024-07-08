//
//  DimensionPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/07/2024.
//

import Foundation
import Combine
import SwiftUI



class DimensionPickerViewModel: PropertyEditBaseViewModel {
    
    @Published var dimensionPropertyToEdit = ObjectEditService.shared.dimensionPropertyToEdit

    @Published var editableDimension: [PartTag] = []
    
    var dimensionPropertyBinding: Binding<PartTag> {
        Binding<PartTag>(
            get: { self.dimensionPropertyToEdit },
            set: { self.setDimensionPropertyToEdit($0) }
        )
    }
    
    var partToEdit = ObjectEditService.shared.partToEdit
  
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
            super.init()

        ObjectEditService.shared.$partToEdit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.partToEdit = newData
                self?.setFirstAvailableDimensionPropertyActive()
                self?.editableDimension = self?.getPropertiesForDimensionPicker() ?? []
            }
            .store(in: &self.cancellables)
        
        ObjectEditService.shared.$dimensionPropertyToEdit
            .receive(on: DispatchQueue.main)
            .assign(to: \.dimensionPropertyToEdit,on: self)
            .store(in: &cancellables)

    }
    

    
    
    func getPropertiesForDimensionPicker() -> [PartTag] {

        switch partToEdit{
        
        case .backSupport:
            return [ .width, .height]
            
        case .backSupportHeadSupport:
            return [.length,  .width, .height]
            
        case .fixedWheelAtRearWithPropeller:
            return [.width]
        
        case .footSupport, .assistantFootLever:
            return [.length]
        
        default:
            return [.length, .width]
        }
    }
    
    
    func setDimensionPropertyToEdit(_ propertyToEdit: PartTag) {
        ObjectEditService.shared.setDimensionPropertyToEdit(propertyToEdit)
    }
    
    ///most parts have length and wdith, but for those that do not have length
    ///the default length cannot be use
    ///so set the first available dimension prroperty as the default
    ///otherwise no dimension property is highlighted and stepper have no effect
    func setFirstAvailableDimensionPropertyActive() {
        let editableDimension = getPropertiesForDimensionPicker()
        if let firstDimension = editableDimension.first {
            setDimensionPropertyToEdit(
                firstDimension
            )
        }
    }
    
}






