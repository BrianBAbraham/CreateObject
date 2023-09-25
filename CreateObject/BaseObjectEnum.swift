//
//  BaseTypes.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation

enum BaseObjectTypes: String, CaseIterable {
    
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

enum GroupsDerivedFromRawValueOfBaseObjectTypes: String {
    case caster = "caster"
    case bath = "Bath"
    case fixedWheel = "wheel"
    case door = "Door"
    case power = "Power"
    case selfPropelling = "Self-propelling"
    case scooter = "Scooter"
    case stairLift = "stairLift"
    case verticalLift = "VerticaLift"

}


enum GroupsDerivedFromRawValueOfPartTypes: String {
case sitOn = "hair"
}

///object creation includes features if the object is containted
///in the feature group
struct BaseObjectGroups {
    let allFourCaster: [BaseObjectTypes] =
        [.allCasterBed,
         .allCasterChair,
         .allCasterHoist,
         .allCasterStandAid,
         .allCasterStretcher,
         .allCasterTiltInSpaceShowerChair]
    
    var rearFixedWheel: [BaseObjectTypes] =
        [
         .fixedWheelManualRearDrive,
         .fixedWheelRearDrive,
         .scooterRearDrive3Wheeler,
         .scooterRearDrive4Wheeler]
   
    let oneRearWheel: [BaseObjectTypes] =
        [
        .scooterFrontDrive3Wheeler]
    
    let midCaster: [BaseObjectTypes]
        = [.allCasterSixHoist]
    
    let midFixedWheel: [BaseObjectTypes] =
        [.fixedWheelMidDrive]
    
    let frontFixedWheel: [BaseObjectTypes] =
        [.fixedWheelFrontDrive,
        .scooterFrontDrive3Wheeler,
        .scooterFrontDrive4Wheeler]
    
    let twinSitOnAbility: [BaseObjectTypes] =
        [ .fixedWheelManualRearDrive,
          .fixedWheelRearDrive,
          .fixedWheelMidDrive,
          .fixedWheelFrontDrive,
          .scooterRearDrive3Wheeler,
          .scooterRearDrive4Wheeler,
          .scooterFrontDrive3Wheeler,
          .scooterFrontDrive4Wheeler]
    
    let singleWheelAtRear: [BaseObjectTypes] =
        [ .scooterRearDrive3Wheeler]
    
    let singleWheelAtFront: [BaseObjectTypes] =
        [ .scooterRearDrive3Wheeler]
    
    let sixWheels: [BaseObjectTypes] =
        [
        .allCasterSixHoist,
        .fixedWheelMidDrive]
    
    let noWheel: [BaseObjectTypes] = [.showerTray]
    let noBodySupport: [BaseObjectTypes] = [.showerTray]
    
    let footSupport: [BaseObjectTypes]
    let backSupport: [BaseObjectTypes]
    
    let fourWheels: [BaseObjectTypes]
    let threeWheels: [BaseObjectTypes]
    let midWheels: [BaseObjectTypes]
    let allCaster: [BaseObjectTypes]
    let frontPrimaryOrigin: [BaseObjectTypes]
    let midPrimaryOrigin: [BaseObjectTypes]
    let rearPrimaryOrigin: [BaseObjectTypes]
    let frontCaster: [BaseObjectTypes]
    let rearCaster: [BaseObjectTypes]
    let allDriveOrigin: [BaseObjectTypes]
    
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
                                .allCasterTiltInSpaceShowerChair]
        
        backSupport =
            twinSitOnAbility + [.allCasterChair,
                                .allCasterStandAid,
                                .allCasterTiltInSpaceShowerChair]
    }
}



struct SupportObjectGroups {
    
    let forSitOn: [BaseObjectTypes] =
        [
            .allCasterChair,
            .allCasterStandAid,
            .allCasterTiltInSpaceShowerChair,
        ] + BaseObjectGroups().twinSitOnAbility
    
    let forFoot: [BaseObjectTypes]
    
    let forBack: [BaseObjectTypes]
    
    let canTilt:[BaseObjectTypes] = [ .allCasterTiltInSpaceShowerChair]
    
    init() {
        forFoot = forSitOn
        forBack = forSitOn
    }
}
///
///allCaster
///
///
