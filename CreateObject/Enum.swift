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
    case backSupportJoint = "backSupportHorizontalJoint"
    case baseToCarryBarConnector = "baseToCarryBarConnector"

    case overHeadSupport = "overHeadSupport"
    case overHeadHookSupport = "overHeadHookSupport"
    case overHeadSupportJoint = "overHeadSupportVerticalJoint"
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
    
    //case centreToFront = "centreToFront"
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
    case footSupportHorizontalJoint = "footSupportHorizontalJoint"
    //case footSupportHanger = "footSupportHanger"
    case footSupportHangerLink = "footSupportHangerLink"
    case footSupportHangerSitOnVerticalJoint = "footSupportHangerSitOnVerticalJoint"
    case footSupportHangerBaseJoint = "footSupportHangerBaseJoint"

    case handleAtRear = "rearHandle"
    case handleAtRearInOnePiece = "rearHandleInOnePiece"
    
    
    
    case headSupport = "headSupport"
    case headSupportJoint = "headSupportHorizontalJoint"
    case headSupportLink = "headSupportLink"
    case headSupportLinkJoint = "headSupportLinkHorizontalJoint"
    
    case height = "Height"
    case joint = "Joint"
    
    case joyStickForOccupant = "occupantControlledJoystick"
    case joyStickForAssistant = "assistantControlledJoystick"
    
    case leftToRightDimension = "xIos"
    case length = "Length"
    case lieOnSupport = "lieOn"
    case objectOrigin = "objectOrigin"
    case viewOrigin = "viewOrigin"

    case sitOn = "sitOn"
    case sleepOnSupport = "sleepOn"
    case standOnSupport = "standOn"
    case stringLink = "_"
    case tiltJoint = "tiltInSpaceHorizontalJoint" 
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


struct PartCollections {
    
    static let head: [Part] =
        [.headSupport, .armVerticalJoint, .headSupportLink, .headSupportLinkJoint]
    static  let reclinable: [Part] =
        [.backSupport, .backSupportJoint, .joyStickForAssistant, .carriedObjectAtRear] + head
    static let foot: [Part] =
        [.footSupport,
        .footSupportHangerLink,
            .footSupportHorizontalJoint,
            .footSupportInOnePiece,
            .footSupportHangerBaseJoint,
            .footSupportHangerSitOnVerticalJoint]
    
  static  let tiltable: [Part] =
    [.armSupport, .sitOn, .backSupportJoint, .joyStickForOccupant]  + reclinable + foot
}



enum ObjectOptions: String, CaseIterable  {
    case assistant = "assistant"
    case bumper = "bumper"
    case door = "door"

    case headSupport = "head support"

    case occupant = "occupant"
    case reclinedBackSupport = "reclining back support"
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
        [Part.footSupport.rawValue, Part.footSupportHorizontalJoint.rawValue]
    }
    
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
