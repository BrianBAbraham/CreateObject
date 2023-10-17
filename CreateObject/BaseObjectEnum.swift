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
//    let sitOnBackFootTiltJoint: [ObjectTypes] = [.allCasterTiltInSpaceShowerChair]
//
//    let footSupport: [ObjectTypes]
    let backSupport: [ObjectTypes]
//    let sideSupport: [ObjectTypes]
    
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
        
//        footSupport =
//            twinSitOnAbility + [.allCasterChair,
//                                .allCasterStandAid,
//                                .allCasterTiltInSpaceShowerChair,
//                                .showerTray]
//
        backSupport =
            twinSitOnAbility + [.allCasterChair,
                                .allCasterStandAid,
                                .allCasterTiltInSpaceShowerChair]
//
//        sideSupport =
//            twinSitOnAbility + [.allCasterChair,
//                                .allCasterStandAid,
//                                .allCasterTiltInSpaceShowerChair]
    }
}

/// provides the object names for the picker
/// provides the chainPartLabels for each object
struct ObjectsAndTheirChainLabels {
    static let typicalWheeledChairSupport: [Part] =
    [
        //.backSupport,
        .backSupportHeadSupport,
        .footSupport,
        .sideSupport,

        .sitOnTiltJoint,
            .sitOn,]
    
    let dictionary: ObjectPartChainLabelsDictionary =
    [ .allCasterBed: [ .sideSupport, .sitOn],
      .allCasterChair: typicalWheeledChairSupport,
      .allCasterTiltInSpaceShowerChair: typicalWheeledChairSupport,
      .allCasterStretcher: [.sideSupport, .sitOn, ],
      .fixedWheelFrontDrive: typicalWheeledChairSupport,
      .fixedWheelMidDrive: typicalWheeledChairSupport ,
      .fixedWheelRearDrive: typicalWheeledChairSupport,
      .showerTray: [.footOnly]]
}

//struct ObjectPartChains {
//
//    var partChains: [PartChain] = []
//
//    init(_ object: ObjectTypes) {
//        partChains = getPartChains(object)
//
//        func getPartChains (_ object: ObjectTypes)
//        -> [PartChain] {
//            let typicalWheeledChair =
//            LabelInPartChainOut ([
//                .backSupport,
//                .backSupportHeadSupport,
//                .footSupport,
//                .sideSupport,
//                .sitOnTiltJoint
//            ]).partChains
//
//            switch object {
//            case .allCasterTiltInSpaceShowerChair:
//                return
//                    typicalWheeledChair
//            case .allCasterBed:
//                return
//                    [[.sideSupport]]
//            case .allCasterStretcher:
//                return
//                    [[.sideSupport]]
//            case .showerTray:
//                return
//                    [[.footSupport]]
//            default:
//                return
//                    typicalWheeledChair
//            }
//        }
//    }
//}




///
///I need to have a system which
///allows the UI to include/exlude partChains
