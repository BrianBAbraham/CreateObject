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
        .sideSupportRotationJoint,
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
    
    .fixedWheelSolo: [.fixedWheelAtMid] + [.sitOn]
    ]
        
}



/// Object.chains: [ [ObjectValues]  ]
/// where ObjectValues has object properties
struct Object {
    var objectsAndTheirChainLabels: ObjectPartChainLabelsDictionary {
        ObjectsAndTheirChainLabels().dictionary
    }
    //var labelInPartChainOut: LabelInPartChainOut
    //DIMENSIONS
    var occupantBodySupportDefaultDimension: OccupantBodySupportDefaultDimension
    var occupantBackSupportDefaultDimension:
        OccupantBackSupportDefaultDimension
    var occupantSideSupportDefaultDimension:
        OccupantSideSupportDefaultDimension
    var occupantFootSupportDefaultDimension:
        OccupantFootSupportDefaultDimension
    var objectBaseConnectionDefaultDimension:
        ObjectBaseConnectionDefaultDimension
    
    ///ORIGINS
    var sitOnOrigin: PositionAsIosAxes = ZeroValue.iosLocation
    var preTiltOccupantBackSupportDefaultOrigin:
        PreTiltOccupantBackSupportDefaultOrigin
    var preTiltOccupantSideSupportDefaultOrigin:
        PreTiltOccupantSideSupportDefaultOrigin
    var preTiltOccupantFootSupportDefaultOrigin:
        PreTiltOccupantFootSupportDefaultOrigin
    var preTiltBaseJointDefaultOrigin:
        PreTiltBaseJointDefaultOrigin
    var baseConnectionId: BaseConnectionId
    let objectType: ObjectTypes
    
    
    static let firstBilateral: [Part] = [.id0, .id1]

    static let backSupport: PartChain =
        [
        .sitOn,
        .backSupportRotationJoint,
        .backSupport]
    let foot: PartChain =
        [
         .sitOn,
        .footSupportHangerJoint,
        .footSupportJoint,
        .footSupport
        ]
    let footOnly: PartChain =
        [.footSupportInOnePiece]
    let headSupport: PartChain =
        [
        .backSupportHeadSupportJoint,
        .backSupportHeadSupportLink,
        .backSupportHeadSupport
        ]
   static let sideSupport: PartChain =
        [
        .sitOn,
        .sideSupportRotationJoint,
        .sideSupport]
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
    static let casterWheelAtFront: PartChain =
        [
        .casterVerticalJointAtFront,
        .casterForkAtFront,
        .casterWheelAtFront
        ]
    let onlyOne = 0
    
    /// An arrray
    /// containing an array of PartDimensionOriginIds
    /// with data for parts from object origin to terminal part
    var partData: PartData =
        PartData(
            part: .notFound,
            dimension: ZeroValue.dimension3d,
            origin: ZeroValue.iosLocation,
            ids:  [],
            angles: ZeroValue.rotationAngles)
    var partDataChain: [PartData] = []
    
    ///[PartDataChain]
    var allPartDataChain: [PartDataChain] = []
    
    ///all partDataTuple but not organised as chain
    var allPartDataTuple: [PartDataTuple] = []
    ///all partDataTuple orgainised into chain
    var partDataTupleChain: [[PartDataTuple]] = []
    
