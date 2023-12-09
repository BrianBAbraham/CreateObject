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

///Tilt acts on one or more part
///The parts affected by the tilt are placed in an array
struct TiltPartChain {
    
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
        chairSupport + rearAndFrontCasterWheels,
    
    .allCasterStretcher:
        [ .sitOn] + rearAndFrontCasterWheels,
    
    .fixedWheelMidDrive:
        chairSupport + [.fixedWheelAtMid] + rearAndFrontCasterWheels,
    
    .fixedWheelFrontDrive:
        chairSupport + [.fixedWheelAtFront],
    
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
    
    //var parentPart: Part
    
    var dimension: OneOrTwo<Dimension3d>
    
    var maxDimension: OneOrTwo<Dimension3d>
    
    var minDimension: OneOrTwo<Dimension3d>
    
    var origin: OneOrTwo<PositionAsIosAxes>
    
    var minAngle: OneOrTwo<RotationAngles>
    
    var maxAngle: OneOrTwo<RotationAngles>
    
    var id: OneOrTwo<Part>
    
    var sitOnId: Part
    
    var scopesOfRotation: [[Part]]
    
    init (
        part: Part,
        dimension: OneOrTwo<Dimension3d>,
        maxDimension: OneOrTwo<Dimension3d>? = nil,
        minDimension: OneOrTwo<Dimension3d>? = nil,
        origin: OneOrTwo<PositionAsIosAxes>,
        minAngle: OneOrTwo<RotationAngles>,
        maxAngle: OneOrTwo<RotationAngles>,
        id: OneOrTwo<Part>,
        sitOnId: Part = .id0,
        scopesOfRotation: [[Part]] = [] ) {
            self.part = part
            self.dimension = dimension
            self.maxDimension = maxDimension ?? dimension
            self.minDimension = minDimension ?? dimension
            self.origin = origin
            self.minAngle = minAngle
            self.maxAngle = maxAngle
            self.id = id
            self.sitOnId = sitOnId
            self.scopesOfRotation = scopesOfRotation
        }
}




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
                dimension: dimension,
                origin: getSitOnOrigin(),
                minAngle: .two(left: ZeroValue.rotationAngles, right: ZeroValue.rotationAngles),
                maxAngle: .two(left: ZeroValue.rotationAngles, right: ZeroValue.rotationAngles),
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
            if let dimension = OneOrTwoExtraction(dimension).values.one {
                let bodySupportHeight =
                    MiscObjectParameters(objectType).getMainBodySupportAboveFloor()
                let originDic: BaseObjectOriginDictionary = [
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
        var maxAngle: OneOrTwo<RotationAngles> = .one(one: ZeroValue.rotationAngles)
        
        if let parent {
            parentDimension = getOneDimensionFromOneOrTwo(parent.dimension)
        }
        
        getChildValues()
            
            
        return
            OneOrTwoGenericPartValue(
                part: childPart,
                dimension: childDimension,
                maxDimension: childDimension,
                origin: childOrigin,
                minAngle: .one(one: ZeroValue.rotationAngles),
                maxAngle: maxAngle,
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
                        setFootSupportJointChildOrigin()
                case .footSupportHangerJoint:
                        setChildDimensionForObject(Joint.dimension3d)
                        setFootSupportHangerJointChildOrigin()
                case .footSupportHangerLink:
                        setChildDimensionForObject(Joint.dimension3d)
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
                        setChildDimensionForObject(Joint.dimension3d)
                        setSitOnTiltJointChildOrigin()
                        setScopesOfRotationForSitOnTiltJoint()
                        setAngleForSitOnTiltJoint()
                
                
                default:
                    fatalError(
                        "StructFactory: \(#function) unkown case of \(childPart)")
            }
        }
        

          func  setAngleForSitOnTiltJoint() {
              let zeroAngle = ZeroValue.angle
              let max = Measurement(value: 60.0, unit: UnitAngle.degrees)
              maxAngle = .one(one:(x: max, y: zeroAngle, z: zeroAngle))
                
            }
            
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
            //let dimension = getOneDimensionFromOneOrTwo(parentDimension)
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: 0.0,
                 z: parentDimension.length/2) )
        }
        
        
        func setBackSupportHeadSupportLinkChildDimension() {
            setChildDimensionForObject(
                [:][objectType] ??
                (width: 20.0, length: 20.0, height: 150.0)
            )
        }
        
        
        func setBackSupportHeadSupportLinkChildOrigin() {
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: 0.0,
                 z: getChildDimension(keyPath: \.height)) )
        }
        
        
        func setBackSupportHeadSupportChildDimension() {
            setChildDimensionForObject(
                [:][objectType] ??
                (width: 150.0, length: 20.0, height: 100.0)
            )
        }
        
        
        func setBackSupportHeadSupportChildOrigin() {
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: 0.0,
                 z: getChildDimension(keyPath: \.height)) )
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
            
            print ("DETECT")

            setChildDimensionForObject(
                [.showerTray
                 : (width: 900.0, length: 1200.0, height: 10.0)][objectType] ??
                (width: 50.0, length: 200.0, height: 200.0)  )
            
            print (childDimension)
        }
            
            
        func setFootSupportHangerJointChildOrigin() {
            setChildOriginForObject(
                [
                    : ][objectType] ??
                (x: parentDimension.width/2.0,
                 y: parentDimension.length/2.0,
                 z: 0.0) )
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
                 y: parentDimension.length,
                 z: 0.0) )
        }

        
       func setFootSupportChildDimension() {
            setChildDimensionForObject(
                [:][objectType] ??
                (width: 150.0, length: 100.0, height: 20.0)
            )
        }
        
        
        func setFootSupportOrigin() {
            let dimensionWidth = getChildDimension( keyPath: \.width)
            setChildOriginForObject(
                [
                    : ][objectType] ??
                (x: dimensionWidth,
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
                 length: parentDimension.length * 2,
                 height: 150.0),
             .fixedWheelRearDrive:
                (width: 20.0,
                 length: parentDimension.length,
                 height: 150.0) ][objectType] ??
            (width: 50.0, length: 400.0, height: 150.0)
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
                     z: originHeight) ][objectType] ??
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
                            .fixedWheelFrontDrive: (
                                        x: xPosition,
                                        y: -sitOnLength + rearStability,
                                        z: wheelJointHeight),
                            .fixedWheelMidDrive: midDriveOrigin,
                            .fixedWheelSolo: midDriveOrigin][objectType] ?? (
                                        x: xPosition,
                                        y: rearStability,
                                        z: wheelJointHeight)
                case
                    .fixedWheelHorizontalJointAtMid,
                    .casterVerticalJointAtMid:
                        origin = [
                            .fixedWheelMidDrive: (
                                x: xPosition,
                                y: rearStability + frontStability,
                                z: wheelJointHeight) ] [objectType] ?? (
                                x: xPosition,
                                y: (rearStability + frontStability + sitOnLength)/2.0,
                                z: wheelJointHeight)
                case
                    .fixedWheelHorizontalJointAtFront,
                    .casterVerticalJointAtFront:
                        origin = [
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



enum Drive {
    case rear
    case mid
    case front
}
                                           


//parts edited by the UI are stored in dictionary
///these dictiionaries are used for parts,
///where extant, instead of default values
///during intitialisation
struct OneOrTwoUserEditedDictionary {
    let dimension: Part3DimensionDictionary
    let parentToPartOrigin: PositionDictionary
    let objectToPartOrigin: PositionDictionary
    let angle: AngleDictionary
    let partChainId: [PartChain: OneOrTwo<Part> ]
    //let partIds: [Part: OneOrTwo<Part>]
}


enum OneOrTwo <T> {
    case two (left: T, right: T)
    case one (one: T)
}


struct OneOrTwoExtraction<T> {
    var values: (left: T?, right: T?, one: T?)

    init (_ oneOrTwo: OneOrTwo<T>) {
        values = extractValues(oneOrTwo)

        func extractValues(_ value: OneOrTwo<T>) -> (left: T?, right: T?, one: T?) {
            switch value {
            case .two(let left, let right):
                return (left: left, right: right, one: nil)
            case .one(let one):
                return (left: nil, right: nil, one: one)
            }
        }
    }
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
    let angleDic: AngleDictionary
    let partChainIdDic: [PartChain: OneOrTwo<Part>]
    let part: Part
    let sitOnId: Part
    var name: String {
        CreateNameFromParts ( [
            .sitOn,
            sitOnId,
            part]
        ).name}
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
        angleDic = userEditedDictionary.angle
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

    func getDimension(_ partIds: OneOrTwo<Part>)
    -> OneOrTwo<Dimension3d?> {
        return getValue(partIds, from: dimensionDic) { id in
            CreateNameFromParts([.sitOn, sitOnId, part, id]).name
        }
    }

    func getOrigin(_ partIds: OneOrTwo<Part>)
    -> OneOrTwo<PositionAsIosAxes?> {
        return getValue(partIds, from: parentToPartOriginDic) { id in
            CreateNameFromParts([.sitOn, sitOnId, part, id]).name
        }
    }
}


///parts edited by the UI are stored in dictionary
///these dictiionaries are used for parts,
///where extant, instead of default values
///during intitialisation
struct UserEditedDictionary {
    let dimension: Part3DimensionDictionary
    let parentToPartOrigin: PositionDictionary
    let objectToPartOrigin: PositionDictionary
    let angle: AngleDictionary
    let partChainsId: [PartChain: [[Part]]]
    
}
