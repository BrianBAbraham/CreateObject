//
//  OriginStepperViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine
import SwiftUI


class OriginStepperViewModel: PropertyEditBaseViewModel {
    var stepperValueBinding: Binding<Double> {
        Binding<Double>(
            get: { self.getInitialSliderValue(self.partToEdit,self.originPropertyToEdit) },
            set: {                     newValue in
                self.setValueForBilateralPartInUserEditedDic(
                    self.partToEdit,
                    self.originPropertyToEdit,
                            newValue
                            )
                self.modifyObjectByCreatingFromName() }
        )
    }
    var originPropertyToEdit = ObjectEditService.shared.originPropertyToEdit
    
    var partToEdit = ObjectEditService.shared.partToEdit
    
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
            super.init()

        ObjectEditService.shared.$partToEdit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.partToEdit = newData
              
            }
            .store(in: &self.cancellables)
        
        ObjectEditService.shared.$originPropertyToEdit
            .receive(on: DispatchQueue.main)
            .assign(to: \.originPropertyToEdit,on: self)
            .store(in: &cancellables)

    }
    
}
