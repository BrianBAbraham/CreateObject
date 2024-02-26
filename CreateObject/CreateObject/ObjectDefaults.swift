//
//  ObjectDefaults.swift
//  CreateObject
//
//  Created by Brian Abraham on 07/02/2024.
//

import Foundation


enum ObjectTypes: String, CaseIterable, Hashable {
    
    case allCasterBed = "Bed with caster base"
    case allCasterChair = "Chair with caster base"
    case allCasterHoist = "Hoist with caster base"
    case allCasterSixHoist = "Hoist with caster base and six caster"
    case allCasterTiltInSpaceShowerChair = "Tilting shower chair with caster base"
    case allCasterTiltInSpaceArmChair = "Tilting arm chair with caster base"
    case allCasterStandAid = "Stand aid with caster base"
    case allCasterStretcher = "Stretcher with caster Base "
    
//    case bathIntegralHoist = "IntegralBathHoist"
//    case bathFloorFixedHoistOneRotationPoint = "SingleRotationPointBathHoist"
//    case bathFloorFixedHoistTwoRotationPoint = "DoubleRotationPointBathHoist"
    
    case fixedWheelRearDriveAssisted = "Assisted wheelchair"
    case fixedWheelFrontDrive = "Power wheelchair with front drive"
    case fixedWheelMidDrive  = "Power wheelchair with mid-drive"
    case fixedWheelRearDrive = "Power wheelchair with rear drive"
    case fixedWheelManualRearDrive = "Self-propelling wheelchair with rear drive"
    case fixedWheelSolo = "Power wheelchair with active balance"
    case fixedWheelTransfer = "Fixed wheel transfer device"
    
//    case hingedDoorSingle = "Door"
//    case hingedDoorDouble = "Bi-FoldDoor"
//    case hingedDoortripple = "Tri-FoldDoor"
//
    case scooterFrontDrive4Wheeler = "Scooter 4 wheel front drive"
    case scooterFrontDrive3Wheeler =  "Scooter 3 wheel front drive"
    case scooterRearDrive4Wheeler  = "Scooter 4 wheel rear drive"
    case scooterRearDrive3Wheeler = "Scooter 3 wheel rear drive"
    
    case seatThatTilts = "Tilting chair"
    
    case showerTray = "Shower tray"
    
    case stairLiftStraight = "Straight stair-lift"
    case stairLiftInternalRadius = "Internal radius stair-lift"
    case stairLiftExternalRaidus = "External radius stair-lift"
    
    case verticalLift = "Vertical Lift"
}






/// provides the object names for the picker
/// provides the chainLabels for each object
//MARK: ObjectsChainLabels
struct ObjectChainLabel {
    static let chairSupport: [Part] =
        [.sitOn,
        .backSupportHeadSupport,
        .footSupport,
        .armSupport,
        .sitOnTiltJoint]
    static let chairSupportWithOutFoot: [Part] =
        [.sitOn,
        .backSupportHeadSupport,
        .armSupport,
        .sitOnTiltJoint]
    static let rearAndFrontCasterWheels: [Part] =
        [.casterWheelAtRear, .casterWheelAtFront]
    static let chairSupportWithFixedRearWheel: [Part] =
    chairSupport + [.fixedWheelAtRear]
    
   static let dictionary: ObjectChainLabelDictionary =
        [
        .allCasterBed:
            [.sitOn, .armSupport ],
          
        .allCasterChair:
            chairSupport + rearAndFrontCasterWheels,
    
        .allCasterTiltInSpaceArmChair:
            chairSupportWithOutFoot + rearAndFrontCasterWheels + [.sitOnTiltJoint],
          
        .allCasterTiltInSpaceShowerChair:
            chairSupport + rearAndFrontCasterWheels + [.sitOnTiltJoint],
        
        .allCasterStretcher:
            [ .sitOn, .armSupport] + rearAndFrontCasterWheels,
        
        .fixedWheelRearDriveAssisted:
            chairSupport + [.fixedWheelAtRear] + [.casterWheelAtFront] + [.assistantFootLever],
        
        .fixedWheelMidDrive:
            chairSupport + [.fixedWheelAtMid] + rearAndFrontCasterWheels,
        
        .fixedWheelFrontDrive:
            chairSupport + [.fixedWheelAtFront] + [.casterWheelAtRear],
         
        .fixedWheelRearDrive:
            chairSupportWithFixedRearWheel + [.casterWheelAtFront] ,
        
        .fixedWheelManualRearDrive:
            chairSupportWithFixedRearWheel + [.casterWheelAtFront] + [.fixedWheelAtRearWithPropeller],
        
   

        .fixedWheelSolo: [.sitOn] + [.fixedWheelAtMid]  + [.armSupport] ,
    
            .scooterRearDrive4Wheeler: chairSupportWithOutFoot + [.fixedWheelAtRear, .steeredWheelAtFront],
    
            .showerTray: [.sitOn],
    
    ]
}


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


