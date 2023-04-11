//
//  ObjectEditVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/04/2023.
//

import Foundation
import SwiftUI

struct PartEditModel {
    var part: String  //FixedWheelBase.Subtype.midDrive.rawValue
    
}

class PartEditViewModel: ObservableObject {
    static let initialPart = Part.primaryOrigin.rawValue
    
    
    @Published private var partEditModel: PartEditModel =
    PartEditModel(part: initialPart)
}


extension PartEditViewModel {
    func getCurrenPartToEditName() -> String {
        let partName = partEditModel.part
//print("get " + partName)
        return partName

    }
    
    func getObjectWidth (_ objectType: BaseObjectTypes)
    -> Double {
        var width = 0.0
        
        if objectType.rawValue.contains ("caster") {
            width = 100
        }
        
        if objectType.rawValue.contains ("wheel") {
            width = 200
        }
        
        if objectType.rawValue.contains ("wheel") {
            width = 300
        }

            return width
    }
    
//    func getEditPermissionsForPart(_ uniquePartName: String)
//    -> Edit {
//        let cornerEdit = false
//        let originEdit = false
//        let sideEdit = false
//        let lengthOnlyEdit = false
//        let widthOnlyEdit = false
//        let maintainWidthSymmetry = false
//
//        var permissions: Edit =
//        (corner: false, origin: false, side: false, lengthOnly: false, widthOnly: false, widthSymmetry: false)
//
//        if uniquePartName.contains(Part.arm.rawValue) {
//            permissions =
//            (corner: true, origin: true, side: true, lengthOnly: true, widthOnly: true, widthSymmetry: true)
//        }
//
//        if uniquePartName.contains(Part.sitOn.rawValue) {
//            permissions =
//            (corner: true, origin: true, side: true, lengthOnly: true, widthOnly: true, widthSymmetry: false)
//        }
//
//        if uniquePartName.contains(Part.fixedWheel.rawValue) {
//            permissions =
//            (corner: false, origin: true, side: false, lengthOnly: true, widthOnly: true, widthSymmetry: true)
//        }
//
//        return permissions
//    }
    
    
    func getColorForPart(_ uniquePartName: String)-> Color {
        var color: Color = .blue
        let partNameBeingEdited = getCurrenPartToEditName()
        
        if uniquePartName == partNameBeingEdited {
            color = .white
        } else {
        
            if uniquePartName.contains(Part.arm.rawValue) {
                color = .green
            }
            if uniquePartName.contains(Part.fixedWheel.rawValue) {
                color = .black
            }
            
            if uniquePartName.contains(Part.footSupport.rawValue) {
                color = .green
            }
//            if partName.contains(Part.sitOn.rawValue) {
//                color = .blue
//            }
            
            if uniquePartName.contains(Part.overHeadSupport.rawValue) {
                color = .green
            }
            
            if uniquePartName.contains("asterWheel") {
                color = .black
            }
            if uniquePartName.contains("VerticalJoint") {
                color = .red
            }
            
            if uniquePartName.contains("HorizontalJoint") {
                color = .black
            }
        }

        return color
        
    }
    
    func setCurrentPartToEditName(_ partName: String) {
//print("set " + partName)
            partEditModel.part = partName
    }
}



