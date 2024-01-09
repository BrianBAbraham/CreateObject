//
//  ObjectCreator.swift
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation

struct ObjectMaker {
    let objectsAndTheirChainLabels: ObjectPartChainLabelsDictionary = ObjectsAndTheirChainLabels().dictionary
    
    let objectsAndTheirChainLabelsDicIn: ObjectPartChainLabelsDictionary
    
    var partValuesDic: [Part: PartData] = [:]
    
    let objectType: ObjectTypes
    
    let dictionaries: Dictionaries

    init(
        _ objectType: ObjectTypes,
        _ userEditedDictionary: Dictionaries,
        _ objectsAndTheirChainLabelsDicIn: ObjectPartChainLabelsDictionary = [:]) {
        
            self.objectType = objectType
            self.dictionaries = userEditedDictionary
            self.objectsAndTheirChainLabelsDicIn =
            objectsAndTheirChainLabelsDicIn
            
            initialiseAllPart()
            
            postProcessGlobalOrigin()
    }
    
    
   mutating func postProcessGlobalOrigin(){
        let allPartChain = getAllPartChain()
        var partsToHaveGlobalOriginSet = getOneOfEachPartInAllPartChain()
      
        for chain in allPartChain {
            processPart( chain)
        }

        func processPart(_ chain: [Part]) {
            for index in 0..<chain.count {
                let part = chain[index]
                if partsToHaveGlobalOriginSet.contains(part){
                let parentGlobalOrigin = getParentGlobalOrigin(index)
                  setGlobalOrigin(part, parentGlobalOrigin)
                  partsToHaveGlobalOriginSet = removePartFromArray(part)
                }
            }
            
            
            func getParentGlobalOrigin(_ index: Int) -> OneOrTwo<PositionAsIosAxes> {
                if index == 0 {
                    return .one(one: ZeroValue.iosLocation)
                } else {
                   let parentPart = chain[index - 1]
                    
                    guard let parentPartValue = partValuesDic[parentPart] else {
                        fatalError()
                    }
                    return parentPartValue.globalOrigin
                }
            }
        }

       
        func getAllPartChain() -> [[Part]]{
            guard let allChainLabel = getAllChainLabel() else {
                fatalError()
            }
            var allPartChain: [[Part]] = []
            for label in allChainLabel {
                allPartChain.append(getPartChain(label))
            }
            return allPartChain
        }

        
       func setGlobalOrigin(_ part: Part, _ parentGlobalOrigin: OneOrTwo<PositionAsIosAxes>) {
            guard let partValue = partValuesDic[part] else {
                fatalError("This part:\(part) has not been intialised where the parent global origin is \(parentGlobalOrigin)")
            }

            let childOrigin = partValue.childOrigin

            let globalOrigin =
                   getGlobalOrigin(childOrigin, parentGlobalOrigin)

            let modifiedPartValue = partValue.withNewGlobalOrigin(globalOrigin)

            partValuesDic[part] = modifiedPartValue
        }
        
        
        func getGlobalOrigin(
            _ childOrigin: OneOrTwo<PositionAsIosAxes>,
            _ parentGlobalOrigin: OneOrTwo<PositionAsIosAxes>)
       -> OneOrTwo<PositionAsIosAxes> {
            let (modifiedChildOrigin, modifiedParentGlobalOrigin) =
            OneOrTwo<Any>.convert2OneOrTwoToAllTwoIfMixedOneAndTwo (childOrigin, parentGlobalOrigin)
                
            return
                modifiedChildOrigin.mapWithDoubleOneOrTwoWithOneOrTwoReturn(modifiedParentGlobalOrigin)
                
        }
       
       
       func removePartFromArray(_ elementToRemove: Part) -> [Part] {
           partsToHaveGlobalOriginSet.filter { $0 != elementToRemove }
       }
    }
}

extension ObjectMaker {
    mutating func initialiseAllPart() {
        let orderedToEnsureParentInitialisedFirst = getOneOfEachPartInAllPartChain()

        for part in orderedToEnsureParentInitialisedFirst {
            switch part {
                case .sitOn:
                    initialilseOneOrTwoSitOn()
                    
                case .backSupport:
                    initialiseOneOrTwoDependantPart(
                        .sitOn,.backSupport )
                case .backSupportHeadSupportJoint:
                    initialiseOneOrTwoDependantPart(
                        .backSupport, .backSupportHeadSupportJoint )
                case .backSupportHeadSupportLink:
                    initialiseOneOrTwoDependantPart(
                        .backSupportHeadSupportJoint, .backSupportHeadSupportLink )
                case .backSupportHeadSupport:
                    initialiseOneOrTwoDependantPart(
                          .backSupportHeadSupportLink, .backSupportHeadSupport )
                case .footSupportHangerLink:
                    initialiseOneOrTwoIndependantPart(
                        .footSupportHangerLink )
                case //part depends on sitOn
                        .backSupportRotationJoint,
                        .footSupportHangerJoint,
                        .sideSupport,
                        .sideSupportRotationJoint,
                        .sitOnTiltJoint:
                            initialiseOneOrTwoDependantPart(
                                .sitOn, part )
                case .footSupport:
                        initialiseOneOrTwoIndependantPart(part)
                case .footSupportJoint:
                        initialiseOneOrTwoDependantPart(.footSupportHangerLink, part )
                case .footSupportInOnePiece, .footOnly:
                            initialiseOneOrTwoIndependantPart(part)
                case
                    .fixedWheelAtRear,
                    .fixedWheelAtMid,
                    .fixedWheelAtFront,
                    .casterWheelAtRear,
                    .casterWheelAtMid,
                    .casterWheelAtFront:
                        initialiseOneOrTwoWheel(part)
                case // all intialised by the wheel
                    .casterForkAtRear,
                    .casterForkAtMid,
                    .casterForkAtFront,
                    .fixedWheelHorizontalJointAtRear,
                    .fixedWheelHorizontalJointAtMid,
                    .fixedWheelHorizontalJointAtFront,
                    .casterVerticalJointAtRear,
                    .casterVerticalJointAtMid,
                    .casterVerticalJointAtFront:
                        break

                default:
                    fatalError( "\n\nDictionary Provider: \(#function) no initialisation defined for this part: \(part)")
            }
        }
    }
    

