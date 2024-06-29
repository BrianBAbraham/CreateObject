//
//  ObjectEditVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/04/2023.
//

import Foundation

import Combine




//MARK: DEVELOPMENT change to struct nothing changes
///Every object has associated menus providing user edit
///The View determines if it should display from this code
class ObjectShowMenuViewModel: ObservableObject {
    
    static let partsNotToAppearOnEditMenu: [PartGroup] = [
        .tilt,
        .backJointAndLink,
        .casterJoint,
        .fixedWheelJoint,
        .footJointAndLink,
        .stabiliser,
        .steeredJoint,
    ]
    
    var currentObjectType: ObjectTypes = //DictionaryService.shared.currentObjectType
    ObjectDataService.shared.objectType
    
    private var cancellables: Set<AnyCancellable> = []

    init () {
//        DictionaryService.shared.$currentObjectType
//            .sink { [weak self] newData in
//                self?.currentObjectType = newData
//            }
//            .store(in: &self.cancellables)
        
        ObjectDataService.shared.$objectType
            .sink { [weak self] newData in
                self?.currentObjectType = newData
            }
            .store(in: &self.cancellables)
    }
}


extension ObjectShowMenuViewModel {
    
    func getPropertiesForDimensionPicker(_ part: Part) -> [PartTag] {

        switch part{
        
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
    
    
    func getPropertiesForOriginPicker(_ part: Part) -> [PartTag] {
       
        if  let displayPart = PartToDisplayInMenu.dictionary[part] {
            //print(displayPart)
                switch displayPart {
                case .seat:
                    if currentObjectType == .showerTray {
                        return []
                    } else {
                        return [.xOrigin, .yOrigin]
                    }
                case .propeller, .footLever, .headrest:
                    return [.xOrigin]
                case .casterForkAtFront, .casterForkAtMid, .casterForkAtRear:
                    return [.yOrigin]
                case .backrest:
                   return []
                default:
                    return [.xOrigin, .yOrigin]
                }
        } else {
            return [.xOrigin, .yOrigin]
        }
    }
    

    func getBilateralPartMenuStatus(_ part: Part) -> Bool {
        //!OneOrTwoId.partWhichAreAlwaysUnilateral.contains(part)
        true
    }
    
    
    func getSidePickerMenuStatus(_ part: Part) -> Bool {
        let alwaysUnilateral =
            OneOrTwoId.partWhichAreAlwaysUnilateral.contains(part)
        let partGroup = part.transformPartToPartGroup()
        let alwaysBilateral =
        [.caster, .casterFork, .casterJoint, .fixedWheel, .fixedWheelJoint].contains(partGroup)
        let showMenu = !(alwaysUnilateral || alwaysBilateral)
        
        return showMenu
    }
    
    
    func getBilateralPresenceMenuStatus(_ part: Part) -> Bool {
        let neverBilateral =
            OneOrTwoId.partWhichAreAlwaysUnilateral.contains(part)
        let rigidlyBilateral =
            (part.transformPartToPartGroup() == PartGroup.none ? false: true)
    
        let showMenu = (!neverBilateral && !rigidlyBilateral)
        
        return showMenu
        
        //nb T rB T: nil
        //nb F rb F: nil
        //nb T rB F: show
        //nb F rB T: no show
    }
    
    
    func getTiltMenuPart(_ part: Part) -> Part? {
        TiltingAbility(part, currentObjectType).tilter
    }
    
    func getUniPresenceMenuStatus(_ part: Part) -> Bool {
        let editable: [Part] = [
            .backSupportHeadSupport
        ]
       return
        editable.contains(part)
      
    }
    
    
    func getUniEditMenuStatus(_ part: Part) -> Bool {
        let editable: [Part] = [
            .mainSupport, .backSupport
        ]
        let status =
        editable.contains(part)
        return status
    }
    
    
//    func getEditableOrigin(_ part: Part) -> [PartTag] {
//        let yOnly: [PartTag] = [.yOrigin]
//        let xOnly: [PartTag] = [.xOrigin]
//        let editableOriginDic: [Part: [PartTag]] = [
//            .assistantFootLever: xOnly,
//            .casterForkAtFront: yOnly,
//            .casterForkAtMid: yOnly,
//            .casterForkAtRear: yOnly,
//            .fixedWheelAtRearWithPropeller: xOnly
//        ]
//        
//      let editableOrigin = editableOriginDic[part] ?? [.xOrigin, .yOrigin]
//        
//        return editableOrigin
//    }
    
    
    
    func getOneOfAllPartForObjectBeforeEdit() -> [Part] {
            AllPartInObject.getOneOfAllPartInObjectBeforeEdit(currentObjectType)
      }
    
    
    func getOneOfAllEditablePartForObjectBeforeEdit() -> [String] {
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        let parts =
        oneOfAllPartForObjectBeforeEdit.filter {!Self.partsNotToAppearOnEditMenu.contains( $0.transformPartToPartGroup())}
        return parts.map{$0.rawValue}
    }
    
    
    func getOneOfAllEditablePartWithMenuNamesForObjectBeforeEdit() -> [String] {
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        let parts =
        oneOfAllPartForObjectBeforeEdit.filter {!Self.partsNotToAppearOnEditMenu.contains($0.transformPartToPartGroup())}
   //print(parts)
        return PartToDisplayInMenu(parts, currentObjectType).names
    }
}


//    func getColorForPart(_ uniquePartName: String)-> Color {
//
//
//        var color: Color = .blue
//        let partNameBeingEdited = getCurrenPartToEditName()
//
//        if uniquePartName == "object_id0_sitOn_id0_sitOn_id0" {
//            color = .red
//        }
//
//        if uniquePartName == partNameBeingEdited {
//            color = .white
//        } else {
//
//            if uniquePartName.contains(Part.sideSupport.rawValue) {
//                color = .green
//            }
//            if uniquePartName.contains(Part.fixedWheel.rawValue) {
//                color = .black
//            }
//
//            if uniquePartName.contains(Part.footSupport.rawValue) {
//                color = .green
//            }
//
//
//            if uniquePartName.contains("asterWheel") {
//                color = .black
//            }
//            if uniquePartName.contains("VerticalJoint") {
//                color = .red
//            }
//
//            if uniquePartName.contains("HorizontalJoint") {
//                color = .red
//            }
//            if uniquePartName.contains("footSupportHangerSitOnVerticalJoint") {
//                color = .black
//            }
//            if uniquePartName.contains("footSupportHorizontalJoint") {
//                color = .black
//            }
//            if uniquePartName.contains(Part.backSupport.rawValue) {
//                color = .gray
//            }
//            if uniquePartName.contains("head") {
//                color = .gray
//            }
//
//
//        }
//
//        return color
//
//    }
    
    
    
//    func setCurrentPartToEditName(_ partName: String) {
//
//            partEditModel.part = partName
//    }
//



