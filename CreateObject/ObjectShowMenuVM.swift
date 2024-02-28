//
//  ObjectEditVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/04/2023.
//

import Foundation
import SwiftUI
import Combine

struct EditObjectMenuShowModel {

    }


//MARK: DEVELOPMENT change to struct nothing changes
///Every object has associated menus providing user edit
///The View determines if it should display from this code
class ObjectShowMenuViewModel: ObservableObject {

    static let noneditablePart: [Part] = [
        .backSupportHeadSupportLink,
        .backSupportHeadSupportJoint,
        .casterVerticalJointAtFront,
        .fixedWheelHorizontalJointAtRear,
        .footSupportHangerLink,
    ]
    var currentObjectType: ObjectTypes = DictionaryService.shared.currentObjectType
    private var cancellables: Set<AnyCancellable> = []
  //  var oneOfAllPartForObjectBeforeEdit: [Part] = []
    init () {
//        DictionaryService.shared.$userEditedSharedDics
//            .sink { [weak self] newData in
//                self?.userEditedSharedDics = newData
//            }
//            .store(in: &cancellables)
        
        DictionaryService.shared.$currentObjectType
            .sink { [weak self] newData in
                self?.currentObjectType = newData
            }
            .store(in: &self.cancellables)
//        
//        DictionaryService.shared.$partDataSharedDic
//            .sink { [weak self] newData in
//                self?.partDataSharedDic = newData
//            }
//            .store(in: &self.cancellables)
        

   
   
    }
    
}





extension ObjectShowMenuViewModel {
    func getShowMenuStatus(_ part: Part) -> Bool{
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        let allParts = oneOfAllPartForObjectBeforeEdit
        
        let menuRequired = allParts.contains(part)
        //print("\(currentObjectType) \(part)  \(menuRequired) ")
        return menuRequired
    }
    
    func getShowMenuStatus(_ parts: [Part]) -> [Part: Bool]{
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        var menuDic: [Part: Bool] = [:]
        
        for part in oneOfAllPartForObjectBeforeEdit {
            menuDic[part] = oneOfAllPartForObjectBeforeEdit.contains(part)
        }
        
       // print("\(currentObjectType) \(menuDic) ")
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
        return showMenuStatus
    }
    
    
    func getPartIsOneOfAllUniletralPartForObjectBeforeEdit(_ part: Part) -> Bool {
        let showMenuStatus = OneOrTwoId.partWhichAreAlwaysUnilateral.contains(part)
        return showMenuStatus
    }
    
    
    func getBilateralityIsEditable(_ part: Part) -> Bool {
        //you cannot edit out a wheel related part
        let nonEditableBilaterality: [Part] = [
            .fixedWheelAtFront,
            .fixedWheelAtMid,
            .fixedWheelAtRear,
            .casterForkAtFront,
            .casterForkAtMid,
            .casterForkAtFront,
            .casterWheelAtFront,
            .casterWheelAtMid,
            .casterWheelAtRear
        ]
        return
            getPartIsOneOfAllBilateralPartForObjectBeforeEdit(part) &&
            !nonEditableBilaterality.contains(part)
    }
    
    
    func getOneOfAllPartForObjectBeforeEdit() -> [Part] {
            AllPartInObject.getOneOfAllPartInObjectBeforeEdit(currentObjectType)
      }
    
    
    func getOneOfAllEditablePartForObjectBeforeEdit() -> [String] {
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        let parts =
            oneOfAllPartForObjectBeforeEdit.filter {!Self.noneditablePart.contains($0)}
        return parts.map{$0.rawValue}
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



