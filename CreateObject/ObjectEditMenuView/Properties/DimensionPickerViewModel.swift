//
//  DimensionPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/07/2024.
//

import Foundation
import Combine
import SwiftUI

class DimensionPickerViewModel: DimensionBaseViewModel {
    
    @Published var dimensionPropertyToEdit = ObjectEditService.shared.dimensionPropertyToEdit

    @Published var editableDimension: [PartTag] = []
    
//    var dimensionPropertyBinding: Binding<PartTag> {
//        Binding<PartTag>(
//            get: { self.dimensionPropertyToEdit },
//            set: { self.setDimensionPropertyToEdit($0) }
//        )
//    }
    
    var partToEdit = ObjectEditService.shared.partToEdit

    var objectChainLabelsDefaultDic = ObjectDataService.shared.objectChainLabelsDefaultDic
  
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


        ObjectDataService.shared.$objectChainLabelsDefaultDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectChainLabelsDefaultDic,on: self)
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
        
        print(propertyToEdit)
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


class DimensionBaseViewModel: ObservableObject {
    @Published var doNotShow = true
    var objectType = ObjectDataService.shared.objectType
    var userEditedSharedDics = DictionaryService.shared.userEditedSharedDics
    
    private var cancellables: Set<AnyCancellable> = []

    init() {
        ObjectEditService.shared.$scopeOfEditForSide
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.doNotShow = self?.getPartNotPresent() ?? true
            }
            .store(in: &self.cancellables)
        
        ObjectDataService.shared.$objectType
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectType,on: self)
            .store(in: &cancellables)
        
        DictionaryService.shared.$userEditedSharedDics
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEditedSharedDics,on: self)
            .store(in: &cancellables)
    }

    func getPartNotPresent() -> Bool {
        let partOrAssociatedPart = PartsRequiringLinkedPartUse(ObjectEditService.shared.partToEdit).partForEditableOrigin
        let first = getSidesPresentGivenPossibleUserEdit(partOrAssociatedPart)[0]
        return first == .none
    }

    func getSidesPresentGivenPossibleUserEdit(_ partOrAssociatedPart: Part) -> [SidesAffected] {
        guard let chainLabels = DictionaryService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[ObjectDataService.shared.objectType] ?? ObjectDataService.shared.objectChainLabelsDefaultDic[ObjectDataService.shared.objectType] else {
            fatalError()
        }

        var sidesPresent: [SidesAffected] = []
        if chainLabels.contains(partOrAssociatedPart) {
            let oneOrTwoId: OneOrTwo<PartTag> = DictionaryService.shared.userEditedSharedDics.partIdsUserEditedDic[partOrAssociatedPart] ?? OneOrTwoId(ObjectDataService.shared.objectType, partOrAssociatedPart).forPart
            sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
        } else {
            sidesPresent = [.none]
        }

        return sidesPresent
    }
}
