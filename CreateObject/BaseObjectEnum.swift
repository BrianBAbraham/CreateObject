//
//  BaseTypes.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation

enum ObjectTypes: String, CaseIterable {
    
    case allCasterBed = "Bed with caster base"
    case allCasterChair = "Chair with caster base"
    case allCasterHoist = "Hoist with caster base"
    case allCasterSixHoist = "Hoist with caster base and six caster"
    case allCasterTiltInSpaceShowerChair = "Tilting shower chair with caster base"
    case allCasterStandAid = "Stand aid with caster base"
    case allCasterStretcher = "Stretcher with caster Base "
    
//    case bathIntegralHoist = "IntegralBathHoist"
//    case bathFloorFixedHoistOneRotationPoint = "SingleRotationPointBathHoist"
//    case bathFloorFixedHoistTwoRotationPoint = "DoubleRotationPointBathHoist"
    
    
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

//enum GroupsDerivedFromRawValueOfBaseObjectTypes: String {
//    case caster = "caster"
//    case bath = "Bath"
//    case fixedWheel = "wheel"
//    case door = "Door"
//    case power = "Power"
//    case selfPropelling = "Self-propelling"
//    case scooter = "Scooter"
//    case stairLift = "stairLift"
//    case verticalLift = "VerticaLift"
//
//}


//enum GroupsDerivedFromRawValueOfPartTypes: String {
//case sitOn = "hair"
//}

///object creation includes features if the object is containted
///in the feature group
struct BaseObjectGroups {
    let allFourCaster: [ObjectTypes] =
        [.allCasterBed,
         .allCasterChair,
         .allCasterHoist,
         .allCasterStandAid,
         .allCasterStretcher,
         .allCasterTiltInSpaceShowerChair]
    
    var rearFixedWheel: [ObjectTypes] =
        [
         .fixedWheelManualRearDrive,
         .fixedWheelRearDrive,
         .scooterRearDrive3Wheeler,
         .scooterRearDrive4Wheeler]
   
    let oneRearWheel: [ObjectTypes] =
        [
        .scooterFrontDrive3Wheeler]
    
    let midCaster: [ObjectTypes]
        = [.allCasterSixHoist]
    
    let midFixedWheel: [ObjectTypes] =
        [.fixedWheelMidDrive]
    
    let frontFixedWheel: [ObjectTypes] =
        [.fixedWheelFrontDrive,
        .scooterFrontDrive3Wheeler,
        .scooterFrontDrive4Wheeler]
    
    let twinSitOnAbility: [ObjectTypes] =
        [ .fixedWheelManualRearDrive,
          .fixedWheelRearDrive,
          .fixedWheelMidDrive,
          .fixedWheelFrontDrive,
          .scooterRearDrive3Wheeler,
          .scooterRearDrive4Wheeler,
          .scooterFrontDrive3Wheeler,
          .scooterFrontDrive4Wheeler]
    
    let singleWheelAtRear: [ObjectTypes] =
        [ .scooterRearDrive3Wheeler]
    
    let singleWheelAtFront: [ObjectTypes] =
        [ .scooterRearDrive3Wheeler]
    
    let sixWheels: [ObjectTypes] =
        [
        .allCasterSixHoist,
        .fixedWheelMidDrive]
    
    let noWheel: [ObjectTypes] = [.showerTray]
    let noBodySupport: [ObjectTypes] = [.showerTray]
    let sitOnBackFootTiltJoint: [ObjectTypes] = [.allCasterTiltInSpaceShowerChair]
    
    let footSupport: [ObjectTypes]
    let backSupport: [ObjectTypes]
    let sideSupport: [ObjectTypes]
    
    let fourWheels: [ObjectTypes]
    let threeWheels: [ObjectTypes]
    let midWheels: [ObjectTypes]
    let allCaster: [ObjectTypes]
    let frontPrimaryOrigin: [ObjectTypes]
    let midPrimaryOrigin: [ObjectTypes]
    let rearPrimaryOrigin: [ObjectTypes]
    let frontCaster: [ObjectTypes]
    let rearCaster: [ObjectTypes]
    let allDriveOrigin: [ObjectTypes]
    