    mutating func initialiseOneOrTwoWheel(_ oneChainLabel: Part ) {
        let partChain = LabelInPartChainOut(oneChainLabel).partChain
        let partWithJoint: [Part] = [
                .fixedWheelHorizontalJointAtRear,
                .fixedWheelHorizontalJointAtMid,
                .fixedWheelHorizontalJointAtFront,
                .casterVerticalJointAtRear,
                .casterVerticalJointAtMid,
                .casterVerticalJointAtFront]
        var siblings: [PartData] = []
        var jointPart:Part = .notFound

        if let jointIndex = partChain.firstIndex(where: { partWithJoint.contains($0) }) {
            jointPart = partChain[jointIndex]
            for index in 0..<partChain.count {
                let part = partChain[index]
                if index != jointIndex {
                    initialiseOneOrTwoIndependantPart(part)

                    if let values = partValuesDic[part] {
                        siblings.append(values)
                    } else {
                        fatalError( "\n\nDictionary Provider: \(#function) initialisation did not succedd this part: \(part)")
                    }
                }
            }
        }
        initialiseOneOrTwoDependantPart(
            .sitOn,
            jointPart,
            siblings)
    }


    mutating func initialilseOneOrTwoSitOn (){
         let sitOnPartValue =
         StructFactory(
            objectType,
            dictionaries)
                 .createOneOrTwoSitOn(
                    nil,
                    nil)
            
            partValuesDic +=
                [.sitOn: sitOnPartValue]
    }


    mutating func initialiseOneOrTwoDependantPart(
        _ parent: Part,
        _ child: Part,
        _ siblings: [PartData] = []) {
        if let parentValue = partValuesDic[parent] {
            partValuesDic +=
                [child:
                    StructFactory(
                        objectType,
                        dictionaries)
                            .createOneOrTwoDependentPartForSingleSitOn(
                                parentValue,
                                child,
                                []) ]
        } else {
             fatalError( "\n\nDictionary Provider: \(#function) no initialisation defined for this part: \(parent)")
        }
    }


    mutating func initialiseOneOrTwoIndependantPart(_ child: Part) {
        partValuesDic +=
            [child:
                StructFactory(
                   objectType,
                   dictionaries)
                        .createOneOrTwoDependentPartForSingleSitOn(
                            nil,
                            child,
                            []) ]
    }


    func getOneOfEachPartInAllPartChain() -> [Part]{
        let chainLabels = getAllChainLabel()
        var oneOfEachPartInAllChainLabel: [Part] = []
        if let chainLabels{
            for label in chainLabels {
               let partChain = LabelInPartChainOut(label).partChain
                for part in partChain {
                    if !oneOfEachPartInAllChainLabel.contains(part) {
                        oneOfEachPartInAllChainLabel.append(part)
                    }
                }
            }
        }
        return oneOfEachPartInAllChainLabel
    }
    
    func getPartChain(_ label: Part) -> [Part] {
        LabelInPartChainOut(label).partChain
    }
    
    
    func getAllChainLabel() -> [Part]? {
        objectsAndTheirChainLabelsDicIn[objectType] ??
        ObjectsAndTheirChainLabels().dictionary[objectType]
    }
}




//MARK: PART
protocol Parts {
    var stringValue: String { get }
}


enum Part: String, Parts, Hashable {
    typealias AssociatedType = String
    
    var stringValue: String {
        return self.rawValue
    }
    
    
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

    case fixedWheel = "fixedWheel"
    case fixedWheelPropeller = "fixedWheelPropeller"
    
  
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
    case footSupportHangerLink = "footSupportHangerLink"
    case footSupportHangerJoint = "footSupportHangerSitOnVerticalJoint"
  
    case joint = "Joint"
    
    case joyStickForOccupant = "occupantControlledJoystick"

    case objectOrigin = "object"

