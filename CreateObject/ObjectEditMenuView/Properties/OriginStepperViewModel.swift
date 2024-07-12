//
//  OriginStepperViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine
import SwiftUI


class OriginStepperViewModel: PropertyEditBase, SharedOriginPropertyToEdit {
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
    

internal var cancellables: Set<AnyCancellable> = []
    
    override init() {
            super.init()
        subscribeToDataService()

    }
}


protocol SharedOriginPropertyToEdit: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    var originPropertyToEdit: PartTag { get set }
       
       func subscribeToDataService()
   }

   extension SharedOriginPropertyToEdit {
       func subscribeToDataService() {
           ObjectEditService.shared.$originPropertyToEdit
               .receive(on: DispatchQueue.main)
               .assign(to: \.originPropertyToEdit,on: self)
               .store(in: &cancellables)
       }
   }
