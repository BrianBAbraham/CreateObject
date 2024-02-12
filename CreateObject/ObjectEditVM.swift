//
//  ObjectEditVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 03/02/2024.
//

import Foundation
import Combine


class DataService: ObservableObject {
    @Published var userEditedSharedDic: UserEditedDictionaries = UserEditedDictionaries.shared
    @Published var dimensionSharedDic: Part3DimensionDictionary = [:]
    @Published var partDataSharedDic: [Part: PartData] = [:]
    @Published var currentObjectType: ObjectTypes = .fixedWheelRearDrive
    @Published var presenceOfPartForSide: Side = .both
    @Published var scopeOfEditForSide: Side = .both
    @Published var dimensionValueToEdit: PartTag = .length

    @Published var objectChainLabelsDefaultDic: ObjectChainLabelDictionary = [:]
    static let shared = DataService()
    private init() {

    }
}




class ObjectEditViewModel: ObservableObject {
    @Published  var userEditedDic: UserEditedDictionaries = UserEditedDictionaries.shared
    var objectType: ObjectTypes = .fixedWheelRearDrive
    var dimensionValueToEdit: PartTag = .length
    private var cancellables: Set<AnyCancellable> = []
    
    
    
    init () {
        DataService.shared.$userEditedSharedDic
            .sink { [weak self] newData in
                self?.userEditedDic = newData
            }
            .store(in: &self.cancellables)
        
        DataService.shared.$currentObjectType
            .sink { [weak self] newData in
                self?.objectType = newData
            }
            .store(in: &self.cancellables)
        
        DataService.shared.$dimensionValueToEdit
            .sink { [weak self] newData in
                self?.dimensionValueToEdit = newData
            }
            .store(in: &self.cancellables)
    }
    
}

extension ObjectEditViewModel {
    
    
//    func getDimensionValueToBeEdited() -> PartTag{
//        return dimensionValueToEdit
//    }
//
    
    func setCurrentRotation(
        _ maxMinusSliderValue: Double) {
            var partName: String {
                let parts: [Parts] = [Part.objectOrigin, PartTag.id0, PartTag.stringLink, Part.sitOnTiltJoint, PartTag.id0, PartTag.stringLink, Part.sitOn, PartTag.id0]
               return
                CreateNameFromParts(parts ).name    }
            
        let angleUserEditedDic =
            [partName:
                 (x:
                    Measurement(value: maxMinusSliderValue, unit: UnitAngle.degrees),
                  y: ZeroValue.angle,
                  z: ZeroValue.angle)]
            
        DataService.shared.userEditedSharedDic.angleUserEditedDic += angleUserEditedDic
        }
    
    
    func replaceChainLabelForObject(
        _ removal: Part,
        _ replacement: Part) {
                 
        removeChainLabelFromObject(removal)

        guard var curentObjectChainLabels = DataService.shared.userEditedSharedDic
                .objectChainLabelsUserEditDic[objectType]  else {
         fatalError()
        }
        curentObjectChainLabels += [replacement]

        DataService.shared.userEditedSharedDic
            .objectChainLabelsUserEditDic[objectType] =
                curentObjectChainLabels
       
    }
    
    
    func removeChainLabelFromObject(
        _ chainLabel: Part) {
        guard let currentObjectChainLabels =
                DataService.shared.userEditedSharedDic.objectChainLabelsUserEditDic[objectType] ??
                    ObjectChainLabel.dictionary[objectType] else {
                          fatalError()
                        }
        let newChainLabels =
            currentObjectChainLabels.filter { $0 != chainLabel}
        DataService.shared.userEditedSharedDic.objectChainLabelsUserEditDic[objectType] = newChainLabels
    }
    
    
    func restoreChainLabelToObject(_ chainLabel: Part) {
     
        guard let currentObjectChainLabels =
                ObjectChainLabel.dictionary[objectType] else {
            fatalError("no chain labels for object \(objectType)")
        }
        let newChainLabels = currentObjectChainLabels + [chainLabel]
        
        DataService.shared.userEditedSharedDic.objectChainLabelsUserEditDic[objectType] =
            newChainLabels
    }
    
    
    func setPartIdDicInKeyToNilRestoringDefault (_ partChainWithoutRoot: [Part]) {
        for part in partChainWithoutRoot {
            DataService.shared.userEditedSharedDic.partIdsUserEditedDic.removeValue(forKey: part)
        }
    }
    
