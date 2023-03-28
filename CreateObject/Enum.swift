//
//  Enum.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation





enum Part: String {
    case arm = "arm"
    case armJoint = "armJoint"
    case backrest = "backrest"

    case baseToCarryBarConnector = "baseToCarryBarConnector"

    case carryBar = "carryBar"
    case casterFork = "casterFork"
    case casterSpindleJointAtCenter = "casterSpindleJointAtCenter"
    case casterSpindleJointAtFront = "casterSpindleJointAtFront"
    case casterSpindleJointAtRear = "casterSpindleJointAtRear"
    case casterWheelAtCenter = "casterWheelAtCenter"
    case casterWheelAtFront = "casterWheelAtFront"
    case casterWheelAtRear = "casterWheelAtRear"
    case ceiling = "ceiling"
//    case centreLine = "centreLine"
    case corner = "corner"
    case id = "_id"

    case fixedWheel = "fixedWheel"
    case fixedWheelPropeller = "fixedWheelPropeller"
    
    case footSupport = "footSupport"
    case footSupportJoint = "footSupportJoint"
    case footSupportHanger = "footSupportHanger"
    case footSupportHangerSeatJoint = "footSupportHangerSeatJoint"
    case footSupportHangerBaseJoint = "footSupportHangerBaseJoint"
    //case footSupportJoint = "footSupportHangerSupportJoint"

    case joint = "Joint"
    
    case leftToRightDimension = "xIos"

    case primaryOrigin = "primaryOrigin"

    case sitOn = "sitOn"
    case stringLink = "_"
    case topToBottomDimension = "yIos"

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
