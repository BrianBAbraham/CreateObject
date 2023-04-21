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


struct CreateFromParts {
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
    Part.sitOn.rawValue + Part.id.rawValue + String(indexForSitOn) + Part.stringLink.rawValue +
        Part.corner.rawValue + String(indexForCorner)
      }
    
//    var name: String {
//        part.rawValue + Part.id.rawValue +
//        String(indexForSide) + Part.stringLink.rawValue +
//        Part.corner.rawValue + String(indexForCorner) + Part.stringLink.rawValue +
//        Part.sitOn.rawValue + Part.id.rawValue + String(indexForSitOn)
//      }
}

//raw dictionary
//part_id*_corner*_sitOn_id*
//primaryOrigin_id*_part_id*_sitOn_id*
//sitOn_id*_corner*

//unique name = raw dictionry - _corner*
//part_id*_sitOn_id*
// sitOn_id*

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
    let forPart: [String]
    
    init(_ dictionary: PositionDictionary) {
        forPart = getUniquePartNamesOfCornerItems(dictionary)
        
        func getUniquePartNamesOfCornerItems(_ dictionary: [String: PositionAsIosAxes] ) -> [String] {

            let cornerKeys = dictionary.filter({$0.key.contains(Part.corner.rawValue)}).keys
            var uniqueNames: [String] = []
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

struct GetGeneralName {
    let fromUniquePartName: String
    
    init(_ uniqueName: String) {
        fromUniquePartName = getName(uniqueName)
        
        func getName(_ uniqueName: String)
            -> String {
           let firstItemIsTheCommonName: Int = 0
           let nameInSplitForm: [String] =
            uniqueName.components(separatedBy: ConnectStrings.symbol)
            return nameInSplitForm[firstItemIsTheCommonName]
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


