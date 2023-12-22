//
//  ObjectCreator.swift
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
    case backSupportRotationJoint = "backSupportRotationJoint"
    case backSupportHeadSupport = "backSupportHeadSupport"
    case backSupportHeadSupportJoint = "backSupportHeadSupportHorizontalJoint"
    case backSupportHeadSupportLink = "backSupportHeadSupportLink"
    case backSupportHeadLinkRotationJoint = "backSupportHeadSupportLinkHorizontalJoint"
    case backSupportTiltJoint = "backSupportReclineAngle"
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

    case casterVerticalJointAtRear = "casterVerticalBaseJointAtRear"
    case casterVerticalJointAtMid = "casterVerticalBaseJointAtMid"
    case casterVerticalJointAtFront = "casterVerticalBaseJointAtFront"
    
    case casterForkAtRear = "casterForkAtRear"
    case casterForkAtMid = "casterForkAtMid"
    case casterForkAtFront = "casterForkAtFront"
    
    case casterWheelAtRear = "casterWheelAtRear"
    case casterWheelAtMid = "casterWheelAtMid"
    case casterWheelAtFront = "casterWheelAtFront"
    
    case casterWheel = "casterWheel"
    case ceiling = "ceiling"
    
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
    
    
    
    case fixedWheelHorizontalJointAtRear = "fixedWheelHorizontalBaseJointAtRear"
    case fixedWheelHorizontalJointAtMid = "fixedWheelHorizontalBaseJointAtMid"
    case fixedWheelHorizontalJointAtFront = "fixedWheelHorizontalBaseJointAtFront"
    case fixedWheelAtRear = "fixedWheelAtRear"
    case fixedWheelAtMid = "fixedWheelAtMid"
    case fixedWheelAtFront = "fixedWheelAtFront"
    case fixedWheelAtRearWithPropeller = "fixedWheelAtRearithPropeller"
    case fixedWheelAtMidWithPropeller = "fixedWheelAtMidithPropeller"
    case fixedWheelAtFrontWithPropeller = "fixedWheelAtFrontithPropeller"
    
    
    
    case footSupport = "footSupport"
    case footOnly = "footOnly"
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
    case sideSupportJoystick = "sideSupportJoystick"
    case stringLink = "_"
    
    case stabilityAtRear = "stabilityAtRear"
    case stabilityAtFront = "stabilityAtFront"
    case stabilityAtSideAtRear = "stabilityAtSideAtRear"
    case stabilityAtSideAtMid = "stabilityAtSideAtMid"
    case stabilityAtSideAtFront = "stabilityAtSideAtFront"
    
    
    //case sitOnTiltJoint = "tiltInSpaceAngle"
    case sitOnTiltJoint = "tiltInSpaceHorizontalJoint"
    
    
    case topToBottomDimension = "yIos"
    case width = "Width"
}



enum Toggles {
    case twinSitOn
    case sitOnPosition
}






//Source of truth for partChain
//MARK: ChainLabel
struct LabelInPartChainOut  {
    static let backSupport: PartChain =
        [
        .sitOn,
        .backSupportRotationJoint,//origin depends on sitOn dimension
        .backSupport] //dimension depends on sitOn dimension
    let foot: PartChain =
        [
        .sitOn,
        .footSupportHangerJoint,//origin depends on sitOn dimension
        .footSupportHangerLink,
        .footSupportJoint,
        .footSupport
        ]
    let footOnly: PartChain =
        [.footSupportInOnePiece]
   static let headSupport: PartChain =
        [
        .backSupportHeadSupportJoint,
        .backSupportHeadSupportLink,
        .backSupportHeadSupport
        ]
   static let sideSupport: PartChain =
        [
        .sitOn,
        //.sideSupportRotationJoint,
        .sideSupport] //dimension depends on sitOn dimension
    let sitOn: PartChain =
        [
        .sitOn]
    static let sitOnTiltJoint: PartChain =
       [
        .sitOn,
        .sitOnTiltJoint]
    static let fixedWheelAtRear: PartChain =
        [
       .fixedWheelHorizontalJointAtRear,
       .fixedWheelAtRear]
    static let fixedWheelAtMid: PartChain =
        [
        .fixedWheelHorizontalJointAtMid,
        .fixedWheelAtMid]
    static let fixedWheelAtFront: PartChain =
        [
        .fixedWheelHorizontalJointAtFront,
        .fixedWheelAtFront]
    static let casterWheelAtRear: PartChain =
        [
        .casterVerticalJointAtRear,
        .casterForkAtRear,
        .casterWheelAtRear
        ]
    static let casterWheelAtMid: PartChain =
        [
        .casterVerticalJointAtMid,
        .casterForkAtMid,
        .casterWheelAtMid
        ]
    static let casterWheelAtFront: PartChain =
        [
        .casterVerticalJointAtFront,
        .casterForkAtFront,
        .casterWheelAtFront
        ]
    
    var partChains: [PartChain] = []
    var partChain: PartChain = []
    init(_ parts: [Part]) {//many partChain label
        for part in parts {
            partChains.append (getPartChain(part))
        }
    }
    
