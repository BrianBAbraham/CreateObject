//
//  DictionaryTransformation.swift
//  CreateObject
//
//  Created by Brian Abraham on 18/02/2023.
//

import Foundation
import SwiftUI



struct ForScreen {
    var dictionary: PositionDictionary = [:]
    
    init( _ actualSize: PositionDictionary,
          _ minThenMaxPositionOfObject: [PositionAsIosAxes],
          _ maxDimension: Double
    ) {
        
        let minThenMax = minThenMaxPositionOfObject
        let offset = CreateIosPosition.minus(minThenMax[0])
       
        let scale = Screen.smallestDimension / maxDimension
        dictionary = createDictionaryForScreen(actualSize, scale, offset)

    }
    
    
    func createDictionaryForScreen(
        _ actualSize: PositionDictionary,
        _ scale: Double,
        _ offset: PositionAsIosAxes)
    -> PositionDictionary {
        var dictionaryForScreen: PositionDictionary = [:]
        for item in actualSize {
            dictionaryForScreen[item.key] =
            (x: (item.value.x + offset.x) * scale,
             y: (item.value.y + offset.y) * scale,
             z: item.value.z)
        }
        return dictionaryForScreen
    }
}


struct DictionaryElementIn {
    //let pointOut: [CGPoint]
    let singleElementDictionary: [String: [PositionAsIosAxes]]
    
    init (_ element: [String: [PositionAsIosAxes]]) {
        self.singleElementDictionary = element
        //pointOut = cgPointsOut()
   // }

    }
    func cgPointsOut() -> [CGPoint] {
        let onlyOneDictionaryMember = 0
        var points: [CGPoint] = []
        let locationsFromPrimaryOrigin = singleElementDictionary.map{$0.1}[onlyOneDictionaryMember]
        
        for location in locationsFromPrimaryOrigin {
            points.append(CGPoint(x: location.x , y: location.y))
        }
        
        return points
    }
    

}


struct DictionaryWithValue {
    let dictionary: [String: PositionAsIosAxes]
    
    init(_ dictionary: [String: PositionAsIosAxes]) {
        self.dictionary = dictionary
    }
    
    func asArray()
        ->[String: [PositionAsIosAxes]] {
            var dictionaryWithArrayOfValue:[String: [PositionAsIosAxes]] = [:]
            for element in dictionary {
                dictionaryWithArrayOfValue += [element.key: [element.value] ]
            }
          //  let partName = dictionary.map{$0.0}[onlyOneDictionaryMember]
            
            return dictionaryWithArrayOfValue//[partName: [dictionary[partName]!] ]
    }
    
    func asCGPoint()
    -> [String: CGPoint] {
        var dictionaryWithCGPointValue:[String: CGPoint] = [:]
        for element in dictionary {
            dictionaryWithCGPointValue += [element.key: CGPoint(x: element.value.x, y: element.value.y) ]
        }
      //  let partName = dictionary.map{$0.0}[onlyOneDictionaryMember]
        
        return dictionaryWithCGPointValue//[partName: [dictionary[partName]!] ]
    }
}

struct DictionaryInStringOut {
    let dictionary: [String: PositionAsIosAxes ]    //CHANGE
    var stringOfNamesOut: String = ""
    var stringOfValuesOut: String = ""
    let keys: [String]
    let valuesForAllKeys: [PositionAsIosAxes]    //CHANGE

