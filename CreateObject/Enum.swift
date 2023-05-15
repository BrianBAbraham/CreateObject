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
    case arm = "arm"
    case armVerticalJoint = "armVerticalJoint"
    case backSupport = "backSupport"
    case backSupportHorizontalJoint = "backSupportHorizontalJoint"
    case baseToCarryBarConnector = "baseToCarryBarConnector"

    case overHeadSupport = "overHeadSupport"
    case overHeadHookSupport = "overHeadHookSupport"
    case overHeadSupportVerticalJoint = "overHeadSupportVerticalJoint"
    case casterFork = "casterFork"
    case casterFrontToRearLink = "casterFrontToRearLink"
    case casterVerticalJointAtCenter = "casterVerticalJointAtCenter"
    case casterVerticalJointAtFront = "casterVerticalJointAtFront"
    case casterVerticalJointAtRear = "casterVerticalJointAtRear"
    case casterWheelAtCenter = "casterWheelAtCenter"
    case casterWheelAtFront = "casterWheelAtFront"
    case casterWheelAtRear = "casterWheelAtRear"
    case ceiling = "ceiling"

    case corner = "corner"
    case id = "_id"
    case id0 = "_id0"
    case id1 = "_id1"
    case fixedWheel = "fixedWheel"
    case fixedWheelPropeller = "fixedWheelPropeller"
    
    case footSupport = "footSupport"
    case footSupportInOnePiece = "footSupportInOnePiece"
    case footSupportHorizontalJoint = "footSupportHorizontalJoint"
    case footSupportHanger = "footSupportHanger"
    case footSupportHangerLink = "footSupportHangerLink"
    case footSupportHangerSitOnVerticalJoint = "footSupportHangerSitOnVerticalJoint"
    case footSupportHangerBaseJoint = "footSupportHangerBaseJoint"

    case headSupport = "headSupport"
    case joint = "Joint"
    
    case leftToRightDimension = "xIos"

    case objectOrigin = "objectOrigin"
    case viewOrigin = "viewOrigin"

    case sitOn = "sitOn"
    case stringLink = "_"
    case topToBottomDimension = "yIos"

}

enum ObjectOptions: String, CaseIterable  {
    case assistant = "assistant"
    case bumper = "bumper"
    case door = "door"
//    case doubleSitOnFrontAndRear = "rear-front"
//    case doubleSitOnFront = "front seat"
//    case doubleSitOnRear = "rear seat"
//    case doubleSitOnLeftAndRight = "side-by-side"
//    case doubleSitOnLeft = "left seat"
//    case doubleSitOnRight = "right seat"
    case headSupport = "head support"
    case occupant = "occupant"
    case recliningBackSupport = "reclining back support"
    case selfPropellers = "self propllers"
    case singleFootSupport = "single foot support"
    case sixCaster = "six caster"
    
}

enum Toggles {
    case doubleSitOn
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