    init() {
        fourWheels =
            [
            .fixedWheelRearDrive,
            .fixedWheelRearDrive,
            .scooterRearDrive4Wheeler,
            .scooterFrontDrive4Wheeler] +
            allFourCaster
        
        threeWheels =
            singleWheelAtRear +
            singleWheelAtFront
        
        midWheels =
            midCaster +
            midFixedWheel
        
        allCaster =
            allFourCaster +
            [.allCasterSixHoist]
        
        rearPrimaryOrigin =
            allCaster +
            rearFixedWheel
        midPrimaryOrigin =
            midFixedWheel
        frontPrimaryOrigin =
            frontFixedWheel
        
        allDriveOrigin =
            rearFixedWheel +
            midFixedWheel +
            frontFixedWheel
        
        frontCaster =
            allCaster +
            [.fixedWheelMidDrive, .fixedWheelRearDrive]
        
        rearCaster =
            allCaster +
            [.fixedWheelMidDrive, .fixedWheelFrontDrive]
        
        footSupport =
            twinSitOnAbility + [.allCasterChair,
                                .allCasterStandAid,
                                .allCasterTiltInSpaceShowerChair,
                                .showerTray]
        
        backSupport =
            twinSitOnAbility + [.allCasterChair,
                                .allCasterStandAid,
                                .allCasterTiltInSpaceShowerChair]
        
        sideSupport =
            twinSitOnAbility + [.allCasterChair,
                                .allCasterStandAid,
                                .allCasterTiltInSpaceShowerChair]
    }
}

struct ObjectPartChains {

    var partChains: [PartChain] = []

    init(_ object: ObjectTypes) {
        partChains = getPartChains(object)

        func getPartChains (_ object: ObjectTypes)
        -> [PartChain] {
            let typicalWheeledChair =
            LabelInPartChainOut ([
                .backSupport,
                .backSupportHeadSupport,
                .footSupport,
                .sideSupport,
                .sitOnTiltJoint
            ]).partChains

            switch object {
            case .allCasterTiltInSpaceShowerChair:
                return
                    typicalWheeledChair
            case .allCasterBed:
                return
                    [[.sideSupport]]
            case .allCasterStretcher:
                return
                    [[.sideSupport]]
            case .showerTray:
                return
                    [[.footSupport]]
            default:
                return
                    typicalWheeledChair
            }
        }
    }
}

//partChainLabel: ids for each part in partChain for that label
struct PartChainsIdDictionary {
    var dic: [PartChain : [[Part]] ] = [:]
    let sitOnId : Part
    let bilateral: [Part] = [.id0, .id1]
    init (_ partChains: [PartChain], _ sitOnId: Part ) {
        self.sitOnId = sitOnId
        
        getId(partChains)
        
        //the number of id always match the partChain
        func getId (_ partChains: [PartChain]) {
            for chain in partChains {
                var ids: [[Part]] = []
                for part in chain {
                    ids.append(getId(part))
                }
                dic += [chain: ids]
            }
            
            func getId(_ part: Part) -> [Part] {
                var ids: [Part] = []
                switch part {
                case .sitOn:
                        ids = [sitOnId]
                    case .backSupporRotationJoint:
                        ids = [.id0]
                    case .backSupport:
                        ids = [.id0]
                    case .backSupportHeadLinkRotationJoint:
                        ids = [.id0]
                    case .backSupportHeadSupportLink:
                        ids = [.id0]
                    case .backSupportHeadSupport:
                        ids = [.id0]
                    default:
                        ids = bilateral
                }
                return ids
            }
        }
    }
}

//struct SupportObjectGroups {
//
//    let forSitOn: [BaseObjectTypes] =
//        [
//            .allCasterChair,
//            .allCasterStandAid,
//            .allCasterTiltInSpaceShowerChair,
//        ] + BaseObjectGroups().twinSitOnAbility
//
//    let forFoot: [BaseObjectTypes]
//
//    let forBack: [BaseObjectTypes]
//
//    let canTilt:[BaseObjectTypes] = [ .allCasterTiltInSpaceShowerChair]
//
//    init() {
//        forFoot = forSitOn
//        forBack = forSitOn
//    }
//
//}



//struct BaseObjectOptionProvider {
//    //let baseObject: BaseObjectTypes
//    var baseObjectOption: BaseOptionDictionary = [:]
//
//    init ( _ baseObject: BaseObjectTypes) {
//        baseObjectOption = getBaseOptionOptions(baseObject)
//
//
//
//    func getBaseOptionOptions (_ baseObject: BaseObjectTypes) -> BaseOptionDictionary{
//        switch baseObject {
//
//            case .allCasterBed:
//                baseObjectOption =
//                    [.sideSupport: true,
//                     .sideSupportRotationJoint: true]
//            case .allCasterTiltInSpaceShowerChair:
//                baseObjectOption =
//                    [.backSupportHeadSupport: true,
//                     ]
//            default:
//                baseObjectOption = [:]
//        }
//        return baseObjectOption
//    }
//    }
//
//}

///
///I need to have a system which
///allows the UI to include/exlude partChains
