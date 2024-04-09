//
//  CreateName.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation


struct ObjectId {
   static let objectId = PartTag.id0
}


struct ConnectStrings {
    static let symbol = PartTag.stringLink.rawValue


    static func byUnderscoreOrSymbol(
        _ first: String,
        _ second:String,
        _ symbol:String = PartTag.stringLink.rawValue)
    -> String {
        first + symbol + second //+ symbol
    }
}


//struct RemoveObjectName {
//    let nameToBeRemovedCharacterCount = CreateNameFromParts([Part.objectOrigin, PartTag.id0, PartTag.stringLink]).name.count
//    
//    func remove(_ name: String)
//        -> String {
//        let startIndex =
//           name.index(name.startIndex, offsetBy: nameToBeRemovedCharacterCount)
//        
//        return
//         String(name[startIndex...])
//    }
//}


struct CreateNameFromIdAndPart {
    var name: String
    
    init(_ id: PartTag, _ part: Part) {
        
        name = getNameFromParts(id, part)
        
        func getNameFromParts(_ id: PartTag, _ part: Parts)
            -> String {
                let downcastPart = part as! Part
                let parts: [Parts] =
                [Part.objectOrigin, ObjectId.objectId, PartTag.stringLink, downcastPart , id, PartTag.stringLink, Part.mainSupport, PartTag.id0]
                   return
                    CreateNameFromParts(parts ).name
        }
    }
}

struct CreateNameFromParts {
    var name: String = ""
    
    init(_ parts: [Parts]) {
        name = getNameFromParts(parts)
    }
    
    private func getNameFromParts(_ parts: [Parts]) -> String {
        var name = ""
        for item in parts {
            name += item.stringValue
        }
        return name
    }
}


struct GetUniqueNamesX {
    let forPart: [String]
  
    init(_ dictionary: PositionDictionary) {
        forPart = getUniquePartNamesOfCornerItems(dictionary)
       
        func getUniquePartNamesOfCornerItems(_ dictionary: [String: PositionAsIosAxes] ) -> [String] {
            var uniqueNames: [String] = []
            let cornerKeys = dictionary.filter({$0.key.contains(PartTag.corner.rawValue)}).keys
           // print(cornerKeys)
            var removedName = ""
            var nameWithoutCornerString = ""
            let cornerName = PartTag.stringLink.rawValue + PartTag.corner.rawValue
            for cornerKey in cornerKeys {
                for index in 0...3 {
                    removedName = cornerName + String(index)
                    nameWithoutCornerString = String(cornerKey.replacingOccurrences(of: removedName, with: ""))
                    
                    if nameWithoutCornerString != cornerKey {
                        uniqueNames.append(nameWithoutCornerString)
                    }
                }
            }
            return uniqueNames.removingDuplicates()
        }
    }
}



//struct UniqueNamesForDimensions {
//
//    var are: [String] = []
//    
//
//    init(_ dictionary: Part3DimensionDictionary) {
//
//        are = getUniqueNameForDimensions(dictionary)
//
//
//
//        func getUniqueNameForDimensions(_ dictionary: Part3DimensionDictionary ) -> [String] {
//            var uniqueNames: [String] = []
//            for (key, _) in dictionary {
//                let components =
//                key.split(separator: "_")
//                if let firstPart = components.first {
//                    uniqueNames.append(String(firstPart) )
//                }
//            }
//            return uniqueNames
//        }
//    }
//}

//struct GetGeneralName {
//    let fromUniquePartName: String
//
//    init(_ uniqueName: String) {
//        fromUniquePartName = getName(uniqueName)
//
//        func getName(_ uniqueName: String)
//            -> String {
//           let firstItemIsTheCommonName: Int = 0
//           let nameInSplitForm: [String] =
//            uniqueName.components(separatedBy: ConnectStrings.symbol)
//            return nameInSplitForm[firstItemIsTheCommonName]
//        }
//    }
//}



struct ParentToPartName {
    func convertedToObjectToPart(_ parentToPartName: String)
        -> String {
        var editedString = parentToPartName
        var underscoreCount = 0
        var startIndex: String.Index?
            let objectName = Part.objectOrigin.rawValue + ObjectId.objectId.rawValue + PartTag.stringLink.rawValue

        for (index, character) in editedString.enumerated() {
            if character == "_" {
                underscoreCount += 1
                if underscoreCount == 2 {
                    startIndex = editedString.index(editedString.startIndex, offsetBy: index + 1)
                    break
                }
            }
        }

        if let startIndex = startIndex {
            editedString = objectName + String(editedString[startIndex...])
        }
//print(parentToPartName)
//print(editedString)
//print("\n\n")
            return editedString
    }
    
}


struct UniqueToGeneralName {
    let uniqueName: String
    let generalName: String
    
    init(_ uniqueName: String) {
        self.uniqueName = uniqueName
        generalName = getGeneralName()
        
        func getGeneralName() -> String {
            let components = uniqueName.split(separator: "_")
            
            if components.count > 2 {
                let desiredSubstring = String(components[2])
                return desiredSubstring
            } else {
               return ""
            }
        }
    }
}



func replaceCharBeforeSecondUnderscore(in string: String, with replacement: String) -> String {
    let underscoreIndexes = string.enumerated().filter { $0.element == "_" }.map { $0.offset }
    
    guard underscoreIndexes.count >= 2 else {
        print("Error: Expected at least two underscores in the string.")
        return string
    }
    
    let secondUnderscoreIndex = underscoreIndexes[1]
    let indexBeforeSecondUnderscore = string.index(string.startIndex, offsetBy: secondUnderscoreIndex - 1)
    
    if secondUnderscoreIndex > 0, string.distance(from: string.startIndex, to: indexBeforeSecondUnderscore) >= 0 {
        let startIndex = string.startIndex
        let endIndex = string.index(before: indexBeforeSecondUnderscore)
        let stringStart = string[startIndex...endIndex]
        
        let replacementStartIndex = string.index(after: endIndex)
        let replacementEndIndex = string.index(after: indexBeforeSecondUnderscore)
        let stringEnd = string[replacementEndIndex...]
        
        return stringStart + replacement + stringEnd
    } else {
        print("Error: Cannot replace character before the second underscore.")
        return string
    }
}


//}

//extension String {
//    var capitalizeFirstLetter: String {
//        // 1
//        let firstLetter = self.prefix(1).capitalized
//        // 2
//        let remainingLetters = self.dropFirst()
//        // 3
//        return firstLetter + remainingLetters
//    }
//}