    init(_ objectType: ObjectTypes) {
        self.objectType = objectType
   
        
        //Preliminary Initialisation of All Dimensions
        occupantBodySupportDefaultDimension =
            OccupantBodySupportDefaultDimension(objectType)
        occupantBackSupportDefaultDimension =
            OccupantBackSupportDefaultDimension(objectType)
        occupantSideSupportDefaultDimension =
            OccupantSideSupportDefaultDimension(objectType)
        occupantFootSupportDefaultDimension =
            OccupantFootSupportDefaultDimension(objectType)
        objectBaseConnectionDefaultDimension =
            ObjectBaseConnectionDefaultDimension(objectType)
                
        //Preliminary Initialisation of All Origins
        preTiltOccupantBackSupportDefaultOrigin =
            PreTiltOccupantBackSupportDefaultOrigin(objectType)
        preTiltOccupantSideSupportDefaultOrigin =
            PreTiltOccupantSideSupportDefaultOrigin(objectType)
        preTiltOccupantFootSupportDefaultOrigin =
            PreTiltOccupantFootSupportDefaultOrigin(objectType)
        preTiltBaseJointDefaultOrigin =
            PreTiltBaseJointDefaultOrigin(objectType)
            
        baseConnectionId = BaseConnectionId(objectType)
            
        //Build array of chain
        if let chainLabels = objectsAndTheirChainLabels[objectType] {
            
            if chainLabels.contains(.sitOn){
                sitOnOrigin =
                    PreTiltSitOnAndWheelBaseJointOrigin(objectType).sitOnOrigins.onlyOne [onlyOne]
            }
            for chainLabel in chainLabels {
                let partChain =
                    LabelInPartChainOut([chainLabel]).partChains[onlyOne]
                //empty chain for each chain label
                for part in partChain {
                    let partDimensionOriginId = getPartDataTuple(part)
                    partData =
                        PartData(
                            part: partDimensionOriginId.part,
                            dimension: partDimensionOriginId.dimension,
                            origin: partDimensionOriginId.origin,
                            ids:  partDimensionOriginId.ids,
                            angles: ZeroValue.rotationAngles)
                    if partDimensionOriginId.part != ZeroValue.partDataTouple.part {
                        partDataChain.append(partData)
                    }
                }
                if partDataChain.count != 0 {
                    allPartDataChain.append(PartDataChain(partDataChain))
                }
                partDataChain = []
            }
        }
        
        allPartDataTuple = getAllPartDataTupleWithNoDuplicates()
        partDataTupleChain = getAllPartDataChainAsTuple()
        
        
        func getAllPartDataTupleWithNoDuplicates()
            -> [PartDataTuple] {
            var allPartDataTuple: [PartDataTuple] = []
            for partDataChain in allPartDataChain {
               allPartDataTuple +=
                    partDataChain.manyPartDataTuple
            }
                
                func removeDuplicates ()
                    -> [PartDataTuple]{
                    let inputData: [PartDataTuple] = allPartDataTuple
                    // Create a custom comparator function
                    func areEqual(_ lhs: PartDataTuple, _ rhs: PartDataTuple)
                        -> Bool {
                        // Implement your comparison logic here
                        return lhs.part == rhs.part
                    }

                    var uniqueData: [PartDataTuple] = []

                    for item in inputData {
                        if !uniqueData.contains(where: { areEqual($0, item) }) {
                            uniqueData.append(item)
                        }
                    }
                    return uniqueData
                }
                return removeDuplicates()
        }
        
        
        // chainAsTouple
        //[ // last part is the chainLabel
        //    [//first [PartDataTuple]]
        //        (part: start of chain, dimension: , origin: , ids: ), //PartDimensionOriginIds
        //        .
        //        .
        //        .
        //        (part: end of chain , dimension: , origin: , ids: )
        //    ],
        //    .
        //    .
        //    .
        //    [//last [PartDataTuple]]
        //        (part: start of chain, dimension: , origin: , ids: ),
        //        .
        //        .
        //        .
        //        (part: end of chain , dimension: , origin: , ids: )
        //    ],
        //]
        func getAllPartDataChainAsTuple()
            -> [[PartDataTuple]] {
            let objectChains = allPartDataChain
            var chainsAsTouple: [[PartDataTuple]] = []
            for objectChain in objectChains {
                var chainAsTouple: [PartDataTuple] = []
                for part in objectChain.chain {
                    chainAsTouple.append( (
                        part: part.part,
                        dimension: part.dimension,
                        origin: part.origin,
                        ids: part.ids,
                        angles: part.angles) )
                }
                chainsAsTouple.append(chainAsTouple)
            }
            return chainsAsTouple
        }
        
    }
    
//MARK: -NEW
///this would be come a for loop for an array of the part in object without duplicates
    /// only object woudl be passed
    
