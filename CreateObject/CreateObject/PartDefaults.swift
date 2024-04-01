//
//  PartDefaults.swift
//  CreateObject
//
//  Created by Brian Abraham on 07/02/2024.
//

import Foundation


enum Part: String, Parts, Hashable {
    typealias AssociatedType = String
    
    var stringValue: String {
        return self.rawValue
    }
    
    case assistantFootLever = "assistantFootLever"
    
    //case armSupport = "arm"
    case armVerticalJoint = "armVerticalJoint"
    
    case backSupport = "backSupport"
    case backSupportAdditionalPart = "backSupportAdditionalPart"
    case backSupportAssistantHandle = "backSupportRearHandle"
    case backSupportAssistantHandleInOnePiece = "backSupportRearHandleInOnePiece"
    case backSupportAssistantJoystick = "backSupportJoyStick"
    case backSupportTiltJoint = "backSupportRotationJoint"
    case backSupportHeadSupport = "headrest"
    case backSupportHeadSupportJoint = "backSupportHeadSupportHorizontalJoint"
    case backSupportHeadSupportLink = "backSupportHeadSupportLink"
    case backSupportHeadLinkRotationJoint = "backSupportHeadSupportLinkHorizontalJoint"
   
      
//    case baseToCarryBarConnector = "baseToCarryBarConnector"
//
//
//    case overheadSupportMastBase = "overHeadSupporMastBase"
//    case overheadSupportMast = "overHeadSupporMast"
//    case overheadSupportAssistantHandle = "overHeadSupporHandle"
//    case overheadSupportAssistantHandleInOnePiece = "overHeadSupporHandleInOnePiece"
//    case overheadSupportLink = "overHeadSupportLink"
//    case overheadSupport = "overHeadSupport"
//    case overheadSupportHook = "overHeadHookSupport"
//    case overheadSupportJoint = "overHeadSupportVerticalJoint"
//
//    case carriedObjectAtRear = "objectCarriedAtRear"

   
    case casterVerticalJointAtRear = "casterVerticalBaseJointAtRear"
    case casterVerticalJointAtMid = "casterVerticalBaseJointAtMid"
    case casterVerticalJointAtFront = "casterVerticalBaseJointAtFront"
    
    case fixedWheelHorizontalJointAtRear = "fixedWheelHorizontalBaseJointAtRear"
    case fixedWheelHorizontalJointAtMid = "fixedWheelHorizontalBaseJointAtMid"
    case fixedWheelHorizontalJointAtFront = "fixedWheelHorizontalBaseJointAtFront"
    
    case casterForkAtRear = "casterForkAtRear"
    case casterForkAtMid = "casterForkAtMid"
    case casterForkAtFront = "casterForkAtFront"
    
    case casterWheelAtRear = "casterWheelAtRear"
    case casterWheelAtMid = "casterWheelAtMid"
    case casterWheelAtFront = "casterWheelAtFront"

    //case fixedWheel = "fixedWheel"
    //case fixedWheelPropeller = "fixedWheelPropeller"
    
  
    case fixedWheelAtRear = "fixedWheelAtRear"
    case fixedWheelAtMid = "fixedWheelAtMid"
    case fixedWheelAtFront = "fixedWheelAtFront"
    case fixedWheelAtRearWithPropeller = "propeller"
    case fixedWheelAtMidWithPropeller = "fixedWheelAtMidithPropeller"
    case fixedWheelAtFrontWithPropeller = "fixedWheelAtFrontithPropeller"
    
    case footSupport = "footSupport"
    case footOnly = "footOnly"
    case footSupportInOnePiece = "footSupportInOnePiece"
    case footSupportJoint = "footSupportHorizontalJoint"
    case footSupportHangerLink = "footSupportHangerLink"
    case footSupportHangerJoint = "footSupportHangerSitOnVerticalJoint"
  
    case joint = "Joint"
    
    case joyStickForOccupant = "occupantControlledJoystick"

    case objectOrigin = "object"

    case notFound = "notAnyPart"
    
    
    case mainSupport = "sitOn"
    //case sleepOnSupport = "sleepOn"
    case standOnSupport = "standOn"
    
    case armSupport = "armSupport"
    case sideSupport = "sideSupport"
    case sideSupportRotationJoint = "sideSupportRotatationJoint"
    case sideSupportJoystick = "sideSupportJoystick"

    case stabilizerAtRear = "stabilityAtRear"
    case stabilizerAtMid = "stabilityAtMid"
    case stabilizerAtFront = "stabilityAtFront"
    
    case sitOnTiltJoint = "tilt-in-space"
    
