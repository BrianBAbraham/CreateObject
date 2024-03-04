//
//  ObjectEditVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/04/2023.
//

import Foundation
import SwiftUI
import Combine




//MARK: DEVELOPMENT change to struct nothing changes
///Every object has associated menus providing user edit
///The View determines if it should display from this code
class ObjectShowMenuViewModel: ObservableObject {
    
    static let partsNotToAppearOnEditMenu: [Part] = [
        .backSupportHeadSupportLink,
        .backSupportHeadSupportJoint,
        .casterVerticalJointAtFront,
        .casterVerticalJointAtRear,
        .fixedWheelHorizontalJointAtFront,
        .fixedWheelHorizontalJointAtMid,
        .fixedWheelHorizontalJointAtRear,
        .footSupportHangerLink,
        .steeredVerticalJointAtFront,
       
    ]
    
    var currentObjectType: ObjectTypes = DictionaryService.shared.currentObjectType
    
    private var cancellables: Set<AnyCancellable> = []

    init () {
        DictionaryService.shared.$currentObjectType
            .sink { [weak self] newData in
                self?.currentObjectType = newData
            }
            .store(in: &self.cancellables)
    }
}


extension ObjectShowMenuViewModel {
    
    func getPropertyMenuForDimensionEdit(_ part: Part) -> [PartTag] {
        switch part{
        case .footSupport, .assistantFootLever:
            BilateralPartWithOnePropertyToChangeService.shared.setDimensionPropertyToEdit(.length)
            return [.length]
        default: return [.length, .width]
        }
    }
    
    func getShowMenuStatus(_ part: Part) -> Bool{
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        let allParts = oneOfAllPartForObjectBeforeEdit
        print(part)
        let menuRequired = allParts.contains(part)
        return menuRequired
    }
    
    func getShowMenuStatus(_ parts: [Part]) -> [Part: Bool]{
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        var menuDic: [Part: Bool] = [:]
        
        for part in oneOfAllPartForObjectBeforeEdit {
            menuDic[part] = oneOfAllPartForObjectBeforeEdit.contains(part)
        }
        return menuDic
    }
    
    
    func getShowAnyMenuStatus(_ parts: [Part]) -> Bool {
     let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        var showAnyMenu = false
        for part in parts {
            showAnyMenu = oneOfAllPartForObjectBeforeEdit.contains(part)
        }
        return showAnyMenu
    }
    
    
    func getPartIsOneOfAllBilateralPartForObjectBeforeEdit(_ part: Part) -> Bool {
        let showMenuStatus = !OneOrTwoId.partWhichAreAlwaysUnilateral.contains(part)
       //print("\(part) \(showMenuStatus)")
        return showMenuStatus
    }
    
    

 
    
    func getDoesPartHaveDimensionalPropertyMenu(_ part: Part) -> Bool {
        let exclusionsToDimensionPropertyMenu: [Part] = [
            .sitOnTiltJoint]
        let showMenuStatus =
            OneOrTwoId.partWhichAreAlwaysUnilateral.contains(part) &&
            !exclusionsToDimensionPropertyMenu.contains(part)
        
        return showMenuStatus
    }
    
    func getBilateralityIsEditable(_ part: Part) -> Bool {
        //you cannot edit out a wheel related part
        let nonEditableBilaterality: [Part] = [
            .fixedWheelAtFront,
            .fixedWheelAtFrontWithPropeller,
            .fixedWheelAtMid,
            .fixedWheelAtRear,
            .fixedWheelAtRearWithPropeller,
            .casterForkAtFront,
            .casterForkAtMid,
            .casterForkAtFront,
            .casterWheelAtFront,
            .casterWheelAtMid,
            .casterWheelAtRear,
            .sitOnTiltJoint,
            .steeredWheelAtFront
        ]
        
        let status = 
        getPartIsOneOfAllBilateralPartForObjectBeforeEdit(part) &&
        !nonEditableBilaterality.contains(part)
        
       // print("\(part) \(status)")
        return status
            
    }
    
    func getOneIsEditable(_ part: Part) -> Bool {

        let editable: [Part] = [
            .backSupportHeadSupport
        ]
        
        let status =
        
        editable.contains(part)

        return status
            
    }
    
    
    func getEditableOrigin(_ part: Part) -> [PartTag] {
        let yOnly: [PartTag] = [.yOrigin]
        let xOnly: [PartTag] = [.xOrigin]
        let editableOriginDic: [Part: [PartTag]] = [
            .assistantFootLever: xOnly,
            .casterForkAtFront: yOnly,
            .casterForkAtMid: yOnly,
            .casterForkAtRear: yOnly,
        ]
        
      let editableOrigin = editableOriginDic[part] ?? [.xOrigin, .yOrigin]
        
        return editableOrigin
    }
    
    
    func getOneOfAllPartForObjectBeforeEdit() -> [Part] {
            AllPartInObject.getOneOfAllPartInObjectBeforeEdit(currentObjectType)
      }
    
    
    func getOneOfAllEditablePartForObjectBeforeEdit() -> [String] {
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        let parts =
            oneOfAllPartForObjectBeforeEdit.filter {!Self.partsNotToAppearOnEditMenu.contains($0)}
        return parts.map{$0.rawValue}
    }
    
    func getOneOfAllEditablePartWithMenuNamesForObjectBeforeEdit() -> [String] {
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        let parts =
            oneOfAllPartForObjectBeforeEdit.filter {!Self.partsNotToAppearOnEditMenu.contains($0)}
       // print( MenuDisplayPartDictionary(parts, currentObjectType).names)
        
        return MenuDisplayPartDictionary(parts, currentObjectType).names
    }
    
//    func getOneMenuNameForPartName (_ part: Part) -> String {
//    
//        let menuName = MenuNamesDictionary([part], currentObjectType).name
//        if menuName == "" {
//            fatalError("no menu name for \(part)")
//        } else {
//            return menuName
//        }
//        
//    }
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



