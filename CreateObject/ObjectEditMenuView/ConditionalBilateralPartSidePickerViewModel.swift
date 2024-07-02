//
//  ConditionalBilateralPartSidePickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/07/2024.
//

import Foundation
import Combine

class ConditionalBilateralPartSidePickerViewModel: ObservableObject {
    @Published var showMenu = false
    static let objectEditService = ObjectEditService.shared
    var partToEdit = objectEditService.partToEdit
   
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        ObjectEditService.shared.$partToEdit
            .sink { [weak self] newData in
                self?.partToEdit = newData
                self?.showMenu = self?.getSidePickerMenuStatus() ?? false
            }
            .store(in: &self.cancellables)
    }
    
    func getSidePickerMenuStatus() -> Bool {
        let alwaysUnilateral =
            OneOrTwoId.partWhichAreAlwaysUnilateral.contains(partToEdit)
        let partGroup = partToEdit.transformPartToPartGroup()
        let alwaysBilateral =
        [.caster, .casterFork, .casterJoint, .fixedWheel, .fixedWheelJoint].contains(partGroup)
        let showMenu = !(alwaysUnilateral || alwaysBilateral)
        
        return showMenu
    }
}



class BilateralPartSidePickerViewModel: ObservableObject {
    @Published var choiceOfEditForSide = objectEditService.choiceOfEditForSide
    
    @Published var scopeOfEditForSide = objectEditService.scopeOfEditForSide
   
    static let objectEditService = ObjectEditService.shared
    var partToEdit = objectEditService.partToEdit
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        Self.objectEditService.$partToEdit
            .receive(on: DispatchQueue.main)
            .assign(to: \.partToEdit,on: self)
            .store(in: &cancellables)
        
        Self.objectEditService.$choiceOfEditForSide
            .receive(on: DispatchQueue.main)
            .assign(to: &$choiceOfEditForSide)
        
        Self.objectEditService.$scopeOfEditForSide
            .receive(on: DispatchQueue.main)
            .assign(to: &$scopeOfEditForSide)

    }
    
    
    func setSideToEdit(
        _ sideChoice: SidesAffected
    ) {
        ObjectEditService.shared.setSideToEdit(
            sideChoice
        )
    }
}