    case notFound = "notAnyPart"
    
    
    case sitOn = "sitOn"
    case sleepOnSupport = "sleepOn"
    case standOnSupport = "standOn"
    
    case sideSupport = "sideSupport"
    case sideSupportRotationJoint = "sideSupportRotatationJoint"
    case sideSupportJoystick = "sideSupportJoystick"

    case stabilityAtRear = "stabilityAtRear"
    case stabilityAtFront = "stabilityAtFront"
    case stabilityAtSideAtRear = "stabilityAtSideAtRear"
    case stabilityAtSideAtMid = "stabilityAtSideAtMid"
    case stabilityAtSideAtFront = "stabilityAtSideAtFront"
    
    case sitOnTiltJoint = "tiltInSpaceHorizontalJoint"
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}


enum PartTag: String, Parts {
    
    case corner = "corner"
    case id0 = "_id0"
    case id1 = "_id1"
    case stringLink = "_"
    
    var stringValue: String {
        return self.rawValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}


//enum PartJoint: String, Parts {
//
//
//
//
//    var stringValue: String {
//        return self.rawValue
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(rawValue)
//    }
//}



enum ObjectTypes: String, CaseIterable, Hashable {
    
    case allCasterBed = "Bed with caster base"
    case allCasterChair = "Chair with caster base"
    case allCasterHoist = "Hoist with caster base"
    case allCasterSixHoist = "Hoist with caster base and six caster"
    case allCasterTiltInSpaceShowerChair = "Tilting shower chair with caster base"
    case allCasterStandAid = "Stand aid with caster base"
    case allCasterStretcher = "Stretcher with caster Base "
    
//    case bathIntegralHoist = "IntegralBathHoist"
//    case bathFloorFixedHoistOneRotationPoint = "SingleRotationPointBathHoist"
//    case bathFloorFixedHoistTwoRotationPoint = "DoubleRotationPointBathHoist"
    
    
    case fixedWheelFrontDrive = "Power wheelchair with front drive"
    case fixedWheelMidDrive  = "Power wheelchair with mid-drive"
    case fixedWheelRearDrive = "Power wheelchair with rear drive"
    case fixedWheelManualRearDrive = "Self-propelling wheelchair with rear drive"
    case fixedWheelSolo = "Power wheelchair with active balance"
    case fixedWheelTransfer = "Fixed wheel transfer device"
    
//    case hingedDoorSingle = "Door"
//    case hingedDoorDouble = "Bi-FoldDoor"
//    case hingedDoortripple = "Tri-FoldDoor"
//
    case scooterFrontDrive4Wheeler = "Scooter 4 wheel front drive"
    case scooterFrontDrive3Wheeler =  "Scooter 3 wheel front drive"
    case scooterRearDrive4Wheeler  = "Scooter 4 wheel rear drive"
    case scooterRearDrive3Wheeler = "Scooter 3 wheel rear drive"
    
    case seatThatTilts = "Tilting chair"
    
    case showerTray = "Shower tray"
    
    case stairLiftStraight = "Straight stair-lift"
    case stairLiftInternalRadius = "Internal radius stair-lift"
    case stairLiftExternalRaidus = "External radius stair-lift"
    
    case verticalLift = "Vertical Lift"
}



/// provides the object names for the picker
/// provides the chainPartLabels for each object
//MARK: ObjectsChainLabels
struct ObjectsAndTheirChainLabels {
    static let chairSupport: [Part] =
        [.sitOn,
        .backSupportHeadSupport,
        .footSupport,
        .sideSupport,
        .sitOnTiltJoint]
    static let rearAndFrontCasterWheels: [Part] =
        [.casterWheelAtRear, .casterWheelAtFront]
    static let chairSupportWithFixedRearWheel: [Part] =
    chairSupport + [.fixedWheelAtRear]
    
    let dictionary: ObjectPartChainLabelsDictionary =
    [
    .allCasterBed:
        [.sitOn, .sideSupport ],
      
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

    .fixedWheelSolo: [.sitOn] + [.fixedWheelAtMid]  + [.sideSupport] ]
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
        [.footOnly]
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



//MARK: OneOrTwoId
struct OneOrTwoId {
    let forPart: OneOrTwo<PartTag>
    init(_ objectType: ObjectTypes,_ part: Part){
        forPart = getIdForPart(part)
        
        
        func getIdForPart(_ part: Part)
        -> OneOrTwo<PartTag>{
            switch part {
                case  // default not used as case will detect undefined part
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
                    .sideSupportRotationJoint,
                    .casterVerticalJointAtFront,
                    .casterForkAtFront,
                    .casterWheelAtFront:
                
                    return .two(left: PartTag.id0, right: PartTag.id1)
                
                case
                    .backSupportRotationJoint,
                    .backSupport,
                    .backSupportHeadSupportJoint,
                    .backSupportHeadSupportLink,
                    .backSupportHeadSupport,
                    .footSupportInOnePiece,
                    .footOnly,
                    .sitOn,
                    .sitOnTiltJoint:
                    return .one(one: PartTag.id0)
                default :
                fatalError("OneOrTwoId: \(#function)  no id has been defined for \(part)")
            }
        }
    }
}


//MAARK: PARTDATA
struct PartData {
    var part: Part
    
