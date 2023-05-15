//
//  TwinSitOnVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 15/05/2023.
//

import Foundation


typealias TwinSitOnOptions = [TwinSitOnOption : Bool]

enum TwinSitOnOption: String, CaseIterable  {
   
    case baby = "baby"
    case buddy = "buddy"
    case frontAndRear = "rear-front"
    case front = "front seat"
    case rear = "rear seat"
    case leftAndRight = "side-by-side"
    case left = "left seat"
    case right = "right seat"
    
}

struct TwinSitOnModel {
    var options: TwinSitOnOptions
}


class TwinSitOnViewModel: ObservableObject {
    
    static let twinSitOnOptionsDictionary =
    Dictionary(uniqueKeysWithValues: TwinSitOnOption.allCases.map { $0 }.map { ($0, false) })
    
    @Published private var twinSitOnModel: TwinSitOnModel =
    TwinSitOnModel( options: twinSitOnOptionsDictionary)
    
}


extension TwinSitOnViewModel {
    
    
    func getState(_ text: String = "")
        -> Bool {
            let dictionary = twinSitOnModel.options

            let state =
                (dictionary[.leftAndRight] ?? false) ||
                (dictionary[.frontAndRear] ?? false)
            return state
        }
    
    
    func getManyState ( _ options: [TwinSitOnOption])
    -> [Bool] {
        let dictionary = twinSitOnModel.options
            var optionStates: [Bool] = []
            for option in options {
                optionStates
                    .append(dictionary[option] ?? false)
            }
            return optionStates
    }
    
    
    func getOneState (_ option: TwinSitOnOption)
    -> Bool {
        getTwinSitOnOptions()[option] ?? false
    }

    func getTwinSitOnOptions()
        -> TwinSitOnOptions {
            twinSitOnModel.options
    }
    
    func getTwinSitOnConfiguration()
    -> [TwinSitOnOption] {
        
        var options: [TwinSitOnOption] = []
        let dictionary = twinSitOnModel.options
        
        if dictionary[.leftAndRight] ?? false {
            options = [.left, .right]
        }
        
        if dictionary[.frontAndRear] ?? false {
            options = [.front, .rear]
        }
        
        return options
    }
    
    func getSitOnId()
    -> Part {
        var sitOnId = Part.id0
        
        let dictionary = getTwinSitOnOptions()
        
        if dictionary[.front] ?? false ||
            dictionary[.right] ?? false {
            sitOnId  = Part.id1
        }
        
        return sitOnId
    }
    
    
    
    func setAllToFalse (_ options: [TwinSitOnOption]) {
        var dictionary =
        getTwinSitOnOptions()
        
        for option in options {
            dictionary[option] = false
        }
        
        setTwinSitOnOptions(dictionary)
    }
    
    
    func setFrontAndRearToFalse () {
        let options: [TwinSitOnOption] =
        [.frontAndRear, .front, .rear]
        
        setAllToFalse(options)
    }
    
    
    func setLeftAndRightToFalse () {
        let options: [TwinSitOnOption] =
        [.leftAndRight, .left, .right]
        
       setAllToFalse(options)
    }
    
    func setAllConfigurationFalse () {
        setLeftAndRightToFalse()
        setFrontAndRearToFalse()
    }
    
    
    func setTwinSitOnOptions(_ options: TwinSitOnOptions) {
        twinSitOnModel.options = options
        
    }
    
    func setTwinSitOnOption(
        _ option: TwinSitOnOption, _ state: Bool) {
            
           var dictionary = getTwinSitOnOptions()
            
            dictionary[option] = state
            
//print(dictionary)
            setTwinSitOnOptions(dictionary)
            
    }
    
    func setTwinSitOnToFalse(
            _ option: TwinSitOnOption,
            _ state: Bool) {
                
            setTwinSitOnOption(
                option,
                state)
            
            var options: [TwinSitOnOption] = []
                
            if option == TwinSitOnOption.frontAndRear
                && !state {
            options = [.front, .rear]
            }
            
            if option == TwinSitOnOption.leftAndRight
                && !state {
                options = [.left, .right]
            }
                
            for seat in options {
                setTwinSitOnOption(
                    seat,
                    state)
            }
                
        }
    
}