    case steeredVerticalJointAtFront = "steeredVerticalBaseJointAtFront"
    case steeredVerticalJointAtRear = "steeredVerticalBaseJointAtRear"
    case steeredWheelAtFront = "steeredWheelAtFront"
    case steeredWheelAtRear = "steeredWheelAtRear"
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
    
    
    func transformPartToPartGroup() -> PartGroup {
        switch self {
        case
            .backSupportHeadSupportJoint,
            .backSupportHeadSupportLink:
                return .backJointAndLink
        case 
            .casterForkAtFront,
            .casterForkAtMid,
            .casterForkAtRear:
                return .casterFork
        case
            .casterVerticalJointAtFront,
            .casterVerticalJointAtMid,
            .casterVerticalJointAtRear:
                return .casterJoint
        case
            .casterWheelAtFront,
            .casterWheelAtMid,
            .casterWheelAtRear:
                return .caster
        case  
            .fixedWheelAtFront,
            .fixedWheelAtMid,
            .fixedWheelAtRear:
                return .fixedWheel
        case .fixedWheelHorizontalJointAtFront,.fixedWheelHorizontalJointAtMid,.fixedWheelHorizontalJointAtRear:
                return .fixedWheelJoint
            
        case
            .footSupportHangerJoint,
            .footSupportHangerLink,
            .footSupportJoint:
                return .footJointAndLink
//        case .fixedWheelAtFrontWithPropeller,
//            .fixedWheelAtMidWithPropeller,
//            .fixedWheelAtRearWithPropeller:
//            return .propeller
        case
            .steeredVerticalJointAtFront,
            .steeredVerticalJointAtRear:
                return .steeredJoint
        case
            .steeredWheelAtFront,
            .steeredWheelAtRear:
                return .steeredWheel
            
        case
            .sitOnTiltJoint,
            .backSupportTiltJoint:
                return .tilt
        default:
            return .none
        }
    }
}


/// Object creation requires greater part specification than
/// edit so to minimise name multiple Part of the same group
/// this enum provides the basis for a transform
enum PartGroup: String, Parts {
    case backJointAndLink
    case caster
    case casterFork
    case casterJoint
    case fixedWheel
    case fixedWheelJoint
    case footJointAndLink
    case propeller
    case steeredJoint
    case steeredWheel
    case tilt
    case none
    
    var stringValue: String {
          return String(describing: self)
      }
}




enum PartTag: String, Parts {
    case angle = "angle"
    case corner = "corner"
    case id0 = "_id0"
    case id1 = "_id1"
    case stringLink = "_"
    case width = "width"
    case length = "length"
    case height = "height"
    case dimension = "dimension"
    case origin = "origin"
    case xOrigin = "x-origin"
    case yOrigin = "y-origin"
    case zOrigin = "zOrigin"
    
    var stringValue: String {
        return self.rawValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}


///Alllow part removal or inclusion
///replaces chainLabels
struct PartSwapLabel {
    
    let part: Part
    static let dictionary: [Part: Part] = [
        .backSupportHeadSupport: .backSupport,
        .fixedWheelAtRearWithPropeller: .fixedWheelAtRear,
        .fixedWheelAtFrontWithPropeller: .fixedWheelAtFront,
    ]
        
    let swappedPair: [Part]
    let pair: [Part]
    
    init (_ part: Part) {
        self.part = part
        pair = Self.getPair(part)
        swappedPair =  [pair[1], pair[0]]
    }

    
  static func getPair(_ part: Part) -> [Part]{
        guard let key = PartSwapLabel.dictionary[part] else {
            fatalError()
        }
        
        return [part, key]
    }
}


struct PartDefaultAngle {
    
