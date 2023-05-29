//
//  MeasurementDictionaryCreation.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/05/2023.
//

import Foundation


struct CreateMeasurementDictionary {
    let dictionary: MeasurementDictionary
    
    init(
        _ nameCase: MeasurementParts,
        _ parts: [Part],
        _ lengths: [Double],
        _ widths: [Double]) {
    
            dictionary =
                getDictionary(
                nameCase,
                parts,
                lengths,
                widths)
            
            func getDictionary(
                _ nameCase: MeasurementParts,
                _ parts: [Part],
                _ lengths: [Double],
                _ widths: [Double])
                -> MeasurementDictionary {
                    var dictionary: MeasurementDictionary = [:]
                    
                    for index in 0..<parts.count {
                        let preName = parts[index].rawValue + nameCase.rawValue
                        dictionary[preName + Part.width.rawValue] = widths[index]
                        dictionary[preName + Part.length.rawValue] = lengths[index]
                    }
                    return dictionary
            }
    }
}

struct GetFromMeasurementDictionary {
    let dimension: Dimension
    
    init(
        _ dictionary: MeasurementDictionary,
        _ part: Part,
        _ nameCase: MeasurementParts
    ) {
        dimension = getDimension()
        
        func getDimension ()
        -> Dimension {
            let preName = part.rawValue + nameCase.rawValue
            let widthName = preName + Part.width.rawValue
            let lengthName = preName + Part.length.rawValue
            let dimension =
                (length: dictionary[lengthName] ?? 0.0,
                 width: dictionary[widthName] ?? 0.0)
            
            return dimension
        }
    }
    
    
}

protocol Measurements {
    var nameCase: MeasurementParts {get}
    var dictionary: MeasurementDictionary {get}
    
}
