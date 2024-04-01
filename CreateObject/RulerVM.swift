//
//  RulerVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import Foundation
import Combine


struct RulerModel {
    let ensureInitialObjectAllOnScreen: EnsureInitialObjectAllOnScreen
    let rulerMarks: CornerDictionary
    var rulerNumbers: PositionDictionary
    
    
    
    
}
class MeasurementSystemService {
    @Published var unitSystem: UnitSystem = .cm
    
    static let shared = MeasurementSystemService()
    
    
    func getMeasurementSytem() -> UnitSystem {
        unitSystem
    }
    
    
    func setMeasurementSystem(_ unitSystem: UnitSystem) {
        print(unitSystem)
        self.unitSystem = unitSystem
    }
}

class RulerViewModel: ObservableObject {
    
    
    private var cancellables: Set<AnyCancellable> = []
    @Published var unitSystem: UnitSystem = MeasurementSystemService.shared.unitSystem
    let lengthBefore = 170.0
    let lengthAfter = 30.0
    let numberSpan: Double
    let width: Double
    @Published private var rulerModel: RulerModel
    let rulerData: RulerDataBackground
    let rulerMarks: RulerDataMarks
  
    init(
        _ numberSpan: Double = 1500.0,
        _ width: Double = 170.0
    ) {
        
        self.numberSpan = numberSpan
        self.width = width
        let rulerLength = lengthBefore + numberSpan + lengthAfter
        
        

        
        rulerData =
            RulerDataBackground (
                rulerLength: rulerLength,
                rulerWidth: width
            )
        
        rulerMarks = RulerDataMarks(lengthBefore: lengthBefore, numberSpan: numberSpan, ruleWidth: width, unitSystem: .mm)
        
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
        
        MeasurementSystemService.shared.$unitSystem
            .sink { [weak self] newData in
                self?.unitSystem = newData
            }
            .store(in: &self.cancellables)
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
        createNumberDictionary()

    }
    
    func createNumberDictionary() -> PositionDictionary{
        let dictionary = getRulerMarks()
        var labelDictionary: PositionDictionary = [:]
        print("ruler")
        print(unitSystem)
        print("")
        let unitCorrection = unitSystem == UnitSystem.mm ? 1: 10
        for (key, value) in dictionary {
            if !key.contains(Level.tertiary.rawValue)  && !key.contains(Level.halfSecondary.rawValue){
              
                let value = value[0].y
                let numberName = String(Int(value - lengthBefore)/unitCorrection)
                labelDictionary += [numberName: (x: width/2.0, y: value, z: RulerDataMarks.rulerPositionOnZ)]
            }
        }
       return labelDictionary
    }

}


struct RulerDataMarks {
    let lengthBefore: Double
    let numberSpan: Double
    let ruleWidth: Double
    let unitSystem: UnitSystem
    var widthIndices: [Int] {
        (0..<10).map { $0 }
    }
    static let rulerPositionOnZ = 1000.0

    
  
    
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
       
        let numberOfDivisions = Int(numberSpan/division)
        for i in 0...numberOfDivisions {
            let positionY = Double(i) * division + lengthBefore
            valuesForY.append(positionY)
        }
        
        return valuesForY
    }
    

}


struct RulerDataBackground {
    let rulerLength: Double
    let rulerWidth: Double
  //  let unitSystem: UnitSystem
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
