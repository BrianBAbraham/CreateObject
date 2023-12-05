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
        .backSupporRotationJoint,//origin depends on sitOn dimension
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

protocol PartValues {
    var part: Part {get set}
    var dimension: Dimension3d  {get set}
    var origin: PositionAsIosAxes  {get set}
    var minAngle: RotationAngles  {get set}
    var maxAngle: RotationAngles {get set}
    var id: Part  {get set}
}





///Permits either '.one(one: T)' or '.leftRight(left: T, right: T)
///part data. Thus, left-right differences are enabled in
///for dependencies in the default values.  Thus, for example,
///sideSupport left right differences can be set in the UI and
///these can result in a wider wheel base.
enum Symmetry <T> {
    case leftRight (left: T, right: T)
    case one (one: T)
}

struct Id {
    let forPart: Symmetry<Part>
    
    init(_ part: Part){
       
        forPart = getIdForPart(part)
        
        
        func getIdForPart(_ part: Part)
        -> Symmetry<Part>{
            switch part {
                case
                    .fixedWheelAtRear,
                    .fixedWheelAtMid,
                    .fixedWheelAtFront,
                    .footSupportHangerJoint,
                    .footSupportJoint,
                    .footSupport,
                    .sideSupport,
                    .sideSupportRotationJoint:
                    return .leftRight(left: .id0, right: .id1)
                case .backSupporRotationJoint,
                     .backSupport,
                     .backSupportHeadSupportJoint,
                     .backSupportHeadSupportLink,
                     .backSupportHeadSupport:
                    return .one(one: .id0)
            default :
                fatalError("Id: \(#function) no id has been defined for \(part)")
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
                    .backSupporRotationJoint,
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
    
    var dimension: OneOrTwo<Dimension3d>
    
    var maxDimension: OneOrTwo<Dimension3d>
    
    var minDimension: OneOrTwo<Dimension3d>
    
    var origin: OneOrTwo<PositionAsIosAxes>
    
    var minAngle: OneOrTwo<RotationAngles>
    
    var maxAngle: OneOrTwo<RotationAngles>
    
    var id: OneOrTwo<Part>
    
    init (
        part: Part,
        dimension: OneOrTwo<Dimension3d>,
        maxDimension: OneOrTwo<Dimension3d>? = nil,
        minDimension: OneOrTwo<Dimension3d>? = nil,
        origin: OneOrTwo<PositionAsIosAxes>,
        minAngle: OneOrTwo<RotationAngles>,
        maxAngle: OneOrTwo<RotationAngles>,
        id: OneOrTwo<Part>) {
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


struct GenericPartValue: PartValues {
    var part: Part
    
    var dimension: Dimension3d
    
    var maxDimension: Dimension3d
    
    var minDimension: Dimension3d
    
    var origin: PositionAsIosAxes
    
    var minAngle: RotationAngles
    
    var maxAngle: RotationAngles
    
    var id: Part
    
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
            let dimension = OneOrTwoExtraction(dimension).values[0]
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
        }
            
            
        func getPartOriginForObject(
        _ defaultOrigin: PositionAsIosAxes)
            -> OneOrTwo<PositionAsIosAxes> {
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
            switch parent.dimension {
            case .one (let one):
                parentDimension = one
            case .two :
                fatalError(
                    "StructFactory: \(#function) two sitOn assumed")
            }
        }
        
        
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
                case .backSupporRotationJoint:
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
                    .fixedWheelHorizontalJointAtFront:
                        setChildDimensionForObject(Joint.dimension3d)
                        setWheelBaseJointChildOrigin(childPart)
                case .footSupport:
                        setFootSupportChildDimension()
                        setFootSupportJointChildOrigin()
                
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
                
//                case
//                    .stabilityAtRear,
//                    .stabilityAtFront,
//                    .stabilityAtSideAtRear:
//                        setStabilityOrigin()
                
                
 
                    
                    
                default:
                    fatalError(
                        "StructFactory: \(#function) unkown case of \(childPart)")
            }
        }
                
        func setBackSupportRotationJointOrigin() {
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: -parentDimension.length/2,
                 z: 0.0) )
        }
        
        
        func setBackSupportChildDimension() {
            setChildDimensionForObject(
                [:][objectType] ??
                (width: 20.0, length: parentDimension.width, height: 150.0)
            )
        }
        
        
        func setBackSupportChildOrigin() {
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: -parentDimension.length/2,
                 z: 0.0) )
        }
        
        
        func setBackSupportHeadSupportJointChildOrigin() {
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
            setChildDimensionForObject(
                [.showerTray
                 : (width: 900.0, length: 1200.0, height: 10.0)][objectType] ??
                (width: 50.0, length: 200.0, height: 200.0)  )
        }
            
            
        func setWheelBaseJointChildOrigin(_ wheelPart: Part) {
            var origin = ZeroValue.iosLocation
            let rearStability = getStability(.stabilityAtRear)
            let frontStability = getStability(.stabilityAtFront)
            let sideStabilityAtRear = getStability(.stabilityAtSideAtRear)
            let sideStabilityAtMid = getStability(.stabilityAtSideAtMid)
            let sideStabilityAtFront = getStability(.stabilityAtSideAtFront)
            let sitOnWidth = parentDimension.width
            let sitOnLength = parentDimension.length
            let wheelJointHeight = getWheelJointHeight(wheelPart)
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
                switch getSibling(part).dimension {
                    case .one (let one):
                       return one.height/2
                    default:
                        return 0.0
                }
            }
                
        }
        
            
        func getSibling(_ part: Part)
            -> OneOrTwoGenericPartValue{
            let sibling = siblings.first(where: { $0.part == part })
            if sibling == nil {
                fatalError("\n\nStructFactory: \(#function) \(part) forced uwnrapped ")
                           } else {
                    return sibling!
                }
        }
            
    
        func setFootSupportHangerLinkChildOrigin() {
            setChildOriginForObject(
                [
                    .fixedWheelRearDrive:
                        (x: 0.0,
                         y: parentDimension.length/2,
                         z: 0.0) ][objectType] ??
                (x: 0.0,
                 y: parentDimension.length/2,
                 z: 0.0) )
        }
        
        
        func setFootSupportJointChildOrigin() {
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
                    childOrigin =
                        .two(left: left ?? defaultOrigin,
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

/// objectType: [partLabel: [(Part: PositionAsIosAxis)] ]
///
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
                                           


