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
    static let initialPart = Part.primaryOrigin.rawValue
    
    
    @Published private var partEditModel: PartEditModel =
    PartEditModel(part: initialPart)
}


extension ObjectEditViewModel {
    func getCurrenPartToEditName() -> String {
        let partName = partEditModel.part
//print("get " + partName)
        return partName

    }
    
    func primaryToFootPlateFrontLength(
        _ dictionary: PositionDictionary,
        _ uniqueName: String,
        _ length: Double) {
        var editedDictionary = dictionary
            
    }
    
    
    func getNames () {
        //create name
        //or get names from dictionary using unique value
    }
    
    func getPrimaryAxisToFootPlateEndLength(
        _ dictionary: PositionDictionary,
        _ supportIndex: Int = 0)
        -> [Double] {
            var lengths: [Double] = []
            let partName  = Part.footSupportHorizontalJoint.rawValue
            var onePartDictionary = dictionary
            let supportName = CreateSupportPartName(index: supportIndex).name
            
            onePartDictionary =
            onePartDictionary
                .filter({$0.key.contains(partName)})
            
            onePartDictionary =
            onePartDictionary
                .filter({$0.key.contains(supportName)})
            
            if onePartDictionary.count == 8 {
                for index in 0..<1 {
                    let partIdName = Part.id.rawValue + String(index) + Part.stringLink.rawValue
                    onePartDictionary =
                    onePartDictionary.filter({$0.key.contains(partIdName)})
                    lengths.append(getMaximumLength(onePartDictionary))
                }
            }
            
           if onePartDictionary.count == 4 {
               lengths = [getMaximumLength(onePartDictionary)]
            }

            func getMaximumLength (_ dictionary: PositionDictionary)
                -> Double {
                let ifAllEqualUseFirst = 0
                let values = dictionary.map{$0.1}
                let yValues = CreateIosPosition.getArrayFromPositions(values).y
                let maxValue = yValues.max() ?? yValues[ifAllEqualUseFirst]
                return maxValue
            }

         return lengths
    }
    
    
    func removePartFromDictionary (
    _ dictionary: PositionDictionary,
    _ part: Part,
    _ supportIndex: Int = 0)
    -> PositionDictionary {
        
        dictionary.filter ({!$0.key.contains("id0") })
        
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