   mutating func getPartDataTuple (
    _ part: Part)
        -> PartDataTuple {
        switch part {
            case
            .backSupportRotationJoint,
            .backSupport,
            .backSupportHeadSupportJoint,
            .backSupportHeadSupportLink,
            .backSupportHeadSupport:
                preTiltOccupantBackSupportDefaultOrigin.reinitialise(part)
                occupantBackSupportDefaultDimension.reinitialise(part)
                return
                    (
                    part: part,
                    dimension: occupantBackSupportDefaultDimension.dimension,
                    origin: preTiltOccupantBackSupportDefaultOrigin.origin,
                    ids: [.id0],
                    angles: ZeroValue.rotationAngles)
            case
            .footSupportHangerJoint,
            .footSupportHangerLink,
            .footSupportJoint,
            
            .footSupport,
            .footSupportInOnePiece:
                preTiltOccupantFootSupportDefaultOrigin.reinitialise(part)
                occupantFootSupportDefaultDimension.reinitialise(part)
                return
                    (
                    part: part,
                    dimension: occupantFootSupportDefaultDimension.dimension,
                    origin: preTiltOccupantFootSupportDefaultOrigin.origin,
                    ids: part == .footSupportInOnePiece ?
                        [.id0]: Self.firstBilateral,
                    angles: ZeroValue.rotationAngles)
            case
            .sideSupportRotationJoint,
            .sideSupport:
                preTiltOccupantSideSupportDefaultOrigin.reinitialise(part)
                occupantSideSupportDefaultDimension.reinitialise(part)
                 return
                    (
                    part: part,
                    dimension: occupantSideSupportDefaultDimension.dimension,
                    origin: preTiltOccupantSideSupportDefaultOrigin.origin,
                    ids: Self.firstBilateral,
                    angles: ZeroValue.rotationAngles)

            case
            .sitOn:
                occupantBodySupportDefaultDimension.reinitialise(.sitOn)
                return
                    (
                    part: .sitOn,
                    dimension: occupantBodySupportDefaultDimension.dimension,
                    origin: sitOnOrigin,
                    ids: [.id0] ,
                    angles: ZeroValue.rotationAngles)

            case
            .sitOnTiltJoint:
                preTiltBaseJointDefaultOrigin.reinitialise(part)
                objectBaseConnectionDefaultDimension.reinitialise(part)
                return
                    (
                    part: part,
                    dimension: Joint.dimension3d,
                    origin: preTiltBaseJointDefaultOrigin.origin,
                    ids: [.id0],
                    angles: ZeroValue.rotationAngles )

            case
            .fixedWheelAtRear,
            .fixedWheelHorizontalJointAtRear,
            .fixedWheelHorizontalJointAtMid,
            .fixedWheelAtMid,
            .fixedWheelHorizontalJointAtFront,
            .fixedWheelAtFront,
            .casterVerticalJointAtRear,
            .casterForkAtRear,
            .casterWheelAtRear,
            .casterVerticalJointAtMid,
            .casterForkAtMid,
            .casterWheelAtMid,
            .casterVerticalJointAtFront,
            .casterForkAtFront,
            .casterWheelAtFront:
                preTiltBaseJointDefaultOrigin.reinitialise(part)
                objectBaseConnectionDefaultDimension.reinitialise(part)
                baseConnectionId.reinialise(part)
            
                return
                    (
                    part: part,
                    dimension: objectBaseConnectionDefaultDimension.dimension,
                    origin: preTiltBaseJointDefaultOrigin.origin,
                    ids: baseConnectionId.ids,
                    angles: ZeroValue.rotationAngles )

            default:
                print("\(#function) \(part.rawValue) not found")
                return ZeroValue.partDataTouple
        }
    }
}


extension Object {
    ///all data for the part
    struct PartData {
        let part: Part
        let dimension: Dimension3d
        let origin:PositionAsIosAxes
        let ids: [Part]
        let angles: RotationAngles
        
        ///Alternative data strructure
        var partDataTuple: PartDataTuple {
            (part: part,
             dimension: dimension,
             origin: origin,
             ids: ids,
             angles: angles)
        }
    }
    
    
    ///A array of partData in a chain
    ///from origin to the part
    struct PartDataChain {
        let chain: [PartData]
        let lastPart: Part
        var manyPartDataTuple: [PartDataTuple] = []
        init(_ chain: [PartData]) {
            self.chain = chain
            lastPart = chain.last?.part ?? .notFound
            getManyPartDataTuple()
            
            func getManyPartDataTuple() {
                for partData in chain {
                    manyPartDataTuple.append(partData.partDataTuple)
                }
            }
        }
    }
}




struct OneOrTWoId {
    let forPart: OneOrTwo<Part>
    