    let allAngleData:
        (min: RotationAngles, max: RotationAngles, initial: RotationAngles)
    let angle: RotationAngles
    var minMaxAngle: AngleMinMax = ZeroValue.angleMinMax
  
    
    init(_ part: Part, _ objectType: ObjectTypes) {
        allAngleData = getAllAngleData(part, objectType)
        
        
        self.angle = allAngleData.initial
        minMaxAngle = getMinMaxAngle()
    
        func getAllAngleData(_ part: Part, _ objectType: ObjectTypes)
        -> (min: RotationAngles, max: RotationAngles, initial: RotationAngles) {
            let partObject = PartObject(part, objectType)
            guard let allAngleData =
                    getFineTunedAngleDefault(partObject) ??
                    getGeneralAngleDefault(part) else {
                fatalError("no angle defined for part \(part)")
            }
            return allAngleData
        }
        
        func getFineTunedAngleDefault(_ partObject: PartObject) 
        -> (min: RotationAngles, max: RotationAngles, initial: RotationAngles)?{
            let dictionary: [PartObject: (min: RotationAngles, max: RotationAngles, initial: RotationAngles)] = [:]
            
            return dictionary[partObject]
        }
        
        
        func getGeneralAngleDefault(_ part: Part)
        -> (min: RotationAngles, max: RotationAngles, initial: RotationAngles)?{
            let z: Measurement<UnitAngle> = ZeroValue.angleDeg
            let zPlus = 1.0 * pow(10, -Double(10))//arbirtrarilly cose to zero
            let dictionary: [Part: (min: RotationAngles, max: RotationAngles, initial: RotationAngles)] = [
                .sitOnTiltJoint:
                    (min: (x: Measurement(value: zPlus, unit: UnitAngle.degrees), y: z , z: z),
                     max: (x: Measurement(value: 30.0, unit: UnitAngle.degrees), y: z , z: z),
                    initial: (x: Measurement(value: 0.0, unit: UnitAngle.degrees), y: z , z: z) ),
                .backSupportTiltJoint:
                    (min: (x: Measurement(value: zPlus, unit: UnitAngle.degrees), y: z , z: z),
                     max: (x: Measurement(value: 90.0, unit: UnitAngle.degrees), y: z , z: z),
                    initial: (x: Measurement(value: 0.0, unit: UnitAngle.degrees), y: z , z: z) )
            ]
            return dictionary[part]
        }
        
        
        func getMinMaxAngle() -> AngleMinMax {
            
            let min = extractNonZeroAngle(allAngleData.min)
            
            let max = extractNonZeroAngle(allAngleData.max)
            
            return (min: min, max: max)
            
            func extractNonZeroAngle(_ angle: RotationAngles) -> Measurement<UnitAngle> {
                guard let nonZeroAngle = [angle.x, angle.y, angle.z].first(where: { $0.value != 0 }) else {
                    fatalError("All angles are zero.")
                }
                return nonZeroAngle
            }
        }
    }
}


struct PartDefaultDimension {
    static let casterForkDimension = (width: 50.0, length: 100.0, height: 50.0)
    static let casterWheelDimension = (width: 20.0, length: 75.0, height: 75.0)
    static let fixedWheelDimension = (width: 20.0, length: 600.0, height: 600.0)
    static let poweredWheelDimension = (width: 50.0, length: 200.0, height: 200.0)
    static let steeredWheelDimension = (width: 50.0, length: 200.0, height: 200.0)
    static let joint = (width: 20.0, length: 20.0, height: 20.0)

