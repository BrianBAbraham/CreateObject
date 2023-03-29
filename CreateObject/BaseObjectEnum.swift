//
//  BaseTypes.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation

enum BaseObjectTypes: String, CaseIterable {
    
    case allCasterBed = "FourCasterBed"
    case allCasterChair = "FourCasterChair"
    case allCasterHoist = "AllCasterHoist"
    //case allCaster6Hoist  = "SixCasterHoist"
    case allCasterStandAid = "FourCasterStandAid"
    case allCasterStretcher = "FourCasterStretcher"
    
//    case bathIntegralHoist = "IntegralBathHoist"
//    case bathFloorFixedHoistOneRotationPoint = "SingleRotationPointBathHoist"
//    case bathFloorFixedHoistTwoRotationPoint = "DoubleRotationPointBathHoist"
    
    case fixedWheelFrontDrive = "FrontDriveWheelchair"
    case fixedWheelMidDrive  = "MidDriveWheelchair"
    case fixedWheelRearDrive = "RearDriveWheelchair"
    case fixedWheelSolo = "BalancingDriveWheelchair"
    case fixedWheelTransfer = "TransferFixedWheelDriveDevice"
    
//    case hingedDoorSingle = "Door"
//    case hingedDoorDouble = "Bi-FoldDoor"
//    case hingedDoortripple = "Tri-FoldDoor"
//    
//    case scooterFrontDrive4Wheeler = "FrontDriveFourWheelScooter"
//    case scooterFrontDrive3Wheeler =  "FrontDriveThreeWheelScooter"
//    case scooterRearDrive4Wheeler  = "RearDriveFourWheelScooter"
//    case scooterRearDrive3Wheeler = "RearDriveThreeWheelScooter"
}

enum BaseObjectGroups: String {
    case caster = "Caster"
    case bath = "Bath"
    case fixedWheel = "Wheel"
    case door = "Door"
    case scooter = "Scooter"
    case stairLift = "StairLift"
    case verticalLift = "VerticaLift"
}




