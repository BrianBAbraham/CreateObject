//
//  ObjectEditVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/04/2023.
//

import Foundation
import SwiftUI

struct EditObjectMenuShowModel {
   // struct ObjectModifiers {
        static let supportDimension: [UserModifiers] = [.supportLength, .supportWidth]
        static let footControl: [UserModifiers] = [.footSupport, .footSeparation]
        static let standardWheeledChair = footControl + supportDimension + [.tiltInSpace] + [.headRest] + [.legLength]
        static var dictionary: [ObjectTypes: [UserModifiers]] = {
            [
                .allCasterBed: supportDimension,
                .allCasterChair: supportDimension,
                .allCasterTiltInSpaceShowerChair: standardWheeledChair,
                .allCasterTiltInSpaceArmChair: supportDimension + [.tiltInSpace] + [.headRest],
                .fixedWheelFrontDrive: standardWheeledChair,
                .fixedWheelMidDrive: standardWheeledChair,
                .fixedWheelRearDrive: standardWheeledChair ,
                .fixedWheelManualRearDrive: standardWheeledChair ,
                .fixedWheelSolo: standardWheeledChair,
                    //.fixedWheelTransfer : ,
                .showerTray: supportDimension
            ]
        }()
  //  }

    //static var shared = EditObjectMenuShowModel()





    struct UserModifiersPartDependency {
        static var dictionary: [UserModifiers: [Part]] = {
            [.footSupport: [.footSupport],
             .footSeparation: [.footSupport]
            ]
        }()
    }

    
}


enum UserModifiers: String {
    case casterBaseSeparator = "open"
    case casterSepartionAtFront = "front caster"
    case casterSeparationAtRear = "rear caster"
    case backRecline = "back recline"
    case footSupport = "foot support"
    case footSeparation = "foot separtion"
    case headRest = "head rest"
    case independantJoyStick = "joy stick"
    case legLength = "leg length"
    case legSeparatation = "leg separation"
    case propelleers = "propellers"
    case rearJoyStick = "rear joy stick"
    case supportLength = "support length"
    case supportWidth = "support width"
    case tiltInSpace = "tilt-in-space"
}


class ObjectMenuShowViewModel: ObservableObject {
    @EnvironmentObject var objectPickVM: ObjectPickViewModel
    static let initialPart = Part.objectOrigin.rawValue
    
    
    @Published private var editObjectMenuShowModel: EditObjectMenuShowModel =
    EditObjectMenuShowModel()
}


extension ObjectMenuShowViewModel {
    
    
//
//    func getCurrenPartToEditName() -> String {
//        let partName = partEditModel.part
//        return partName
//    }
    


    
    func getShowMenuStatus(_ view: UserModifiers, _ objectName: String)-> Bool {
        let dictionary = EditObjectMenuShowModel.dictionary
        guard let objectType = ObjectTypes(rawValue: objectName) else {
            fatalError("no object defined for this name!")
        }
        var state: Bool = false
        if let show = dictionary[objectType] {
            state = show.contains(view)
        }
        //print("\(view) \(objectName) \(state)")
        return state
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

    
}



