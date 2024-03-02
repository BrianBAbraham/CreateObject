//
//  ObjectEditVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 03/02/2024.
//

import Foundation
import Combine

///LOGIC
///picker determines choiceOfEditForSide
///AND
///scopeOfEditForSide-changes determine choiceOfEditForSide:
///current choiceOfEditForSide removed?
///if .both -> .left || .right set to .right || .left, respectively
///if .left || .right -> .none set to .none
///current choiceOfEditForSide add?
///if .none -> .left || .right set to .left || .right, respectively
///if .left || .right  -> .both, set to .both

class ObjectEditViewModel: ObservableObject {
    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionaries.shared
    
    var objectType: ObjectTypes = .fixedWheelRearDrive
    
   var dimensionPropertyToEdit: PartTag = BilateralPartWithOnePropertyToChangeService.shared.dimensionPropertyToEdit
    
    var scopeOfEditForSide: SidesAffected = BilateralPartWithOnePropertyToChangeService.shared.scopeOfEditForSide
    
    var choiceOfEditForSide: SidesAffected = BilateralPartWithOnePropertyToChangeService.shared.choiceOfEditForSide
    
    var partDataSharedDic = DictionaryService.shared.partDataSharedDic
    
    @Published var choiceOfPartForEdit = Part.mainSupport

    private var cancellables: Set<AnyCancellable> = []
    
    init () {
        DictionaryService.shared.$userEditedSharedDics
            .sink { [weak self] newData in
                self?.userEditedSharedDics = newData
            }
            .store(in: &cancellables)
        
        DictionaryService.shared.$currentObjectType
            .sink { [weak self] newData in
                self?.objectType = newData
            }
            .store(in: &self.cancellables)
        
        BilateralPartWithOnePropertyToChangeService.shared.$dimensionPropertyToEdit
            .sink { [weak self] newData in
                self?.dimensionPropertyToEdit = newData
            }
            .store(in: &self.cancellables)
        
        
        DictionaryService.shared.$partDataSharedDic
            .sink { [weak self] newData in
                self?.partDataSharedDic = newData
            }
            .store(in: &self.cancellables)

        
        BilateralPartWithOnePropertyToChangeService.shared.$scopeOfEditForSide
            .sink { [weak self] newData in
                self?.scopeOfEditForSide = newData
            }
            .store(in: &self.cancellables)
        
        BilateralPartWithOnePropertyToChangeService.shared.$choiceOfEditForSide
            .sink { [weak self] newData in
                self?.choiceOfEditForSide = newData
            }
            .store(in: &self.cancellables)
    }
}



//MARK: get
extension ObjectEditViewModel {
    func getChoiceOfPartToEdit() -> Part{
        choiceOfPartForEdit
    }
    
    
    func getDimensionPropertyToBeEdited() -> PartTag {
        //print(dimensionPropertyToEdit)
        return
            dimensionPropertyToEdit
    }
    
    
    func getScopeOfEditForSide() -> [SidesAffected] {
        switch scopeOfEditForSide{
        case .both:
            return [.both, .left, .right]
        case .left:
            return [.left]
        case .right:
            return [.right]
        case .none:
            return [.none]
        }
    }
    
    
    func getChoiceOfEditForSide() -> SidesAffected {
        choiceOfEditForSide
    }
    
    
    func getEditedOrDefaultDimension(
        _ name: String,
        _ part: Part,
        _ id: PartTag)
        -> Dimension3d {

            guard let partData = partDataSharedDic[part] else {
                fatalError()
            }
        return
            partData.dimension.returnValue(id)
    }
    
    
    func getEditedOrDefaultOriginOffset(
        _ name: String)
        -> PositionAsIosAxes {

        return
            userEditedSharedDics.parentToPartOriginOffsetUserEditedDic[name] ?? ZeroValue.iosLocation
    }
    
    
    func getEditedOrDefaultOrigin(
        _ name: String,
        _ part: Part,
        _ id: PartTag)
        -> PositionAsIosAxes {

            guard let partData = partDataSharedDic[part] else {
                fatalError()
            }
        return
            partData.childOrigin.returnValue(id)
    }
    
    

}



extension ObjectEditViewModel {
    
