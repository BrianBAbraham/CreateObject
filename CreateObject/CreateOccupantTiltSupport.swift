//
//  CreateOccupantTiltSupport.swift
//  CreateObject
//
//  Created by Brian Abraham on 25/05/2023.
//

import Foundation

//struct CreateOccupantTiltSupport {
//
//    var dictionaryForTiltJoint: PositionDictionary = [:]
//    var tiltedDictionary: PositionDictionary = [:]
//
//    init(
//        _ dictionary: PositionDictionary,
//        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
//        _ supportIndex: Int,
//        _ sitOnWidth: [Double] ){
//            
//    dictionaryForTiltJoint =
//        getDictionary(
//            supportIndex,
//            parentFromPrimaryOrigin,
//            sitOnWidth
//        )
//            tiltedDictionary = tiltTheDictionary(dictionary)
//    }
//    
//    mutating func getDictionary(
//        _ supportIndex: Int,
//        _ parentFromPrimaryOrigin: [PositionAsIosAxes],
//        _ sitOnWidth: [Double]
//        )
//        -> PositionDictionary {
//        
//            let tiltDictionary =
//            CreateOnePartOrSideSymmetricParts(
//                (length: Joint.dimension.length, width: sitOnWidth[supportIndex] ),
//                .tiltJoint,
//                parentFromPrimaryOrigin[supportIndex],
//                (x: 0.0, y: 0.0, z: -100.0),
//                supportIndex)
//            
//            return tiltDictionary.cornerDictionary
//    }
//
//    func tiltTheDictionary(
//        _ dictionary: PositionDictionary)
//        -> PositionDictionary{
//            let tiltable = PartCollections.tiltable
//            
//            
//            return [:]
//    }
//    
//    
//}