    var originName: OneOrTwo<String>
    
    var dimensionName: OneOrTwo<String>

    var dimension: OneOrTwo<Dimension3d>
    
    var maxDimension: OneOrTwo<Dimension3d>
    
    var minDimension: OneOrTwo<Dimension3d>
    
    var childOrigin: OneOrTwo<PositionAsIosAxes>
    
    var globalOrigin: OneOrTwo<PositionAsIosAxes>
    
    var minMaxAngle: OneOrTwo<AngleMinMax>
    
    var angles: OneOrTwo<RotationAngles>
    
    var id: OneOrTwo<PartTag>
    
    var sitOnId: Parts
    
    var scopesOfRotation: [[Part]]
    
    init (
        part: Part,
        originName: OneOrTwo<String>,
        dimensionName: OneOrTwo<String>,
        dimension: OneOrTwo<Dimension3d>,
        maxDimension: OneOrTwo<Dimension3d>? = nil,
        minDimension: OneOrTwo<Dimension3d>? = nil,
        origin: OneOrTwo<PositionAsIosAxes>,
        globalOrigin: OneOrTwo<PositionAsIosAxes> =
            .one(one: ZeroValue.iosLocation),
        minMaxAngle: OneOrTwo<AngleMinMax>?,
        angles: OneOrTwo<RotationAngles>?,
        id: OneOrTwo<PartTag>,
        sitOnId: PartTag = .id0,
        scopesOfRotation: [[Part]] = [] ) {
            self.part = part
            self.originName = originName
            self.dimensionName = dimensionName
            self.dimension = dimension
            self.maxDimension = maxDimension ?? dimension
            self.minDimension = minDimension ?? dimension
            self.childOrigin = origin
            self.globalOrigin = globalOrigin
            
            self.id = id
            self.sitOnId = sitOnId
            self.scopesOfRotation = scopesOfRotation
            self.angles = getAngles()
            self.minMaxAngle = getMinMaxAngle()
            

            func getAngles() -> OneOrTwo<RotationAngles> {
                guard let unwrapped = angles else {
                    return  id.createOneOrTwoWithOneValue(ZeroValue.rotationAngles)
                }
                return unwrapped
            }

            
            func getMinMaxAngle() -> OneOrTwo<AngleMinMax> {
                guard let unwrapped = minMaxAngle else {
                    return  id.createOneOrTwoWithOneValue(ZeroValue.angleMinMax)
                }
                return unwrapped
            }
        }
}


extension PartData {
  func withNewGlobalOrigin(_ newGlobalOrigin: OneOrTwo<PositionAsIosAxes>) -> PartData {
        var updatedPartData = self
      updatedPartData.globalOrigin = newGlobalOrigin
        return updatedPartData
    }
}




enum OneOrTwoOptional <V> {
    case two(left: V?, right: V?)
    case one(one: V?)
    
    func mapOptionalToNonOptionalOneOrTwo<T>(_ defaultValue: T) -> OneOrTwo<T> {

        var optionalToNonOptional: OneOrTwo<T> = setToParameterType(defaultValue)
        switch self { //assign default to one or left and right if nil
        case .one(let one):
            if let one {
                optionalToNonOptional = .one(one: one as! T)
            } else {
                optionalToNonOptional = .one(one: defaultValue)
           }

        case .two(let left, let right):
            var returnForLeft: T
            var returnForRight: T
            if let left {
                returnForLeft = left as! T
            } else {
                returnForLeft = defaultValue
            }
            if let right {
                returnForRight = right as! T
            } else {
                returnForRight = defaultValue
            }
            optionalToNonOptional =
                .two(left: returnForLeft, right: returnForRight)
        }
        
        return optionalToNonOptional
        
        func setToParameterType<T>(_ defaultValue: T) -> OneOrTwo<T> {
            switch defaultValue {
            case is Dimension3d:
                return OneOrTwo.one(one: ZeroValue.dimension3d) as! OneOrTwo<T>
            case is PositionAsIosAxes:
                return OneOrTwo.one(one: ZeroValue.iosLocation) as! OneOrTwo<T>
            case is RotationAngles:
                return OneOrTwo.one(one: ZeroValue.rotationAngles) as! OneOrTwo<T>
            case is AngleMinMax:
                return OneOrTwo.one(one: ZeroValue.angleMinMax) as! OneOrTwo<T>
            default:
                fatalError()
            }
        }
    }
}



enum OneOrTwo <T> {
    case two (left: T, right: T)
    case one (one: T)
    
    func createOneOrTwoWithOneValue<U>(_ value: U) -> OneOrTwo<U> {
        switch self {
        case .one:
            return .one(one: value)
        case .two:
            return .two(left: value, right: value)
        }
    }
    


//    var left: T? {
//        switch self {
//        case .two(let left, _):
//            return left
//        case .one:
//          return nil
//        }
//    }
//
//    var right: T? {
//        switch self {
//        case .two(_, let right):
//            return right
//        case .one:
//            return nil
//        }
//    }
//
    var one: T? {
        switch self {
        case .two:
            return nil
        case .one(let one):
            return one
        }
    }
    

