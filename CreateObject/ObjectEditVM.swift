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
        return partName
    }
    
    func getNames () {
        //create name
        //or get names from dictionary using unique value
    }
    
   
    func getEditOptionsForObject ( _ dictionary: PositionDictionary
    ) {
        
    }
    
    
  
    
    
    func getPrimaryAxisToFootSupportEndLength (
        dictionary: PositionDictionary,
        name: String,
        part: Part,
        _ supportIndex: Part)
        -> [Double] {
            var lengths: [Double] = []
            let partName  = CreateNameFromParts([part,.stringLink]).name

            var onePartDictionary = dictionary
            
            //let sitOnPartId = supportIndex == 0 ? Part.id0: Part.id1
            let supportName = CreateNameFromParts([.sitOn, supportIndex]).name
            
            onePartDictionary =
            SuccessivelyFilteredDictionary([Part.corner.rawValue, partName, supportName],dictionary).dictionary


            if part == .footSupport {
                let leftFootSupportName = CreateNameFromParts([.footSupport,.id0]).name

                let rightSupportName = CreateNameFromParts([.footSupport,.id1]).name

                    for name in [leftFootSupportName, rightSupportName] {
                        lengths.append(getLength(onePartDictionary.filter({$0.key.contains(name)})))
                    }
            }

            
            if part == .footSupportInOnePiece {
                lengths = [getLength(onePartDictionary)]
            }


            func getLength (_ dictionary: PositionDictionary)
                -> Double {
                let ifAllEqualUseFirst = 0
                let values = dictionary.map{$0.1}
                let yValues = CreateIosPosition.getArrayFromPositions(values).y
                let maxValue = yValues.max() ?? yValues[ifAllEqualUseFirst]
                return maxValue //- minValue
            }
            
         return lengths
    }
    
    
    
    func getPrimaryAxisToFootPlateEndLengthMaximum ( _ dictionaryForMeasurement: PositionDictionary)
        -> Double {
        
        let defaultMinimumLength = getPrimaryAxisToFootSupportEndLengthMinimum(dictionaryForMeasurement)
            
        let maximumLength =
        InitialOccupantFootSupportMeasure.footSupportHangerMaximumLength +
        InitialOccupantFootSupportMeasure.footSupport.length/2 +
        defaultMinimumLength

        return maximumLength
    }
    
    
    
    func getPrimaryAxisToFootSupportEndLengthMinimum (
        _ dictionaryForMeasurement: PositionDictionary)
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
    
    
    func getPrimaryAxisToFootSupportEndExtrema(
        _ currentObjectDictionary: PositionDictionary,
        _ defaultDictionary: PositionDictionary,
        _ onePieceOrLeftRightFootSupport: Part)
        -> ClosedRange<Double> {
            var range: ClosedRange<Double>
            if onePieceOrLeftRightFootSupport == .footSupport {
                range =
                getPrimaryAxisToFootSupportEndLengthMinimum(currentObjectDictionary)...getPrimaryAxisToFootPlateEndLengthMaximum(defaultDictionary)
            } else {
                let initialLength = InitialOccupantFootSupportMeasure.footShowerSupport.length
                range =
                initialLength...initialLength + InitialOccupantFootSupportMeasure.footShowerSupportMaximumIncrease.length
                
            }
        return range
    }
    
    

    
    
    func getColorForPart(_ uniquePartName: String)-> Color {
        
//print(uniquePartName)
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
                color = .red
            }
            
            if uniquePartName.contains(Part.backSupport.rawValue) {
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
    
    
    
    func setPrimaryToFootSupportWithHangerFrontLength(
        _ dictionary: PositionDictionary,
        _ partId: Part,
        _ lengthChange: Double,
        _ sitOnId: Part)
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
                
            let sitOnName = CreateNameFromParts([.sitOn, sitOnId]).name
            filteredDictionary = filteredDictionary.filter({
                $0.key.contains(
                    sitOnName
                 )
            })


            let soloFootSupportPresent = Part.id
                
            if partId != soloFootSupportPresent {
                let partWithSupportName = CreateNameFromParts([partId,.stringLink,.sitOn]).name
                filteredDictionary = filteredDictionary.filter({$0.key.contains(partWithSupportName)})
            }
   

                
            var editedDictionary = dictionary
            
            for (key, value) in filteredDictionary {
                let newValue = value.y + lengthChange
                filteredDictionary[key] = (x:value.x, y: newValue, z: value.z)
                editedDictionary[key] = filteredDictionary[key]
                
              
                }
            //}
                
                for (key, _) in editedDictionary {
                    let linkPresent = key.contains(Part.footSupportHangerLink.rawValue) &&
                    key.contains(Part.sitOn.rawValue + sitOnId.rawValue)
                    //print(key)
                    
                    if linkPresent {
                        editedDictionary[key] = nil
                        //print("link detected")
                    }
                }
            
                 //.forEach{print($0)}
//print("" )
//print(DictionaryInStringOut(editedDictionary).stringOfNamesOut.contains("link"))
                
           // let firstItem = filteredDictionary.first!
         //   let supportIndexName = Part.sitOn.rawValue + sitOnId.rawValue
                let supportIndex = sitOnId == .id0 ?  0 : 1
            //firstItem.key.contains(supportIndexName) ? 0 : 1
//print(supportIndex)
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
    
    
    func setPrimaryToFootSupportFrontLengthWhenNoFootHanger(
        _ dictionary: PositionDictionary,
        _ partId: Part,
        _ lengthChange:Double)
        -> PositionDictionary {
        
        let namesForFilter =
        [Part.footSupportInOnePiece.rawValue + Part.stringLink.rawValue
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
            let ignoreCornersAtLengthIsZero = value.y == 0.0
            let newValue = ignoreCornersAtLengthIsZero ? 0.0: value.y + lengthChange
            filteredDictionary[key] = (x:value.x, y: newValue, z: value.z)
            editedDictionary[key] = filteredDictionary[key]
        }
        return editedDictionary
    }
    
}



