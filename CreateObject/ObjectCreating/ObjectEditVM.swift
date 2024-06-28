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
    
 
    
    var scopeOfEditForSide: SidesAffected = ObjectEditService.shared.scopeOfEditForSide
    
    @Published var sideToEdit: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
   
    @Published var partToEdit = ObjectEditService.shared.partToEdit
   
    @Published var dimensionPropertyToEdit: PartTag = ObjectEditService.shared.dimensionPropertyToEdit
    
    @Published var originPropertiesToEdit: PartTag = ObjectEditService.shared.originPropertyToEdit
    
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
        
        ObjectEditService.shared.$dimensionPropertyToEdit
            .sink { [weak self] newData in
                self?.dimensionPropertyToEdit = newData
            }
            .store(in: &self.cancellables)
        
        ObjectEditService.shared.$originPropertyToEdit
            .sink { [weak self] newData in
                self?.originPropertiesToEdit = newData
            }
            .store(in: &self.cancellables)
        
        
        DictionaryService.shared.$partDataSharedDic
            .sink { [weak self] newData in
                self?.partDataSharedDic = newData
            }
            .store(in: &self.cancellables)

        
        ObjectEditService.shared.$scopeOfEditForSide
            .sink { [weak self] newData in
                self?.scopeOfEditForSide = newData
            }
            .store(in: &self.cancellables)
        
        ObjectEditService.shared.$choiceOfEditForSide
            .sink { [weak self] newData in
                self?.sideToEdit = newData
            }
            .store(in: &self.cancellables)
    }
}



//MARK: get
extension ObjectEditViewModel {
    func getPartToEdit() -> Part{
        return partToEdit
    }
    
    
    func setPartToEdit(_ partName: String) {
        guard let part = Part(rawValue: partName) else {
            fatalError("no part for that part name")
        }
        ObjectEditService.shared.setPartToEdit(part)
        
        partToEdit = part
    }
    
    
    func getPropertyToBeEdited() -> PartTag {
            dimensionPropertyToEdit
    }
    
    
    func setDimensionPropertyToEdit(_ propertyToEdit: PartTag) {
        ObjectEditService.shared.setDimensionPropertyToEdit(propertyToEdit)
    }
    
    
    func getOriginPropertyToBeEdited() -> PartTag {
            originPropertiesToEdit
    }
    
    
    func setOriginPropertiesToEdit(_ propertyToEdit: PartTag) {
        ObjectEditService.shared.setOriginPropertyToEdit(propertyToEdit)
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
        sideToEdit
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
        _ name: String
    )
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

    
    func setBothOrLeftOrRightAsEditible(
        _ sideChoice: SidesAffected
    ) {
        ObjectEditService.shared.setBothOrLeftOrRightAsEditible(
            sideChoice)
    }
    
    
    
    func setSideToEdit(
        _ sideChoice: SidesAffected
    ) {
        ObjectEditService.shared.setSideToEdit(
            sideChoice
        )
    }
    

    func setCurrentRotation(
        _ maxMinusSliderValue: Double,
        _ part: Part
    ) {
        var partName: String {
            CreateNameFromIdAndPart(.id0, part).name
        }
        
     
        let angleUserEditedDicEntry =
        [partName:
            (
                x:Measurement(
                    value: maxMinusSliderValue,
                    unit: UnitAngle.degrees
                ),
                y: ZeroValue.angle,
                z: ZeroValue.angle
            )]
        
        DictionaryService.shared.angleUserEditedDicModifier(
            angleUserEditedDicEntry
        )
    }
    
    
    func setPartIdDicInKeyToNilRestoringDefault (_ partChainWithoutRoot: [Part]) {
        //PARTIDUSEREDITEDICCHANGE
        for part in partChainWithoutRoot {
            DictionaryService.shared.partIdsUserEditedDicReseter(part)
        }
    }
    
    
    