    init(_ part: Part) { //one partChain label
        partChain = getPartChain(part)
    }

    
   mutating func getPartChain (
    _ part: Part)
        -> PartChain {
        switch part {
            case .backSupport:
                return
                    Self.backSupport
            case .backSupportHeadSupport:
                return
                    Self.backSupport + Self.headSupport
            case .footOnly:
                return
                    footOnly
            case .footSupport:
                return
                    foot //+ [.footSupport]
            case .footSupportInOnePiece:
                return
                    foot + [.footSupportInOnePiece]
            case .sideSupport:
                return
                    Self.sideSupport
            case .sideSupportJoystick:
                return
                    Self.sideSupport + [.sideSupportJoystick]
            case .sitOn:
                return sitOn
            case .sitOnTiltJoint:
                return
                    Self.sitOnTiltJoint
            case .fixedWheelAtRear:
                return
                    Self.fixedWheelAtRear
            case .fixedWheelAtMid:
                return
                    Self.fixedWheelAtMid
            case .fixedWheelAtFront:
                return
                    Self.fixedWheelAtFront
            case .fixedWheelAtRearWithPropeller:
                    return
                Self.fixedWheelAtRear + [.fixedWheelPropeller]
            case .fixedWheelAtMidWithPropeller:
                return
                    Self.fixedWheelAtMid + [.fixedWheelPropeller]
            case .fixedWheelAtFrontWithPropeller:
                return
                    Self.fixedWheelAtFront + [.fixedWheelPropeller]
            case .casterWheelAtRear:
                return
                    Self.casterWheelAtRear
            case .casterWheelAtFront:
                return
                    Self.casterWheelAtFront
            default:
                return []
        }
    }
}

/// provides the object names for the picker
/// provides the chainPartLabels for each object
//MARK: ObjectsChainLabels
struct ObjectsAndTheirChainLabels {
    static let chairSupport: [Part] =
        [
        .backSupportHeadSupport,
        .footSupport,
        .sideSupport,
        .sitOnTiltJoint,
        .sitOn,]
    static let rearAndFrontCasterWheels: [Part] =
        [.casterWheelAtRear, .casterWheelAtFront]
    static let chairSupportWithFixedRearWheel: [Part] =
    chairSupport + [.fixedWheelAtRear]
    
    let dictionary: ObjectPartChainLabelsDictionary =
    [
    .allCasterBed:
        [ .sideSupport, .sitOn],
      
    .allCasterChair:
        chairSupport + rearAndFrontCasterWheels,
      
    .allCasterTiltInSpaceShowerChair:
        chairSupport + rearAndFrontCasterWheels + [.sitOnTiltJoint],
    
    .allCasterStretcher:
        [ .sitOn] + rearAndFrontCasterWheels,
    
    .fixedWheelMidDrive:
        chairSupport + [.fixedWheelAtMid] + rearAndFrontCasterWheels,
    
    .fixedWheelFrontDrive:
        chairSupport + [.fixedWheelAtFront] + [.casterWheelAtRear],
     
    .fixedWheelRearDrive:
        chairSupportWithFixedRearWheel + [.casterWheelAtFront],
    
    .fixedWheelManualRearDrive:
        chairSupportWithFixedRearWheel + [.casterWheelAtFront],
    
    .showerTray: [.footOnly],
    
        .fixedWheelSolo: [.fixedWheelAtMid] + [.sitOn] + [.sideSupport]
    ]
        
}








//MARK: OneOrTwoId
struct OneOrTWoId {
    let forPart: OneOrTwo<Part>
    
    init(_ objectType: ObjectTypes,_ part: Part){
       
        forPart = getIdForPart(part)
        
        func getIdForPart(_ part: Part)
        -> OneOrTwo<Part>{
            switch part {
                case
                    .casterForkAtRear,
                    .casterForkAtMid,
                    
                    .casterVerticalJointAtRear,
                    .casterVerticalJointAtMid,
                    
                    .casterWheelAtRear,
                    .casterWheelAtMid,
                   
                    .fixedWheelAtRear,
                    .fixedWheelAtMid,
                    .fixedWheelAtFront,
                    .fixedWheelHorizontalJointAtRear,
                    .fixedWheelHorizontalJointAtMid,
                    .fixedWheelHorizontalJointAtFront,
                    .footSupportHangerJoint,
                    .footSupportHangerLink,
                    .footSupportJoint,
                    .footSupport,
                
                    .sideSupport,
                    .sideSupportRotationJoint:
                    return .two(left: .id0, right: .id1)
                
                case
                    .casterVerticalJointAtFront,
                    .casterForkAtFront,
                    .casterWheelAtFront:
                    return getIdForFrontAccountingForDriveLocation()
                case
                    .backSupportRotationJoint,
                    .backSupport,
                    .backSupportHeadSupportJoint,
                    .backSupportHeadSupportLink,
                    .backSupportHeadSupport,
                    .footSupportInOnePiece,
                    .sitOn,
                    .sitOnTiltJoint:
                    return .one(one: .id0)
                default :
                fatalError("OneOrTwoId: \(#function)  no id has been defined for \(part)")
            }
        }
        
        func getIdForFrontAccountingForDriveLocation()
        -> OneOrTwo<Part>{
            switch objectType {
            
                
            case .fixedWheelFrontDrive, .fixedWheelRearDrive:
                return .two(left: .id0, right: .id1)
            default:
                return .two(left: .id2, right: .id3)
                
            }
            
        }
    }
}


struct OneOrTwoGenericPartValue {
    var part: Part
    
    var originName: OneOrTwo<String>
    
    var dimensionName: OneOrTwo<String>

    var dimension: OneOrTwo<Dimension3d>
    
    var maxDimension: OneOrTwo<Dimension3d>
    
    var minDimension: OneOrTwo<Dimension3d>
    
    var childOrigin: OneOrTwo<PositionAsIosAxes>
    
    var minMaxAngle: OneOrTwo<AnglesMinMax>
    
    var angles: OneOrTwo<RotationAngles>
    
    var id: OneOrTwo<Part>
    
    var sitOnId: Part
    
    var scopesOfRotation: [[Part]]
    