    var linkedOrParentDimension = ZeroValue.dimension3d
    var userEditedDimensionOneOrTwoOptional: OneOrTwoOptional<Dimension3d>?
    var userEditedDimensionOneOrTwo: OneOrTwo<Dimension3d> = .one(one: ZeroValue.dimension3d)
    var partDimension = ZeroValue.dimension3d
    var partDimensionOneOrTwo: OneOrTwo<Dimension3d> = .one(one: ZeroValue.dimension3d)
    let part: Part
    let objectType: ObjectTypes
    var parentPart: Part
    
    
    init (_ part: Part,
          _ objectType: ObjectTypes,
          _ linkedOrParentData: PartData = ZeroValue.partData,
          _ userEditedDimensionOneOrTwoOptional: OneOrTwoOptional<Dimension3d>? = nil) {
        self.part = part
        self.objectType = objectType
        self.parentPart = linkedOrParentData.part
        self.userEditedDimensionOneOrTwoOptional = userEditedDimensionOneOrTwoOptional

        linkedOrParentDimension = linkedOrParentData.dimension.mapOneOrTwoToOneOrLeftValue()
        
        guard let unwrapped = getDefault(part) else {
            fatalError("no dimension exists for part \(part)")
        }
        
        partDimension = unwrapped
       
        if let unwrapped = userEditedDimensionOneOrTwoOptional {
            userEditedDimensionOneOrTwo = getDimensionFromOptional()
            
            func getDimensionFromOptional() -> OneOrTwo<Dimension3d>{
                switch unwrapped {
                case .one (let one):
                    let returnOne = one == nil ? partDimension: one!
                    return .one(one: returnOne)
                case .two(let left, let right):
                    let returnLeft = left == nil ? partDimension: left!
                    let returnRight = right == nil ? partDimension: right!
                    return .two(left: returnLeft, right: returnRight)
                }
            }
        }

        func getDefault(_ childOrParent: Part)  -> Dimension3d? {
            getFineTuneDimensionDefault(childOrParent) ??
            getGeneralDimensionDefault(childOrParent)
        }
                     
        
        func getFineTuneDimensionDefault(_ childOrParent: Part) -> Dimension3d? {
            [
                PartObject(.backSupport, .allCasterTiltInSpaceArmChair): (width: linkedOrParentDimension.width, length: 100.0, height: 500.0),
                PartObject(.casterForkAtFront, .fixedWheelMidDrive): (width: 20.0, length: 50.0, height: 50.0),
                PartObject(.casterWheelAtFront, .fixedWheelMidDrive): (width: 20.0, length: 50.0, height: 50.0),
                PartObject(.fixedWheelAtRear, .fixedWheelManualRearDrive): (width: 20.0, length: 600.0, height: 600.0),
                PartObject(.footOnly, .showerTray): (width: 900.0, length: 1200.0, height: 10.0),
                PartObject(.armSupport, .allCasterTiltInSpaceArmChair): (width: 100.0, length: linkedOrParentDimension.length, height: 150.0),
                PartObject(.mainSupport, .allCasterBed): (width: 900.0, length: 2000.0, height: 150.0),
                PartObject(.mainSupport, .allCasterStretcher): (width: 600.0, length: 1400.0, height: 10.0),
                PartObject(.mainSupport, .showerTray): (width: 900.0, length: 1200.0, height: 10.0),
                PartObject(.stabilizerAtMid, .fixedWheelMidDrive): (width: 50.0, length: 0.0, height: 0.0),
                PartObject(.stabilizerAtFront, .fixedWheelMidDrive): (width: -50.0, length: 20.0, height: 0.0),
                PartObject(.stabilizerAtFront, .scooterFrontDrive4Wheeler): (width: 0.0, length: Self.steeredWheelDimension.length, height: 0.0),
                PartObject(.stabilizerAtRear, .allCasterTiltInSpaceShowerChair): (width: 0.0, length: -100.0, height: 0.0),
                PartObject(.stabilizerAtRear, .fixedWheelRearDriveAssisted): (width: 50.0, length: -100.0, height: 0.0),
            ][PartObject(childOrParent, objectType)]
        }
    
    
        func  getGeneralDimensionDefault(_ childOrParent: Part) -> Dimension3d? {
            let z = ZeroValue.dimension3d
            let j = Self.joint
            return
                [
                .assistantFootLever: (width: 20.0, length: 300.0, height: 20.0),
                .armSupport: (width: 50.0, length: linkedOrParentDimension.length, height: 150.0),
                .backSupport: (width: linkedOrParentDimension.width, length: 10.0 , height: 500.0),
                .backSupportHeadSupport: (width: 150.0, length: 50.0, height: 100.0) ,
                .backSupportHeadSupportJoint: Self.joint,
                .backSupportHeadSupportLink: (width: 20.0, length: 20.0, height: 150.0),
                .backSupportTiltJoint: j,
                .casterForkAtFront: Self.casterForkDimension,
                .casterForkAtRear: Self.casterForkDimension,
                .casterWheelAtFront: Self.casterWheelDimension,
                .casterWheelAtMid: Self.casterWheelDimension,
                .casterWheelAtRear: Self.casterWheelDimension,
                .casterVerticalJointAtFront:j,
                .casterVerticalJointAtMid:j,
                .casterVerticalJointAtRear: j,
                .fixedWheelAtFront: Self.poweredWheelDimension,
                .fixedWheelAtMid: Self.poweredWheelDimension,
                .fixedWheelAtRear: Self.poweredWheelDimension,
                .fixedWheelHorizontalJointAtFront: j,
                .fixedWheelHorizontalJointAtMid: j,
                .fixedWheelHorizontalJointAtRear:j,
                .fixedWheelAtRearWithPropeller: (width: 10.0, length: linkedOrParentDimension.length * 0.9, height: linkedOrParentDimension.height * 0.9),
                .footSupport: (width: 150.0, length: 100.0, height: 20.0),
                .footSupportJoint: j,
                .footSupportInOnePiece: (width: 50.0, length: 200.0, height: 200.0),
                .footSupportHangerJoint: j,
                .footSupportHangerLink: (width:20.0, length: 300.0, height: 20.0),
                .objectOrigin: z,
                
                .mainSupport: (width: 400.0, length: 400.0, height: 10.0),
                .sideSupport: (width: 50.0, length: linkedOrParentDimension.length, height: 150.0),
                .sitOnTiltJoint: j,
                .stabilizerAtFront: z,
                .stabilizerAtMid: z,
                .stabilizerAtRear: z,
                .steeredWheelAtFront: Self.steeredWheelDimension,
                .steeredVerticalJointAtFront: j,
                ] [childOrParent]
        }
    }
}



struct PartEditedElseDefaultOrigin {
    let linkedOrParentDimension: OneOrTwo<Dimension3d>
    var linkedOrParentDimensionUsingOneValue: Dimension3d
    let part: Part
    let objectType: ObjectTypes
  
