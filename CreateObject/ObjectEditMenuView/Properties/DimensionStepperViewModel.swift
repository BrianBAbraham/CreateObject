//
//  DimensionStepperViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/07/2024.
//

import Foundation
import Combine
import SwiftUI


class DimensionStepperViewModel: PropertyEditBaseViewModel {
    var partToEdit = ObjectEditService.shared.partToEdit
    
    var dimensionPropertyToEdit = ObjectEditService.shared.dimensionPropertyToEdit
    
    var stepperValueBinding: Binding<Double> {
        Binding<Double>(
            get: { self.getInitialSliderValue(self.partToEdit,self.dimensionPropertyToEdit) },
            set: {                     newValue in
                self.setValueForBilateralPartInUserEditedDic(
                    self.partToEdit,
                    self.dimensionPropertyToEdit,
                            newValue
                            )
                self.modifyObjectByCreatingFromName() }
        )
    }
    
//    var objectChainLabelsDefaultDic = ObjectDataService.shared.objectChainLabelsDefaultDic
  
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
            super.init()
        
        ObjectEditService.shared.$partToEdit
            .sink { [weak self] newData in
                self?.partToEdit = newData
            }
            .store(in: &self.cancellables)
        
        ObjectEditService.shared.$dimensionPropertyToEdit
            .receive(on: DispatchQueue.main)
            .assign(to: \.dimensionPropertyToEdit,on: self)
            .store(in: &cancellables)
        
//        ObjectDataService.shared.$objectChainLabelsDefaultDic
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.objectChainLabelsDefaultDic,on: self)
//            .store(in: &cancellables)
    }
    
    

    
    
//    
//    func setDimensionPropertyToEdit(_ propertyToEdit: PartTag) {
//        ObjectEditService.shared.setDimensionPropertyToEdit(propertyToEdit)
//    }
//    
//
//    
    

    
    
    

    
    

    

    
    

}