    func adjustForSymmetry() -> OneOrTwo<T> {
        switch self {
        case .one:
            return self
        case .two (let left, let right):
            //if unequal then the values must have been user edited
            if left as! PositionAsIosAxes == right as! PositionAsIosAxes {
                return .two(left:
                                CreateIosPosition.getLeftFromRight(right as! PositionAsIosAxes) as! T,
                            right: right)
            } else {
                return .two(left: left, right: right)
            }
        }
    }


    
    func mapSingleOneOrTwoWithOneFuncWithReturn<U>(_ transform: (T) -> U) -> OneOrTwo<U> {
        switch self {
        case .one(let value):
            return .one(one: transform(value))
        case .two(let left, let right):
            return .two(left: transform(left), right: transform(right))
        }
    }
    
    
    func mapSingleOneOrTwoAndOneFuncWithReturn<U, V>(
        _ second: OneOrTwo<V>,
        _ transform: (T, V) -> U)
    -> OneOrTwo<U> {
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

    

    func map3New<V, W, U>( _ second: OneOrTwo<V>, _ third: OneOrTwo<W>,_ transform: (T, V, W) -> U) -> OneOrTwo<U> {

       let (first,second, third) = convert3OneOrTwoToAllTwoIfMixedOneAndTwo(self, second, third)
        switch (first, second, third) {
        case let (.one(value1), .one(value2), .one(value3)):
            return .one(one: transform(value1, value2, value3))
        case let (.two(left1, right1), .two(left2, right2), .two(left3, right3)):
            return .two(
                        left: transform(left1, left2, left3),
                        right: transform(right1, right2, right3))
        default:
            // Handle other cases if needed
            fatalError("Incompatible cases for map3")
        }
    }

    
    
  static func convert2OneOrTwoToAllTwoIfMixedOneAndTwo<U, V>(
        _ value1: OneOrTwo<U>,
        _ value2: OneOrTwo<V>
    ) -> (OneOrTwo<U>, OneOrTwo<V>) {
        switch (value1, value2) {
        case let (.one(oneValue), .two):
            return (.two(left: oneValue, right: oneValue), value2)
        case let (.two, .one(oneValue)):
            return (value1, .two(left: oneValue, right: oneValue))
        default:
            return (value1, value2)
        }
    }
    
    
    func convert3OneOrTwoToAllTwoIfMixedOneAndTwo<U, V, W>(
        _ value1: OneOrTwo<U>,
        _ value2: OneOrTwo<V>,
        _ value3: OneOrTwo<W>)
    -> (OneOrTwo<U>, OneOrTwo<V>, OneOrTwo<W>) {
        switch (value1, value2, value3) {
        case let (.one(oneValue), .two, .two):
            return ( .two(left: oneValue, right: oneValue), value2, value3)
        case let (.two, .one(oneValue), .two):
            return (value1, .two(left: oneValue, right: oneValue), value3)
        case let (.one(firstOneValue), .two, .one(secondOneValue)):
            return (.two(left: firstOneValue, right: firstOneValue), value2, .two(left: secondOneValue, right: secondOneValue))
        case let (.two, .two, .one(oneValue)):
            return (value1, value2, .two(left: oneValue, right: oneValue))
        default:
            return (value1, value2, value3)
        }
    }
    
    
    
    func mapWithDoubleOneOrTwoWithOneOrTwoReturn(
        _ value0: OneOrTwo<PositionAsIosAxes>)
    -> OneOrTwo<PositionAsIosAxes> {
        switch (self, value0) {
        case let (.two (left0, right0) , .two(left1, right1)):
            let leftAdd = left0 as! PositionAsIosAxes + left1
            let rightAdd = right0 as! PositionAsIosAxes + right1
            return .two(left: leftAdd, right: rightAdd)
        case let (.one( one0), .one(one1)):
            let oneAdd = one0 as! PositionAsIosAxes + one1
            return .one(one: oneAdd)
        default:
            fatalError("\n\n\(String(describing: type(of: self))): \(#function ) a problem exists with one or both of the OneOrTwo<PositionAsIosAxes>)")
        }
    }

    func mapFiveOneOrTwoAndToOneFuncWithVoidReturn(
         _ value1: OneOrTwo<String>,
         _ value2: OneOrTwo<RotationAngles>,
         _ value3: OneOrTwo<AngleMinMax>,
         _ value4: OneOrTwo<PositionAsIosAxes>,
         _ transform: (Dimension3d, String, RotationAngles, AngleMinMax, PositionAsIosAxes)  -> ()) {
             
          //   print("\(value1), \(value2), \(value3), \(value4) ")
         switch (self, value1, value2, value3, value4) {
         case let (.one(one0), .one(one1), .one(one2), .one(one3), .one(one4)):
             transform(one0 as! Dimension3d, one1, one2, one3, one4)
         
         
         case let (.two(left0, right0), .two(left1, right1), .two(left2, right2), .two(left3, right3), .two(left4, right4) ):
             transform(left0 as! Dimension3d, left1, left2, left3, left4)
             transform(right0 as! Dimension3d, right1, right2, right3, right4)
         default:
             fatalError("\n\n\(String(describing: type(of: self))): \(#function ) the fmap has either one globalPosition and two id or vice versa )")
         }
     }
    
    
}


struct MiscObjectParameters {
    let objectType: ObjectTypes