    let parentData: PartData
    var userEditedPartDimensionOneOrTwo: OneOrTwo<Dimension3d>
    var editedElseDefaultOriginOneOrTwo: OneOrTwo<PositionAsIosAxes> = .one(one: ZeroValue.iosLocation)
    var userEditedOptionalOriginOffset: OneOrTwoOptional<PositionAsIosAxes>

    
    init (_ part: Part,
          _ object: ObjectTypes,
          _ linkedOrParentData: PartData,
          _ userEditedDimensionOneOrTwo: OneOrTwo<Dimension3d>,
          _ partIdAllowingForUserEdit: OneOrTwo<PartTag>,
          _ userEditedOriginOffsetOneOrTwoOptional: OneOrTwoOptional<PositionAsIosAxes>
          ) {
        self.part = part
        self.objectType = object
        self.parentData = linkedOrParentData
        self.userEditedPartDimensionOneOrTwo = userEditedDimensionOneOrTwo
        self.userEditedOptionalOriginOffset =
            userEditedOriginOffsetOneOrTwoOptional//provide edited origin

        linkedOrParentDimension = linkedOrParentData.dimension
        linkedOrParentDimensionUsingOneValue = linkedOrParentDimension.mapOneOrTwoToOneOrLeftValue()
        
        editedElseDefaultOriginOneOrTwo = getOneOrTwoOriginWithOptionalOffset()
        
        //child origin is with respect to parent dimension
        func getOneOrTwoOriginWithOptionalOffset() -> OneOrTwo<PositionAsIosAxes>{

            let parentDimensionAsTouple = linkedOrParentDimension.mapToTouple()
            
            
            
            ///if you remove a propeller both parent remain
            ///so if you seek the parent depenant dimesnion for the remaining propeller
            ///you get an error as there are two
            
            switch userEditedPartDimensionOneOrTwo {
            case .one (let onePart):
                var oneParentValueIfOneChild: Dimension3d
                
                if let unwrapped = parentDimensionAsTouple.one {
                    //parent has one (unilateral) dimension
                    oneParentValueIfOneChild = unwrapped
                } else {
                    //parent has two (bilateral) dimension
                    if  partIdAllowingForUserEdit.mapToTouple().one != nil {
                        //but child has one dimension
                            oneParentValueIfOneChild = assignParentDimensionAccordingToId()
                    } else {
                        fatalError("child is one and parent is neither one or two")
                    }
                }
            
                guard var returnOneOrigin = getDefaultFromDimensions(onePart, oneParentValueIfOneChild) else {
                    fatalError("no default dimension for this part \(part)")
                }
                
                
                
                if doesOneHaveId0RequiringRightToLeftTransform() != nil {
                    returnOneOrigin = CreateIosPosition.getLeftFromRight(returnOneOrigin)
                }
                let editedElseDefaultOrigin: OneOrTwo<PositionAsIosAxes> =
                    getUserEditedElseDefaultPartOrigin(returnOneOrigin)
                
            return editedElseDefaultOrigin
                
                
                func assignParentDimensionAccordingToId() -> Dimension3d {
                    guard let childId = partIdAllowingForUserEdit.mapToTouple().one else {
                        fatalError("no child id")
                    }
                    let parentDimension: OneOrTwo<Dimension3d> =
                    linkedOrParentDimension.mapTwoToOneUsingOneId(childId)
                    
                    return parentDimension.returnValue(childId)
                }
                
                
                
            case .two(let leftPart, let rightPart):
                
                var returnLeftOrigin = getDefaultFromDimensions(leftPart, parentDimensionAsTouple.left) ?? ZeroValue.iosLocation

                returnLeftOrigin = CreateIosPosition.getLeftFromRight(returnLeftOrigin)
                
                let returnRightOrigin = getDefaultFromDimensions(rightPart, parentDimensionAsTouple.right) ?? ZeroValue.iosLocation
                
                let editedElseDefaultOrigin: OneOrTwo<PositionAsIosAxes> =
                    getUserEditedElseDefaultPartOrigin(returnLeftOrigin, returnRightOrigin)
                
                return editedElseDefaultOrigin
            }
        }
        
        func getUserEditedElseDefaultPartOrigin(
            _ value1: PositionAsIosAxes,
            _ value2: PositionAsIosAxes? = nil ) -> OneOrTwo<PositionAsIosAxes>{
            //edited values else default values
                let origins =
            userEditedOriginOffsetOneOrTwoOptional.mapValuesToOptionalOneOrTwoAddition(value1, value2)
//                if part == .fixedWheelAtRearWithPropeller {
//                   
//                    print(userEditedOriginOffsetOneOrTwoOptional)
//                    print (origins )
//                }
                return origins
        }
        
        
        func doesOneHaveId0RequiringRightToLeftTransform() -> PartTag? {
            var idForOne: PartTag? = nil
            switch partIdAllowingForUserEdit{
            case .one(let one):
                if one == .id0 {
                    idForOne = .id0
                }
            default:
              break
            }
            return idForOne
        }
        
        
        func getDefaultFromDimensions(_ selfDimension: Dimension3d, _ parentDimension: Dimension3d)  -> PositionAsIosAxes? {
            let origin =
            getFineTuneOriginDefault(selfDimension, parentDimension) ??
            getGeneralOriginDefault(selfDimension, parentDimension)
            return origin
        }
                     
        
        func getFineTuneOriginDefault(_ selfDimension: Dimension3d, _ parentDimension: Dimension3d) -> PositionAsIosAxes? {
            let chairHeight = 500.0
            return
                [
                PartObject(.fixedWheelAtRear, .fixedWheelManualRearDrive): (x: 75.0, y: 0.0, z: 0.0),
                PartObject(.mainSupport, .fixedWheelSolo): (x: 0.0, y: 0.0, z: chairHeight),
                PartObject(.mainSupport, .fixedWheelMidDrive): (x: 0.0, y: 0.0, z: chairHeight ),
                PartObject(.mainSupport, .fixedWheelFrontDrive): (x: 0.0, y: -selfDimension.length/2, z: chairHeight),
                PartObject(.mainSupport, .allCasterBed): (x: 0.0, y: selfDimension.length/2, z: 900.0),
                PartObject(.mainSupport, .allCasterStretcher): (x: 0.0, y: selfDimension.length/2, z: 900.0),
                
                ][PartObject(part, object)]
        }
    
    
        func  getGeneralOriginDefault(_ selfDimension: Dimension3d, _ linkedOrParentDimension: Dimension3d) -> PositionAsIosAxes? {
           let wheelBaseJointOrigin = getWheelBaseJointOrigin()
//                    if part == .fixedWheelAtRearWithPropeller {
//                        
//                        print(wheelBaseJointOrigin)
//                        print (PartDefaultDimension(.fixedWheelAtRear,objectType, linkedOrParentData).partDimension.width )
//                    }
            return
                [
                .armSupport: (x: linkedOrParentDimension.width/2 + selfDimension.width/2, y: 0.0, z: selfDimension.height/2),
                .assistantFootLever: (x: linkedOrParentDimension.width/2, y: -(selfDimension.length + linkedOrParentDimension.length)/2, z: wheelBaseJointOrigin.z),
                .backSupport: (x: 0.0, y: -(linkedOrParentDimension.length + selfDimension.length)/2, z: selfDimension.height/2.0 ),
                .backSupportHeadSupport: (x: 0.0, y: 0.0, z: linkedOrParentDimension.height/2),
                .backSupportHeadSupportJoint: (x: 0.0, y: 0.0, z: linkedOrParentDimension.height/2.0),
                .backSupportHeadSupportLink:   (x: 0.0, y: 0.0, z: selfDimension.height/2),
                .backSupportTiltJoint: (x: 0.0, y: -linkedOrParentDimension.length/2, z: 0.0) ,
                
                .casterForkAtFront: (x: 0.0, y: -selfDimension.length * 2.0/3.0, z:  200.0),
                .casterForkAtRear: (x: 0.0, y: -selfDimension.length * 2.0/3.0, z:  200.0),
                .casterWheelAtFront: (x: 0.0, y: -selfDimension.height/2.0, z: 0.0),
                .casterWheelAtRear: (x: 0.0, y: -selfDimension.height/2.0, z: 0.0),
                .casterVerticalJointAtFront: wheelBaseJointOrigin,
                .casterVerticalJointAtRear: wheelBaseJointOrigin,
                .fixedWheelAtFront: ZeroValue.iosLocation,
                .fixedWheelAtMid: ZeroValue.iosLocation,
                .fixedWheelAtRear: ZeroValue.iosLocation,
                .fixedWheelHorizontalJointAtFront: wheelBaseJointOrigin,
                .fixedWheelHorizontalJointAtMid: wheelBaseJointOrigin,
                .fixedWheelHorizontalJointAtRear: wheelBaseJointOrigin,
                .fixedWheelAtRearWithPropeller: (x: PartDefaultDimension(.fixedWheelAtRear,objectType, linkedOrParentData).partDimension.width * 2 ,
                                                 //wheelBaseJointOrigin.x,
                                                 y: 0.0, z: 0.0),
                .footOnly: ZeroValue.iosLocation,
                
                .footSupport: (x: -PartDefaultDimension(.footSupport,objectType, linkedOrParentData).partDimension.width/2.0,
                               y: linkedOrParentDimension.length/2.0, z: 0.0),
                
                .footSupportJoint: (x: 0.0, y: linkedOrParentDimension.length/2.0, z: 0.0),
                .footSupportHangerJoint: (x: linkedOrParentDimension.width/2.0, y: linkedOrParentDimension.length/2.0, z: 0.0),
                
                .footSupportHangerLink: (x: linkedOrParentDimension.width/2.0 , y: (linkedOrParentDimension.length + selfDimension.length)/2.0, z: selfDimension.height/2.0),
            
                .footSupportInOnePiece: ZeroValue.iosLocation,
                .sideSupport: (x: linkedOrParentDimension.width/2 + selfDimension.width/2, y: 0.0, z: selfDimension.height/2),
                
                .sideSupportRotationJoint: (x: linkedOrParentDimension.width/2, y: -linkedOrParentDimension.length/2, z: selfDimension.height),
                .mainSupport:  (x: 0.0, y: selfDimension.length/2, z: 500.0 ),
                .sitOnTiltJoint: (x: 0.0, y: linkedOrParentDimension.length/12, z: -100.0),
                .steeredVerticalJointAtFront: wheelBaseJointOrigin,
                .steeredWheelAtFront: ZeroValue.iosLocation
                ] [part]
        }
    }
    
    
    func getWheelBaseJointOrigin() -> PositionAsIosAxes {
        
        var origin = ZeroValue.iosLocation
        
        let frontStability = PartDefaultDimension(.stabilizerAtFront, objectType).partDimension
        let midStability = PartDefaultDimension(.stabilizerAtMid, objectType).partDimension
        let rearStability = PartDefaultDimension(.stabilizerAtRear, objectType ).partDimension
        
        let xOffset = linkedOrParentDimensionUsingOneValue.width
        let yOffset = linkedOrParentDimensionUsingOneValue.length
        let wheelJointHeight = 0.0
        let rearCasterVerticalJointOriginForMidDrive = (
                x: xOffset/2 + rearStability.width,
                y: -yOffset/2 + rearStability.length,
                z: wheelJointHeight)
        let midDriveOrigin = (
            x: xOffset/2 + rearStability.width,
            y: yOffset/2 + rearStability.length,
            z: wheelJointHeight)
        let xPosition = xOffset/2 + rearStability.width
        let xPositionAtFront = xOffset/2 + frontStability.width
//        if part == .fixedWheelAtRearWithPropeller {
//            print("Detect")
//            print(xPosition)
//        }
           switch part {
                case
                    .fixedWheelAtRearWithPropeller,
                    .fixedWheelHorizontalJointAtRear,
                    .casterVerticalJointAtRear:
                        origin = [
                            .fixedWheelManualRearDrive: (
                                x: xPosition + rearStability.width,
                                y: rearStability.length,
                                z: wheelJointHeight),
                            .fixedWheelFrontDrive: (
                                x: xPosition + rearStability.width,
                                y: -yOffset + rearStability.length,
                                        z: wheelJointHeight),
                            .fixedWheelMidDrive: rearCasterVerticalJointOriginForMidDrive ][objectType] ?? (
                                        x: xPosition,
                                        y: rearStability.length,
                                        z: wheelJointHeight)
               
//               if part == .fixedWheelAtRearWithPropeller {
//                   print("Detect")
//                   print(xPosition)
//               }
                case
                    .fixedWheelHorizontalJointAtMid,
                    .casterVerticalJointAtMid:
                        origin = [
                            .fixedWheelSolo: (
                                x: xPosition,
                                y: 0.0,
                                z: wheelJointHeight)
                                ,
                            .fixedWheelMidDrive: (
                                x: xPosition + midStability.width,
                                y: 0.0,
                                z: wheelJointHeight) ] [objectType] ?? (
                                x: xPosition,
                                y: (rearStability.length + yOffset)/2.0,
                                z: wheelJointHeight)
                case
                    .fixedWheelHorizontalJointAtFront,
                    .casterVerticalJointAtFront,
                    .steeredVerticalJointAtFront:
                        origin = [
                            .fixedWheelFrontDrive: (
                                    x: xPosition,
                                    y: frontStability.length,
                                    z: wheelJointHeight),
                            .fixedWheelMidDrive: (
                                    x: xPosition + frontStability.width,
                                    y: yOffset/2 + frontStability.length,
                                    z: wheelJointHeight),
                            .fixedWheelSolo: midDriveOrigin,
                            .scooterRearDrive4Wheeler: (
                                            x: xPositionAtFront,
                                            y: 800.0 + frontStability.length,
                                            z: wheelJointHeight)
                            ][objectType] ?? (
                                        x: xPositionAtFront,
                                        y: yOffset + frontStability.length,
                                        z: wheelJointHeight)
                default:
                    break
            }
        return origin
    }
}




enum MenuDisplayPart: String {
    case armrest = "armrest"
    case backrest = "backrest"
    case base = "base"
    case casterForkAtFront = "front fork"
    case casterForkAtMid = "mid fork"
    case casterForkAtRear = "rear fork"
    case footRest = "footrest"
    case footLever = "foot tipper"
    case headrest = "headrest"
    case propeller = "propeller"
    case sides = "sides"
    case seat = "seat"
    case tilt = "tilt"
    case top = "top"