    init (
        part: Part,
        originName: OneOrTwo<String>,
        dimensionName: OneOrTwo<String>,
        dimension: OneOrTwo<Dimension3d>,
        maxDimension: OneOrTwo<Dimension3d>? = nil,
        minDimension: OneOrTwo<Dimension3d>? = nil,
        origin: OneOrTwo<PositionAsIosAxes>,
        minMaxAngles: OneOrTwo<AnglesMinMax>,
        angles: OneOrTwo<RotationAngles>,
        id: OneOrTwo<Part>,
        sitOnId: Part = .id0,
        scopesOfRotation: [[Part]] = [] ) {
            self.part = part
            self.originName = originName
            self.dimensionName = dimensionName
            self.dimension = dimension
            self.maxDimension = maxDimension ?? dimension
            self.minDimension = minDimension ?? dimension
            self.childOrigin = origin
            self.minMaxAngle = minMaxAngles
            self.angles = angles
            self.id = id
            self.sitOnId = sitOnId
            self.scopesOfRotation = scopesOfRotation
        }
}





enum OneOrTwo <T> {
    case two (left: T, right: T)
    case one (one: T)
    
    var left: T? {
        switch self {
        case .two(let left, _):
            return left
        case .one:
          return nil
        }
    }

    var right: T? {
        switch self {
        case .two(_, let right):
            return right
        case .one:
            return nil
        }
    }
    
    var one: T? {
        switch self {
        case .two:
            return nil
        case .one(let one):
            return one
        }
    }
    
    var values: (left: T?, right: T?, one: T?) {
        (left: left, right: right, one: one)
    }
    
    func map1<U>(_ transform: (T) -> U) -> OneOrTwo<U> {
        switch self {
        case .one(let value):
            return .one(one: transform(value))
        case .two(let left, let right):
            return .two(left: transform(left), right: transform(right))
        }
    }
    
    
    func map2<U, V>(_ second: OneOrTwo<V>, _ transform: (T, V) -> U) -> OneOrTwo<U> {
        switch (self, second) {
        case let (.one(value1), .one(value2)):
            return .one(one: transform(value1, value2))
        case let (.two(left1, right1), .two(left2, right2)):
            return .two(left: transform(left1, left2), right: transform(right1, right2))
        default:
            // Handle other cases if needed
            fatalError("Incompatible cases for map2")
        }
    }
    
    func map3<U, V, W>(_ second: OneOrTwo<V>, _ third: OneOrTwo<W>,_ transform: (T, V, W) -> U) -> OneOrTwo<U> {
        switch (self, second, third) {
        case let (.one(value1), .one(value2), .one(value3)):
            return .one(one: transform(value1, value2, value3))
        case let (.two(left1, right1), .two(left2, right2), .two(left3, right3)):
            return .two(left: transform(left1, left2, left3), right: transform(right1, right2, right3))
        default:
            // Handle other cases if needed
            fatalError("Incompatible cases for map3")
        }
    }
    
}


//struct OneOrTwoExtraction<T> {
//    var values: (left: T?, right: T?, one: T?)
//
//    init (_ oneOrTwo: OneOrTwo<T>) {
//        values = extractValues(oneOrTwo)
//
//        func extractValues(_ value: OneOrTwo<T>) -> (left: T?, right: T?, one: T?) {
//            switch value {
//            case .two(let left, let right):
//                return (left: left, right: right, one: nil)
//            case .one(let one):
//                return (left: nil, right: nil, one: one)
//            }
//        }
//    }
//}


//MARK: StructFactory
struct StructFactory {
    let objectType: ObjectTypes
    let oneOrTwoUserEditedDictionary: OneOrTwoUserEditedDictionary
    
    init(_ objectType: ObjectTypes,
        _ oneOrTwoUserEditedDictionary: OneOrTwoUserEditedDictionary){
        self.objectType = objectType
        self.oneOrTwoUserEditedDictionary = oneOrTwoUserEditedDictionary
    }
}


struct KeyPathContainer<T> {
    var left: T?
    var right: T?
    var one: T?
}

extension StructFactory {
    
    func createOneOrTwoSitOn(
    _ sideSupport: OneOrTwoGenericPartValue?,
    _ footSupportHangerLink: OneOrTwoGenericPartValue?)
        -> OneOrTwoGenericPartValue {
        let oneOrTwoSitOnId: OneOrTwo<Part> = .one(one: .id0)
            
        let oneOrTwoUserEditedValues =
            OneOrTwoUserEditedValue(
                objectType,
                oneOrTwoUserEditedDictionary,
                .id0,
                .sitOn)
        let dimension = getSitOnDimension()
            
        return
            OneOrTwoGenericPartValue(
                part: .sitOn,
                originName: .one(one: "object_id0_sitOn_id0_sitOn_id0"),
                dimensionName: .one(one: "object_id0_sitOn_id0_sitOn_id0"),
                dimension: dimension,
                origin: getSitOnOrigin(),
                minMaxAngles: .one(one:
                                (min: ZeroValue.rotationAngles,
                                 max: ZeroValue.rotationAngles)),
                angles: .one(one: ZeroValue.rotationAngles),
                id: .one(one: .id0) )
            
            
        func getSitOnDimension() -> OneOrTwo<Dimension3d> {
            let dimensionDic: BaseObject3DimensionDictionary =
                [.allCasterStretcher: (width: 600.0, length: 1200.0, height: 10.0),
                 .allCasterBed: (width: 900.0, length: 2000.0, height: 150.0),
                 .allCasterHoist: (width: 0.0, length: 0.0, height: 0.0)
                    ]
            return
                getPartDimensionForObject(
                    dimensionDic[objectType] ??
                    (width: 400.0, length: 400.0, height: 10.0) )
        }
            
            
        func getSitOnOrigin() -> OneOrTwo<PositionAsIosAxes> {
            //if let dimension = OneOrTwoExtraction(dimension).values.one {
            if let dimension = dimension.one {
                let bodySupportHeight =
                    MiscObjectParameters(objectType).getMainBodySupportAboveFloor()
                let originDic: BaseObjectOriginDictionary = [
                    .fixedWheelSolo: (
                        (x: 0.0, y: 0.0, z: bodySupportHeight)
                    ),
                    
                    .fixedWheelMidDrive:
                        (x: 0.0, y: 0.0, z: bodySupportHeight ),
                    .fixedWheelFrontDrive:
                        (x: 0.0, y: -dimension.length/2, z: bodySupportHeight)]
                return
                    getPartOriginForObject(
                        originDic[objectType] ??
                        (x: 0.0, y: dimension.length/2, z: bodySupportHeight ) )
            } else {
                fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) sitOn does not have a .one dimension")
            }
            
        }
            
            
        func getPartOriginForObject(
        _ defaultOrigin: PositionAsIosAxes)
            -> OneOrTwo<PositionAsIosAxes> {
//                print(oneOrTwoUserEditedValues.origin)
                
            switch oneOrTwoUserEditedValues.origin {
                case .one (let one):
                    return .one(one: one ?? defaultOrigin )
                case .two(let left, let right):
                    return .two(left: left ?? defaultOrigin,
                                right: right ?? defaultOrigin)
            }
        }
            
            
        func getPartDimensionForObject(
        _ defaultDimension: Dimension3d)
            -> OneOrTwo<Dimension3d> {
//                print(oneOrTwoUserEditedValues.dimension)
                
            switch oneOrTwoUserEditedValues.dimension {
                case .one (let one):
                    return .one(one: one ?? defaultDimension )
                case .two(let left, let right):
                    return .two(left: left ?? defaultDimension,
                                right: right ?? defaultDimension)
            }
        }
    }
}