    func getDimensionValueToBeEdited() -> PartTag {
        //print(dimensionValueToEdit)
        return
        dimensionValueToEdit
       // DataService.shared.dimensionValueToEdit
    }
    
    
    func setSidesToBeEdited(_ sides: Side) {
        //print(sides)
        DataService.shared.scopeOfEditForSide = sides
    }
    
    
    func getPresenceOfPartForSide() -> Side {
        DataService.shared.presenceOfPartForSide
    }
    
    
    func convertLeftRightSelectionToSideSelection(
        _ isLeftSelected: Bool,
        _ isRightSelected: Bool) -> Side {
       
        if isLeftSelected && isRightSelected {
            return .both
        } else if isLeftSelected {
            return .left
        } else if isRightSelected {
            return .right
        } else {
            return .none
        }
    }

    
    func setWhenPartChangesOneOrTwoStatus(
        _ isLeftSelected: Bool,
        _ isRightSelected: Bool,
        _ part: Part) {
            
        let side = convertLeftRightSelectionToSideSelection(isLeftSelected, isRightSelected)
            
        DataService.shared.presenceOfPartForSide = side
        
        let partChain = LabelInPartChainOut(part).partChain
        
        switch side {
        case .left, .right:
            let newId: OneOrTwo<PartTag> = (side == .left) ?
                .one(one: .id0): //if left requires .id0 for x < 0
                .one(one: .id1)  //if right requires .i1 for x >= 0
            
            let chainLabelForFootWasAlreadyRemoved = DataService.shared.userEditedSharedDic.objectChainLabelsUserEditDic[objectType]?.contains(part) == false
            
            if chainLabelForFootWasAlreadyRemoved {
                restoreChainLabelToObject(part) //toggle is restoring
            }
            
            let ignoreFirstItem = 1 // relevant part subsequent
            for index in ignoreFirstItem..<partChain.count {
                DataService.shared.userEditedSharedDic.partIdsUserEditedDic[partChain[index]] = newId// if only either L or R change id to suit
            }
        case .none:
            removeChainLabelFromObject(part)
        case .both:
            setPartIdDicInKeyToNilRestoringDefault(partChain)
            DataService.shared.userEditedSharedDic.objectChainLabelsUserEditDic.removeValue(forKey: objectType)
            DataService.shared.scopeOfEditForSide = .both
        }
    }
    
    
    func setValueForBilateralPartInUserEditedDic(
        _ value: Double,
        _ part: Part,
        _ dimensionOrOrigin: PartTag,
        _ valueToBeChange: PartTag) {

        switch DataService.shared.scopeOfEditForSide {
        case .both:
            process(.id0)
            process(.id1)
        case.left:
            process(.id0)
        case.right:
            process(.id1)
        default:
            break
        }
     
      
        func process(_ id: PartTag) {
            let name = getName( id, part)
            let currentDimension = getEditedOrDefaultDimension(name, part, id)
            let newDimension = dimensionWithModifiedLength(currentDimension)
            DataService.shared.userEditedSharedDic.dimensionUserEditedDic +=
            [name: newDimension]
        }
        
    
        func dimensionWithModifiedLength(_ dimension: Dimension3d) -> Dimension3d {
            (width: dimension.width,
             length: value,
             height:dimension.height)
        }
        
        
//        func originModifiedByLength(_ origin: PositionAsIosAxes) -> PositionAsIosAxes {
//        (x: origin.x,
//         y: origin.y,
//         z: origin.z)
//        }
        
    }
    
    
    func getName (_ id: PartTag, _ part: Part =  Part.footSupportHangerLink) -> String {
        var name: String {
            let parts: [Parts] =
            [Part.objectOrigin, PartTag.id0, PartTag.stringLink, part , id, PartTag.stringLink, Part.sitOn, PartTag.id0]
           return
            CreateNameFromParts(parts ).name    }
        return name
    }
    
    
    func getEditedOrDefaultDimension(
        _ name: String,
        _ part: Part,
        _ id: PartTag)
        -> Dimension3d {
        guard let partData = DataService.shared.partDataSharedDic[part] else {
            fatalError()
        }
        return
            partData.dimension.returnValue(id)
    }
    
    
    func setEitherDimensionForOnePartInUserEditedDic(
        _ value: Double,
        _ part: Part//,
    //    _ selectedDimension: PartTag
    ) {
//print(selectedDimension)
    let name = getName(.id0, part)

    let currentDimension =
            getEditedOrDefaultDimension(name, part, .id0)

    let newDimension = dimensionValueToEdit == .width ?
        (width: value,
         length: currentDimension.length,
         height:currentDimension.height)
        :
        (width: currentDimension.width,
         length: value,
         height:currentDimension.height)
 
    DataService.shared.userEditedSharedDic.dimensionUserEditedDic +=
        [name: newDimension]
    }
    
    
    func updateDimensionToBeEdited(_ dimension: PartTag) {
      
        DataService.shared.dimensionValueToEdit = dimension
        //print(dimensionValueToEdit)
    }

}