    case wheelAtMid = "mid wheel"
    case wheelAtRear = "rear wheel"
    case wheelAtFront = "front wheel"
}


struct PartToDisplay {
var names: [String] = []
var name: String = ""
   static let dictionary: [Part: MenuDisplayPart] = [
        .assistantFootLever: .footLever,
        .armSupport: .armrest,
        .backSupport: .backrest,
        .backSupportHeadSupport: .headrest,
        .backSupportTiltJoint: .tilt,
        .casterForkAtFront: .casterForkAtFront,
        .casterForkAtMid: .casterForkAtMid,
        .casterForkAtRear: .casterForkAtRear,
        .casterWheelAtFront: .wheelAtFront,
        .casterWheelAtMid: .wheelAtMid,
        .casterWheelAtRear: .wheelAtRear,

        .fixedWheelAtFront: .wheelAtFront,
        .fixedWheelAtMid: .wheelAtMid,
        .fixedWheelAtRear: .wheelAtRear,
        .footSupport: .footRest,
        .fixedWheelAtFrontWithPropeller: .propeller,
        .fixedWheelAtMidWithPropeller: .propeller,
        .fixedWheelAtRearWithPropeller: .propeller,
        .mainSupport: .seat,
        .sitOnTiltJoint: .tilt,
        .steeredWheelAtFront: .wheelAtFront
        ]
   static let partObjectToMenuNameDictionary: [PartObject: MenuDisplayPart] = [
    PartObject(.sideSupport, .allCasterBed): .sides,
    PartObject(.sideSupport, .allCasterStretcher): .sides,
    PartObject(.mainSupport, .allCasterBed): .top,
    PartObject(.mainSupport, .allCasterStretcher): .top,
    PartObject(.mainSupport, .showerTray): .base,
    ]
    
