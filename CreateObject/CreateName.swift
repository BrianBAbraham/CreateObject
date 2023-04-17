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

struct CreateSupportPartName {
    let index: Int
    var name: String {
        
        String(
        Part.sitOn.rawValue + Part.id.rawValue + String(index)
        )
    }
}

//struct CreateFootPlateName {
//    let indexForSide: Int
//    let indexForCorner: Int
//    let indexForSitOn: Int
//    var name: String {
//        Part.footSupport.rawValue + Part.id.rawValue +
//        String(indexForSide) + Part.stringLink.rawValue +
//        Part.corner.rawValue + String(indexForCorner) + Part.stringLink.rawValue +
//        Part.sitOn.rawValue + Part.id.rawValue + String(indexForSitOn)
//    }
//}
//
//
//struct CreateArmName {
//    let indexForSide: Int
//    let indexForCorner: Int
//    let indexForSitOn: Int
//    var name:String {
//        Part.arm.rawValue + Part.id.rawValue +
//        String(indexForSide) + Part.stringLink.rawValue +
//        Part.corner.rawValue + String(indexForCorner) + Part.stringLink.rawValue +
//        Part.sitOn.rawValue + Part.id.rawValue + String(indexForSitOn)
//      }
//}

struct CreateSymmetricPartName {
    let indexForSide: Int
    let indexForCorner: Int
    let indexForSitOn: Int
    let part: Part
    var name: String {
        part.rawValue + Part.id.rawValue +
        String(indexForSide) + Part.stringLink.rawValue +
        Part.corner.rawValue + String(indexForCorner) + Part.stringLink.rawValue +
        Part.sitOn.rawValue + Part.id.rawValue + String(indexForSitOn)
      }
}

struct CreateOriginName {
    let part: Part
    let identifierForThisPartType: Int
    let firstName: String
    let secondName: String
    init(
        _ part: Part,
        identifierForThisPartType: Int
    ) {
        self.part = part
        self.identifierForThisPartType = identifierForThisPartType
        firstName = getFirstName()
        secondName = getSecondName()
        
        func getFirstName() -> String {
            part.rawValue + Part.id.rawValue + String(identifierForThisPartType) //+ "_"
        }
        
        func getSecondName() -> String {
            part.rawValue + Part.id.rawValue + String(identifierForThisPartType) //+ "_"
        }
    }
}

struct GetUniqueNames {
    let uniqueCornerNames: [String]
    
    init(_ dictionary: PositionDictionary) {
        uniqueCornerNames = getUniquePartNamesOfCornerItems(dictionary)
        
        func getUniquePartNamesOfCornerItems(_ dictionary: [String: PositionAsIosAxes] ) -> [String] {

            let relevantKeys = dictionary.filter({$0.key.contains(Part.corner.rawValue)}).keys
            var uniqueNames: [String] = []
            var removedName = ""
            var newName = ""
            let commonName = Part.stringLink.rawValue + Part.corner.rawValue
            for relevantKey in relevantKeys {
                for index in 0...3 {
                    removedName = commonName + String(index)
                    newName = String(relevantKey.replacingOccurrences(of: removedName, with: ""))
                    
                    if newName != relevantKey {
                        uniqueNames.append(newName)
                    }
                }
            }

            return uniqueNames.removingDuplicates()
        }
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


