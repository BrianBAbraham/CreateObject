//
//  ObjectDictionaryInformation.swift
//  CreateObject
//
//  Created by Brian Abraham on 14/04/2023.
//

import Foundation


struct GetValueFromDictionary <T> {
    var value: T

    init(
        _ dictionary: [String: T],
        _ parts: [Part] = []) {
            
            value = ZeroValue.iosLocation as! T
      
        getDimension(
            dictionary,
            parts
        )
 
        func getDimension(
            _ dictionary: [String: T],
            _ parts: [Part]){

            let name = CreateNameFromParts(parts).name

            let wrappedDimension = dictionary[name] //

                if wrappedDimension is PositionAsIosAxes {
                value = wrappedDimension ?? ZeroValue.iosLocation as! T
            }

                if wrappedDimension is Dimension3d {
                value = wrappedDimension ?? ZeroValue.dimension3d as! T
            }
        }
    }
}










