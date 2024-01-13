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

class ObjectEditViewModel: ObservableObject {
    static let initialPart = Part.objectOrigin.rawValue
    
    
    @Published private var partEditModel: PartEditModel =
    PartEditModel(part: initialPart)
}


extension ObjectEditViewModel {
    
    
    //receive default dictionary and make changes returning a modified dictionary
    // MARK: EDIT DEFAULT DICTIONARY
    func getModifiedDictionary (
        _ dictionary: Part3DimensionDictionary)
        -> Part3DimensionDictionary{
        dictionary
    }
    
    func getCurrenPartToEditName() -> String {
        let partName = partEditModel.part
        return partName
    }
    
    func getNames () {
        //create name
        //or get names from dictionary using unique value
    }
    
   
    func getEditOptionsForObject ( _ dictionary: PositionDictionary
    ) {
        
    }
    

    

    
    
 
    
    

    
    
    func getColorForPart(_ uniquePartName: String)-> Color {
        
//print(uniquePartName)
        var color: Color = .blue
        let partNameBeingEdited = getCurrenPartToEditName()
        
        if uniquePartName == "object_id0_sitOn_id0_sitOn_id0" {
            color = .red
        }
        
        if uniquePartName == partNameBeingEdited {
            color = .white
        } else {
        
            if uniquePartName.contains(Part.sideSupport.rawValue) {
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
            
//            if uniquePartName.contains(Part.overheadSupport.rawValue) {
//                color = .green
//            }
            
            if uniquePartName.contains("asterWheel") {
                color = .black
            }
            if uniquePartName.contains("VerticalJoint") {
                color = .red
            }
            
            if uniquePartName.contains("HorizontalJoint") {
                color = .red
            }
            if uniquePartName.contains("footSupportHangerSitOnVerticalJoint") {
                color = .black
            }
            if uniquePartName.contains("footSupportHorizontalJoint") {
                color = .black
            }
            if uniquePartName.contains(Part.backSupport.rawValue) {
                color = .gray
            }
            if uniquePartName.contains("head") {
                color = .gray
            }

        
//            if uniquePartName.contains(BaseObjectTypes.showerTray.rawValue) {
//                color = .blue
//            }
        }

        return color
        
    }
    
    
    
    func setCurrentPartToEditName(_ partName: String) {
//print("set " + partName)
            partEditModel.part = partName
    }
    

    
}



