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
    
    var clockwise = true
    
    init(){
        MovementDictionaryForScreenService.shared.$movementDictionaryForScreen
            .sink { [weak self] newData in
                self?.movementDictionaryForScreen = newData
                self?.arcDictionary = self?.createArcDictionary() ?? [:]
                self?.staticPointDictionary = self?.createStaticPointDictionary() ?? [:]
                self?.uniqueStaticPointNames = self?.getUniqueStaticPointNames() ?? []
                self?.uniqueArcPointNames = self?.getUniqueArcPointNames() ?? []
                self?.angles = self?.getArcViewData() ?? []
                
              
            }
            .store(
                in: &cancellables
            )
        
        uniqueArcNames = getUniqueArcNames()
        uniqueArcPointNames = getUniqueArcPointNames()
        uniqueStaticPointNames = getUniqueStaticPointNames()
        arcDictionary = createArcDictionary()
        angles = getArcViewData()
        
        
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

        return arcDictionary
    }
    
    
    func createStaticPointDictionary() -> CornerDictionary {
        let dic =
        movementDictionaryForScreen.filter{$0.key.contains(PartTag.staticPoint.rawValue)}
        
        return dic
    }
    
    
    func getArcViewData() -> [AnglesRadius] {
        var angles: [AnglesRadius] = []
    
        if uniqueStaticPointNames.count > 0 { //ignore when empty
            guard let staticPoint = staticPointDictionary[uniqueStaticPointNames[0]]?[0] else {
                fatalError()
            }
            
            let pairsOfPoints = arcDictionary.values.map{ $0}
            
            for index in 0..<pairsOfPoints.count {
                let pairs = pairsOfPoints[index]
                let radius = distance(from: staticPoint, to: pairs[0])
               
                var firstAngle = angle(pairs[0])
                var secondAngle = angle(pairs[1])
                var shortestDifference = 0.0
                
                if lastShortestDifference.count == pairsOfPoints.count {//not the first time
                    //subsequently use the last difference
                    
                    shortestDifference = getShortestDifference([firstAngle, secondAngle])
                 //   if index == 0 {
                        checkTruth(lastShortestDifference[index],shortestDifference)
                   // }

                    lastShortestDifference[index] = shortestDifference

                } else {
                    let adjustFirstDifference = -0.0001//random value to indicate prior movement
                    shortestDifference = getShortestDifference([firstAngle, secondAngle])
                    lastShortestDifference.append(getShortestDifference([firstAngle, secondAngle]) + adjustFirstDifference)
                   // if index == 0 {
                        checkTruth(lastShortestDifference[index], shortestDifference)
                    //}
                }
                
                let anglesRadius = (id: index, start: firstAngle, end: secondAngle, radius: radius, clockwise: clockwise)
                angles += [anglesRadius]
            }

            
            func angle(_ value: PositionAsIosAxes) -> Double{
                let dy = value.y - staticPoint.y
                let dx = value.x - staticPoint.x
                return atan2(dy, dx)
            }
            
            
            func checkTruth(
                _ lastShortestDifference: Double,
                _ shortestDifference: Double
            ) {

                let anticlockwiseZeroTravere = zeroTraverse(
                    zero: lastShortestDifference,
                    nonZero: shortestDifference
                )
                let clockwiseZeroTravere = zeroTraverse(
                    zero: shortestDifference,
                    nonZero: lastShortestDifference
                )
                
                if anticlockwiseZeroTravere {
                    clockwise = false
                }
                
                if clockwiseZeroTravere {
                    clockwise = true
                }
                
                
                    func zeroTraverse(
                        zero zeroDifference: Double,
                        nonZero nonZeroDifference: Double
                    ) -> Bool{
                        let zeroTest = Double(
                            String(
                                format:  "%.3f",
                                zeroDifference
                            )
                        )
                    let anticlockwiseZeroTraverse: Bool = nonZeroDifference < 0.0 ? true: false
                    var state = false
                    if  zeroTest == 0.0 && anticlockwiseZeroTraverse{
                        state = true
                    }
                    return state
                }
            }


            
            func getShortestDifference(_ anglePairs: [Double]) -> Double {
                let difference = anglePairs[1] - anglePairs[0]
                return
                    atan2(sin(difference), cos(difference))
            }
            
            
            func distance(from: PositionAsIosAxes, to: PositionAsIosAxes) -> Double {
                sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
            }
            

            
        }
        return angles
    }
    
}