    func changeOneOrTwoStatusOfPart(
        _ isLeftSelected: Bool,
        _ isRightSelected: Bool,
        _ part: Part) {
            
        let linkedPartDic: [Part: Part] = [
            .footSupport: .footSupportHangerLink,
           
        ]
         
        let side = //.both/.left/.right/.none
            convertLeftRightSelectionToSideSelection(
                isLeftSelected,
                isRightSelected)
            
        let partChain = LabelInPartChainOut(part).partChain
            
        let oldScope = scopeOfEditForSide
      
        ObjectEditService.shared.setBothOrLeftOrRightAsEditible(side)
            
        switch side {
            //if left xor right selected
            //id of part may change
        case .left, .right:
            
            let newId: OneOrTwo<PartTag> = (side == .left) ?
                .one(one: .id0): //if left requires .id0 for x < 0
                .one(one: .id1)  //if right requires .i1 for x >= 0
            
            //has part been removed?
            let chainLabelWasAlreadyRemoved = userEditedSharedDics.objectChainLabelsUserEditDic[objectType]?.contains(part) == false
            //replace chain label if removed
            if chainLabelWasAlreadyRemoved {
                restoreChainLabelToObject(part)
            }
            //update id dic for part
          //  print (part)
            
            let partOrLinkedPart = linkedPartDic[part] ?? part
            guard let firstIndex = partChain.firstIndex(of: partOrLinkedPart) else {
                fatalError("\(partChain)")
            }
            //provide id for the parts of the chain being edited
            //as not all the chain may be removed
            for index in firstIndex..<partChain.count {
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
                ObjectEditService.shared.setSideToEdit(newChoice)
            }
    }
    
    
    ///the value may be for origin or dimension
    ///origin may be x or y
    ///dimension may be width or length
    func setValueForBilateralPartInUserEditedDic(
        _ value: Double,
        _ part: Part,
        _ propertyToEdit: PartTag,
        _ sidesAffected: SidesAffected? = nil) {
    
        var partOrLinkedPart: Part = .notFound

        let allDimensionProperties: [PartTag] = [.width, .length, .height]

        if value == 0.0 && allDimensionProperties.contains(propertyToEdit) {
           //do not let dimensions cross zer0
        } else {
            
            transformToStabiliserForDriveWheelModForOriginY ()

            var sidesToEdit: SidesAffected
            
            if let unwrapped = sidesAffected {
               sidesToEdit = unwrapped
            } else {
                sidesToEdit = sideToEdit
               
            }
                
            switch sidesToEdit {
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
        }

     
        func process(
            _ id: PartTag
        ) {
            let name = CreateNameFromIdAndPart(
                id,
                partOrLinkedPart
            ).name
            switch propertyToEdit {
            case .length, .width, .height:
                let currentDimension =
                getEditedOrDefaultDimension(
                    name,
                    partOrLinkedPart,
                    id
                )
                let newDimension =
                dimensionWithModifiedProperty(
                    value,
                    currentDimension,
                    propertyToEdit
                )
                DictionaryService.shared.dimensionUserEditedDicModifier(
                    [name: newDimension]
                )
            case .xOrigin, .yOrigin:
                let currentOrigin = getEditedOrDefaultOriginOffset(
                    name
                )
                let newOriginOffset = propertyToEdit == .xOrigin ? xOriginModified(
                    currentOrigin,
                    id
                ) : yOriginModified(
                    currentOrigin,
                    id
                )
                DictionaryService.shared.originOffsetUserEdtiedDicModifier(
                    [name: newOriginOffset]
                )
            default: break
            }
        }
            
            
        func transformToStabiliserForDriveWheelModForOriginY () {
            ///the static point is on the  common turn axis of the fixed wheels
            ///increasing the stability of the main support by increasing the distance
            ///between the main support and the drive wheels for a rear drive  wheelchair
            ///therefore is an increase in stability rather than solely a motion of the drive wheels
            ///however, it is cleaner to include y origin control of the drive wheelchair position
            ///in the rear wheel menu rather than create a new stability menu
            ///the code to do that is also conistant with the mid and front drive
            let dic: [Part: Part] = [
                .fixedWheelAtRear: .stabiliser,
                .fixedWheelAtFront: .stabiliser,
                .fixedWheelAtMid: .stabiliser,
            ]
            
            if let unwrapped = dic[part],  propertyToEdit == .yOrigin {
                partOrLinkedPart = unwrapped
        
            } else {
                partOrLinkedPart = part
            }
        }
            
            
        func xOriginModified(_ origin: PositionAsIosAxes, _ id: PartTag) -> PositionAsIosAxes {
        
            var mod: Double//eg armRest xMove '-' brings closer, but headRest moves left
            
            if getNoModRequiredX(part) {
                mod = 1.0
            } else {
                mod = makeLeftAndRightMoveCloserWithNegAndApartWithPos()
            }
           
            let newOrigin =
                (x: origin.x + value * mod,
                 y: origin.y,
                 z: 0.0)
            
        
            return newOrigin
            
            func makeLeftAndRightMoveCloserWithNegAndApartWithPos() -> Double {

                var reverseDirection = 1.0
                if sideToEdit == .both {
                    reverseDirection = id == .id1 ? 1.00: -1.00
                }
                return reverseDirection
            }
        }
            
            
        func getNoModRequiredX(_ part: Part) -> Bool{
            let exclusionsForAlwaysUniPart: [Part] = [
                .mainSupport,
                .backSupport,
                .backSupportHeadSupport
            ]
            
            return
                exclusionsForAlwaysUniPart.contains(part) ? true: false
        }
        
        
        func yOriginModified(_ origin: PositionAsIosAxes, _ id: PartTag) -> PositionAsIosAxes {
            return
                (x: origin.x,
                y: origin.y + value,
                z: 0.0)
        }
    }
    
    
    func dimensionWithModifiedProperty(
        _ value: Double,
        _ dimension: Dimension3d,
        _ property: PartTag
    ) -> Dimension3d {
        switch property {
        case .height:
            return
                (
                    width: dimension.width,
                    length: dimension.length,
                    height: value
                )
        case .length:
            return
                (
                    width: dimension.width,
                    length: value,
                    height:dimension.height
                )
        case.width:
            return
                (
                    width: value,
                    length: dimension.length,
                    height:dimension.height
                )
        default: return dimension
        }

    }

    
    func setDimensionPropertyValueForOnePartInUserEditedDic(
        _ value: Double,
        _ part: Part
    ) {
        
        let name = CreateNameFromIdAndPart(
            .id0,
            part
        ).name
        
        let currentDimension =
        getEditedOrDefaultDimension(
            name,
            part,
            .id0
        )
        
        let newDimension = dimensionWithModifiedProperty(
            value,
            currentDimension,
            dimensionPropertyToEdit
        )
        
        DictionaryService.shared.dimensionUserEditedDicModifier(
            [name: newDimension]
        )
    }

    

    
}

//MARK: CHAIN LABELS
extension ObjectEditViewModel {
    
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
    
    
    func restoreChainLabelToObject(
        _ chainLabel: Part
    ) {
        guard let currentObjectChainLabels =
                ObjectChainLabel.dictionary[objectType] else {
            fatalError(
                "no chain labels for object \(objectType)"
            )
        }
        let newChainLabels = currentObjectChainLabels + [chainLabel]
        
        DictionaryService.shared.userEditedSharedDics.objectChainLabelsUserEditDic[objectType] =
            newChainLabels
    }
}