//OneOrTwoGenericPartValue

extension StructFactory {
    func createOneOrTwoDependentPartForSingleSitOn(
    _ parent: OneOrTwoGenericPartValue?,
    _ childPart: Part,
    _ siblings: [OneOrTwoGenericPartValue])
        -> OneOrTwoGenericPartValue {
        
        let oneOrTwoUserEditedValues = //optional values apart from id
                OneOrTwoUserEditedValue(
                    objectType,
                    oneOrTwoUserEditedDictionary,
                    .id0,
                    childPart)
        
        var parentDimension = ZeroValue.dimension3d
        var childDimension: OneOrTwo<Dimension3d> =
                .one(one: ZeroValue.dimension3d)
        var childOrigin: OneOrTwo<PositionAsIosAxes> =
            .one(one: ZeroValue.iosLocation)
        var scopesOfRotation: [[Part]] = []
        var childAnglesMinMax: OneOrTwo<AnglesMinMax> =
                .one(one:
                        (min:ZeroValue.rotationAngles,
                         max: ZeroValue.rotationAngles ))
        var childAngles:  OneOrTwo<RotationAngles> = .one(one: ZeroValue.rotationAngles)
            
         
        var originName: OneOrTwo<String> = .one(one: "")
        
            setOriginNames()
        if let parent {
            parentDimension = getOneDimensionFromOneOrTwo(parent.dimension)
        }
        
        getChildValues()
            

          
        return
            OneOrTwoGenericPartValue(
                part: childPart,
                originName: originName,
                dimensionName: originName,
                dimension: childDimension,
                maxDimension: childDimension,
                origin: childOrigin,
                minMaxAngles: childAnglesMinMax,
                angles: childAngles,
                id: OneOrTWoId(objectType, childPart).forPart,
                scopesOfRotation: scopesOfRotation)
        
        func getChildValues () {
            switch childPart {
                case .backSupportRotationJoint:
                        setChildDimensionForObject(Joint.dimension3d)

                        setBackSupportRotationJointOrigin()
                case .backSupport:
                        setBackSupportChildDimension()
                        setBackSupportChildOrigin()
                case .backSupportHeadSupportJoint:
               
                        setChildDimensionForObject(Joint.dimension3d)
                        setBackSupportHeadSupportJointChildOrigin()
                case .backSupportHeadSupportLink:
                        setBackSupportHeadSupportLinkChildDimension()
                        setBackSupportHeadSupportLinkChildOrigin()
                case .backSupportHeadSupport:
                        setBackSupportHeadSupportChildDimension()
                        setBackSupportHeadSupportChildOrigin()
                case .casterForkAtRear,.casterForkAtMid, .casterForkAtFront:
                        setCasterForkChildDimension()
                        setCasterForkChildOrigin()
                case .casterWheelAtRear,.casterWheelAtMid, .casterWheelAtFront:
                        setCasterWheelChildDimension()
                        setCasterWheelChildOrigin()
                case .fixedWheelAtRear,.fixedWheelAtMid, .fixedWheelAtFront:
                        setFixedWheelChildDimension()
                        setFixedWheelChildOrigin()
                
                case
                    .fixedWheelHorizontalJointAtRear,
                    .fixedWheelHorizontalJointAtMid,
                    .fixedWheelHorizontalJointAtFront,
                    .casterVerticalJointAtRear,
                    .casterVerticalJointAtMid,
                    .casterVerticalJointAtFront:
                        setChildDimensionForObject(Joint.dimension3d)
                        setWheelBaseJointChildOrigin(childPart)
                
                case .footSupport:
                        setFootSupportChildDimension()
                        setFootSupportChildOrigin()
                case .footSupportHangerJoint:
                        setChildDimensionForObject(Joint.dimension3d)
                        setFootSupportHangerJointChildOrigin()
                case .footSupportHangerLink:
                        setFootSupportHangerLinkChildDimension()
                        setFootSupportHangerLinkChildOrigin()
                case .footSupportJoint:
                        setChildDimensionForObject(Joint.dimension3d)
                        setFootSupportJointChildOrigin()
        
                case .footSupportInOnePiece:
                        childOrigin = .one(one: ZeroValue.iosLocation)
                        setFootSupportInOnePieceChildDimension()
                case .sideSupport:
                        setSideSupportChildDimension()
                        setSideSupportChildOrigin()
                case .sideSupportRotationJoint:
                        setSideSupportChildDimension()
                        setSideSupportRotationJointChildOrigin()
                case .sitOnTiltJoint:
                //print("SitOnTiltJoint detected")
                        setChildDimensionForObject(Joint.dimension3d)
                        setSitOnTiltJointChildOrigin()
                        setScopesOfRotationForSitOnTiltJoint()
                        setSitOnTiltJointAngles()
                
                
                default:
                    fatalError(
                        "StructFactory: \(#function) unkown case of \(childPart)")
            }
        }
    
      
        func setOriginNames(){
            switch oneOrTwoUserEditedValues.originName {
            case .one (let one):
               originName =
                    .one(one: one ?? "" )
            case .two(let left, let right):
                originName =
                    .two(
                        left: left ?? "",
                        right: right ?? "")
            }
        }
            
//       func setSitOnTiltJointAngle() {
//          let zeroAngle = ZeroValue.angle
//          let max = Measurement(value: 60.0, unit: UnitAngle.degrees)
//          maxAngle = .one(one:(x: max, y: zeroAngle, z: zeroAngle))
//
//        }
            
        func getOneDimensionFromOneOrTwo(_ parentValue: OneOrTwo<Dimension3d>)
            -> Dimension3d {
                var dimension: Dimension3d = ZeroValue.dimension3d
                switch parentValue {
                    case .two(let left, let right):
                    //value average for default
                    dimension = (left + right)/2.0
                    case .one(let one):
                    dimension = one
                }
                return dimension
        }
        
            
            
        func setBackSupportRotationJointOrigin() {
        //let dimension = getOneDimensionFromOneOrTwo(parentDimension)
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: -parentDimension.length/2,
                 z: 0.0) )
        }
        
        
        func setBackSupportChildDimension() {
            //let dimension = getOneDimensionFromOneOrTwo(parentDimension)
            setChildDimensionForObject(
                [:][objectType] ??
                (width: parentDimension.width, length: 20.0 , height: 500.0)
            )
        }
        
        
        func setBackSupportChildOrigin() {
            let dimension = getOneDimensionFromOneOrTwo(childDimension)
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: 0.0,
                 z: dimension.height/2.0 )
                )
        }
        
        
        func setBackSupportHeadSupportJointChildOrigin() {
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: 0.0,
                 z: parentDimension.height/2.0) )
        }
        
        
        func setBackSupportHeadSupportLinkChildDimension() {
            setChildDimensionForObject(
                [:][objectType] ??
                (width: 20.0, length: 20.0, height: 150.0)
            )
        }
        
        
        func setBackSupportHeadSupportLinkChildOrigin() {
            let dimension = getOneDimensionFromOneOrTwo(childDimension)
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: 0.0,
                 z: dimension.height/2) )
        }
        
        
        func setBackSupportHeadSupportChildDimension() {
            setChildDimensionForObject(
                [:][objectType] ??
                (width: 150.0, length: 50.0, height: 100.0)
            )
        }
        
        
        func setBackSupportHeadSupportChildOrigin() {
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: 0.0,
                 z: parentDimension.height/2.0) )
        }
            
            
        func setCasterForkChildDimension() {
             setChildDimensionForObject(
                [.fixedWheelMidDrive:
                    (width: 20.0,
                     length: 75.0,
                     height: 50.0),
                    ][objectType] ??
                (width: 50.0, length: 100.0, height: 50.0)
             )
         }
         
         
         func setCasterForkChildOrigin() {
             let originLength = getChildDimension(keyPath: \.length)
             setChildOriginForObject(
                 [
                     : ][objectType] ??
                 (x: 0.0,
                  y: -originLength * 2.0/3.0,
                  z: 0.0) )
         }
            
            
        func setCasterWheelChildDimension() {
             setChildDimensionForObject(
                [.fixedWheelMidDrive:
                    (width: 20.0,
                     length: 75.0,
                     height: 75.0),
                    ][objectType] ??
                (width: 50.0, length: 75.0, height: 75.0)
             )
         }
         
         
         func setCasterWheelChildOrigin() {
             let originHeight = getChildDimension(keyPath: \.height)
             setChildOriginForObject(
                 [
                     : ][objectType] ??
                 (x: 0.0,
                  y: -originHeight/2.0,
                  z: 0.0) )
         }
            
            
        func setFixedWheelChildDimension() {
             setChildDimensionForObject(
                [.fixedWheelManualRearDrive:
                    (width: 20.0,
                     length: 600.0,
                     height: 600.0),
                    ][objectType] ??
                (width: 50.0, length: 200.0, height: 200.0)
             )
         }
         
         
         func setFixedWheelChildOrigin() {
             setChildOriginForObject(
                 [
                     : ][objectType] ??
                 (x: 0.0,
                  y: 0.0,
                  z: 0.0) )
         }

            
        func setFootSupportInOnePieceChildDimension(){
            
           // print ("DETECT")

            setChildDimensionForObject(
                [.showerTray
                 : (width: 900.0, length: 1200.0, height: 10.0)][objectType] ??
                (width: 50.0, length: 200.0, height: 200.0)  )
            
            //print (childDimension)
        }
            
            
        func setFootSupportHangerJointChildOrigin() {
            setChildOriginForObject(
                [
                    : ][objectType] ??
                (x: parentDimension.width/2.0,
                 y: parentDimension.length/2.0,
                 z: 0.0) )
        }
            

        func setFootSupportHangerLinkChildDimension() {
             setChildDimensionForObject(
                [.fixedWheelManualRearDrive:
                    (width: 20.0,
                     length: 300.0,
                     height: 20.0),
                    ][objectType] ??
                (width:20.0, length: 300.0, height: 20.0)
             )
         }
            
             
        func setFootSupportHangerLinkChildOrigin() {
           let dimension = getOneDimensionFromOneOrTwo(childDimension)
            setChildOriginForObject(
                [
                    .fixedWheelRearDrive:
                        (x: 0.0,
                         y: dimension.length/2,
                         z: dimension.height/2) ][objectType] ??
                (x: 0.0,
                 y: dimension.length/2,
                 z: dimension.height/2) )
        }
        
        
        func setFootSupportJointChildOrigin() {
           // let dimension = getOneDimensionFromOneOrTwo(parentDimension)
            setChildOriginForObject(
                [
                    : ][objectType] ??
                (x: 0.0,
                 y: parentDimension.length/2.0,
                 z: 0.0) )
        }

        
       func setFootSupportChildDimension() {
            setChildDimensionForObject(
                [:][objectType] ??
                (width: 150.0, length: 100.0, height: 20.0)
            )
        }
        
        
        func setFootSupportChildOrigin() {
            let dimensionWidth = getChildDimension( keyPath: \.width)
           // print (-dimensionWidth/2.0)
            setChildOriginForObject(
                [
                    : ][objectType] ??
                (x: -dimensionWidth/2.0,
                 y: 0.0,
                 z: 0.0) )
        }
            
            
        func setScopesOfRotationForSitOnTiltJoint() {
            scopesOfRotation = [
              
                [.backSupport, .backSupportHeadSupport],
                [.backSupport, .backSupportHeadSupport, .sideSupport],
                [.backSupport, .backSupportHeadSupport, .sideSupport, .footSupport],
                [.backSupport, .backSupportHeadSupport, .footSupport]
                ]
        }
        
            
        func setSideSupportChildDimension() {
            //let dimension = getOneDimensionFromOneOrTwo(parentDimension)
            setChildDimensionForObject(
            [.allCasterStretcher:
                (width: 20.0,
                 length: parentDimension.length,
                 height: 100.0),
             .allCasterBed:
                (width: 20.0,
                 length: parentDimension.length,
                 height: 150.0),
             .fixedWheelSolo:
                (width: 20.0,
                 length: parentDimension.length,
                 height: 150.0),
             .fixedWheelRearDrive:
                (width: 20.0,
                 length: parentDimension.length,
                 height: 150.0) ][objectType] ??
            (width: 50.0, length: 300.0, height: 150.0)
            )
        }
        
        
        func setSideSupportChildOrigin () {
            //let dimension = getOneDimensionFromOneOrTwo(parentDimension)
            let originHeight = getChildDimension(keyPath: \.height)
            setChildOriginForObject(
                [.allCasterStretcher:
                    (x: parentDimension.width/2,
                     y: 0.0,
                     z: originHeight),
                 .allCasterBed:
                    (x: parentDimension.width/2,
                     y: 0.0,
                     z: originHeight),
                 .fixedWheelRearDrive:
                    (x: parentDimension.width/2,
                     y: 0.0,
                     z: originHeight),
                 .fixedWheelFrontDrive:
                    (x: parentDimension.width/2,
                     y: 0.0,
                     z: originHeight)][objectType] ??
                (x: parentDimension.width/2,
                 y: 0.0,
                 z: originHeight) )
        }
        
        
        func setSideSupportRotationJointChildOrigin () {
            //let dimension = getOneDimensionFromOneOrTwo(parentDimension)
            let originHeight = getChildDimension(keyPath: \.height)
            setChildOriginForObject(
                [.allCasterStretcher:
                    (x: 0.0,
                     y: parentDimension.length/2,
                     z: 0.0),
                 .allCasterBed:
                    (x: 0.0,
                     y: parentDimension.length/2,
                     z: 0.0) ][objectType] ??
                (x: 0.0,
                 y: -parentDimension.length/2,
                 z: originHeight) )
        }
 
            /// minMaxAngle is set
            /// angle is derived from maxAngle
            /// angle is checked in the UI
        func setSitOnTiltJointAngles() {
            let zeroAngle = ZeroValue.angle
            let min = Measurement(value: 0.0, unit: UnitAngle.degrees)
            let max = Measurement(value: 30.0, unit: UnitAngle.degrees)
            let minRotationAngles =
                (x: min, y: zeroAngle, z: zeroAngle)
            let maxRotationAngles =
                (x: max, y: zeroAngle, z: zeroAngle)
            
            setChildAnglesForObject(maxRotationAngles)
            setChildMinMaxAnglesForObject((min: minRotationAngles, max: maxRotationAngles))
        }
            
            
        func setSitOnTiltJointChildOrigin(){
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: -parentDimension.length/4,
                 z: -100.0) )
        }
        
            
        func setWheelBaseJointChildOrigin(_ wheelPart: Part) {
            var origin = ZeroValue.iosLocation
            let rearStability = getStability(.stabilityAtRear)
            let frontStability = getStability(.stabilityAtFront)
            let sideStabilityAtRear = getStability(.stabilityAtSideAtRear)
            let sideStabilityAtMid = getStability(.stabilityAtSideAtMid)
            let sideStabilityAtFront = getStability(.stabilityAtSideAtFront)
            let sitOnWidth = parentDimension.width //getOneDimensionFromOneOrTwo(parent.dimension).width
            let sitOnLength = parentDimension.length //getOneDimensionFromOneOrTwo(parentDimension).length
            let wheelJointHeight = 100.0//getWheelJointHeight(wheelPart)
            let midDriveRearCasterVerticalJointOrigin = (
                x: sitOnWidth/2 + sideStabilityAtRear,
                y: -sitOnLength/2 + rearStability,
                z: wheelJointHeight)
            let midDriveOrigin = (
                x: sitOnWidth/2 + sideStabilityAtRear,
                y: sitOnLength/2 + rearStability,
                z: wheelJointHeight)
            let xPosition = sitOnWidth/2 + sideStabilityAtRear
                
            switch childPart {
                case
                    .fixedWheelHorizontalJointAtRear,
                    .casterVerticalJointAtRear:
                        origin = [
                            .fixedWheelManualRearDrive: (
                                x: xPosition + 50.0,
                                y: rearStability,
                                z: wheelJointHeight),
                            .fixedWheelFrontDrive: (
                                x: xPosition + 100.0,
                                        y: -sitOnLength + rearStability,
                                        z: wheelJointHeight),
                            .fixedWheelMidDrive: midDriveRearCasterVerticalJointOrigin ][objectType] ?? (
                                        x: xPosition,
                                        y: rearStability,
                                        z: wheelJointHeight)
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
                                x: xPosition,
                                y: 0.0,
                                z: wheelJointHeight) ] [objectType] ?? (
                                x: xPosition,
                                y: (rearStability + frontStability + sitOnLength)/2.0,
                                z: wheelJointHeight)
                case
                    .fixedWheelHorizontalJointAtFront,
                    .casterVerticalJointAtFront:
                        origin = [
                        //    .allCasterTiltInSpaceShowerChair
                            .fixedWheelFrontDrive: (
                                    x: xPosition,
                                    y: frontStability,
                                    z: wheelJointHeight),
                            .fixedWheelMidDrive: (
                                    x: xPosition,
                                    y: sitOnLength/2 + frontStability,
                                    z: wheelJointHeight),
                            .fixedWheelSolo: midDriveOrigin][objectType] ?? (
                                    x: xPosition,
                                    y: sitOnLength + frontStability,
                                    z: wheelJointHeight)
                default:
                    break
            }
            
            setChildOriginForObject(origin)
            
            func getStability(_ stability: Part) -> Double{
                switch stability {
                    case .stabilityAtRear:
                        return
                            [.fixedWheelManualRearDrive: -50.0,
                             .allCasterTiltInSpaceShowerChair: -200.0
                            ][objectType] ?? -30.0
                    case .stabilityAtFront:
                        return
                            [:][objectType] ?? 0.0
                    case .stabilityAtSideAtRear:
                        return
                            [:][objectType] ?? 20.0
                    case .stabilityAtSideAtMid:
                        return
                            [:][objectType] ?? 20.00
                    case .stabilityAtSideAtFront:
                       return
                            [:][objectType] ?? 20.00
                    default:
                        return 0.0
                }
            }
                
                
                    
                    
            func getWheelJointHeight(_ part: Part)
                -> Double {
                    //print(siblings.count)
                    switch siblings.getElement(withPart: part).dimension {
                    case .one (let one):
                       return one.height/2
                    default:
                        return 0.0
                    }
            }
        }
            
            
        func setChildAnglesForObject(
            _ defaultAngles: RotationAngles) {
           //     print("angle set detected with \(defaultAngles)")
                switch oneOrTwoUserEditedValues.angles {
                case .one (let one):
                   // print("one")
                    childAngles =
                        .one(one: one ?? defaultAngles )
                case .two(let left, let right):
                  //  print("Two")
                    childAngles =
                        .two(
                            left: left ?? defaultAngles,
                            right: right ?? defaultAngles)
                }
        }
            
            
        func setChildMinMaxAnglesForObject(
            _ defaultAngles: AnglesMinMax) {
                switch oneOrTwoUserEditedValues.anglesMinMax {
                case .one (let one):
                    childAnglesMinMax =
                        .one(one: one ?? defaultAngles )
                case .two(let left, let right):
                    childAnglesMinMax =
                        .two(
                            left: left ?? defaultAngles,
                            right: right ?? defaultAngles)
                }
        }
            
            
        func setChildDimensionForObject(
            _ defaultDimension: Dimension3d) {
            switch oneOrTwoUserEditedValues.dimension {
                case .one (let one):
                    childDimension = .one(one: one ?? defaultDimension )
                case .two(let left, let right):
                    childDimension = .two(left: left ?? defaultDimension,
                                right: right ?? defaultDimension)
            }
        }
        
        
        func setChildOriginForObject(
            _ defaultOrigin: PositionAsIosAxes) {
            switch oneOrTwoUserEditedValues.origin {
                case .one (let one):
                    childOrigin =
                        .one(one: one ?? defaultOrigin )
                case .two(let left, let right):
                 let leftDefaultOrigin =
                        CreateIosPosition.getLeftFromRight(
                            defaultOrigin)
                    childOrigin =
                        .two(left: left ?? leftDefaultOrigin,
                            right: right ?? defaultOrigin)
            }
        }
        

        func getChildDimension( keyPath: KeyPath<Dimension3d, Double>) -> Double {
            var originDimension = 0.0
            
            switch childDimension {
                case .one(let one):
                    originDimension = one[keyPath: keyPath] / 2
                case .two(let left, let right):
                    originDimension = (left[keyPath: keyPath] + right[keyPath: keyPath]) / 2
            }
            
            return originDimension
        }
    }
}



