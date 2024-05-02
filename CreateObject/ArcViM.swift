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
    
    var lastShortestDifference: [Double] = [0.0]
    
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
      
        var swappedAngle: [Double] = []
        if uniqueStaticPointNames.count > 0 { //ignore when empty
            guard let staticPoint = staticPointDictionary[uniqueStaticPointNames[0]]?[0] else {
                fatalError()
            }
            
            let pairsOfPoints = arcDictionary.values.map{ $0}
            
            for index in 0..<pairsOfPoints.count {
                let pairs = pairsOfPoints[index]
                let radius = distance(from: staticPoint, to: pairs[0])
               
                let firstAngle = angle(pairs[0])
                let secondAngle = angle(pairs[1])
                
                if lastShortestDifference.count == pairsOfPoints.count {//not the first time
                    //subsequently use the last difference
                    
                  //  print(lastShortestDifference[index])
                    swappedAngle = swapIfEndAngleIsLeavingInAnticlockwiseDirection( [firstAngle, secondAngle],lastShortestDifference[index] )
                    
                    lastShortestDifference[index] = getShortestDifference(swappedAngle)
//                    print(lastShortestDifference[index])
//                    print("\(index)\n")
                    
                    if index == 9 {
                        checkTruth( [firstAngle, secondAngle],lastShortestDifference[index] )
                    }

                } else {
                    swappedAngle = swapIfEndAngleIsLeavingInAnticlockwiseDirection( [firstAngle, secondAngle], 0.0)
                   
                    lastShortestDifference.append(getShortestDifference(swappedAngle))
                }
                
               
                let anglesRadius = (id: index, start: swappedAngle[0], end: swappedAngle[1], radius: radius )
                angles += [anglesRadius]
                //print(anglesRadius)
            }
            
            
            print("")
            
            func angle(_ value: PositionAsIosAxes) -> Double{
                let dy = value.y - staticPoint.y
                let dx = value.x - staticPoint.x
                return atan2(dy, dx)
            }
            
            func checkTruth(_ anglePairs: [Double], _ lastShortestDifference: Double)  {
                
                let shortestDifference = getShortestDifference(anglePairs)
                
                let shortestDifferenceState = shortestDifference > 0.0 ? true: false
                let lastShortestDifferenceState = lastShortestDifference > 0.0 ? true: false
                let topQuadrantsState = lastShortestDifference.magnitude > .pi / 2.0 ? true: false
                let differenceState = shortestDifference - lastShortestDifference > 0.0 ? true: false
                
                let states34 = [lastShortestDifferenceState, shortestDifferenceState, topQuadrantsState]
                let states12 = [lastShortestDifferenceState, shortestDifferenceState, differenceState]
                
                if states34 == [true, true, true] || states34 == [false, false, false] || states12 == [true, false, false] || states12 == [false, true, false] {
                    print("draw clockwise")
                }
                
                if states34 == [true, true, false] || states34 == [false, false, true] || states12 == [true, false, true] || states12 == [false, true, true]{
                    print("draw anti-clockwise")
                }
            }
            
            
            
            
            func swapIfEndAngleIsLeavingInAnticlockwiseDirection(_ anglePairs: [Double], _ lastShortestDifference: Double) -> [Double] {

                
                // Determine the direction based on the sign of the shortest difference
                
            //    let swapRequired = shortestDifference <= 0 && shortestDifference > .pi / -2.0 ? "swap" : "no swap"
                
               // print(swapRequired)
              //  let direction = shortestDifference >= 0  ? "counterclockwise" : "clockwise"
//                print(" \(shortestDifference)  \(lastShortestDifference) start \(direction) of end by short route")
//                    if swapRequired == "no swap"  {
//
//                            return [anglePairs[0], anglePairs[1]] // no swap
//                    } else {
//                        
//                        return [anglePairs[1], anglePairs[0]] //swap
//                    }
                
               return [anglePairs[0], anglePairs[1]] // no swap
            }
            
            func getShortestDifference(_ anglePairs: [Double]) -> Double {
                let difference = anglePairs[1] - anglePairs[0]
                return
                    atan2(sin(difference), cos(difference))
            }
            
            
            func distance(from: PositionAsIosAxes, to: PositionAsIosAxes) -> Double {
                sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
            }
            
            func previousAngles() {
                
            }
        }
        
       // print(angles)
        return angles
    }
    
}
