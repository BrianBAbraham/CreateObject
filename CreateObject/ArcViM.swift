//
//  ArcViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 30/04/2024.
//

import Foundation
import Combine

class ArcViewModel: ObservableObject {

    @Published var movementDictionaryForScreen: CornerDictionary = MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    @Published var uniqueArcPointNames: [String] = []
    @Published var uniqueArcNames: [String] = []
    @Published var uniqueStaticPointNames: [String] = []
    @Published var arcDictionary: CornerDictionary = [:]
    @Published var staticPointDictionary: CornerDictionary = [:]
    
    ///each element is the angle to an arc point on a  lower integer object and then a higher integer object
    @Published var angles: [AnglesRadius] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        MovementDictionaryForScreenService.shared.$movementDictionaryForScreen
            .sink { [weak self] newData in
                self?.movementDictionaryForScreen = newData
                self?.arcDictionary = self?.createArcDictionary() ?? [:]
                self?.staticPointDictionary = self?.createStaticPointDictionary() ?? [:]
                self?.uniqueStaticPointNames = self?.getUniqueStaticPointNames() ?? []
                self?.uniqueArcPointNames = self?.getUniqueArcPointNames() ?? []
                self?.angles = self?.getAngles() ?? []
                
              
            }
            .store(
                in: &cancellables
            )
        
        uniqueArcNames = getUniqueArcNames()
        uniqueArcPointNames = getUniqueArcPointNames()
        uniqueStaticPointNames = getUniqueStaticPointNames()
        arcDictionary = createArcDictionary()
        angles = getAngles()
        
        
    }
    
    
    func getUniqueArcPointNames() -> [String] {
        let names =
        Array( movementDictionaryForScreen.keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
        
        //print(names)
        return names
      
    }
    
    
    func getUniqueArcNames() -> [String] {
       var names = getUniqueArcPointNames()
        names = StringAfterSecondUnderscore.get(in: names)
    
    names = Array(Set(names))
    return names
        
    }
    
    
    func getUniqueStaticPointNames() -> [String] {
        let names =
        Array(
            movementDictionaryForScreen.keys
        ).filter {
            $0.contains(
                PartTag.staticPoint.rawValue) }
        
        return names
    }
    
    
    func createArcDictionary() -> CornerDictionary {
        var arcDictionary: CornerDictionary = [:]
     
        let names = Array(movementDictionaryForScreen.keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
        let namesWithoutPrefix = Array(Set(RemovePrefix.get(PartTag.arcPoint.rawValue, names)))
        let prefixNames = SubstringBefore.get(substring: PartTag.arcPoint.rawValue, in: names)
      
        if prefixNames.count > 1 { //ignore when only one object
            
            //objectZero will have the first value and etc
            let orderedPrefixNames = SortStringsByEmbeddedNumber().get(prefixNames)
            
           // print(orderedPrefixNames)
            for name in namesWithoutPrefix {
                
                let firstPointName = orderedPrefixNames[0] + name
                let secondPointName = orderedPrefixNames[1] + name
                guard let firstPointValue = movementDictionaryForScreen[firstPointName] else {
                    fatalError("\(names)")
                }
                guard let secondPointValue = movementDictionaryForScreen[secondPointName] else {
                    fatalError()
                }
                let any = 0//four identical values; conforms to corners; disregard three
                arcDictionary += [name: [firstPointValue[any], secondPointValue[any]]]
            }
        }
        //getAngles()
       // print(arcDictionary)
        return arcDictionary
    }
    
    
    func createStaticPointDictionary() -> CornerDictionary {
        let dic =
        movementDictionaryForScreen.filter{$0.key.contains(PartTag.staticPoint.rawValue)}
        
        
        return dic
    }
    
    
    func  getAngles() -> [AnglesRadius] {
        var angles: [AnglesRadius] = []
        if uniqueStaticPointNames.count > 0 { //ignore when empty
            guard let staticPoint = staticPointDictionary[uniqueStaticPointNames[0]]?[0] else {
                fatalError()
            }
            
            let pairsOfPoints = arcDictionary.values.map{ $0}
            
            for index in 0..<pairsOfPoints.count {
                let pairs = pairsOfPoints[index]
                let radius = distance(from: staticPoint, to: pairs[0])
               
                let swappedAngle = swapIfEndAngleIsLeavingInAnticlockwiseDirection( [angle(pairs[0]), angle(pairs[1])])
                let anglesRadius = (id: index, start: swappedAngle[0], end: swappedAngle[1], radius: radius )
                angles += [anglesRadius]
                print(anglesRadius)
            }
            
            func angle(_ value: PositionAsIosAxes) -> Double{
                let dy = value.y - staticPoint.y
                let dx = value.x - staticPoint.x
                return atan2(dy, dx)
            }
            
            
            func swapIfEndAngleIsLeavingInAnticlockwiseDirection(_ anglePairs: [Double]) -> [Double] {
                let difference = anglePairs[1] - anglePairs[0]
                let shortestDifference = atan2(sin(difference), cos(difference))

                // Determine the direction based on the sign of the shortest difference
                let direction = shortestDifference >= 0 ? "counterclockwise" : "clockwise"

//                if shortestDifference < .pi / 2.0 {
                    if direction == "counterclockwise"  {
                      //  if shortestDifference < .pi / 2.0 {
                            return [anglePairs[0], anglePairs[1]] // no swap
                        } else {
                            
                            return [anglePairs[1], anglePairs[0]] //swap
                        }
//                    } else {
//                        return [anglePairs[0], anglePairs[1]] // no swap
//                    }
                    
//                } else {
//                    return [anglePairs[0], anglePairs[1]] // no swap
//                }
                
            }
            
            
            func distance(from: PositionAsIosAxes, to: PositionAsIosAxes) -> Double {
                sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
            }
        }
        
       // print(angles)
        return angles
    }
    
}
