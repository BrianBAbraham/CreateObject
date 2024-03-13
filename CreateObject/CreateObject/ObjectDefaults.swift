//
//  ObjectDefaults.swift
//  CreateObject
//
//  Created by Brian Abraham on 07/02/2024.
//

import Foundation









struct AllPartInObject {
    
    static func getOneOfAllPartInObjectBeforeEdit(_ objectType: ObjectTypes) -> [Part] {
        guard let allPartChainLabels = ObjectChainLabel.dictionary[objectType] else {
            fatalError("chain labels not defined for object")
        }
        var oneOfEachPartInAllChainLabel: [Part] = []
            for label in allPartChainLabels {
               let partChain = LabelInPartChainOut(label).partChain
                for part in partChain {
                    if !oneOfEachPartInAllChainLabel.contains(part) {
                        oneOfEachPartInAllChainLabel.append(part)
                    }
                }
            }
        return oneOfEachPartInAllChainLabel
    }
}











struct DefaultMinMaxDimensionDictionary {
  static  let casterFork =
        (min: (width: 10.0, length: 10.0, height: 10.0),
         max: (width: 100.0, length: 200.0, height: 500.0))
    static let casterWheel =
    (min: (width: 10.0, length: 20.0, height: 20.0),
     max: (width: 100.0, length: 300.0, height: 300.0))
    static let fixedWheel =
    (min: (width: 10.0, length: 100.0, height: 100.0),
     max: (width: 100.0, length: 800.0, height: 800.0))
    static let propeller =
    (min: (width: 10.0, length: 10.0, height: 300.0),
     max: (width: 100.0, length: 800.0, height: 800.0))
    
    let dimensionDic: Part3DimensionDictionary = [:]
    
    let fineDimensionMinMaxDic: [PartObject: (min: Dimension3d, max: Dimension3d)] = [
        PartObject(.mainSupport, .showerTray):
            (min: (width: 600.0, length: 600.0, height: 10.0),
             max: (width: 2000.0, length: 3000.0, height: 10.0))
        ]
    let generalDimensionMinMaxDic: [Part: (min: Dimension3d, max: Dimension3d)] = [
        .assistantFootLever:
          (min: (width: 10.0, length: 10.0, height: 10.0),
           max: (width: 100.0, length: 500.0, height: 40.0)),
        .armSupport:
          (min: (width: 10.0, length: 10.0, height: 10.0),
           max: (width: 200.0, length: 1000.0, height: 40.0)),
        .backSupport:
          (min: (width: 10.0, length: 10.0, height: 10.0),
           max: (width: 1000.0, length: 400.0, height: 40.0)),
       .backSupportHeadSupport:
         (min: (width: 10.0, length: 10.0, height: 10.0),
          max: (width: 1000.0, length: 400.0, height: 40.0)),
        .casterForkAtFront: casterFork,
        .casterForkAtRear: casterFork,
        .casterWheelAtRear: casterWheel,
        .casterWheelAtFront: casterWheel,
        .fixedWheelAtFront: fixedWheel,
        .fixedWheelAtMid: fixedWheel,
        .fixedWheelAtRear: fixedWheel,
        .fixedWheelAtRearWithPropeller: propeller,
        .footSupport:
            (min: (width: 10.0, length: 50.0, height: 10.0),
             max: (width: 50.0, length: 1000.0, height: 40.0)),
        .footSupportHangerLink:
            (min: (width: 10.0, length: 50.0, height: 10.0),
             max: (width: 50.0, length: 1000.0, height: 40.0)),
        .mainSupport:
          (min: (width: 200.0, length: 200.0, height: 10.0),
           max: (width: 1000.0, length: 2000.0, height: 40.0)),
          .sideSupport:
            (min: (width: 10.0, length: 10.0, height: 10.0),
             max: (width: 200.0, length: 1000.0, height: 40.0)),
        .steeredWheelAtFront: fixedWheel,
        ]
    
    static var shared = DefaultMinMaxDimensionDictionary()
    
    
    func getDefault(_ part: Part, _ objectType: ObjectTypes)  -> (min: Dimension3d, max: Dimension3d) {
        let minMaxDimension =
        getFineTuneMinMaxDimension(part, objectType) ??
        getGeneralMinMaxDimension(part)
        return minMaxDimension
    }
    
    
    func getFineTuneMinMaxDimension(_ part: Part, _ objectType: ObjectTypes) -> (min: Dimension3d, max: Dimension3d)? {
       fineDimensionMinMaxDic[PartObject(part, objectType)]
    }
    
    
    func getGeneralMinMaxDimension(_ part: Part) -> (min: Dimension3d, max: Dimension3d) {
      
        guard let minMax = generalDimensionMinMaxDic[part] else {
            fatalError("no minMax exists for \(part)")
        }
        
        return minMax
    }
}





struct DefaultMinMaxOriginDictionary {
    let originDic: PositionDictionary = [:]
    
    let fineOriginMinMaxDic: [PartObject: (min: PositionAsIosAxes, max: PositionAsIosAxes)] = [
        PartObject(.mainSupport, .showerTray):
            (min: (x: 600.0, y: 600.0, z: 10.0),
             max: (x: 2000.0, y: 3000.0, z: 10.0))
        ]
    let generalOriginMinMaxDic: [Part: (min: PositionAsIosAxes, max: PositionAsIosAxes)] = [
          .footSupportHangerLink:
            (min: (x: -500.0, y: 0.0, z: 0.0),
             max: (x: 500.0, y: 0.0, z: 0.0))
        ]
    
    static var shared = DefaultMinMaxOriginDictionary()
    
    
    func getDefault(_ part: Part, _ objectType: ObjectTypes)  -> (min: PositionAsIosAxes, max: PositionAsIosAxes) {
        let minMaxDimension =
        getFineTuneMinMaxOrigin(part, objectType) ??
        getGeneralMinMaxOrigin(part)
        return minMaxDimension
    }
    
    
    func getFineTuneMinMaxOrigin(_ part: Part, _ objectType: ObjectTypes) -> (min: PositionAsIosAxes, max: PositionAsIosAxes)? {
       fineOriginMinMaxDic[PartObject(part, objectType)]
    }
    
    
    func getGeneralMinMaxOrigin(_ part: Part) -> (min: PositionAsIosAxes, max: PositionAsIosAxes) {
       
        guard let minMax = generalOriginMinMaxDic[part] else {
            fatalError("no minMax exists for \(part)")
        }
        
        return minMax
    }
}

/// some edits have have multiple effects
//enum ObjectLinkedEdits {
//    case legLength //lengthens footSupportHangerLink dimension and footSupport origin
//    case sitOn // affects object frame origin
//    
//}