    func setChoiceOfPartToEdit(_ partName: String) {
        guard let part = Part(rawValue: partName) else {
            fatalError("no part for that part name")
        }
      
        choiceOfPartForEdit = part
    }
    
    
    func convertLeftRightSelectionToSideSelection(
        _ isLeftSelected: Bool,
        _ isRightSelected: Bool) -> SidesAffected {
       
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

    func setBothOrLeftOrRightAsEditible(_ sideChoice: SidesAffected) {
        BilateralPartWithOnePropertyToChangeService.shared.setBothOrLeftOrRightAsEditible(sideChoice)
    }
    
    
    
    func setBothOrLeftOrRightAsEditibleChoice(_ sideChoice: SidesAffected) {
        BilateralPartWithOnePropertyToChangeService.shared.setBothOrLeftOrRightAsEditibleChoice(sideChoice)
    }
    

    func setCurrentRotation(
        _ maxMinusSliderValue: Double) {
            var partName: String {
                let parts: [Parts] = [Part.objectOrigin, PartTag.id0, PartTag.stringLink, Part.sitOnTiltJoint, PartTag.id0, PartTag.stringLink, Part.mainSupport, PartTag.id0]
               return
                CreateNameFromParts(parts ).name    }
            
        let angleUserEditedDic =
            [partName:
                 (x:
                    Measurement(value: maxMinusSliderValue, unit: UnitAngle.degrees),
                  y: ZeroValue.angle,
                  z: ZeroValue.angle)]

            DictionaryService.shared.angleUserEditedDicModifier(angleUserEditedDic)
    }
    
    
    func setPartIdDicInKeyToNilRestoringDefault (_ partChainWithoutRoot: [Part]) {
        //PARTIDUSEREDITEDICCHANGE
        for part in partChainWithoutRoot {
            DictionaryService.shared.partIdsUserEditedDicReseter(part)
        }
    }
    
    
    func setWhenPartChangesOneOrTwoStatus(
        _ isLeftSelected: Bool,
        _ isRightSelected: Bool,
        _ part: Part) {
            print(part)
        let side = //.both/.left/.right/.none
            convertLeftRightSelectionToSideSelection(
                isLeftSelected,
                isRightSelected)
            
        let partChain = LabelInPartChainOut(part).partChain
            
        let oldScope = scopeOfEditForSide
        
        BilateralPartWithOnePropertyToChangeService.shared.setBothOrLeftOrRightAsEditible(side)
            
        switch side {
        case .left, .right:
            
            let newId: OneOrTwo<PartTag> = (side == .left) ?
                .one(one: .id0): //if left requires .id0 for x < 0
                .one(one: .id1)  //if right requires .i1 for x >= 0
            
            let chainLabelWasAlreadyRemoved = userEditedSharedDics.objectChainLabelsUserEditDic[objectType]?.contains(part) == false
            
            if chainLabelWasAlreadyRemoved {
                restoreChainLabelToObject(part) //toggle is restoring
            }
            
            let ignoreFirstItem = 1 // relevant part subsequent
            for index in ignoreFirstItem..<partChain.count {
                print("\(partChain[index]) \(newId)")
                DictionaryService.shared.partIdsUserEditedDicModifier([partChain[index]: newId])
            }
        case .none:
            removeChainLabelFromObject(part)
        case .both:

            setPartIdDicInKeyToNilRestoringDefault(partChain)
            DictionaryService.shared.objectChainLabelsUserEditDicReseter(objectType)
        }
            
        setNewValueForChoice()

            func setNewValueForChoice() {
                var newChoice = SidesAffected.none
                //from both to one
                if oldScope == .both && isRightSelected ||
                    oldScope == .both && isLeftSelected{
                    newChoice = side}
                //from one to both
                if oldScope == .left && isRightSelected ||
                   oldScope == .right && isLeftSelected {
                    newChoice = .both}
                //from one to none
                if oldScope == .left && !isRightSelected ||
                   oldScope == .right && !isLeftSelected {
                    newChoice = .none}
                //from none to one
                if oldScope == .none && isRightSelected ||
                   oldScope == .none && isLeftSelected {
                    newChoice = side
                }
                BilateralPartWithOnePropertyToChangeService.shared.setBothOrLeftOrRightAsEditibleChoice(newChoice)
            }
    }
    
    
    ///the value may be for origin or dimension
    ///origin may be x or y
    ///dimension may be width or length
    func setValueForBilateralPartInUserEditedDic(
        _ value: Double,
        _ part: Part,
        _ partPropertyToBeChanged: PartTag) {
        switch choiceOfEditForSide {
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
            let name = CreateNameFromIdAndPart(id, part).name
            switch partPropertyToBeChanged {
            case .length, .width:
                let currentDimension =
                    getEditedOrDefaultDimension(name, part, id)
                let newDimension =
                    dimensionWithModifiedProperty(currentDimension, partPropertyToBeChanged)
                DictionaryService.shared.dimensionUserEditedDicModifier([name: newDimension])
            case .xOrigin, .yOrigin:
                let currentOrigin = getEditedOrDefaultOriginOffset(name)
                let newOriginOffset = partPropertyToBeChanged == .xOrigin ? xOriginModified(currentOrigin, id) : yOriginModified(currentOrigin, id)
                DictionaryService.shared.originOffsetUserEdtiedDicModifier([name: newOriginOffset])
                
            default: break
            }
        }
        
            
        func dimensionWithModifiedProperty(_ dimension: Dimension3d, _ property: PartTag) -> Dimension3d {
            switch property {
            case .length:
                return dimensionWithModifiedLength(dimension)
            case.width:
                return dimensionWithModifiedWidth(dimension)
            default: return dimension
            }
            
            func dimensionWithModifiedLength(_ dimension: Dimension3d) -> Dimension3d {
                (width: dimension.width,
                 length: value,
                 height:dimension.height)
            }
            
            func dimensionWithModifiedWidth(_ dimension: Dimension3d) -> Dimension3d {
                (width: value,
                 length: dimension.length,
                 height:dimension.height)
            }
        }
    
       
        func xOriginModified(_ origin: PositionAsIosAxes, _ id: PartTag) -> PositionAsIosAxes {
            let mod = makeLeftAndRightMoveCloserWithNegAndApartWithPos()
           let newOrigin =
                (x: origin.x + value * mod,
                 y: origin.y,
                 z: 0.0)
            
        
            return newOrigin
            
            func makeLeftAndRightMoveCloserWithNegAndApartWithPos() -> Double {
                var reverseDirection = 1.0
                if choiceOfEditForSide == .both {
                    reverseDirection = id == .id1 ? 1.00: -1.00
                }
                return reverseDirection
            }
        }
        
        
        func yOriginModified(_ origin: PositionAsIosAxes, _ id: PartTag) -> PositionAsIosAxes {
            return
                (x: origin.x,
                y: origin.y + value,
                z: 0.0)
        }
        
    }
     
    
    func setDimensionPropertyValueForOnePartInUserEditedDic(
        _ value: Double,
        _ part: Part) {

        let name = CreateNameFromIdAndPart(.id0, part).name

        let currentDimension =
                getEditedOrDefaultDimension(name, part, .id0)

        let newDimension = dimensionPropertyToEdit == .width ?
            (width: value,
             length: currentDimension.length,
             height:currentDimension.height)
            :
            (width: currentDimension.width,
             length: value,
             height:currentDimension.height)
     
        DictionaryService.shared.dimensionUserEditedDicModifier([name: newDimension])
    }
    

    func setDimensionPropertyToBeEdited(_ propertyToBeEdited: PartTag) {
        //dimensionPropertyToEdit = propertyToBeEdited
        BilateralPartWithOnePropertyToChangeService.shared.setDimensionPropertyToEdit(propertyToBeEdited)
    }

}

//MARK: CHAIN LABELS
extension ObjectEditViewModel {
    
