//
//  CreateName.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation





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


struct RemoveObjectName {
    let nameToBeRemovedCharacterCount = CreateNameFromParts([Part.objectOrigin, PartTag.id0, PartTag.stringLink]).name.count
    
    func remove(_ name: String)
        -> String {
        let startIndex =
           name.index(name.startIndex, offsetBy: nameToBeRemovedCharacterCount)
        
        return
         String(name[startIndex...])
    }
}


//struct CreateNameFromParts {
//    let name: String
//    init(_ parts: [any Parts]) {
//
//        name = getNameFromParts(parts)
//
//        func getNameFromParts(_ parts: [any Parts])
//            -> String {
//            var name = ""
//            for item in parts {
//                if let newItem = item.stringValue as? String{
//                    name += newItem
//                } else {
//                    fatalError()
//                }
//                }
//            return name
//        }
//    }
//}

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


struct GetUniqueNames {
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
        let objectName = Part.objectOrigin.rawValue + PartTag.id0.rawValue + PartTag.stringLink.rawValue

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


