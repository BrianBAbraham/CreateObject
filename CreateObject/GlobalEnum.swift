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
    
    //case centreToFront = "centreToFront"
   // case centreHalfWidth = "halfWidthAtCentre"
    //case rearToCentre = "rearToCentre"
   // case rearToFront = "rearToFront"
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


///objects are comprised of  groups of associated parts
///each property povides an array of parts relevant to the group
///in order beginning with the part nearest to object origin
struct PartChainWheelProvider {
    static let casterWheelPartChain: PartChain =
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
        Array( repeating: casterWheelPartChain, count:  2 ).flatMap {$0}
    static let fourCasterParts: [Part] =
        Array( repeating: casterWheelPartChain, count:  4 ).flatMap {$0}
    static let sixCasterParts: [Part] =
        Array( repeating: casterWheelPartChain, count:  6 ).flatMap {$0}
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


//Source of truth for partChain
struct LabelInPartChainOut  {
    static let backSupport: PartChain =
        [
        .sitOn,
        .backSupporRotationJoint,
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
    init(_ parts: [Part]) {
        for part in parts {
            partChains.append (getPartChain(part))
        }
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
        .backSupport,
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
        .backSupporRotationJoint,
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
            .backSupporRotationJoint,
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

protocol PartValues {
    var part: Part {get set}
    var dimension: Dimension3d  {get set}
    var origin: PositionAsIosAxes  {get set}
    var minAngle: RotationAngles  {get set}
    var maxAngle: RotationAngles {get set}
    var id: Part  {get set}
}

//WORKING ON CHAINS IS REQUIRED IF I USE RELATIVE ORIGINS
//CAN I PASS A CHAIN OF PartValue conforming struct
//to instatiate them all?
//extension Object {
//
//    func getInitialiseParts(_ partValues: [PartValues]) {
//        var intialisedParts: [PartValues] = []
//        for partValue in partValues {
//            intialisedParts.append(<#T##newElement: PartValues##PartValues#>)
//        }
//    }
//}

struct StructFactory {
    

    
    
    
    
}

enum Symmetry <T> {
    case leftRight (left: T, right: T)
    case one (one: T)
}


struct GenericPartValue: PartValues {
    var part: Part
    
    var dimension: Dimension3d
    
    var maxDimension: Dimension3d
    
    var minDimension: Dimension3d
    
    var origin: PositionAsIosAxes
    
    var minAngle: RotationAngles
    
    var maxAngle: RotationAngles
    
    var id: Part
    
    //var dimension2: Symmetry<Dimension3d>
    
    init (
        part: Part,
        dimension: Dimension3d,
        maxDimension: Dimension3d? = nil,
        minDimension: Dimension3d? = nil,
        origin: PositionAsIosAxes,
        minAngle: RotationAngles,
        maxAngle: RotationAngles,
        id: Part) {
            self.part = part
            self.dimension = dimension
            self.maxDimension = maxDimension ?? dimension
            self.minDimension = minDimension ?? dimension
            self.origin = origin
            self.minAngle = minAngle
            self.maxAngle = maxAngle
            self.id = id
        }
}


extension StructFactory {
    static func createOneSitOn(
    _ objectType: ObjectTypes,
    _ userEditedDictionary: UserEditedDictionary,
    _ sideSupport: Symmetry<GenericPartValue>?,
    _ footSupportHangerLink: Symmetry<GenericPartValue>?)
        -> Symmetry<GenericPartValue> {
 
        let userEditedValue =
            UserEditedValue(
                userEditedDictionary,
                .id0,
                .sitOn,
                .id0)
        let dimensionDic: BaseObject3DimensionDictionary =
            [.allCasterStretcher: (width: 600.0, length: 1200.0, height: 10.0),
             .allCasterBed: (width: 900.0, length: 2000.0, height: 150.0),
             .allCasterHoist: (width: 0.0, length: 0.0, height: 0.0)
                ]
        let dimension =
                userEditedValue.dimension ??
                dimensionDic[objectType] ??
                (width: 400.0, length: 400.0, height: 10.0)
            
            return
                .one(one: GenericPartValue(
                    part: .sitOn,
                    dimension: dimension,
                    origin: getSitOnOrigin(),
                    minAngle: ZeroValue.rotationAngles ,
                    maxAngle: ZeroValue.rotationAngles,
                    id: .id0) )
            
        func getSitOnOrigin() -> PositionAsIosAxes {
            let bodySupportHeight =
                MiscObjectParameters(objectType).getMainBodySupportAboveFloor()
            let originDic: BaseObjectOriginDictionary = [
                .fixedWheelMidDrive:
                    (x: 0.0, y: 0.0, z: bodySupportHeight ),
                .fixedWheelFrontDrive:
                    (x: 0.0, y: -dimension.length/2, z: bodySupportHeight)]
            
            return
                userEditedValue.origin ??
                originDic[objectType] ??
                (x: 0.0, y: dimension.length/2, z: bodySupportHeight )
        }
    }
}




/// I would like to pass the partChain label
/// the partChain label then creates the structs for those parts

extension StructFactory {
    static func createSitOnDependentPart(
    _ objectType: ObjectTypes,

    _ userEditedDictionary: UserEditedDictionary,
    _ sitOn: Symmetry<GenericPartValue>,
//    _ sideSupport: GenericPart?,
    _ part: Part)
        -> Symmetry<GenericPartValue> {
        //var dimension: Dimension3d = ZeroValue.dimension3d
        var defaultDimension: Dimension3d = ZeroValue.dimension3d
        var maxDimension: Dimension3d = defaultDimension
            var leftRightDimension:  (left: Dimension3d, right: Dimension3d) = (left: ZeroValue.dimension3d, right: ZeroValue.dimension3d)
        var sitOnLength = 0.0
        switch sitOn {
            case .one (let one):
                sitOnLength = one.dimension.length
            default : break
        }
            
        switch part {
            case .sideSupport:
                defaultDimension =
                    [.allCasterStretcher:
                        (width: 20.0,
                         length: sitOnLength,
                         height: 20.0),
                    .allCasterBed:
                        (width: 20.0,
                         length: sitOnLength,
                         height: 20.0),
                    .fixedWheelRearDrive:
                        (width: 20.0,
                         length: sitOnLength,
                         height: 20.0) ][objectType] ??
                        (width: 400.0, length: 400.0, height: 10.0)
                leftRightDimension =
                    getLeftAndRightUserEditedDimensionValues(part, defaultDimension)
        
                
//            case .footSupportInOnePiece:
//                dimension =
//                    [.showerTray: (width: 900.0, length: 1200.0, height: 200.0)] [objectType]
//                    ??
//                    (width: OccupantBodySupportDefaultDimension.general.width,
//                    length: 100.0,
//                    height: 10.0)
            case .footSupportHangerLink:
                    defaultDimension =
                        (width: 20.0, length: 200.0, height: 20.0)
                    maxDimension =
                        (width: 20.0, length: 1200.0, height: 20.0)
                leftRightDimension =
                    getLeftAndRightUserEditedDimensionValues(part, defaultDimension)
            
//            case .baseWheelJoint:
//                    dimension = Joint.dimension3d
//            case .fixedWheelAtRear:
//                    dimension =
//                            [.fixedWheelManualRearDrive:
//                                (width: 20.0,
//                                 length: 600.0,
//                                 height: 600.0)] [objectType] ??
//                                (width: 50.0,
//                                 length: 200.0,
//                                 height: 200.0)
            
            
            /// dep on TwinSitOn
            /// dep on Stability
            /// dep on Drive
            /// dep on id
            /// dep SideSupport
            /// dep on Wheel
            
            
                
            default:
                break
        }
            
            func getLeftAndRightUserEditedDimensionValues(
                _ part: Part, _ defaultDimension: Dimension3d)
                -> (left: Dimension3d, right: Dimension3d) {
                    
                (left: UserEditedValue(userEditedDictionary, .id0, part, .id0).dimension ?? defaultDimension,
                 right: UserEditedValue(userEditedDictionary, .id0, part, .id1).dimension ?? defaultDimension)
            }
            
            
            return
                .leftRight( left:
                                GenericPartValue(
                                    part: part,
                                    dimension: leftRightDimension.left,
                                    maxDimension: maxDimension,
                                    origin: ZeroValue.iosLocation,
                                    minAngle: ZeroValue.rotationAngles,
                                    maxAngle: ZeroValue.rotationAngles,
                                    id: .id0),
                             right:
                                GenericPartValue(
                                    part: part,
                                    dimension: leftRightDimension.right,
                                    maxDimension: maxDimension,
                                    origin: ZeroValue.iosLocation,
                                    minAngle: ZeroValue.rotationAngles,
                                    maxAngle: ZeroValue.rotationAngles,
                                    id: .id1)
                )
                     
    }
}


//extension StructFactory {
//    static func createBaseWheelJointPart(
//        _ objectType: ObjectTypes,
//        _ wheel: Part,
//        _ userEditedDictionary: UserEditedDictionary,
//        _ sitOn: GenericPartValues,
//        _ sideSupport: GenericPartValues?)
//    -> GenericPartValues {
//        var dimension =
//            //userEditedDictionary.dimension[objectType.rawValue] ??
//            ZeroValue.dimension3d
//        var maxDimension: Dimension3d? = nil
//
//        var userEditedValues: [UserEditedValue] = []
//        let ids: [Part] = [.id0,.id1,.id2,.id3,.id4,.id5]
//
//
//
//        return GenericPartValues(
//            part:.baseWheelJoint,
//            dimension: dimension,
//            maxDimension: maxDimension,
//            origin: ZeroValue.iosLocation,
//            minAngle: ZeroValue.rotationAngles,
//            maxAngle: ZeroValue.rotationAngles,
//            ids: [])
//
//
        
        
//        func getWheelBaseJointOrigin() -> [RearMidFrontPositions]{
//            let halfSitOnWidth = sitOn.dimension.width/2
//            let rear =
//                (rear: (
//                     x: halfSitOnWidth +
//                        occupantSideSupportsDimensions[left][right].width +
//                        stability.atRightRear,
//                     y: stability.atRear,
//                     z: wheelDefaultDimensionForRearMidFront.rear.height/2 ),
//                 mid: (
//                     x: halfSitOnWidth +
//                       occupantSideSupportsDimensions[left][right].width +
//                       stability.atRightMid,
//                    y:  sitOnDimensions[onlyOne].length/2 +
//                        stability.atRear ,
//                    z: wheelDefaultDimensionForRearMidFront.mid.height/2 ),
//                 front: (
//                    x: halfSitOnWidth +
//                       occupantSideSupportsDimensions[left][right].width +
//                       stability.atRightFront,
//                    y: stability.atRear +
//                        sitOnDimensions[onlyOne].length +
//                        stability.atFront,
//                    z: wheelDefaultDimensionForRearMidFront.front.height/2 )
//                )
//
//            let mid =
//                (rear: (
//                    x: halfSitOnWidth +
//                       occupantSideSupportsDimensions[left][right].width +
//                       stability.atRightRear,
//                    y: -sitOnDimensions[onlyOne].length/2 -
//                       stability.atRear,
//                    z: wheelDefaultDimensionForRearMidFront.rear.height ),
//                mid: (
//                    x: halfSitOnWidth +
//                      occupantSideSupportsDimensions[left][right].width +
//                      stability.atRightMid,
//                    y:  0.0,
//                   z: wheelDefaultDimensionForRearMidFront.mid.height ),
//                front: (
//                   x: shalfSitOnWidth +
//                      occupantSideSupportsDimensions[left][right].width +
//                      stability.atRightFront,
//                   y: sitOnDimensions[onlyOne].length/2 +
//                       stability.atFront,
//                   z: wheelDefaultDimensionForRearMidFront.rear.height )
//               )
//
//            let front =
//                (rear: (
//                     x: halfSitOnWidth +
//                        occupantSideSupportsDimensions[left][right].width +
//                        stability.atRightRear,
//                     y: stability.atRear -
//                        sitOnDimensions[onlyOne].length -
//                        stability.atFront,
//                     z: wheelDefaultDimensionForRearMidFront.rear.height ),
//                 mid: (
//                     x: halfSitOnWidth +
//                       occupantSideSupportsDimensions[left][right].width +
//                       stability.atRightMid,
//                     y:  -sitOnDimensions[onlyOne].length/2 -
//                     stability.atFront,
//                    z: wheelDefaultDimensionForRearMidFront.mid.height ),
//                 front: (
//                    x: halfSitOnWidth +
//                       occupantSideSupportsDimensions[left][right].width +
//                       stability.atRightFront,
//                    y: 0.0,
//                    z: wheelDefaultDimensionForRearMidFront.rear.height )
//                )
//            return [rear, mid, front]
//        }
        
//    }
//}


//extension StructFactory {
//    static func createIndependentPart(
//    _ objectType: ObjectTypes,
//    _ part: Part)
//        -> GenericPartValues {
//        var dimension = ZeroValue.dimension3d
//            var maxDimension: Dimension3d? = nil
//        switch part {
//
//            default:
//                break
//        }
//            return GenericPartValues(
//                part: part,
//                dimension: dimension,
//                maxDimension: maxDimension,
//                origin: ZeroValue.iosLocation,
//                minAngle: ZeroValue.rotationAngles,
//                maxAngle: ZeroValue.rotationAngles,
//                ids: [])
//    }
//}

//MARK: FootSupport
//struct FeetSupport: PartValues {
//    var part: Part?
//
//    var dimension: Dimension3d
//
//    var origin: PositionAsIosAxes
//
//    var minAngle: RotationAngles
//
//    var maxAngle: RotationAngles
//
//    var ids: [Part]
//
//    let objectType: ObjectTypes
//
//    mutating  func reinitialise(_ part: Part?) {
//          self.part = part
//
//          switch part {
//              case .footSupport:
//                  dimension = getFootSupportInTwoPieces()
//
//              case .footSupportInOnePiece:
//                  dimension = getFootSupportInOnePiece()
//
//              case .footOnly:
//                  dimension = getFootSupportInOnePiece()
//
//          default:
//              break
//          }
//      }
//
//
//
//
//
//}

//extension StructFactory {
//    func createFootSupport(
//    _ objectType: ObjectTypes,
//    _ part: Part)
//        -> FeetSupport {
//
//
//        return FeetSupport(
//            dimension: dimension,
//            origin: ZeroValue.iosLocation,
//            minAngle: ZeroValue.rotationAngles,
//            maxAngle: ZeroValue.rotationAngles,
//            ids: [],
//            objectType: objectType)
//
//
//        func getHangerLink() -> Dimension3d {
//            let dictionary: BaseObject3DimensionDictionary  = [:]
//            let general = (width: 20.0, length: 200.0, height: 20.0)
//            return
//                dictionary[objectType] ?? general
//        }
//
//        func getFootSupportInTwoPieces() -> Dimension3d {
//            let dictionary: BaseObject3DimensionDictionary  = [:]
//            let general = (width: 150.0, length: 100.0, height: 10.0)
//            return
//                dictionary[objectType] ?? general
//        }
//
//        func getFootSupportInOnePiece() -> Dimension3d {
//            let dictionary: BaseObject3DimensionDictionary =
//            [.showerTray: (width: 900.0, length: 1200.0, height: 200.0)]
//            let general =       (
//                width: OccupantBodySupportDefaultDimension.general.width,
//                length: 100.0,
//                height: 10.0)
//
//            return
//                dictionary[objectType] ?? general
//        }
//    }
//}



//struct WheelBaseJoint: PartValues {
//    var part: Part = .sitOn
//
//    var dimension: Dimension3d
//
//    var origin: PositionAsIosAxes
//
//    var minAngle: RotationAngles
//
//    var maxAngle: RotationAngles
//
//    var id: [Part]
//
//    var rearMidFront: Drive
//}




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
                    case .backSupporRotationJoint:
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
                                           


