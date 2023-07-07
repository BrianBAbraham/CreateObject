//
//  Enum.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation


enum DictionaryTypes  {
    case forScreen
    case forMeasurement
}


enum Part: String {
    case armSupport = "arm"
    case armVerticalJoint = "armVerticalJoint"
    
    case backSupport = "backSupport"
    case backSupportAdditionalPart = "backSupportAdditionalPart"
    case backSupportAssistantHandle = "backSupportRearHandle"
    case backSupportAssistantHandleInOnePiece = "backSupportRearHandleInOnePiece"
    case backSupportAssistantJoystick = "backSupportJoyStick"
    case backSupporRotationJoint = "backSupportAngleJoint"
    case backSupportHeadSupport = "backSupportHeadSupport"
    case backSupportHeadSupportJoint = "backSupportHeadSupportHorizontalJoint"
    case backSupportHeadSupportLink = "backSupportHeadSupportLink"
    case backSupportHeadLinkRotationJoint = "backSupportHeadSupportLinkHorizontalJoint"
    case backSupportReclineAngle = "backSupportReclineAngle"
    
    
    case baseToCarryBarConnector = "baseToCarryBarConnector"

    case overheadSupportMastBase = "overHeadSupporMastBase"
    case overheadSupportMast = "overHeadSupporMast"
    case overheadSupportAssistantHandle = "overHeadSupporHandle"
    case overheadSupportAssistantHandleInOnePiece = "overHeadSupporHandleInOnePiece"
    case overheadSupportLink = "overHeadSupportLink"
    case overheadSupport = "overHeadSupport"
    case overheadSupportHook = "overHeadHookSupport"
    case overheadSupportJoint = "overHeadSupportVerticalJoint"
    
    
    case carriedObjectAtRear = "objectCarriedAtRear"
    case casterFork = "casterFork"
    case casterForkAtCenter = "casterForkAtCenter"
    case casterForkAtFront = "casterForkAtFront"
    case casterForkAtRear = "casterForkAtRear"
    case casterFrontToRearLink = "casterFrontToRearLink"
    case casterVerticalJointAtCenter = "casterVerticalJointAtCenter"
    case casterVerticalJointAtFront = "casterVerticalJointAtFront"
    case casterVerticalJointAtRear = "casterVerticalJointAtRear"
    case casterWheelAtCenter = "casterWheelAtCenter"
    case casterWheelAtFront = "casterWheelAtFront"
    case casterWheelAtRear = "casterWheelAtRear"
    case ceiling = "ceiling"
    
    case centreToFront = "centreToFront"
    case centreHalfWidth = "halfWidthAtCentre"
    case rearToCentre = "rearToCentre"
    case rearToFront = "rearToFront"
    case frameTube = "frameTube"


    case corner = "corner"
    case id = "_id"
    case id0 = "_id0"
    case id1 = "_id1"
    case fixedWheel = "fixedWheel"
    case fixedWheelPropeller = "fixedWheelPropeller"
    
    case footSupport = "footSupport"
    
    case footSupportInOnePiece = "footSupportInOnePiece"
    case footSupportJoint = "footSupportHorizontalJoint"
    //case footSupportHanger = "footSupportHanger"
    case footSupportHangerLink = "footSupportHangerLink"
    case footSupportHangerJoint = "footSupportHangerSitOnVerticalJoint"
    //case footSupportHangerBaseJoint = "footSupportHangerBaseJoint"
    
    case height = "Height"
    case joint = "Joint"
    
    case joyStickForOccupant = "occupantControlledJoystick"
    //case joyStickForAssistant = "assistantControlledJoystick"
    
    case leftToRightDimension = "xIos"
    case legSupportAngle = "legSupportAngle"
    case length = "Length"
    case lieOnSupport = "lieOn"
    case object = "object"
    case objectOrigin = "objectOrigin"
    case viewOrigin = "viewOrigin"

