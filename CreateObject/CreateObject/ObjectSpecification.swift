//
//  ObjectSpecification.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/03/2024.
//

import Foundation




enum ObjectTypes: String, CaseIterable, Hashable {
    
    case allCasterBed = "Bed: caster base"
    case allCasterChair = "Chair: caster base"
    case allCasterHoist = "Hoist: caster base"
    case allCasterSixHoist = "Hoist: six caster base"
    case allCasterTiltInSpaceShowerChair = "Tilting shower chair: caster base"
    case allCasterTiltInSpaceArmChair = "Tilting armchair: caster base"
    case allCasterStandAid = "Stand aid: caster base"
    case allCasterStretcher = "Stretcher: caster Base "
    
//    case bathIntegralHoist = "IntegralBathHoist"
//    case bathFloorFixedHoistOneRotationPoint = "SingleRotationPointBathHoist"
//    case bathFloorFixedHoistTwoRotationPoint = "DoubleRotationPointBathHoist"
    
    case fixedWheelRearDriveAssisted = "Assisted wheelchair"
    case fixedWheelFrontDrive = "Power chair front drive"
    case fixedWheelMidDrive  = "Power chair mid-drive"
    case fixedWheelRearDrive = "Power chair rear drive"
    case fixedWheelManualRearDrive = "Self-propelling chair rear drive"
    case fixedWheelSolo = "Power chair active balance"
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






//Source of truth for partChain
//chainLabel is the last item in array
//MARK: ChainLabel
struct LabelInPartChainOut {
    static let partChainArrays: [[Part]] = [
            [.mainSupport, .assistantFootLever],
            [.mainSupport, .backSupport],
            [.mainSupport, .backSupportTiltJoint],
            [.mainSupport, .footSupportHangerLink,  .footSupport],
            [.footOnly],
            [.mainSupport, .backSupport,.backSupportHeadSupportJoint, .backSupportHeadSupportLink, .backSupportHeadSupport],
            [.mainSupport, .armSupport],
            [.mainSupport],
            [.mainSupport, .sideSupport],
            [.mainSupport, .sitOnTiltJoint],
            [.fixedWheelHorizontalJointAtRear, .fixedWheelAtRear],
            [.fixedWheelHorizontalJointAtMid, .fixedWheelAtMid],
            [.fixedWheelHorizontalJointAtFront, .fixedWheelAtFront],
            [.fixedWheelHorizontalJointAtRear,  .fixedWheelAtRear, .fixedWheelAtRearWithPropeller ],
        
            [.fixedWheelHorizontalJointAtFront,  .fixedWheelAtFrontWithPropeller],
            [.casterVerticalJointAtRear, .casterWheelAtRear, .casterForkAtRear],
            [.casterVerticalJointAtMid, .casterWheelAtMid, .casterForkAtMid],
            [.casterVerticalJointAtFront, .casterWheelAtFront, .casterForkAtFront],
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



/// provides the object names for the picker
/// provides the chainLabels for each object
//MARK: ObjectsChainLabels
struct ObjectChainLabel {
    static let chairSupport: [Part] =
        [.mainSupport,
         .backSupportTiltJoint,
        .backSupportHeadSupport,
        .footSupport,
        .armSupport,
        .sitOnTiltJoint]
    static let chairSupportWithOutFoot: [Part] =
        [.mainSupport,
        .backSupportHeadSupport,
        .armSupport,
        .sitOnTiltJoint]
    ///setting the fork and not the casterWheel  as the terminal part
    ///facilitates editing of the fork length and posiitiong
    ///setting the casterWheel as the terminal part makes the edit loigic more complicated
    static let rearAndFrontCasterFork: [Part] =
        [.casterForkAtRear, .casterForkAtFront]
    static let chairSupportWithFixedRearWheel: [Part] =
    chairSupport + [.fixedWheelAtRear]
    
   static let dictionary: ObjectChainLabelDictionary =
        [
        .allCasterBed:
            [.mainSupport, .sideSupport ],
          
        .allCasterChair:
            chairSupport + rearAndFrontCasterFork,
    
        .allCasterTiltInSpaceArmChair:
            chairSupportWithOutFoot + rearAndFrontCasterFork + [.sitOnTiltJoint],
          
        .allCasterTiltInSpaceShowerChair:
            chairSupport + rearAndFrontCasterFork + [.sitOnTiltJoint],
        
        .allCasterStretcher:
            [ .mainSupport, .sideSupport] + rearAndFrontCasterFork,
        
        .fixedWheelRearDriveAssisted:
            chairSupport + [.fixedWheelAtRear] + [.casterForkAtFront] + [.assistantFootLever],
        
        .fixedWheelMidDrive:
            chairSupport + [.fixedWheelAtMid] + rearAndFrontCasterFork,
        
        .fixedWheelFrontDrive:
            chairSupport + [.fixedWheelAtFront] + [.casterForkAtRear],
         
        .fixedWheelRearDrive:
            chairSupportWithFixedRearWheel + [.casterForkAtFront] ,
        
        .fixedWheelManualRearDrive:
            chairSupportWithFixedRearWheel + [.casterForkAtFront] + [.fixedWheelAtRearWithPropeller],
        
   

        .fixedWheelSolo: [.mainSupport] + [.fixedWheelAtMid]  + [.armSupport] ,
    
            .scooterRearDrive4Wheeler: chairSupportWithOutFoot + [.fixedWheelAtRear, .steeredWheelAtFront],
    
            .showerTray: [.mainSupport],
    
    ]
}


//MARK: OneOrTwoId
struct OneOrTwoId {
    static let partWhichAreAlwaysUnilateral: [Part] = [
        .backSupportTiltJoint,
        .backSupport,
        .backSupportHeadSupportJoint,
        .backSupportHeadSupportLink,
        .backSupportHeadSupport,
        .footSupportInOnePiece,
        .footOnly,
        .mainSupport,
        .sitOnTiltJoint
    ]
    let forPart: OneOrTwo<PartTag>
    init(_ objectType: ObjectTypes,_ part: Part){
        forPart = getIdForPart(part)
        
        
        func getIdForPart(_ part: Part)
        -> OneOrTwo<PartTag>{
            if Self.partWhichAreAlwaysUnilateral.contains(part) {
                return  .one(one: PartTag.id0)
            } else {
                return .two(left: PartTag.id0, right: PartTag.id1)
            }
            

        }
    }
}

struct TiltingAbility {
    let part: Part
    let objectType: ObjectTypes
    static let dictionary: [PartObject: Part] = [
        PartObject(.mainSupport, .fixedWheelRearDrive): .sitOnTiltJoint,
        PartObject(.backSupport, .fixedWheelRearDrive): .backSupportTiltJoint,
        ]
    var tilter: Part? {
        Self.dictionary[PartObject(part, objectType)]
    }
    init (_ part: Part, _ objectType: ObjectTypes) {
        self.part = part
        self.objectType = objectType
    }
}

struct PartInRotationScopeOut {
    let allChainLabels: [Part]
//    let dictionary: [Part: [Part]] = [
//        .sitOnTiltJoint:
//            [.backSupport, .backSupportHeadSupport, .mainSupport, .armSupport, .footSupport],
//        .backSupportTiltJoint:
//            [.backSupport, .backSupportHeadSupport]
//    ]
    
    let dictionary: [Part: [Part]] = [
        .sitOnTiltJoint:
            [.backSupport, .backSupportTiltJoint, .backSupportHeadSupportLink, .backSupportHeadSupport, .mainSupport, .armSupport, .footSupportHangerLink, .footSupport],
//        .backSupportTiltJoint:
//            [.backSupport, .backSupportHeadSupportLink, .backSupportHeadSupport]
    ]
    
    let part: Part
    
    var defaultRotationScope: [Part] {
        dictionary[part] ?? []
    }
    
    var rotationScopeAllowingForEditToChainLabel: [Part] {
        defaultRotationScope//.filter { allChainLabels.contains($0) }
        
    }
    
    init(_ part: Part, _ allChainLabels: [Part]) {
        self.part = part
        self.allChainLabels = allChainLabels
    }
}