    init(_  dictionary: [String: PositionAsIosAxes ]) {    //CHANGE
        self.dictionary = dictionary
        keys = dictionary.keys.map({$0})
        valuesForAllKeys = dictionary.values.map({$0})
        stringOfNamesOut = getNames()

        stringOfValuesOut = getValuesForOrigin()
        
        func getNames() -> String {
            for name in keys {
                stringOfNamesOut += name + " + "
            }
            return stringOfNamesOut
        }
        
//        func getValuesForOrigin() -> String {
//            var valueString: String
//            for  value in valuesForAllKeys {
//                valueString = getValueString(value[0])
//                stringOfValuesOut += valueString + " + "
//            }
//            return stringOfValuesOut
//        }
        
        func getValuesForOrigin() -> String {

            for valuesForOneKey in valuesForAllKeys {
                var valueString: String = ""
                    //for  value in valuesForOneKey {
                        valueString += getValueString(valuesForOneKey) + Part.stringLink.rawValue

                    //}
                stringOfValuesOut += valueString + " + "
            }
            return stringOfValuesOut
        }
        
        func getValueString(_ value: PositionAsIosAxes) -> String{
            String(value.x) + Part.stringLink.rawValue + String(value.y) + Part.stringLink.rawValue + String(value.z)
        }
    }
}



struct DictionaryInArrayOut {
    func getNameValue(_ dictionary: [String: PositionAsIosAxes ], _ sender: String) -> [String]{    //CHANGE
//print(dictionary)
        var namesAndMeasurements: [String] = []
        var values: PositionAsIosAxes    //CHANGE
        for key in dictionary.keys {
            values = dictionary[key]!
                namesAndMeasurements.append(
                    key + ": " +
                    String(Int(values.x)) + Part.stringLink.rawValue +
                    String(Int(values.y)) + Part.stringLink.rawValue +
                    String(Int(values.z))
                )
        }
        let sortedNamesAndMeasurements = namesAndMeasurements.sorted(by: <)
        return sortedNamesAndMeasurements
    }
    
    func getAllOriginNamesAsString(_ myDictionary: [String: PositionAsIosAxes ]) -> String{    //CHANGE
        DictionaryInStringOut(myDictionary).stringOfNamesOut
    }
    
    func getAllOriginValuesAsString(_ myDictionary: [String: PositionAsIosAxes ]) -> String{    //CHANGE
        DictionaryInStringOut(myDictionary).stringOfValuesOut
    }
}


struct OriginStringInDictionaryOut {
    var dictionary: [String: PositionAsIosAxes ] = [:]    //CHANGE
    let namesAsString: String
    var valuesAsString: String

    
    init (_ namesAsString: String,
          _ valuesAsString: String) {
        self.namesAsString = namesAsString
        self.valuesAsString = valuesAsString
        

        
        dictionary = transform()
        
         func transform() -> [String: PositionAsIosAxes ] {
             var arrayOfNames = namesAsString.components(separatedBy: " + ")
                 arrayOfNames.removeLast()

             var arrayOfValues = valuesAsString.components(separatedBy: " + ")
                 arrayOfValues.removeLast()
             var xyzValues: [String]
             var positions: [PositionAsIosAxes] = []   //CHANGE
             
             for values in  arrayOfValues {
                 xyzValues = values.components(separatedBy: "_")
                
                 positions.append(stringToPositionAsIosAxes(xyzValues))
             }

             func stringToPositionAsIosAxes(_ name: [String]) -> PositionAsIosAxes {    //CHANGE
                 return
                 (x: (name[0] as NSString).doubleValue,
                 y: (name[1] as NSString).doubleValue,
                 z:(name[2] as NSString).doubleValue)
                   //  (x: 0.0, y:0.0, z:0.0)
             }

             
             return Dictionary(uniqueKeysWithValues: zip(arrayOfNames, positions))
        }
    }
}


struct Merge {
    static let these = Merge()
    func dictionaries (_ arrayOfDictionary: [ [String: PositionAsIosAxes ] ] ) -> [String: PositionAsIosAxes] {    //CHANGE
        var mergedDictionaries: [String: PositionAsIosAxes ] = [:]    //CHANGE
        
        for dictionary in arrayOfDictionary {
            mergedDictionaries.merge(dictionary) { (first, _) in first}
        }
        
        return mergedDictionaries
    }
}

extension Dictionary {

    static func += (left: inout Dictionary, right: Dictionary) {
        for (key, value) in right {
            left[key] = value
        }
    }
}
