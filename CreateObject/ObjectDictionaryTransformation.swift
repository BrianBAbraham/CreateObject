//
//  ObjectDictionaryTransformation.swift
//  CreateObject
//
//  Created by Brian Abraham on 18/02/2023.
//

import Foundation
import SwiftUI



struct ForScreen {
    var dictionary: PositionDictionary = [:]
    
    init( _ actualSize: PositionDictionary,
          _ offset: PositionAsIosAxes,
          _ scale: Double
    ) {
        dictionary = createDictionaryForScreen(actualSize, scale, offset)
    }
    
    func createDictionaryForScreen(
        _ actualSize: PositionDictionary,
        _ scale: Double,
        _ offset: PositionAsIosAxes)
    -> PositionDictionary {
        let scaleFactor = scale/scale
        var dictionaryForScreen: PositionDictionary = [:]
        for item in actualSize {
            dictionaryForScreen[item.key] =
            (x: (item.value.x + offset.x) * scaleFactor,
             y: (item.value.y + offset.y) * scaleFactor,
             z: item.value.z)
        }
        return dictionaryForScreen
    }
}

struct ForScreen2 {
    var dictionary: CornerDictionary = [:]
    
    init( _ actualSize: CornerDictionary,
          _ offset: PositionAsIosAxes,
          _ scale: Double
    ) {
        dictionary = createDictionaryForScreen(actualSize, scale, offset)
    }
    
    func createDictionaryForScreen(
        _ actualSize: CornerDictionary,
        _ scale: Double,
        _ offset: PositionAsIosAxes)
    -> CornerDictionary {
        let scaleFactor = scale/scale
//print (scale)
//print (offset)
        var dictionaryForScreen: CornerDictionary = [:]
        for item in actualSize {
            var screenValues: [PositionAsIosAxes] = []
            
            for position in item.value {
//print (position)
                screenValues.append(
                (x: (position.x + offset.x) * scaleFactor,
                 y: (position.y + offset.y) * scaleFactor,
                 z: (position.z * scaleFactor) )  )
            }
//print (screenValues)
            dictionaryForScreen[item.key] = screenValues
        }
        
        //print (dictionaryForScreen)
        return dictionaryForScreen
    }
}

///input unique name
///get four cornefor unique name
///get min and max x
///get min and max y
///find width and length
///return width and length


struct MeasurementsFrom {
    
}

struct DictionaryElementIn {

    let singleElementDictionary: [String: [PositionAsIosAxes]]
    let onlyOneDictionaryMember = 0
    let locationsFromPrimaryOrigin: [PositionAsIosAxes]
    
    init (_ element: [String: [PositionAsIosAxes]]) {
        self.singleElementDictionary = element
       locationsFromPrimaryOrigin = singleElementDictionary.map{$0.1}[onlyOneDictionaryMember]
  

    }
    func cgPointsOut() -> [CGPoint] {

        var points: [CGPoint] = []
        for location in locationsFromPrimaryOrigin {
            points.append(CGPoint(x: location.x , y: location.y))
        }
        
        return points
    }
    
