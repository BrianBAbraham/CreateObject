//
//  RulerVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import Foundation

struct RulerModel {
    let ensureInitialObjectAllOnScreen: EnsureInitialObjectAllOnScreen
    let rulerMarks: CornerDictionary
    var rulerNumbers: PositionDictionary
    
    
    
}


class RulerViewModel: ObservableObject {
    let length: Double
    let width: Double
    @Published private var rulerModel: RulerModel
    let rulerData: RulerDataBackground
    let rulerMarks: RulerDataMarks

   

    init(
        _ length: Double = 3000.0,
        _ width: Double = 200.0
    ) {
        self.length = length
        self.width = width
        
        rulerData =
        RulerDataBackground (
            rulerLength: length,
            rulerWidth: width
        )
        
        rulerMarks = RulerDataMarks(rulerLength: length, ruleWidth: width, unitSystem: .mm)
        
        rulerModel = RulerModel(
            ensureInitialObjectAllOnScreen: EnsureInitialObjectAllOnScreen(
                fourCornerDic: rulerData.fourCornerDic,
                oneCornerDic: rulerData.oneCornerDic,
                objectDimension: rulerData.dimension
            ),
            rulerMarks: rulerMarks.getMarksDictionary(),
            rulerNumbers: [:]
        )
        
        rulerModel.rulerNumbers = createNumberDictionary()
    }
    

    
    func getDictionaryForScreen() -> CornerDictionary {
        rulerModel.ensureInitialObjectAllOnScreen.fourCornerDic
    }
    
    
    func getRulerFrameSize() -> Dimension {
        let frameSize = rulerModel.ensureInitialObjectAllOnScreen.objectDimension
        return frameSize
    }
    
    func getRulerMarks() -> CornerDictionary{
        rulerModel.rulerMarks
    }
    
    func getNumberDictionary() -> PositionDictionary {
       
            rulerModel.rulerNumbers
    }
    
    
    
    func createNumberDictionary() -> PositionDictionary{
        let dictionary = getRulerMarks()
        var labelDictionary: PositionDictionary = [:]
        for (key, value) in dictionary {
            if !key.contains(Level.tertiary.rawValue)  && !key.contains(Level.halfSecondary.rawValue){
              
                let value = value[0].y
                let numberName = String(Int(value - RulerDataMarks.numbersOffSet))
                labelDictionary += [numberName: (x: width/2.0, y: value, z: RulerDataMarks.rulerPositionOnZ)]
            }
        }
       return labelDictionary
    }

}


struct RulerDataMarks {
    let rulerLength: Double
    let ruleWidth: Double
    let unitSystem: UnitSystem
    var widthIndices: [Int] {
        (0..<10).map { $0 }
    }
    static let rulerPositionOnZ = 1000.0
    static let numbersOffSet = 50.0
    var numberLength: Double {
    rulerLength - 100
    }
  
    
    func getMarksDictionary() -> CornerDictionary{
        var dictionary: CornerDictionary = [:]
        addToDictionary(getPositions(.tertiary), .tertiary)
        addToDictionary(getPositions(.secondary), .secondary)
        addToDictionary(getPositions(.halfSecondary), .halfSecondary)
        addToDictionary(getPositions(.primary), .primary)

        return dictionary
        
        func addToDictionary(_ positions: [[PositionAsIosAxes]], _ level: Level){
            for i in 0..<positions.count {
                dictionary += [String(i) + level.rawValue: positions[i]]
            }
        }
    }
    


    
    func getPositions(_ level: Level) -> [[PositionAsIosAxes]]{
        let valuesForY = getValuesForY(level)
        let valuesForX = getValuesForX(level)
        var positions: [[PositionAsIosAxes]] = []
        let rulerZ = Self.rulerPositionOnZ
        for y in 0..<valuesForY.count {
            for x in [0,2] {
                positions.append(
                    [(
                        x: valuesForX[x],
                        y: valuesForY[y],
                        z: rulerZ),
                     (
                        x: valuesForX[x + 1],
                        y: valuesForY[y],
                        z: rulerZ) ]
                )
            }
          }
            return positions
    }
    

    
    func getValuesForX(_ level: Level) -> [Double]{
        let stepForX = ruleWidth/18.0
        switch level {
        case .primary:
            return
                getValuesForX([0, 6, 12, 18])
        case .secondary:
            return
                getValuesForX([0, 4, 14, 18])
        case .halfSecondary:
            return
                getValuesForX([0, 3, 15, 18])
        case .tertiary:
            return
                getValuesForX([0, 2, 16, 18])
        }
        
        func getValuesForX(_ indices: [Int] ) -> [Double] {
            indices.map {Double($0) * stepForX }
        }
    }
    
    
    func getValuesForY( _ level: Level) -> [Double]{
        var division: Double
        switch level {
        case .primary:
            division = 1000
        case .secondary:
            division = 100
        case .halfSecondary:
            division = 50
        case .tertiary:
            division = 10
            
        }
        var valuesForY: [Double] = []
        let offset = Self.numbersOffSet
        let numberOfDivisions = Int(numberLength/division)
        for i in 0...numberOfDivisions {
            let positionY = Double(i) * division + offset
            valuesForY.append(positionY)
        }
        
        return valuesForY
    }
    

}


struct RulerDataBackground {
    let rulerLength: Double
    let rulerWidth: Double
    var fourCornerDic: CornerDictionary {
        getDictionary()
    }
    var oneCornerDic: PositionDictionary {
        ConvertFourCornerPerKeyToOne(fourCornerPerElement:  fourCornerDic).oneCornerPerKey
    }
    var dimension: Dimension {
        (width: rulerWidth, length: rulerLength)
    }
        
        func getDictionary() -> CornerDictionary {
            let rulerOnTop = 1000.0
            let outline = [
                ZeroValue.iosLocation,
                (x: rulerWidth, y: 0, z: rulerOnTop),
                (x: rulerWidth, y: rulerLength, z: rulerOnTop),
                (x: 0, y: rulerLength, z: rulerOnTop)
            ]
            return
                ["": outline]
        }
}

enum Level: String {
    case primary = "p"
    case halfSecondary = "h"
    case secondary = "s"
    case tertiary = "t"
}