    init(_ objectType: ObjectTypes) {
        self.objectType = objectType
    }
    
    
    func getMainBodySupportAboveFloor()
    -> Double {
        let forMainBodySupportAboveFloor: [ObjectTypes: Double] =
            [
            .allCasterStretcher: 900.0,
            .allCasterBed: 800.0]
        return
            forMainBodySupportAboveFloor[objectType] ?? 500.0
    }
}


//MARK: StructFactory
struct StructFactory {
    let objectType: ObjectTypes
    let dictionaries: Dictionaries
    
    init(_ objectType: ObjectTypes,
        _ dictionaries: Dictionaries){
        self.objectType = objectType
        self.dictionaries = dictionaries
    }
}


struct KeyPathContainer<T> {
    var left: T?
    var right: T?
    var one: T?
}


extension StructFactory {
    func createOneOrTwoSitOn(
    _ sideSupport: PartData?,
    _ footSupportHangerLink: PartData?)
        -> PartData {
    
        let oneOrTwoUserEditedValues =
            UserEditedValue(
                objectType,
                dictionaries,
                .id0,
                .sitOn)
        
        let dimension = getSitOnDimension()
            
        return
            PartData(
                part: .sitOn,
                originName: .one(one: "object_id0_sitOn_id0_sitOn_id0"),
                dimensionName: .one(one: "object_id0_sitOn_id0_sitOn_id0"),
                dimension: dimension,
                origin: getSitOnOrigin(),

                minMaxAngle: nil,
                angles: nil,
                id: .one(one: PartTag.id0) )
            
            
        func getSitOnDimension() -> OneOrTwo<Dimension3d> {
            let dimensionDic: BaseObject3DimensionDictionary =
                [.allCasterStretcher: (width: 600.0, length: 1200.0, height: 10.0),
                 .allCasterBed: (width: 900.0, length: 2000.0, height: 150.0),
                 .allCasterHoist: (width: 0.0, length: 0.0, height: 0.0)
                    ]
            let defaultDimension: Dimension3d = dimensionDic[objectType] ?? (width: 400.0, length: 400.0, height: 10.0)
 
            let optionalDimension = oneOrTwoUserEditedValues.optionalDimension
            
        return
            optionalDimension.mapOptionalToNonOptionalOneOrTwo(defaultDimension)
        }
            
            
        func getSitOnOrigin() -> OneOrTwo<PositionAsIosAxes> {
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
                
                let defaultOrigin =
                    originDic[objectType] ??
                    (x: 0.0, y: dimension.length/2, z: bodySupportHeight )
                
                
                return
                    oneOrTwoUserEditedValues.optionalOrigin.mapOptionalToNonOptionalOneOrTwo(defaultOrigin)
                
                
            } else {
                fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) sitOn does not have a .one dimension")
            }
            
        }
    }
}


extension StructFactory {
    func createOneOrTwoDependentPartForSingleSitOn(
    _ parent: PartData?,
    _ childPart: Part,
    _ siblings: [PartData])
        -> PartData {
        
        let userEditedValues = //optional values apart from id
                UserEditedValue(
                    objectType,
                    dictionaries,
                    .id0,
                    childPart)
        
        var parentDimension = ZeroValue.dimension3d
        var childDimension: OneOrTwo<Dimension3d> =
                .one(one: ZeroValue.dimension3d)
        var childOrigin: OneOrTwo<PositionAsIosAxes> =
            .one(one: ZeroValue.iosLocation)
        var scopesOfRotation: [[Part]] = []
        var childAnglesMinMax: OneOrTwo<AngleMinMax> =  .one(one: ZeroValue.angleMinMax)
        var childAngles:  OneOrTwo<RotationAngles> = .one(one: ZeroValue.rotationAngles)
        var originName: OneOrTwo<String> = .one(one: "")
        var childId = userEditedValues.partId//two sided default edited to one will be detected
         
            switch childId{
            case .one:
                break
            case .two:
                childAngles = .two(left: ZeroValue.rotationAngles, right: ZeroValue.rotationAngles)
                childAnglesMinMax = .two(left: ZeroValue.angleMinMax, right: ZeroValue.angleMinMax)
            }
        
                
        
        setOriginNames()
            
        if let parent {
            parentDimension = getOneDimensionFromOneOrTwo(parent.dimension)
        }
        
        getChildValues()
            
          
        return
            PartData(
                part: childPart,
                originName: originName,
                dimensionName: originName,
                dimension: childDimension,
                maxDimension: childDimension,
                origin: childOrigin,
                globalOrigin: .one(one: ZeroValue.iosLocation),
                minMaxAngle: childAnglesMinMax,
                angles: childAngles,
                id: childId,
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
        
                case .footSupportInOnePiece, .footOnly:
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
                        setSitOnTiltJointAngles()
                
                
                default:
                    fatalError(
                        "StructFactory: \(#function) unkown case of \(childPart)")
            }
        }
    
      
        func setOriginNames(){
            switch userEditedValues.originName {
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
        
            /// partObjectDicForOrigin: [Part: [object: PositionAsIosAxes]]
            ///partDefaultForOrigin: [Part: PositionAsIosAxes]
            ///,case .sitIOn, ...
            ///childOrigin = partObjectDicForOrigin[part] ?? partDefaultForOrigin[part] or error not defined
            ///part.map(dic1,dc2)
            
        func setBackSupportRotationJointOrigin() {
            setChildOriginForObject(
                [:
                ][objectType] ??
                (x: 0.0,
                 y: -parentDimension.length/2,
                 z: 0.0) )
        }
            
            
            struct PartObjectKey: Hashable {
                var part: Part
                var object: ObjectTypes
            }
            
             
       
        let partObjectDefaultDicForOrigin: [PartObjectKey: PositionAsIosAxes] =
            [PartObjectKey(part: .sitOn, object: .fixedWheelManualRearDrive): (x: 0.0, y: -parentDimension.length/2, z: 0.0)]
            
            
          //  partObjectDefaultDicForOrigin += [.sitOn: []]
        let partDefaultDicForOrigin: [Part: PositionAsIosAxes] = [
            .backSupportRotationJoint: (x: 0.0, y: -parentDimension.length/2, z: 0.0),
            .backSupport: (x: 0.0, y: 0.0, z: getOneDimensionFromOneOrTwo(childDimension).height/2.0 )            ]
        
            
            let partObjectDefaultDicForDimension: [Part: [ObjectTypes: Dimension3d]] = [:]
        let partDefaultDicForDimension: [Part: Dimension3d] = [
            .backSupportRotationJoint: (width: parentDimension.width, length: 20.0 , height: 500.0),]
            
            
            
            
        
        func setBackSupportChildDimension() {
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
             let originLength = getChildOneDimensionSize(keyPath: \.length)
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
             let originHeight = getChildOneDimensionSize(keyPath: \.height)
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
            let dimensionWidth = getChildOneDimensionSize( keyPath: \.width)
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
                
                [.backSupport, .backSupportHeadSupport, .sitOn, .sideSupport, .footSupport],
                [.backSupport, .backSupportHeadSupport,.sideSupport],
                [.sideSupport, .footSupport],
               
                [.backSupport, .backSupportHeadSupport],
                [.backSupport, .backSupportHeadSupport, .sideSupport],

                [.backSupport, .backSupportHeadSupport, .footSupport]
                ]
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
            let originHeight = getChildOneDimensionSize(keyPath: \.height)
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
            let originHeight = getChildOneDimensionSize(keyPath: \.height)
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
            let z = ZeroValue.angle
            let min = Measurement(value: 0.0, unit: UnitAngle.degrees)
            let max = Measurement(value: 60.0, unit: UnitAngle.degrees)
            let minRotationAngle = z
            let maxRotationAngle = max
           
            
            setChildAnglesForObject((x: maxRotationAngle, y: z, z: z))
            setChildMinMaxAnglesForObject((min: minRotationAngle, max: maxRotationAngle))
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
                childAngles = userEditedValues.optionalAngles.mapOptionalToNonOptionalOneOrTwo(defaultAngles)
        }
            
            
        func setChildMinMaxAnglesForObject(
            _ defaultAngles: AngleMinMax) {
                childAnglesMinMax = userEditedValues.optionalAngleMinMax.mapOptionalToNonOptionalOneOrTwo(defaultAngles)
                
        
        }
            
            
        func setChildDimensionForObject(
            _ defaultDimension: Dimension3d) {
                childDimension = userEditedValues.optionalDimension.mapOptionalToNonOptionalOneOrTwo(defaultDimension)
        }
        
        
        func setChildOriginForObject(
            _ defaultOrigin: PositionAsIosAxes) {
                childOrigin = userEditedValues.optionalOrigin.mapOptionalToNonOptionalOneOrTwo(defaultOrigin)
                
                childOrigin = childOrigin.adjustForSymmetry()
        }
        

        func getChildOneDimensionSize( keyPath: KeyPath<Dimension3d, Double>) -> Double {
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



extension Array where Element == PartData {
    func getElement(withPart part: Part) -> PartData {
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
                                          
//MARK: UIEditedDictionary
///parts edited by the UI are stored in dictionary
///these dictiionaries are used for parts,
///where extant, instead of default values
///during intitialisation
///partChainId  are wrapped in OneOrTwo
struct Dictionaries {
    var dimension: Part3DimensionDictionary
    var parentToPartOrigin: PositionDictionary
    var objectToPartOrigin: PositionDictionary
    var anglesDic: AnglesDictionary
    var angleMinMaxDic: AngleMinMaxDictionary
    var partChainId: [PartChain: OneOrTwo<PartTag> ]
    var objectsAndTheirChainLabelsDic: ObjectPartChainLabelsDictionary
    var preTiltObjectToPartFourCornerPerKey: CornerDictionary
    var postTiltObjectToPartFourCornerPerKey: CornerDictionary
    static var shared = Dictionaries()
    
   private init(
        dimension: Part3DimensionDictionary  = [:],
        parentToPartOrigin: PositionDictionary = [:],
        objectToPartOrigin: PositionDictionary = [:],
        anglesDic: AnglesDictionary = [:],
        angleMinMaxDic: AngleMinMaxDictionary = [:],
        partChainId: [PartChain : OneOrTwo<PartTag>] = [:],
        objectsAndTheirChainLabelsDic: ObjectPartChainLabelsDictionary = [:],
        preTiltObjectToPartFourCornerPerKey: CornerDictionary = [:],
        postTiltObjectToPartFourCornerPerKey: CornerDictionary = [:]) {
        self.dimension = dimension
        self.parentToPartOrigin = parentToPartOrigin
        self.objectToPartOrigin = objectToPartOrigin
        self.anglesDic = anglesDic
        self.angleMinMaxDic = angleMinMaxDic
        self.partChainId = partChainId
        self.objectsAndTheirChainLabelsDic = objectsAndTheirChainLabelsDic
        self.preTiltObjectToPartFourCornerPerKey =
            preTiltObjectToPartFourCornerPerKey
        self.postTiltObjectToPartFourCornerPerKey =
            postTiltObjectToPartFourCornerPerKey
    }
}




///All dictionary are input in userEditedDictionary
///The optional  values associated with a part are available
///dimension
///origin
///The non-optional id are available
///All values are wrapped in OneOrTwoValues
struct UserEditedValue {
    let dimensionDic: Part3DimensionDictionary
    let parentToPartOriginDic: PositionDictionary
    let objectToPartOriginDic: PositionDictionary
    let anglesDic: AnglesDictionary
    let angleMinMaxDic: AngleMinMaxDictionary
    let partChainIdDic: [PartChain: OneOrTwo<PartTag>]
    let part: Part
    let sitOnId: PartTag
    
    var originName:  OneOrTwo <String?> = .one(one: nil)
    var optionalAngles: OneOrTwoOptional <RotationAngles> = .one(one: nil)
    var optionalAngleMinMax: OneOrTwoOptional <AngleMinMax> = .one(one: nil)
    var optionalDimension: OneOrTwoOptional <Dimension3d> = .one(one: nil)
    var optionalOrigin: OneOrTwoOptional <PositionAsIosAxes> = .one(one: nil)
    var partId: OneOrTwo <PartTag>
    
    init(
        _ objectType: ObjectTypes,
        _ dictionaries: Dictionaries,
        _ sitOnId: PartTag,
        _ childPart: Part) {
            self.sitOnId = sitOnId
            self.part = childPart
            dimensionDic = dictionaries.dimension
            parentToPartOriginDic = dictionaries.parentToPartOrigin
            objectToPartOriginDic = dictionaries.objectToPartOrigin
            anglesDic = dictionaries.anglesDic
            angleMinMaxDic = dictionaries.angleMinMaxDic

            partChainIdDic = dictionaries.partChainId
            let onlyOne = 0
            let partChain = LabelInPartChainOut([childPart]).partChains[onlyOne]
            partId = //non-optional as must iterate through id
            partChainIdDic[partChain] ?? //UI may edit
            OneOrTwoId(objectType, childPart).forPart // default
            
            
            optionalDimension =
            getOptionalValue(partId, from: dimensionDic) { part in
                return CreateNameFromParts([Part.sitOn, sitOnId, part]).name }
            
            optionalOrigin =
            getOptionalValue(partId, from: parentToPartOriginDic) { part in
                return CreateNameFromParts([Part.sitOn, sitOnId, part]).name }
            
            originName = getOriginName(partId)

          
            
            optionalAngleMinMax =
            getOptionalValue(partId, from: angleMinMaxDic) { part in
                return CreateNameFromParts([Part.sitOn, sitOnId, part]).name }
            
            optionalAngles = getOptionalAngles()

        }
    
    
    func getOriginName(_ partId: OneOrTwo<PartTag>)
    -> OneOrTwo<String?>{
        let start: [Parts] = [Part.objectOrigin, PartTag.id0, PartTag.stringLink, part]
        let end: [Parts] = [PartTag.stringLink, Part.sitOn,  sitOnId]
        
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
    
    
    func getOptionalAngles() -> OneOrTwoOptional<RotationAngles>{
        var angles: OneOrTwoOptional<RotationAngles> = .one(one: nil)
        switch originName {
        case .one(let one):
            angles =
                .one(one: anglesDic[one ?? ""] )
        case .two(let left, let right):
            angles =
                .two(left: anglesDic[ left ?? ""]  , right: anglesDic[right ?? ""] )
        }
        return angles
    }
        
    func getOptionalValue<T>(
        _ partIds: OneOrTwo<PartTag>,
        from dictionary: [String: T?],
        using closure: @escaping (PartTag) -> String
    ) -> OneOrTwoOptional<T> {
        let commonPart = { (id: PartTag) -> T? in
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


