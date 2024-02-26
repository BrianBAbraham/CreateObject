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
//        static let supportDimension: [UserModifiers] = [.supportLength, .supportWidth]
//        static let footControl: [UserModifiers] = [.footSupport, .footSeparation]
//        static let standardWheeledChair = footControl + supportDimension + [.tiltInSpace] + [.headRest] + [.legLength]
//        static var dictionary: [ObjectTypes: [UserModifiers]] = {
//            [
//                .allCasterBed: supportDimension,
//                .allCasterChair: supportDimension + standardWheeledChair,
//                .allCasterStretcher: supportDimension,
//                .allCasterTiltInSpaceShowerChair: standardWheeledChair,
//                .allCasterTiltInSpaceArmChair: supportDimension + [.tiltInSpace] + [.headRest],
//                .fixedWheelRearDriveAssisted: standardWheeledChair,
//                .fixedWheelFrontDrive: standardWheeledChair,
//                .fixedWheelMidDrive: standardWheeledChair,
//                .fixedWheelRearDrive: standardWheeledChair ,
//                .fixedWheelManualRearDrive: standardWheeledChair ,
//                .fixedWheelSolo: standardWheeledChair,
//                .scooterRearDrive4Wheeler: supportDimension + [.tiltInSpace] ,
//                .showerTray: supportDimension,
//               
//            ]
//        }()
//  
//    struct UserModifiersPartDependency {
//        static var dictionary: [UserModifiers: [Part]] = {
//            [.footSupport: [.footSupport],
//             .footSeparation: [.footSupport]
//            ]
//        }()
    }
//
//    
//}
//
//
//enum UserModifiers: String, Parts, Hashable {
//    var stringValue: String {
//        return self.rawValue
//    }
//    
//    case casterBaseSeparator = "open"
//    case casterSepartionAtFront = "front caster"
//    case casterSeparationAtRear = "rear caster"
//    case backRecline = "back recline"
//    case footSupport = "foot support"
//    case footSeparation = "foot separtion"
//    case headRest = "head rest"
//    case independantJoyStick = "joy stick"
//    case legLength = "leg length"
//    case legSeparatation = "leg separation"
//    case propelleers = "propellers"
//    case rearJoyStick = "rear joy stick"
//    case supportLength = "support length"
//    case supportWidth = "support width"
//    case tiltInSpace = "tilt-in-space"
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(rawValue)
//    }
//}

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
    
//    func getShowMenuStatus2(
//        _ menu: Parts) -> Bool {
//            var state: Bool = false
//            if let userModifierMenu = menu as? UserModifiers {
//                let dictionary = EditObjectMenuShowModel.dictionary
//                if let show = dictionary[currentObjectType] {
//                    state = show.contains(userModifierMenu)
//                }
//            }
//            
//            if let partMenu = menu as? Part {
//                //does the unedited object have this part?
//                if let chainLabel =  ObjectChainLabel.dictionary[currentObjectType]{
//                    state = chainLabel.contains(partMenu)
//                }
//                //has object partChain been edited?
//                if let editedPartChain = userEditedSharedDics.objectChainLabelsUserEditDic[currentObjectType] {
//                    //if edited out reset to false
//                    if !editedPartChain.contains(partMenu) {
//                        state = false
//                    }
//                }
//                
//            }
//            return state
//        }
    
    
    ///rotator part presence is non-editable
    ///menus for conditional show
    ///menus for conditional show
    ///menus denoted by part
    ///menus not denoted by modifiers
    
    
    
//    func defaultObjectHasOneOfTheseChainLabels(_ chainLabel: Part) -> Bool
//    {
//        var show = false
//        
//        let defaultChainLabels =
//        ObjectChainLabel.dictionary[currentObjectType] ?? []
//    
//        show = defaultChainLabels.contains(chainLabel) //{
//
//        return show
//    }
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
        
        print("\(currentObjectType) \(menuDic) ")
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
    
    func getOneOfAllPartForObjectBeforeEdit() -> [Part] {
      return
            AllPartInObject.getOneOfAllPartInObjectBeforeEdit(currentObjectType)
      }
    
    func getOneOfAllEditablePartForObjectBeforeEdit() -> [String] {
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
       // print(oneOfAllPartForObjectBeforeEdit)
        let parts =
            oneOfAllPartForObjectBeforeEdit.filter {!Self.noneditablePart.contains($0)}
       // print(parts)
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