    func maximumHeightOut()
    -> Double {
       
        CreateIosPosition.getArrayFromPositions(locationsFromPrimaryOrigin).z.max() ?? 0.0
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



//struct DictionaryInArrayOut2 {
//    func getNameValue (_ dictionary: [String: PositionAsIosAxes ], _ sender: String = "") -> [String]{
//        var namesAndMeasurements: [String] = []
//        var values: PositionAsIosAxes
//        for key in dictionary.keys {
//            values = dictionary[key]!
//            namesAndMeasurements.append(
//                key + ": " +
//                String(Int(values.x)) + Part.stringLink.rawValue +
//                String(Int(values.y)) + Part.stringLink.rawValue +
//                String(Int(values.z))
//            )
//        }
//        let sortedNamesAndMeasurements = namesAndMeasurements.sorted(by: <)
//        return sortedNamesAndMeasurements
//    }
//
//    
//    func getAllOriginNamesAsString(_ myDictionary: [String: PositionAsIosAxes ]) -> String{
//        DictionaryInStringOut(myDictionary).stringOfNamesOut
//    }
//    
//    func getAllOriginValuesAsString(_ myDictionary: [String: PositionAsIosAxes ]) -> String{
//        DictionaryInStringOut(myDictionary).stringOfValuesOut
//    }
//}

struct DictionaryInArrayOut {
    
    
    func getNameValue <T>(_ dictionary: [String: T ]) -> [String]{    //CHANGE

        var namesAndMeasurements: [String] = []
        //var values: PositionAsIosAxes    //CHANGE
        
        var description = ""
        for (key, value) in dictionary {

            if let position = value as? PositionAsIosAxes {
                description = "\(key): \(position.x), \(position.y), \(position.z)"
            }
            
            if let position = value as? Dimension3d {
                description = "\(key): \(position.length), \(position.width), \(position.height)"
            }
            
            if let position = value as? Corners {
                description = "\(key): \(position[0].x), \(position[0].y), \(position[0].z)"
            }
            
            namesAndMeasurements.append(
                description
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

struct SuccessivelyFilteredDictionary {
    let dictionary: PositionDictionary
    
    init (_ names: [String], _ dictionary: PositionDictionary) {
        self.dictionary = getFilteredDictionary(names, dictionary)
        
        
        
        func getFilteredDictionary(
            _ names: [String],
            _ dictionary: PositionDictionary)
        -> PositionDictionary {
            var filteredDictionary: PositionDictionary = dictionary
            
            for name in names {
                filteredDictionary = filteredDictionary.filter({$0.key.contains(name)})
            }
            
            return filteredDictionary
        }
    }
}

struct Filter {
    let dictionary: PositionDictionary
    
    init (
        _ parts: [Part],
        _ dictionary: PositionDictionary,
        _ originOrAndCorner: Part?,
        _ sitOnId: Part?) {
            
            self.dictionary =
            filterDictionary (
                parts,
                dictionary,
                originOrAndCorner,
                sitOnId)
            
            func filterDictionary(
                _ parts: [Part],
                _ dictionary: PositionDictionary,
                _ originOrAndCorner: Part?,
                _ sitOnId: Part?
            )
            -> PositionDictionary {
                let partNameTermination = Part.stringLink.rawValue
                var filteredDictionary: PositionDictionary = [:]
                for part in parts {
                    filteredDictionary  +=
                    dictionary.filter({$0.key.contains(part.rawValue + partNameTermination )})
                }
                
                if let originOrAndCorner {
                    switch originOrAndCorner {
                    case .corner:
                        filteredDictionary =
                        filteredDictionary.filter({$0.key.contains(Part.corner.rawValue)})
                    case .objectOrigin:
                        filteredDictionary =
                        filteredDictionary.filter({$0.key.contains(Part.objectOrigin.rawValue)})
                    default:
                        break
                    }
                }
                
                if let sitOnId {
                    let sitOnName =
                            CreateNameFromParts([.stringLink, .sitOn, sitOnId]).name
                    switch sitOnId {
                    case .id0:
                        filteredDictionary =
                        filteredDictionary.filter({$0.key.contains(sitOnName)})
                    case .id1:
                        filteredDictionary =
                        filteredDictionary.filter({$0.key.contains(sitOnName)})
                    default:
                        break
                    }
                }
                
                return filteredDictionary
            }
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


struct EditFootSupportPosition {
    let dictionary: PositionDictionary
    
    init(_ dictionary: PositionDictionary) {
        self.dictionary = [:]
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

    
extension Dictionary {
    static func -= (left: inout Dictionary, right: Dictionary) {
        var reducedDictionary: [String: PositionAsIosAxes] = [:]
        
        for (key,value) in left {
            if right[key] == nil {
                let name = key as! String
                let position = value as! PositionAsIosAxes
                reducedDictionary[name] = position
            }
        }
    }
}

struct Replace {
    var intialWithReplacements: PositionDictionary = [:]
    
    init( initial: PositionDictionary, replacement: PositionDictionary) {
        
        intialWithReplacements =
        replace(initial, replacement)
    }

    func replace(
        _ initial: PositionDictionary,
        _ replacement: PositionDictionary) -> PositionDictionary{
        var initialWithReplacements = initial
        for (key, value) in replacement {
            if let oldValue = initial[key] {
                
                initialWithReplacements[key] = value
            }
        }
        return initialWithReplacements
    }
    
}


struct ConvertFourCornerPerKeyToOne {
    var oneCornerPerKey: PositionDictionary = [:]
    
    init (fourCornerPerElement: CornerDictionary) {
        oneCornerPerKey = convert(fourCornerPerElement)
    }

    
  func convert(_ fourCornerPerElement: CornerDictionary)
    -> PositionDictionary {
      var oneCornerPerKey: PositionDictionary = [:]
        for (key, value) in fourCornerPerElement {
            for index in 0..<value.count {
                oneCornerPerKey += [key + Part.stringLink.rawValue + Part.corner.rawValue + String(index): value[index]]
            }
        }
        return oneCornerPerKey
    }
}
