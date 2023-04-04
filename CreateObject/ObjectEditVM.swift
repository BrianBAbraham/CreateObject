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
    
    func getColorForPart(_ partName: String)-> Color {
        var color: Color = .black
        let partNameBeingEdited = getCurrenPartToEditName()
        
        if partName == partNameBeingEdited {
            color = .white
        } else {
        
            if partName == Part.arm.rawValue {
                color = .green
            }
            if partName == Part.fixedWheel.rawValue {
                color = .orange
            }
            
            if partName == Part.footSupport.rawValue {
                color = .green
            }
            if partName == Part.sitOn.rawValue {
                color = .blue
            }
            
            if partName == Part.overHeadSupport.rawValue {
                color = .green
            }
            
            if partName.contains("caster") {
                color = .orange
            }
            if partName.contains("VerticalJoint") {
                color = .red
            }
            
            if partName.contains("HorizontalJoint") {
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