    init(_ parts: [Part], _ objectType: ObjectTypes) {
        var menuCase: MenuDisplayPart?
        
        for part in parts {
            menuCase =
                Self.partObjectToMenuNameDictionary[PartObject(part, objectType)] ?? Self.dictionary[part]
            
            guard let unwrapped = menuCase else {
                fatalError("no menu name for \(part)")
            }
            names += [unwrapped.rawValue]
        }
        
        name = names.count == 1 ? names[0]: ""
        
    }
}



struct PartsRequiringLinkedPartUse {
    static let forDimensionDic: [Part: Part] =
    [.footSupport: .footSupportHangerLink,
     ]
    
    static let forOriginDic: [Part: Part] =
    [.footSupport: .footSupportHangerLink,
     .casterWheelAtFront: .casterVerticalJointAtFront,
     .casterWheelAtRear: .casterVerticalJointAtRear,
     .steeredWheelAtFront: .steeredVerticalJointAtFront,]
    
    static let forPartLinkDic: [Part: Part] = [
        .fixedWheelAtRearWithPropeller: .fixedWheelAtRear
    ]
    
   let partForDimension: Part
    
    let partForOrigin: Part
    
    let partForLink: Part?
    
    init(_ part: Part) {
        partForDimension =
            Self.forDimensionDic[part] ?? part
        partForOrigin =
            Self.forOriginDic[part] ?? part
        partForLink =
            Self.forPartLinkDic[part]
    }
}



//determine if a part is linked to another part for origin or dimension
struct LinkedParts {
    let dictionary: [Part: Part] = [
        .fixedWheelHorizontalJointAtRear: .mainSupport,
        .fixedWheelHorizontalJointAtMid: .mainSupport,
        .fixedWheelHorizontalJointAtFront: .mainSupport,
        .casterVerticalJointAtRear: .mainSupport,
        .casterVerticalJointAtMid: .mainSupport,
        .casterVerticalJointAtFront: .mainSupport,
        .steeredVerticalJointAtFront: .mainSupport
        ]
}
