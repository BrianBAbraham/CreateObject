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
    @Published var dimensionForEditing: PartTag = .length

    @Published var objectChainLabelsDefaultDic: ObjectChainLabelDictionary = [:]
    static let shared = DataService()
    private init() {

    }
}




class ObjectEditViewModel: ObservableObject {
    @Published  var userEditedDic: UserEditedDictionaries = UserEditedDictionaries.shared
    var objectType: ObjectTypes = .fixedWheelRearDrive
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
    }
    
}

extension ObjectEditViewModel {
    
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
    
    
    
    func setWhenPartChangesOneOrTwoStatus(_ tag: String, _ part: Part) {
        
        let partChain = LabelInPartChainOut(part).partChain
        
        if tag == "left" || tag == "right" {

            let newId: OneOrTwo<PartTag> = (tag == "left") ? .one(one: .id0) : .one(one: .id1)

            let chainLabelForFootWasRemoved = DataService.shared.userEditedSharedDic.objectChainLabelsUserEditDic[objectType]?.contains(part) == false

            if chainLabelForFootWasRemoved {
                restoreChainLabelToObject(part)
            }

            let ignoreFirstItem = 1 // relevant part subsequent
            for index in ignoreFirstItem..<partChain.count {
                DataService.shared.userEditedSharedDic.partIdsUserEditedDic[partChain[index]] = newId
            }
        }

        if tag == "none" {
            removeChainLabelFromObject(part)
        }

        if tag == "both" {
            setPartIdDicInKeyToNilRestoringDefault(partChain)
            DataService.shared.userEditedSharedDic.objectChainLabelsUserEditDic.removeValue(forKey: objectType)
            DataService.shared.scopeOfEditForSide = .both
        }
    }

    
    func updatePartBeingOnBothSides(isLeftSelected: Bool, isRightSelected: Bool) {
       
        if isLeftSelected && isRightSelected {
            DataService.shared.presenceOfPartForSide = .both
            setWhenPartChangesOneOrTwoStatus("both", Part.footSupport)
        } else if isLeftSelected {
            DataService.shared.presenceOfPartForSide = .left
            setWhenPartChangesOneOrTwoStatus("left", Part.footSupport)
        } else if isRightSelected {
            DataService.shared.presenceOfPartForSide = .right
            setWhenPartChangesOneOrTwoStatus("right", Part.footSupport)
        } else {
            DataService.shared.presenceOfPartForSide = .none
            setWhenPartChangesOneOrTwoStatus("none", Part.footSupport)
        }
    }
    
    
    func setSidesToBeEdited(_ sides: Side) {
        DataService.shared.scopeOfEditForSide = sides
    }
    
    
    func getPresenceOfPartForSide() -> Side {
        DataService.shared.presenceOfPartForSide
    }
    
    
    func setOneOrTwoDimensionForTwoInUserEditedDic(
        _ length: Double,
        _ part: Part) {

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
             length: length,
             height:dimension.height)
        }
        
        
        func originModifiedByLength(_ origin: PositionAsIosAxes) -> PositionAsIosAxes {
        (x: origin.x,
         y: origin.y,
         z: origin.z)
        }
        
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
    
    
    func setOneOrTwoDimensionForOneInUserEditedDic(
        _ value: Double,
        _ part: Part,
        _ selectedDimension: PartTag) {

    let name = getName(.id0, part)

    let currentDimension =
            getEditedOrDefaultDimension(name, part, .id0)

    let newDimension = selectedDimension == .width ?
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
        DataService.shared.dimensionForEditing = dimension
    }

}


