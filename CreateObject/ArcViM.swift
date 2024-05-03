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
      
    
        if uniqueStaticPointNames.count > 0 { //ignore when empty
            guard let staticPoint = staticPointDictionary[uniqueStaticPointNames[0]]?[0] else {
                fatalError()
            }
            
            let pairsOfPoints = arcDictionary.values.map{ $0}
            
            for index in 0..<pairsOfPoints.count {
                let pairs = pairsOfPoints[index]
                let radius = distance(from: staticPoint, to: pairs[0])
               
                var firstAngle = angle(pairs[0]) //<= angle(pairs[1]) ?  angle(pairs[0]) : angle(pairs[1])
                var secondAngle = angle(pairs[1]) //> angle(pairs[0]) ? angle(pairs[1]) : angle(pairs[0])
                var clockwise: Bool = true
                
                if lastShortestDifference.count == pairsOfPoints.count {//not the first time
                    //subsequently use the last difference
                    if index == 0 {
                        clockwise =
                        checkTruth( [firstAngle, secondAngle],lastShortestDifference[index], index )
                    }
                    
//                    update
                    lastShortestDifference[index] = getShortestDifference([firstAngle, secondAngle])
                 

                } else {
                    let adjustFirstDifference = -0.0001//random value to indicate prior movement
                    
                    lastShortestDifference.append(getShortestDifference([firstAngle, secondAngle]) + adjustFirstDifference)
                    if index == 0 {
                        clockwise =
                        checkTruth( [firstAngle, secondAngle],lastShortestDifference[index], index )
                    }
                }
                
//                if clockwise == false {
//                    let temp = firstAngle
//                    firstAngle = secondAngle
//                    secondAngle = temp
//                }
                let anglesRadius = (id: index, start: firstAngle, end: secondAngle, radius: radius, clockwise: clockwise)
                angles += [anglesRadius]
                //print(anglesRadius)
                
//                if clockwise {
//                    print("clockwise")
//                } else {
//                    print("anti-clockwise")
//                }
            }
//            
//            print(atan2(0.0,1.0))
//            print(atan2(1.0,0.0))
//            print(atan2(-1.0,0.0))
            print("")
            
            func angle(_ value: PositionAsIosAxes) -> Double{
                let dy = value.y - staticPoint.y
                let dx = value.x - staticPoint.x
                return atan2(dy, dx)
            }
            
            func checkTruth(_ anglePairs: [Double], _ lastShortestDifference: Double, _ index: Int)  -> Bool {
                var clockwise = true
                let shortestDifference = getShortestDifference(anglePairs)
                
                let shortestDifferenceState = shortestDifference >= 0.0 ? true: false
                let lastShortestDifferenceState = lastShortestDifference >= 0.0 ? true: false
              //  let topQuadrantsState = lastShortestDifference.magnitude >= .pi / 2.0 ? true: false
                let differenceState = shortestDifference - lastShortestDifference < 0.0 ? true: false
                
                let states24 = [lastShortestDifferenceState, shortestDifferenceState, differenceState]
              //  let states13 = [lastShortestDifferenceState, shortestDifferenceState, differenceState]
                
                let stateC4 =  [true, false, true]
                let stateAC4 = [false, true, false]
//                let stateC2 = [false, true, true]
//                let stateAC2 = [true, false, true]
//                let stateAC1 = [true, true, true]
//                let stateC1 = [true, true, false]
//                let stateAC3 = [false, false, false]
//                let stateC3 = [false, false, true]
                
               // print(index)
         
                print(anglePairs)
                if states24 == stateC4 {
                    print("anticlockwise through zero difference detected")
                    print(shortestDifference)
                    print(lastShortestDifference)
                   
                    clockwise = false
                    
                }
                
                
                
                if states24 == stateAC4  {
                    print ("clockwise through zero differnce detected")
                    print(shortestDifference)
                    print(lastShortestDifference)
                  
                    clockwise = true
                    //print("")
                }
//                
//                
//                if states24 == stateAC2  {
//                    print ("ac2 detected")
//                    print(shortestDifference)
//                    print(lastShortestDifference)
//                    //print("")
//                }
//                
//                if states13 == stateAC1  {
//                    print ("ac1 detected")
//                    print(shortestDifference)
//                    print(lastShortestDifference)
//                    //print("")
//                }
//                
//                if states24 == stateC2  {
//                    print ("c2 detected")
//                    print(shortestDifference)
//                    print(lastShortestDifference)
//                    //print("")
//                }
//                
//                if states13 == stateAC3 {
//                    print ("ac3 detected")
//                    print(shortestDifference)
//                    print(lastShortestDifference)
//                    //print("")
//                }
//                
//                if states13 == stateC3 {
//                    print ("c3 detected")
//                    print(shortestDifference)
//                    print(lastShortestDifference)
//                    //print("")
//                }
//                
//                if states13 == stateC1 {
//                    print ("c1 detected")
//                    print(shortestDifference)
//                    print(lastShortestDifference)
//                    //print("")
//                }
                
//                let clockwiseStates = [stateC1, stateC2, stateC3, stateC4]
//                let antiClockwiseStates = [stateAC1, stateAC2, stateAC3, stateAC4]
//                
//                if clockwiseStates.contains(states24) || clockwiseStates.contains(states13) {
//                    clockwise = true
//                  
//                }
//                
//                if antiClockwiseStates.contains(states24) || antiClockwiseStates.contains(states13) {
//                    clockwise = false
//                  
//                    
//                }
//                print(states13)
//                print(states24)
//                if clockwise == true {
//print("clockwise\n")
//                } else {
//                    print("anticlockwise\n")
//                }
                print(clockwise)
                
                return clockwise
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