    init(_ part: Part){
       
        forPart = getIdForPart(part)
        
        func getIdForPart(_ part: Part)
        -> OneOrTwo<Part>{
            switch part {
                case
                    .casterForkAtRear,
                    .casterForkAtMid,
                    .casterForkAtFront,
                    .casterVerticalJointAtRear,
                    .casterVerticalJointAtMid,
                    .casterVerticalJointAtFront,
                    .casterWheelAtRear,
                    .casterWheelAtMid,
                    .casterWheelAtFront,
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
    
    init (
        part: Part,
        //parentPart: Part = .object,
        dimension: OneOrTwo<Dimension3d>,
        maxDimension: OneOrTwo<Dimension3d>? = nil,
        minDimension: OneOrTwo<Dimension3d>? = nil,
        origin: OneOrTwo<PositionAsIosAxes>,
        minAngle: OneOrTwo<RotationAngles>,
        maxAngle: OneOrTwo<RotationAngles>,
        id: OneOrTwo<Part>,
        sitOnId: Part = .id0) {
            self.part = part
            //self.parentPart = parentPart
            self.dimension = dimension
            self.maxDimension = maxDimension ?? dimension
            self.minDimension = minDimension ?? dimension
            self.origin = origin
            self.minAngle = minAngle
            self.maxAngle = maxAngle
            self.id = id
            self.sitOnId = sitOnId
        }
}





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
                    oneOrTwoUserEditedDictionary,
                    .id0,
                    childPart)
        
        var parentDimension = ZeroValue.dimension3d
        var childDimension: OneOrTwo<Dimension3d> =
                .one(one: ZeroValue.dimension3d)
        var childOrigin: OneOrTwo<PositionAsIosAxes> =
            .one(one: ZeroValue.iosLocation)
        
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
                minAngle: .two(left: ZeroValue.rotationAngles, right: ZeroValue.rotationAngles),
                maxAngle: .two(left: ZeroValue.rotationAngles, right: ZeroValue.rotationAngles),
                id: OneOrTWoId(childPart).forPart  )
        
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
                    break

                default:
                    fatalError(
                        "StructFactory: \(#function) unkown case of \(childPart)")
            }
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
                (width: 20.0, length: parentDimension.width, height: 150.0)
            )
        }
        
        
        func setBackSupportChildOrigin() {
            //let dimension = getOneDimensionFromOneOrTwo(parentDimension)
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: -parentDimension.length/2,
                 z: 0.0) )
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
             .fixedWheelRearDrive:
                (width: 20.0,
                 length: parentDimension.length,
                 height: 150.0) ][objectType] ??
            (width: 20.0, length: 400.0, height: 150.0)
            )
        }
        
        
        func setSideSupportChildOrigin () {
            //let dimension = getOneDimensionFromOneOrTwo(parentDimension)
            let originHeight = getChildDimension(keyPath: \.height)
            setChildOriginForObject(
                [.allCasterStretcher:
                    (x: 0.0,
                     y: parentDimension.length/2,
                     z: originHeight),
                 .allCasterBed:
                    (x: 0.0,
                     y: parentDimension.length/2,
                     z: originHeight),
                 .fixedWheelRearDrive:
                    (x: 0.0,
                     y: parentDimension.length/2,
                     z: originHeight) ][objectType] ??
                (x: 0.0,
                 y: parentDimension.length/2,
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

//partChainLabel: ids for each part in partChain for that label
struct PartChainsIdDictionary {
    var dic: [PartChain : [[Part]] ] = [:]
    let sitOnId : Part
    let bilateral: [Part] = [.id0, .id1]
    init (_ partChains: [PartChain], _ sitOnId: Part ) {
        self.sitOnId = sitOnId
        
        getId(partChains)
        
        //the number of id always match the partChain
        func getId (_ partChains: [PartChain]) {
            for chain in partChains {
                var ids: [[Part]] = []
                for part in chain {
                    ids.append(getId(part))
                }
                dic += [chain: ids]
            }
            
            func getId(_ part: Part) -> [Part] {
                var ids: [Part] = []
                switch part {
                    case .sitOn:
                        ids = [sitOnId]
                    case .backSupportRotationJoint:
                        ids = [.id0]
                    case .backSupport:
                        ids = [.id0]
                    case .backSupportHeadLinkRotationJoint:
                        ids = [.id0]
                    case .backSupportHeadSupportLink:
                        ids = [.id0]
                    case .backSupportHeadSupport:
                        ids = [.id0]
                    case .footOnly:
                        ids = [.id0]
                    default:
                        ids = bilateral
                }
                return ids
            }
        }
    }
}

enum Drive {
    case rear
    case mid
    case front
}
                                           