//Source of truth for partChain
//chainLabel is the last item in array
//MARK: ChainLabel
struct LabelInPartChainOut {
    static let partChainArrays: [[Part]] = [
            [.sitOn, .assistantFootLever],
            [.sitOn, .backSupport],
            [.sitOn, .footSupportHangerLink,  .footSupport],
            [.footOnly],
            [.sitOn, .backSupport,.backSupportHeadSupportJoint, .backSupportHeadSupportLink, .backSupportHeadSupport],
            [.sitOn, .armSupport],
            [.sitOn],
            [.sitOn, .sitOnTiltJoint],
            [.fixedWheelHorizontalJointAtRear, .fixedWheelAtRear],
            [.fixedWheelHorizontalJointAtMid, .fixedWheelAtMid],
            [.fixedWheelHorizontalJointAtFront, .fixedWheelAtFront],
            [.fixedWheelHorizontalJointAtRear, .fixedWheelAtRear, .fixedWheelAtRearWithPropeller],
            [.fixedWheelHorizontalJointAtFront, .fixedWheelAtFront, .fixedWheelAtFrontWithPropeller],
            [.casterVerticalJointAtRear, .casterForkAtRear, .casterWheelAtRear],
            [.casterVerticalJointAtMid, .casterForkAtMid, .casterWheelAtMid],
            [.casterVerticalJointAtFront, .casterForkAtFront, .casterWheelAtFront],
            [.steeredVerticalJointAtFront, .steeredWheelAtFront]
            
        ]

        // Create the dictionary dynamically from the PartChain arrays
        static let partChainDictionary: [Part: PartChain] = {
            var dictionary: [Part: PartChain] = [:]

            for (index, partChain) in partChainArrays.enumerated() {
                guard let key = partChain.last else {
                                fatalError("no last part")
                            }
                dictionary[key] = partChain
            }

            return dictionary
        }()

    var partChains: [PartChain] = []
    var partChain: PartChain = []

    init(_ parts: [Part]) {//many partChain label
        for part in parts {
            if let partChain = Self.partChainDictionary[part] {
                partChains.append(partChain)
            }
        }
    }

    init(_ part: Part) { //one partChain label
        if let partChain = Self.partChainDictionary[part] {
            self.partChain = partChain
        }
    }

    mutating func getPartChain(_ part: Part) -> PartChain {
        return Self.partChainDictionary[part] ?? []
    }
}



//determine if a part is linked to another part for origin or dimension
struct LinkedParts {
    let dictionary: [Part: Part] = [
        .fixedWheelHorizontalJointAtRear: .sitOn,
        .fixedWheelHorizontalJointAtMid: .sitOn,
        .fixedWheelHorizontalJointAtFront: .sitOn,
        .casterVerticalJointAtRear: .sitOn,
        .casterVerticalJointAtMid: .sitOn,
        .casterVerticalJointAtFront: .sitOn,
        .steeredVerticalJointAtFront: .sitOn
        ]
}



//MARK: OneOrTwoId
struct OneOrTwoId {
    let forPart: OneOrTwo<PartTag>
    init(_ objectType: ObjectTypes,_ part: Part){
        forPart = getIdForPart(part)
        
        
        func getIdForPart(_ part: Part)
        -> OneOrTwo<PartTag>{
            switch part {
                
                case
                    .backSupportRotationJoint,
                    .backSupport,
                    .backSupportHeadSupportJoint,
                    .backSupportHeadSupportLink,
                    .backSupportHeadSupport,
                    .footSupportInOnePiece,
                    .footOnly,
                    .sitOn,
                    .sitOnTiltJoint:
                    return .one(one: PartTag.id0)
                default :
                return .two(left: PartTag.id0, right: PartTag.id1)
            }
        }
    }
}


struct DefaultMinMaxDimensionDictionary {
    let dimensionDic: Part3DimensionDictionary = [:]
    
    let fineDimensionMinMaxDic: [PartObject: (min: Dimension3d, max: Dimension3d)] = [
        PartObject(.sitOn, .showerTray):
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
        .sitOn:
          (min: (width: 200.0, length: 200.0, height: 10.0),
           max: (width: 1000.0, length: 2000.0, height: 40.0)),
        .footSupportHangerLink:
        (min: (width: 10.0, length: 50.0, height: 10.0),
         max: (width: 50.0, length: 1000.0, height: 40.0))
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
        PartObject(.sitOn, .showerTray):
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
enum ObjectLinkedEdits {
    case legLength //lengthens footSupportHangerLink dimension and footSupport origin
    case sitOn // affects object frame origin
    
}
