//
//  DimensionPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/07/2024.
//

import Foundation
import Combine

class DimensionPickerViewModel: ObservableObject {
    
    
    @Published var dimensionPropertyToEdit = ObjectEditService.shared.dimensionPropertyToEdit
    @Published var doNotShow = true
    @Published var editableDimension: [PartTag] = []
    
    var partToEdit = ObjectEditService.shared.partToEdit
    var userEditedSharedDics = DictionaryService.shared.userEditedSharedDics
    var objectType = ObjectDataService.shared.objectType
    var objectChainLabelsDefaultDic = ObjectDataService.shared.objectChainLabelsDefaultDic
  
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        ObjectEditService.shared.$partToEdit
            .sink { [weak self] newData in
                self?.partToEdit = newData
                self?.setFirstDimensionPropertyActiveOnPartChange()
                self?.doNotShow = self?.getPartNotPresent() ?? true
                self?.editableDimension = self?.getPropertiesForDimensionPicker() ?? []
            }
            .store(in: &self.cancellables)
        
        ObjectEditService.shared.$dimensionPropertyToEdit
            .receive(on: DispatchQueue.main)
            .assign(to: \.dimensionPropertyToEdit,on: self)
            .store(in: &cancellables)
        
        ObjectDataService.shared.$objectType
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectType,on: self)
            .store(in: &cancellables)
        
        ObjectDataService.shared.$objectChainLabelsDefaultDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectChainLabelsDefaultDic,on: self)
            .store(in: &cancellables)
        
        DictionaryService.shared.$userEditedSharedDics
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEditedSharedDics,on: self)
            .store(in: &cancellables)

    }
    
    
    func getSidesPresentGivenPossibleUserEdit(_ partOrAssociatedPart: Part) -> [SidesAffected] {
        
        let oneOrTwoId = userEditedSharedDics.partIdsUserEditedDic[partOrAssociatedPart] ?? OneOrTwoId(objectType, partOrAssociatedPart).forPart
        

        guard let chainLabels = userEditedSharedDics.objectChainLabelsUserEditDic[objectType] ?? objectChainLabelsDefaultDic[objectType] else {
            fatalError()
        }
    
        var sidesPresent: [SidesAffected] = []
        //the part may be removed from both sides by user edit
        if chainLabels.contains(partOrAssociatedPart) {
            sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
        } else {
            sidesPresent = [.none]
        }

        let firstSidesPresentGivesSidesAffected = 0

        ObjectEditService.shared.setScopeOfEditForSide(sidesPresent[firstSidesPresentGivesSidesAffected])

        return sidesPresent
    }
    
    
    func getPartNotPresent() -> Bool {
        let partOrAssociatedPart =
        PartsRequiringLinkedPartUse(partToEdit).partForEditableOrigin
       let first = getSidesPresentGivenPossibleUserEdit(partOrAssociatedPart)[0]
        
        return
            first == .none ? true: false
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
        
        default: return [.length, .width]
        }
    }
    
    
    func setDimensionPropertyToEdit(_ propertyToEdit: PartTag) {
        ObjectEditService.shared.setDimensionPropertyToEdit(propertyToEdit)
    }
    
    
    func setFirstDimensionPropertyActiveOnPartChange() {
        let editableDimension = getPropertiesForDimensionPicker()
        if let firstDimension = editableDimension.first {
            setDimensionPropertyToEdit(
                firstDimension
            )
        }
    }
    
}
