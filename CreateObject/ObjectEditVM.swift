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
    func getCurrenPartToEditName() -> String {
        let partName = partEditModel.part
//print("get " + partName)
        return partName

    }
    
    func setBothSidesToSameLength (
        _ part: Part,
        _ dictionary: PositionDictionary ) {
            
            
        }
    
    func setPrimaryToFootPlateFrontLength(
        _ dictionary: PositionDictionary,
        _ partId: Part,
        _ lengthChange:Double)
        -> PositionDictionary {
            
            let namesForFilter =
            [Part.footSupport.rawValue + Part.stringLink.rawValue,
             Part.footSupportHorizontalJoint.rawValue
             ]
            
            var filteredDictionary: PositionDictionary = [:]
            
            for name in namesForFilter {
                filteredDictionary  +=
                dictionary.filter({$0.key.contains(name )}).filter({$0.key.contains(Part.corner.rawValue)})
            }

            if partId != .id {
                let partWithSupportName = CreateNameFromParts([partId,.stringLink,.sitOn]).name
                
                filteredDictionary = filteredDictionary.filter({$0.key.contains(partWithSupportName)})
            }
            
            var editedDictionary = dictionary
            
            for (key, value) in filteredDictionary {
                
                let newValue = value.y + lengthChange
                filteredDictionary[key] = (x:value.x, y: newValue, z: value.z)
                editedDictionary[key] = filteredDictionary[key]
                
                if key.contains(Part.footSupportHangerLink.rawValue) {
                    editedDictionary[key] = nil
                }
            }
            
            
            let firstItem = filteredDictionary.first!
            let supportIndexName = Part.sitOn.rawValue + Part.id.rawValue + "0"
            let supportIndex =
            firstItem.key.contains(supportIndexName) ? 0 : 1
            
            let hangerLinkDictionary =
                CreateCornerDictionaryForLinkBetweenTwoPartsOnOneOrTWoSides(
                    .footSupportHangerSitOnVerticalJoint,
                    .footSupportHorizontalJoint,
                    .footSupportHangerLink,
                    editedDictionary,
                    supportIndex).newCornerDictionary
            
            editedDictionary += hangerLinkDictionary
            
            return editedDictionary
    }
    
    
    func getNames () {
        //create name
        //or get names from dictionary using unique value
    }
    
    func getPrimaryAxisToFootPlateEndLength(
        dictionary: PositionDictionary,
        name: String,
        _ supportIndex: Int = 0
  )
        -> [Double] {
            var lengths: [Double] = []
            let partName  = CreateNameFromParts([.footSupport,.stringLink]).name

            var onePartDictionary = dictionary
            
            let sitOnPartId = supportIndex == 0 ? Part.id0: Part.id1
            let supportName = CreateNameFromParts([.sitOn, sitOnPartId]).name
            
            onePartDictionary =
            SuccessivelyFilteredDictionary([Part.corner.rawValue, partName, supportName],dictionary).dictionary
//print(name)
//print(onePartDictionary)
//print("")
            let twoFootSupportPresent = 8
            let oneFootSupportPresent = 4

            if onePartDictionary.count == twoFootSupportPresent {

            let leftFootSupportName = CreateNameFromParts([.footSupport,.id0]).name

            let rightSupportName = CreateNameFromParts([.footSupport,.id1]).name

                for name in [leftFootSupportName, rightSupportName] {
                    lengths.append(getMaximumLength(onePartDictionary.filter({$0.key.contains(name)})))
                }
            }
            
           if onePartDictionary.count == oneFootSupportPresent {

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
    
    
    
    func getPrimaryAxisToFootPlateEndLengthMaximum ( _ dictionaryForMeasurement: PositionDictionary)//_ objectPickVM: ObjectPickViewModel   )
    -> Double {
        
        let defaultMinimumLength = getPrimaryAxisToFootPlateEndLengthMinimum(dictionaryForMeasurement)//objectPickVM)
//        let defaultMaximumLength = getPrimaryAxisToFootPlateEndLength( dictionary: dictionaryForMeasurement, name: "maximum")

       let maximumLength =
        InitialOccupantFootSupportMeasure.footSupportHangerMaximumLength +
        InitialOccupantFootSupportMeasure.footSupport.length/2 +
        defaultMinimumLength
        
//print(maximumLength)
        return maximumLength
    }
    
    
    
    func getPrimaryAxisToFootPlateEndLengthMinimum ( _ dictionaryForMeasurement: PositionDictionary)//_ objectPickVM: ObjectPickViewModel   )
    -> Double {
        
        let defaultDictionary = dictionaryForMeasurement
        let hangerVerticalJointFromObjectOriginName =
        CreateNameFromParts([.objectOrigin, .id0,.stringLink,.footSupportHangerSitOnVerticalJoint] ).name
        let itemFromFilteredDictionary =
        SuccessivelyFilteredDictionary([hangerVerticalJointFromObjectOriginName],defaultDictionary).dictionary.first

        
        let defaultLength = itemFromFilteredDictionary?.value.y ?? 0.0
  
        return
          defaultLength
    }
    
    
    func getPrimaryAxisToFootPlateEndExtrema(
        _ currentObjectDictionary: PositionDictionary,
        _ defaultDictionary: PositionDictionary)
        -> ClosedRange<Double> {
            getPrimaryAxisToFootPlateEndLengthMinimum(currentObjectDictionary)...getPrimaryAxisToFootPlateEndLengthMaximum(defaultDictionary)
    }
    
    
    
    func removePartFromDictionary (
    _ dictionary: PositionDictionary,
    _ part: Part,
    _ supportIndex: Int = 0)
    -> PositionDictionary {
        
        dictionary.filter ({!$0.key.contains("id0") })
        
    }
    
    
//    func getObjectWidth (_ objectType: BaseObjectTypes)
//    -> Double {
//        var width = 0.0
//
//        if objectType.rawValue.contains ("caster") {
//            width = 100
//        }
//
//        if objectType.rawValue.contains ("wheel") {
//            width = 200
//        }
//
//        if objectType.rawValue.contains ("wheel") {
//            width = 300
//        }
//
//            return width
//    }
    
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



