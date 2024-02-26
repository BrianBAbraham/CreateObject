//
//  ObjectEditVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 03/02/2024.
//

import Foundation
import Combine


class BilateralPartWithOneValueToChangeService {
   
    @Published var scopeOfEditForSide: SidesAffected = .both
    @Published var choiceOfEditForSide: SidesAffected = .both
    @Published var dimensionValueToEdit: PartTag = .length
    
    
    static let shared = BilateralPartWithOneValueToChangeService()
    
    func setBothOrLeftOrRightAsEditible(_ sideChoice: SidesAffected) {
        scopeOfEditForSide = sideChoice
    }
    
    func setBothOrLeftOrRightAsEditibleChoice(_ sideChoice: SidesAffected) {
        choiceOfEditForSide = sideChoice
    }
}

class DictionaryService {
    @Published var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionaries.shared
    @Published var partDataSharedDic: [Part: PartData] = [:]
    @Published var currentObjectType: ObjectTypes = .fixedWheelRearDrive

    @Published var dimensionValueToEdit: PartTag = .length
        
    static let shared = DictionaryService()
    
    func angleUserEditedDicModifier(_ entry: AnglesDictionary){
        userEditedSharedDics.angleUserEditedDic += entry
    }
    
    func angleUserEditedDicReseter(){
        userEditedSharedDics.angleUserEditedDic = [:]
    }
    
    func dimensionUserEditedDicModifier(_ entry: Part3DimensionDictionary){
        userEditedSharedDics.dimensionUserEditedDic += entry
    }
    
    func dimensionUserEditedDicReseter(){
        userEditedSharedDics.dimensionUserEditedDic = [:]
    }
    
    func objectChainLabelsUserEditDicReseter(_ objectType: ObjectTypes) {
        userEditedSharedDics.objectChainLabelsUserEditDic.removeValue(forKey: objectType)
    }
    
    
    func originOffsetUserEdtiedDicModifier(_ entry: PositionDictionary) {
        userEditedSharedDics.parentToPartOriginOffsetUserEditedDic += entry
    }
    
    func originUserEdtiedDicModifier(_ entry: PositionDictionary) {
//        print(entry)
        userEditedSharedDics.parentToPartOriginUserEditedDic += entry
    }
    
    
    func partDataSharedDicModifier(_ initialised: [Part: PartData] ) {
        partDataSharedDic = initialised
    }
    
    func partIdsUserEditedDicModifier(_ entry: [Part: OneOrTwo<PartTag>]) {
        userEditedSharedDics.partIdsUserEditedDic += entry
    }
    