extension Array where Element == OneOrTwoGenericPartValue {
    func getElement(withPart part: Part) -> OneOrTwoGenericPartValue {
        if let element = self.first(where: { $0.part == part }) {
            return element
        } else {
            //print(self.count)
            fatalError("StructFactory: \(#function) Element with part \(part) not found in [OneOrTwoGenericPartValue]: \(self)].")
        }
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


enum DictionaryVersion {
    case useCurrent
    case useInitial
    case useLoaded
    case useDimension
}



//enum DriveX {
//    case rear
//    case mid
//    case front
//}



                                           

//MARK: UIEditedDictionary
///parts edited by the UI are stored in dictionary
///these dictiionaries are used for parts,
///where extant, instead of default values
///during intitialisation
struct OneOrTwoUserEditedDictionary {
    let dimension: Part3DimensionDictionary
    let parentToPartOrigin: PositionDictionary
    let objectToPartOrigin: PositionDictionary
    let anglesDic: AnglesDictionary
    let anglesMinMaxDic: AnglesMinMaxDictionary
    let partChainId: [PartChain: OneOrTwo<Part> ]
}




///All dictionary are input in userEditedDictionary
///The optional  values associated with a part are available
///dimension
///origin
///The non-optional id are available
///All values are wrapped in OneOrTwoValues
struct OneOrTwoUserEditedValue {
    let dimensionDic: Part3DimensionDictionary
    let parentToPartOriginDic: PositionDictionary
    let objectToPartOriginDic: PositionDictionary
    let anglesDic: AnglesDictionary
    let anglesMinMaxDic: AnglesMinMaxDictionary
    let partChainIdDic: [PartChain: OneOrTwo<Part>]
    let part: Part
    let sitOnId: Part
    
    var originName:  OneOrTwo <String?> = .one(one: nil)

    var angles: OneOrTwo <RotationAngles?> = .one(one: nil)
    var anglesMinMax: OneOrTwo <AnglesMinMax?> = .one(one: nil)
    var dimension: OneOrTwo <Dimension3d?> = .one(one: nil)
    var origin: OneOrTwo <PositionAsIosAxes?> = .one(one: nil)
    var partId: OneOrTwo <Part>
    
    init(
        _ objectType: ObjectTypes,
        _ userEditedDictionary: OneOrTwoUserEditedDictionary,
        _ sitOnId: Part,
        _ childPart: Part) {
            self.sitOnId = sitOnId
            self.part = childPart
            dimensionDic = userEditedDictionary.dimension
            parentToPartOriginDic = userEditedDictionary.parentToPartOrigin
            objectToPartOriginDic = userEditedDictionary.objectToPartOrigin
            anglesDic = userEditedDictionary.anglesDic
            anglesMinMaxDic = userEditedDictionary.anglesMinMaxDic
            
            partChainIdDic = userEditedDictionary.partChainId
            let onlyOne = 0
            let partChain = LabelInPartChainOut([childPart]).partChains[onlyOne]
            partId = //non-optional as must iterate through id
            partChainIdDic[partChain] ?? //UI may edit
            OneOrTWoId(objectType, childPart).forPart // default
            
            dimension =
            getValue(partId, from: dimensionDic) { part in
                return CreateNameFromParts([.sitOn, sitOnId, part]).name }
            
            origin =
            getValue(partId, from: parentToPartOriginDic) { part in
                return CreateNameFromParts([.sitOn, sitOnId, part]).name }
            
            originName = getOriginName(partId)

            angles =
            getValue(partId, from: anglesDic) { part in
                return CreateNameFromParts([.sitOn, sitOnId, part]).name }
            
            anglesMinMax =
            getValue(partId, from: anglesMinMaxDic) { part in
                return CreateNameFromParts([.sitOn, sitOnId, part]).name }
        }
    
    
    func getOriginName(_ partId: OneOrTwo<Part>)
    -> OneOrTwo<String?>{
        let start: [Part] = [.object, .id0, .stringLink, part]
        let end: [Part] = [.stringLink, .sitOn,  sitOnId]
        
   
        switch partId {
        case .one(let one):
            return
                .one(one: CreateNameFromParts(start + [one] + end).name)
        case .two(let left, let right):
            return
                .two(
                    left: CreateNameFromParts(start + [left] + end).name,
                    right:  CreateNameFromParts(start + [right] + end).name)
        }
    }
    
    
    func getValue<T>(
        _ partIds: OneOrTwo<Part>,
        from dictionary: [String: T?],
        using closure: @escaping (Part) -> String)
    -> OneOrTwo<T?> {
        let commonPart = { (id: Part) -> T? in
            dictionary[closure(id)] ?? nil
        }
        
        switch partIds {
        case .one(let oneId):
       
            return .one(one: commonPart(oneId))
        case .two(let left, let right):
            return .two(left: commonPart(left), right: commonPart(right))
        }
    }
}

//    func getDimension(_ partIds: OneOrTwo<Part>)
//    -> OneOrTwo<Dimension3d?> {
//        return getValue(partIds, from: dimensionDic) { id in
//            CreateNameFromParts([.sitOn, sitOnId, part, id]).name
//        }
//    }
//
//
//    func getAngles(_ partIds: OneOrTwo<Part>)
//    -> OneOrTwo<RotationAngles?> {
//        return getValue(partIds, from: anglesDic) { id in
//            CreateNameFromParts([.sitOn, sitOnId, part, id]).name
//        }
//    }
//
//
//    func getAnglesMinMax(_ partIds: OneOrTwo<Part>)
//    -> OneOrTwo<AnglesMinMax?> {
//        return getValue(partIds, from: anglesMinMaxDic) { id in
//            CreateNameFromParts([.sitOn, sitOnId, part, id]).name
//        }
//    }
    

//    func getOrigin(_ partIds: OneOrTwo<Part>)
//    -> OneOrTwo<PositionAsIosAxes?> {
//        print ("DETECT")
//        switch partIds {
//        case .one (let one):
//            print(CreateNameFromParts([.sitOn, sitOnId, part, one]).name)
//        case .two(let left, let right):
//            print(CreateNameFromParts([.sitOn, sitOnId, part, left]).name)
//            print(CreateNameFromParts([.sitOn, sitOnId, part, right]).name)
//        }
//
//        return getValue(partIds, from: parentToPartOriginDic) { id in
//            CreateNameFromParts([.sitOn, sitOnId, part, id]).name
//        }
//    }
//}


///parts edited by the UI are stored in dictionary
///these dictiionaries are used for parts,
///where extant, instead of default values
///during intitialisation
struct UserEditedDictionary {
    let dimension: Part3DimensionDictionary
    let parentToPartOrigin: PositionDictionary
    let objectToPartOrigin: PositionDictionary
    let angleMinMax: AngleMinMaxDictionary
    let angle: AnglesDictionary
    let partChainsId: [PartChain: [[Part]]]
    
}
