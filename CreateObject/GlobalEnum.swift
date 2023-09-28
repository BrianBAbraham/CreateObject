//
//  GlobalEnum.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation


enum DictionaryTypes  {
    case forScreen
    case forMeasurement
}

//enum Sides {
//    case left
//    case notLeft
//}
enum Part: String {
    case armSupport = "arm"
    case armVerticalJoint = "armVerticalJoint"
    
    case backSupport = "backSupport"
    case backSupportAdditionalPart = "backSupportAdditionalPart"
    case backSupportAssistantHandle = "backSupportRearHandle"
    case backSupportAssistantHandleInOnePiece = "backSupportRearHandleInOnePiece"
    case backSupportAssistantJoystick = "backSupportJoyStick"
    case backSupporRotationJoint = "backSupportRotationJoint"
    case backSupportHeadSupport = "backSupportHeadSupport"
    case backSupportHeadSupportJoint = "backSupportHeadSupportHorizontalJoint"
    case backSupportHeadSupportLink = "backSupportHeadSupportLink"
    case backSupportHeadLinkRotationJoint = "backSupportHeadSupportLinkHorizontalJoint"
    case backSupportReclineAngle = "backSupportReclineAngle"
    //case corner = "corner"
    
    case baseToCarryBarConnector = "baseToCarryBarConnector"
    case baseWheelJoint = "baseWheelJoint"

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
    case casterWheel = "casterWheel"
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
    case id2 = "_id2"
    case id3 = "_id3"
    case id4 = "_id4"
    case id5 = "_id5"
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
case notFound = "notAnyPart"
    case sitOn = "sitOn"
    case sleepOnSupport = "sleepOn"
    case standOnSupport = "standOn"
    
    case sideSupport = "sideSupport"
    case sideSupportRotationJoint = "sideSupportRotatationJoint"
    case stringLink = "_"
    case bodySupportAngle = "tiltAngle"
    case sitOnBackFootTiltJoint = "tiltInSpaceHorizontalJoint" 
    case topToBottomDimension = "yIos"
    case width = "Width"
}







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

///Tilt acts on one or more part
///The parts affected by the tilt are placed in an array
struct TiltGroupsFor {
    
    var foot: [String] {
        [Part.footSupport.rawValue, Part.footSupportJoint.rawValue]
    }
    let sitOnAngle: [Part] =
        [
        .sitOn,
        .joyStickForOccupant,
        .lieOnSupport,
        .sleepOnSupport,
       
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
        //.backSupportAssistantHandle,
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
        .footSupportHangerJoint,
        .footSupportHangerLink,
        .footSupportJoint,
        .backSupportAssistantHandle,
        ]
    var backAndHead: [Part]
        {backAngle + headAngle}
    var sitOnAndBackAngle: [Part]
        {sitOnAngle + backAndHead}
    var allAngle: [Part]
        {sitOnAndBackAngle + footAngle}
    var sitOnWithFootAndBackTiltForTwoSides: [Part] {
        leftAndRight
    }
    var sitOnWithFootAndBackTiltForUnilateral: [Part] {
        sitOnAngle + backAngle + headAngle
    }
    
    
}


///objects are comprised of  groups of associated parts
///each property povides an array of parts relevant to the group
///in order beginning with the part nearest to object origin
struct PartChainGroup {
    static let sideSupport: [Part] =
            [
            .sitOn,
            .sideSupportRotationJoint,
            .sideSupport]
    static let sitOn: [Part] =
        [.sitOn]
//    static let tiltInSpaceFromObject: [Part] =
//            [.bodySupportRotationJoint]
    static let sitOnBackFootTiltJointFromSitOn: [Part] =
            [.sitOn,
            .sitOnBackFootTiltJoint]
    static let backSupport: [Part] =
            [
            .sitOn,
            .backSupporRotationJoint,
            .backSupport]
    static let backWithHeadSupport: [Part] =
        backSupport +
            [
            .backSupportHeadLinkRotationJoint,
            .backSupportHeadSupportLink,
            .backSupportHeadSupport]
    static let casterWheelNodes: [Part] =
            [
            .baseWheelJoint,
            .casterFork,
            .casterWheel]
    
    
    static let fixedWheelNodes: [Part] =
            [
            .baseWheelJoint,
            .fixedWheel]
    static let fixedWheelWithPropllerNodes =
        fixedWheelNodes + [.fixedWheelPropeller]
    
    
    static let twoCasterParts: [Part] =
        Array( repeating: casterWheelNodes, count:  2 ).flatMap {$0}
    static let fourCasterParts: [Part] =
        Array( repeating: casterWheelNodes, count:  4 ).flatMap {$0}
    static let sixCasterParts: [Part] =
        Array( repeating: casterWheelNodes, count:  6 ).flatMap {$0}
    static let twoFixedWheelParts =
        Array( repeating: fixedWheelNodes, count:  2 ).flatMap {$0}
    static let twoFixedWheelAndPropellerParts =
        Array( repeating: fixedWheelWithPropllerNodes, count:  2 ).flatMap {$0}
    static let twoFixedWheelsTwoCasterParts: [Part] =
        twoFixedWheelParts + twoCasterParts
    static let twoCasterTwoWheelParts: [Part] =
    twoCasterParts + twoFixedWheelParts
    static let twoCasterTwoWheelPropllerParts: [Part] =
        twoFixedWheelAndPropellerParts + twoCasterParts
    static let fourCasterTwoWheelParts: [Part] =
        fourCasterParts + twoCasterParts
    static let twoCasterTwoFixedWheelTwoCasterParts: [Part] =
        twoCasterTwoWheelParts + twoCasterParts
}


///an objects's inclusion of a part group is indicated by memmbership
///of the object 



enum ViewFrom {
    case side
    case top
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


enum DictionaryVersion {
    case useCurrent
    case useInitial
    case useLoaded
    case useDimension
}