    func partIdsUserEditedDicReseter(_ part: Part) {
        userEditedSharedDics.partIdsUserEditedDic.removeValue(forKey: part)
    }
    
}

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
    var dimensionValueToEdit: PartTag = .length
    var scopeOfEditForSide: SidesAffected = BilateralPartWithOneValueToChangeService.shared.scopeOfEditForSide
    var choiceOfEditForSide: SidesAffected = BilateralPartWithOneValueToChangeService.shared.choiceOfEditForSide
    var partDataSharedDic = DictionaryService.shared.partDataSharedDic

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
        
        DictionaryService.shared.$dimensionValueToEdit
            .sink { [weak self] newData in
                self?.dimensionValueToEdit = newData
            }
            .store(in: &self.cancellables)
        
        
        DictionaryService.shared.$partDataSharedDic
            .sink { [weak self] newData in
                self?.partDataSharedDic = newData
            }
            .store(in: &self.cancellables)

        
        BilateralPartWithOneValueToChangeService.shared.$scopeOfEditForSide
            .sink { [weak self] newData in
                self?.scopeOfEditForSide = newData
            }
            .store(in: &self.cancellables)
        
        BilateralPartWithOneValueToChangeService.shared.$choiceOfEditForSide
            .sink { [weak self] newData in
                self?.choiceOfEditForSide = newData
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

            DictionaryService.shared.angleUserEditedDicModifier(angleUserEditedDic)
            
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
    
    
    func removeChainLabelFromObject(
        _ chainLabel: Part) {
        guard let currentObjectChainLabels =
                DictionaryService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[objectType] ??
                    ObjectChainLabel.dictionary[objectType] else {
                          fatalError()
                        }
        let newChainLabels =
            currentObjectChainLabels.filter { $0 != chainLabel}
        DictionaryService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[objectType] = newChainLabels
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
    
    
    func setPartIdDicInKeyToNilRestoringDefault (_ partChainWithoutRoot: [Part]) {
        //PARTIDUSEREDITEDICCHANGE
        for part in partChainWithoutRoot {
            DictionaryService.shared.partIdsUserEditedDicReseter(part)
//            DataService.shared.userEditedSharedDics.partIdsUserEditedDic.removeValue(forKey: part)
        }
    }
    
    func getDimensionValueToBeEdited() -> PartTag {
        //print(dimensionValueToEdit)
        return
        dimensionValueToEdit
       // DataService.shared.dimensionValueToEdit
    }
    
    
    func setBothOrLeftOrRightAsEditible(_ sideChoice: SidesAffected) {
        BilateralPartWithOneValueToChangeService.shared.setBothOrLeftOrRightAsEditible(sideChoice)
    }
    
    func setBothOrLeftOrRightAsEditibleChoice(_ sideChoice: SidesAffected) {
        BilateralPartWithOneValueToChangeService.shared.setBothOrLeftOrRightAsEditibleChoice(sideChoice)
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
//        case .test:
//            return [.test]
        }

    }
    
    func getChoiceOfEditForSide() -> SidesAffected {
//        print("choice of edit for side obtained")
//        print(choiceOfEditForSide)
//        print("")
//        return
        choiceOfEditForSide
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

    
    func setWhenPartChangesOneOrTwoStatus(
        _ isLeftSelected: Bool,
        _ isRightSelected: Bool,
        _ part: Part) {
            
        let side = //.both/.left/.right/.none
            convertLeftRightSelectionToSideSelection(
                isLeftSelected,
                isRightSelected)
            
        let partChain = LabelInPartChainOut(part).partChain
            
        let oldScope = scopeOfEditForSide
        
            BilateralPartWithOneValueToChangeService.shared.setBothOrLeftOrRightAsEditible(side)
            
        switch side {
        case .left, .right:
            
            let newId: OneOrTwo<PartTag> = (side == .left) ?
                .one(one: .id0): //if left requires .id0 for x < 0
                .one(one: .id1)  //if right requires .i1 for x >= 0
            
            let chainLabelForFootWasAlreadyRemoved = userEditedSharedDics.objectChainLabelsUserEditDic[objectType]?.contains(part) == false
            
            if chainLabelForFootWasAlreadyRemoved {
                restoreChainLabelToObject(part) //toggle is restoring
            }
            
            let ignoreFirstItem = 1 // relevant part subsequent
            for index in ignoreFirstItem..<partChain.count {
               
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
                BilateralPartWithOneValueToChangeService.shared.setBothOrLeftOrRightAsEditibleChoice(newChoice)
            }
    }
    
    
    func setValueForBilateralPartInUserEditedDic(
        _ value: Double,
        _ part: Part,
        _ partPropertyToBeChanged: PartTag
    ) {
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
            case .length:
                let currentDimension = getEditedOrDefaultDimension(name, part, id)
                let newDimension = dimensionWithModifiedLength(currentDimension)
                DictionaryService.shared.dimensionUserEditedDicModifier([name: newDimension])
            case .xOrigin:
                let currentOrigin = getEditedOrDefaultOriginOffset(name)
                let newOriginOffset = xOriginModified(currentOrigin, id)
                DictionaryService.shared.originOffsetUserEdtiedDicModifier([name: newOriginOffset])
                
            default: break
            }
        }
        
    
        func dimensionWithModifiedLength(_ dimension: Dimension3d) -> Dimension3d {
            (width: dimension.width,
             length: value,
             height:dimension.height)
        }
        
        
        func xOriginModified(_ origin: PositionAsIosAxes, _ id: PartTag) -> PositionAsIosAxes {
            let mod = makeLeftAndRightMoveCloserWithNegAndApartWithPos()
           let newOrigin =
                (x: origin.x + value * mod,
                 y: 0.0,
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
        
    }
    
    
//    func getName (_ id: PartTag, _ part: Part =  Part.footSupportHangerLink) -> String {
//        var name: String {
//            let parts: [Parts] =
//            [Part.objectOrigin, PartTag.id0, PartTag.stringLink, part , id, PartTag.stringLink, Part.sitOn, PartTag.id0]
//           return
//            CreateNameFromParts(parts ).name    }
//        return name
//    }
//    
    
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
    
    
    func setEitherDimensionForOnePartInUserEditedDic(
        _ value: Double,
        _ part: Part//,
    //    _ selectedDimension: PartTag
    ) {
//print(selectedDimension)
        let name = CreateNameFromIdAndPart(.id0, part).name

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
 
        //DIMENSIONCHANGE
//    DataService.shared.userEditedSharedDics.dimensionUserEditedDic +=
//        [name: newDimension]
        
        DictionaryService.shared.dimensionUserEditedDicModifier([name: newDimension])
    }
    
    
    func updateDimensionToBeEdited(_ dimension: PartTag) {
      
        DictionaryService.shared.dimensionValueToEdit = dimension
        //print(dimensionValueToEdit)
    }

}


