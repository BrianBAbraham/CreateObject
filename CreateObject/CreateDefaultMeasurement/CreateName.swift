//
//  CreateName.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation





struct ConnectStrings {
    static let symbol = Part.stringLink.rawValue

    static func byUnderscoreOrSymbolForLeftToRightDimension(
        _ first: String,
        _ second:String,
        _ symbol:String = Part.stringLink.rawValue)
    -> String {
        first + symbol + second + symbol + Part.leftToRightDimension.rawValue
    }

    static func byUnderscoreOrSymbolForTopToBottomDimension(
        _ first: String,
        _ second:String,
        _ symbol:String = Part.stringLink.rawValue)
    -> String {
        first + symbol + second + symbol + Part.topToBottomDimension.rawValue
    }
    
    static func byUnderscoreOrSymbol(
        _ first: String,
        _ second:String,
        _ symbol:String = Part.stringLink.rawValue)
    -> String {
        first + symbol + second //+ symbol
    }
}


struct RemoveObjectName {
    let nameToBeRemovedCharacterCount = CreateNameFromParts([.object, .id0, .stringLink]).name.count
    
    func remove(_ name: String)
        -> String {
        let startIndex =
           name.index(name.startIndex, offsetBy: nameToBeRemovedCharacterCount)
        
        return
         String(name[startIndex...])
    }
}


struct CreateNameFromParts {
    let name: String
    init(_ parts: [Part]) {
      
        name = getNameFromParts(parts)
        
        func getNameFromParts(_ parts: [Part])
            -> String {
            var name = ""
            for item in parts {
                name += item.rawValue
                }
            return name
        }
    }
}



struct GetUniqueNames {
    let forPart: [String]
  
    
    
    init(_ dictionary: PositionDictionary) {
        forPart = getUniquePartNamesOfCornerItems(dictionary)
       
        
        func getUniquePartNamesOfCornerItems(_ dictionary: [String: PositionAsIosAxes] ) -> [String] {
            var uniqueNames: [String] = []
            let cornerKeys = dictionary.filter({$0.key.contains(Part.corner.rawValue)}).keys
           // print(cornerKeys)
            var removedName = ""
            var nameWithoutCornerString = ""
            let cornerName = Part.stringLink.rawValue + Part.corner.rawValue
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
        let objectName = Part.object.rawValue + Part.id0.rawValue + Part.stringLink.rawValue

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