    case sitOn = "sitOn"
    case sleepOnSupport = "sleepOn"
    case standOnSupport = "standOn"
    
    case sideSupport = "sideSupport"
    case sideSupportRotationJoint = "sideSupportRotatationJoint"
    case stringLink = "_"
    case bodySupportAngle = "tiltAngle"
    case bodySupportRotationJoint = "tiltInSpaceHorizontalJoint" 
    case topToBottomDimension = "yIos"
    case width = "Width"
}

enum MeasurementParts: String {
    case base = "Base"
    case body = "BodySupport"
    case foot = "FootSupport"
}

//enum MeausurementDirections {
//    case height
//    case length
//    case width =
//}


//struct PartCollections {
//    
//    static let head: [Part] =
//        [.backSupportHeadSupport, .armVerticalJoint, .backSupportHheadSupportLink, .backSupportHeadSupportLinkJoint]
//    static  let reclinable: [Part] =
//        [.backSupport, .backSupportJoint, .baskSupportAssistantJoystick, .backSupportAdditionalObject] + head
//    static let foot: [Part] =
//        [.footSupport,
//        .footSupportHangerLink,
//            .footSupportHorizontalJoint,
//            .footSupportInOnePiece,
//            //.footSupportHangerBaseJoint,
//            .footSupportHangerSitOnVerticalJoint]
//    
//  static  let tiltable: [Part] =
//    [.armSupport, .sitOn, .backSupportJoint, .joyStickForOccupant]  + reclinable + foot
//}



enum ObjectOptions: String, CaseIterable  {
    
    case angleBackSupport = "reclining back support"
    case angleFootSupport = "angle leg support"
    case assistant = "assistant"
    
    case backSupportAssistantHandles = "back support assistant handles"
    case backSupportAdditionalObject = "bacl support additional object"
    case backSupportAssistantHandlesInOnPiece = "back support assistant handle in one piece"
    case backSupportAssistantJoystick = "back support assistant joystick"
    case bumper = "bumper"
    case door = "door"
    case footSupportInOnePiece = "foot support in one piece"
    case headSupport = "head support"

    case occupant = "occupant"

    case tiltInSpace = "tilt in space"
    case tiltAndRecline = "tilt in space and reclining back support"
    case selfPropellers = "self propllers"
    case singleFootSupport = "single foot support"
    case sixCaster = "six caster"
    
}

enum Toggles {
    case twinSitOn
    case sitOnPosition
}

struct PartGroupsFor {
    
    var foot: [String] {
        [Part.footSupport.rawValue, Part.footSupportJoint.rawValue]
    }
    let sitOnAngle: [Part] =
        [
        .sitOn,
        .sideSupport,
        .sideSupportRotationJoint,
        .joyStickForOccupant,
        .lieOnSupport,
        .sleepOnSupport,
        .backSupporRotationJoint,
        .footSupportHangerJoint
        ]
    
    let footAngle: [Part] =
        [
        .footSupport,
        .footSupportHangerLink,
        .footSupportJoint,
        .footSupportInOnePiece
        ]
    let backAngle: [Part] =
        [
        .backSupport,
        .backSupportAssistantJoystick,
        .backSupportAdditionalPart,
        .backSupportAssistantHandle,
        .backSupportHeadSupportJoint
        ]
    let headAngle: [Part] =
        [
        .backSupportHeadSupport,
        .backSupportHeadSupportLink,
        .backSupportHeadLinkRotationJoint
        ]
    let leftAndRight: [Part] =
        [
        .sideSupport,
        .sideSupportRotationJoint,
        .footSupport,
        .footSupportHangerLink,
        .footSupportJoint,
        ]
    var backAndHead: [Part]
        {backAngle + headAngle}
    var sitOnAndBackAngle: [Part]
        {sitOnAngle + backAndHead}
    var allAngle: [Part]
        {sitOnAndBackAngle + footAngle}
    
}







//InterOrigin().names
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
