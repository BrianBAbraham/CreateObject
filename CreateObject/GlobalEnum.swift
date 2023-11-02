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
                    Self.backSupport + headSupport
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






//[
//    [first chain
//        (part: start of chain, dimension: , origin: , ids: ),
//        .
//        .
//        .
//        (part: end of chain , dimension: , origin: , ids: )
//    ],
//    .
//    .
//    .
//    [last chain
//        (part: start of chain, dimension: , origin: , ids: ),
//        .
//        .
//        .
//        (part: end of chain , dimension: , origin: , ids: )
//    ],
//]
//Source of truth for partDimensionOriginIdsChain
struct PartDimensionOriginIdChains {
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
        [            .fixedWheelHorizontalJointAtMid,
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
    
    var partDimensionOriginIdChains: [PartDimensionOriginIdsChain] = []
   
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
                var partDimensionOriginIdChain: PartDimensionOriginIdsChain = []
                    for part in partChain {
                        let partDimensionOriginId = getPartDimensionOriginId(part)
                        if partDimensionOriginId.count != 0 {
                            partDimensionOriginIdChain.append (partDimensionOriginId[0])
                        }
                    }
                if partDimensionOriginIdChain.count != 0 {
                    partDimensionOriginIdChains.append(partDimensionOriginIdChain)
                }
            }
        }
    }
    


    
   mutating func getPartDimensionOriginId (
    _ part: Part)
        -> PartDimensionOriginIdsChain {
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
                    [(
                    part: part,
                    dimension: occupantBackSupportDefaultDimension.dimension,
                    origin: preTiltOccupantBackSupportDefaultOrigin.origin,
                    ids: [.id0] )]
            case
            .footSupportHangerJoint,
            .footSupportJoint,
            .footSupport,
            .footSupportInOnePiece:
                preTiltOccupantFootSupportDefaultOrigin.reinitialise(part)
                occupantFootSupportDefaultDimension.reinitialise(part)
                return
                    [(
                    part: part,
                    dimension: occupantFootSupportDefaultDimension.dimension,
                    origin: preTiltOccupantFootSupportDefaultOrigin.origin,
                    ids: part == .footSupportInOnePiece ?
                        [.id0]: Self.firstBilateral )]
            case
            .sideSupportRotationJoint,
            .sideSupport:
                preTiltOccupantSideSupportDefaultOrigin.reinitialise(part)
                occupantSideSupportDefaultDimension.reinitialise(part)
                 return
                    [(
                    part: part,
                    dimension: occupantSideSupportDefaultDimension.dimension,
                    origin: preTiltOccupantSideSupportDefaultOrigin.origin,
                    ids: Self.firstBilateral )]
            case .sitOn:
                occupantBodySupportDefaultDimension.reinitialise(.sitOn)
                return
                    [(
                    part: .sitOn,
                    dimension: occupantBodySupportDefaultDimension.dimension,
                    origin: sitOnOrigin,
                    ids: [.id0] )]
            case
            .sitOnTiltJoint:
                preTiltBaseJointDefaultOrigin.reinitialise(part)
                objectBaseConnectionDefaultDimension.reinitialise(part)
                return
                    [(
                    part: part,
                    dimension: Joint.dimension3d,
                    origin: preTiltBaseJointDefaultOrigin.origin,
                    ids: [.id0] )]
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
            
//            print ("\(#function) \(objectBaseConnectionDefaultDimension.dimension) \(part)")
                return
                    [(
                    part: part,
                    dimension: objectBaseConnectionDefaultDimension.dimension,
                    origin: preTiltBaseJointDefaultOrigin.origin,
                    ids: baseConnectionId.ids )]
            default:
                print("\(#function) \(part.rawValue) not found")
                return []
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
                                           


