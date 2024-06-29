//
//  ObjectDataGetterVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 16/05/2024.
//

import Foundation
import Combine


class ObjectDataGetterViewModel: ObservableObject {
    var partDataSharedDic = ObjectDataService.shared.partDataDic
    //DictionaryService.shared.partDataSharedDic
    
    var partDataDic = ObjectDataService.shared.partDataDic
    
    var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    var sidesAffected: SidesAffected = ObjectEditService.shared.scopeOfEditForSide
    
    var currentObjectType: ObjectTypes = .fixedWheelRearDrive

    
    @Published var userEditedSharedDics: UserEditedDictionaries = DictionaryService.shared.userEditedSharedDics
    
    var objectChainLabelsDefaultDic: ObjectChainLabelsDictionary = [:]
    
    let defaultMinMaxDimensionDic =
        DefaultMinMaxDimensionDictionary.shared
    
    let defaultMinMaxOriginDic =
        DefaultMinMaxOriginDictionary.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    init () {
        DictionaryService.shared.$userEditedSharedDics
            .sink { [weak self] newData in
                self?.userEditedSharedDics = newData
            }
            .store(in: &self.cancellables)
        
        
//        DictionaryService.shared.$partDataSharedDic
//            .sink { [weak self] newData in
//                self?.partDataSharedDic = newData
//            }
//            .store(in: &self.cancellables)
//        
  
        
        ObjectDataService.shared.$partDataDic
            .sink { [weak self] newData in
                self?.partDataDic = newData
            }
            .store(in: &self.cancellables)
        
        
        ObjectEditService.shared.$scopeOfEditForSide
            .sink { [weak self] newData in
                self?.sidesAffected = newData
            }
            .store(in: &self.cancellables)
        
        ObjectEditService.shared.$choiceOfEditForSide
            .sink { [weak self] newData in
                self?.choiceOfEditForSide = newData
            }
            .store(in: &self.cancellables)
        
        ObjectDataService.shared.$objectType
            .sink { [weak self] newData in
                self?.currentObjectType = newData
            }
            .store(in: &self.cancellables)
//        
//        ObjectImageService.shared.$objectImageData
//            .sink { [weak self] newData in
//                self?.objectImageData = newData
//            }
//            .store(in: &self.cancellables)
        
        ObjectDataService.shared.$objectChainLabelsDefaultDic
            .sink { [weak self] newData in
                self?.objectChainLabelsDefaultDic = newData
            }
            .store(in: &self.cancellables)
        
        
    }
    
    func getInitialSliderValue(
        _ part: Part,
        _ propertyToEdit: PartTag
        ,
        _ sidesAffected: SidesAffected? = nil
    
    ) -> Double {

        var value: Double? = nil
        if let partData = partDataDic[part] {//parts edited out do not exist
            let idForLeftOrRight = choiceOfEditForSide == .right ? PartTag.id1: PartTag.id0
        
            var id: PartTag
            if let sideAsId = sidesAffected?.getOneId() {
                id = sideAsId
            } else {
                id =  partData.id.one ?? idForLeftOrRight//two sources for id
            }
           
            
            switch propertyToEdit {
            case .height:
                let dimension = partData.dimension.returnValue(id)
                
                value = dimension.height
            case .width:
                let dimension = partData.dimension.returnValue(id)
                value = dimension.width
            case.length:
                let dimension = partData.dimension.returnValue(id)
                value = dimension.length
            case .xOrigin, .yOrigin:
                let name = CreateNameFromIdAndPart(id, part).name
                let offsetToOrigin = userEditedSharedDics.originOffsetUserEditedDic[name] ?? ZeroValue.iosLocation

                value = propertyToEdit == .xOrigin ?
                offsetToOrigin.x: offsetToOrigin.y
                
            case .angle:
                value =
                    partData.angles.returnValue(id).x.converted(to: .degrees).value
            
            default:
                break
            }
          
            
        }
            let whenPartHasBeenRemovedAndValueNotUsed = 0.0
          
            return value ?? whenPartHasBeenRemovedAndValueNotUsed
    }
    
    
    func getSidesPresentGivenPossibleUserEdit(_ partOrAssociatedPart: Part) -> [SidesAffected] {
        
        let oneOrTwoId = userEditedSharedDics.partIdsUserEditedDic[partOrAssociatedPart] ?? OneOrTwoId(currentObjectType, partOrAssociatedPart).forPart
        

        guard let chainLabels = userEditedSharedDics.objectChainLabelsUserEditDic[currentObjectType] ?? objectChainLabelsDefaultDic[currentObjectType] else {
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
        

        ObjectEditService.shared.setBothOrLeftOrRightAsEditible(sidesPresent[firstSidesPresentGivesSidesAffected])

        return sidesPresent
    }
    
    
    func getPartNotPresent(_ partOrAssociatedPart: Part) ->Bool {
       let first = getSidesPresentGivenPossibleUserEdit(partOrAssociatedPart)[0]
        
        return
            first == .none ? true: false
    }
    
    
    func getSidesPresentGivenUserEditContainsLeft(_ part: Part) -> Bool {
        getSidesPresentGivenPossibleUserEdit(part).contains(SidesAffected.left) ?
            true: false
    }
    
    
    func getSidesPresentGivenUserEditContainsRight(_ part: Part) -> Bool {
        getSidesPresentGivenPossibleUserEdit(part).contains(SidesAffected.right) ?
            true: false
    }
    
    
    func geMinMax(
        _ part: Part,
        _ propertyToBeEdited: PartTag) -> (min: Double, max: Double) {

            var minMaxValue =
                (min: 0.0, max: 0.0)
            
           
            switch propertyToBeEdited {
//            case .angle:
//               let values =
//                PartDefaultAngle(part, currentObjectType).minMaxAngle
//
//                minMaxValue =
//                    (min: values.min.value,
//                     max: values.max.value)
                
            case .height:
                let values =
                    defaultMinMaxDimensionDic.getDefault(
                        part,
                        currentObjectType)
                minMaxValue = (min: values.min.height,
                               max: values.max.height)
                
            case .length:
                let values =
                    defaultMinMaxDimensionDic.getDefault(
                        part,
                        currentObjectType)
                minMaxValue = (min: values.min.length,
                               max: values.max.length)
                
            case .width:
                let values =
                    defaultMinMaxDimensionDic.getDefault(
                        part,
                        currentObjectType)
                minMaxValue = (min: values.min.width,
                               max: values.max.width)
                
            case .xOrigin, .yOrigin, .zOrigin:
                let values =
                    defaultMinMaxOriginDic.getDefault(
                        part,
                        currentObjectType)
                minMaxValue = (min: values.min.x,
                               max: values.max.x)
               // print(minMaxValue)
            default: break
            }
        return minMaxValue
    }
}
