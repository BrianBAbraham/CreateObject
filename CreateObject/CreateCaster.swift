//
//  CreateCaster.swift
//  CreateObject
//
//  Created by Brian Abraham on 22/03/2023.
//



import Foundation


struct InitialCasterMeasurements {
    let forkOverhangAtFront = 20.0
    let forkOverHangAtRear = 50.0
    let trail: Double = 75//: Measurement(value: -150, unit: UnitLength.millimeters)
    let casterFork: Dimension
    let casterForkFromParent: PositionAsIosAxes
    let wheel: Dimension = (length: 70, width: 40)
    
    init () {
        casterFork = (length:
                        wheel.length +
                        forkOverhangAtFront +
                        forkOverHangAtRear,
                      width: wheel.width * 0.5)
        
        casterForkFromParent = (x: 0.0,
                                y: -casterFork.length/2.0 - forkOverhangAtFront,
                                z: casterFork.length)
    }
}


struct CreateCaster {
    let measurementFor: InitialCasterMeasurements
    var dictionary: PositionDictionary = [:]

    init(
        _ part: Part,
        _ parentFromPrimaryOrigin: PositionAsIosAxes
    )
    {
        measurementFor = InitialCasterMeasurements()
        
        getDictionary (
            part,
            parentFromPrimaryOrigin//,
            //partFromParent
        )
    }

    mutating func getDictionary(
        _ part: Part,
        _ parentFromPrimaryOrigin: PositionAsIosAxes
    ) {

        let supportIdIsAlwaysZero = 0
            
        let casterWheelDictionary =
            CreateOnePartOrSideSymmetricParts(
                measurementFor.wheel,
                part,
                (x:0, y: -measurementFor.trail, z: 0),
                parentFromPrimaryOrigin,
                supportIdIsAlwaysZero)
            

            
        let casterSpindleJointDictionary =
        CreateOnePartOrSideSymmetricParts(
            (length: 20.0, width: 20.0),
            getCasterSpindleJoint(part),
            (x:0, y:0, z: 0),
            parentFromPrimaryOrigin,

            supportIdIsAlwaysZero)
                                 
        func getCasterSpindleJoint(_ part: Part) -> Part {
            var casterSpindleJoint = Part.casterSpindleJointAtFront
            switch part{
            case .casterWheelAtCenter:
                casterSpindleJoint = Part.casterSpindleJointAtCenter
            case .casterWheelAtRear:
                casterSpindleJoint = Part.casterSpindleJointAtRear
            default:
                break
            }
            return casterSpindleJoint
        }

            let casterForkDictionary =
            CreateOnePartOrSideSymmetricParts(
                measurementFor.casterFork,
                getCasterSpindleJoint(part),
                measurementFor.casterForkFromParent,
                parentFromPrimaryOrigin,

                supportIdIsAlwaysZero)
            

        dictionary =
            Merge.these.dictionaries([
                //casterSpindleJointDictionary.originDictionary,
                casterForkDictionary.cornerDictionary,
                casterSpindleJointDictionary.cornerDictionary,
                casterWheelDictionary.cornerDictionary,
                casterWheelDictionary.originDictionary,
                
            ])
    }
}