    func removeChainLabelFromObject(
        _ chainLabel: Part) {
          //  print(chainLabel)
        guard let currentObjectChainLabels =
                DictionaryService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[objectType] ??
                    ObjectChainLabel.dictionary[objectType] else {
                          fatalError()
                        }
        let newChainLabels =
            currentObjectChainLabels.filter { $0 != chainLabel}
        DictionaryService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[objectType] = newChainLabels
    }
    
    
    func replaceChainLabelForObject(
        _ removalThenReplacment: [Part]) {
                 
        removeChainLabelFromObject(removalThenReplacment[0])

        guard var curentObjectChainLabels = userEditedSharedDics
                .objectChainLabelsUserEditDic[objectType]  else {
         fatalError()
        }
        curentObjectChainLabels += [removalThenReplacment[1]]

        DictionaryService.shared.userEditedSharedDics
            .objectChainLabelsUserEditDic[objectType] =
                curentObjectChainLabels
    }
    
    
    func restoreChainLabelToObject(_ chainLabel: Part) {
        guard let currentObjectChainLabels =
                ObjectChainLabel.dictionary[objectType] else {
            fatalError("no chain labels for object \(objectType)")
        }
        let newChainLabels = currentObjectChainLabels + [chainLabel]
        
        DictionaryService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[objectType] =
            newChainLabels
    }
}
