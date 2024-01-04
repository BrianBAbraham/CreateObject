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
                fatalError()
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
        let oneOfEachPartInAllPartChain = getOneOfEachPartInAllPartChain()

        if oneOfEachPartInAllPartChain.contains(.sitOn) {
            partValuesDic +=
                [.sitOn: initialilseOneOrTwoSitOn()]
        }
        if oneOfEachPartInAllPartChain.contains(.backSupport) {
            initialiseOneOrTwoDependantPart(
                .sitOn,.backSupport )
        }
       
        if oneOfEachPartInAllPartChain.contains(.backSupportHeadSupportJoint) {
            initialiseOneOrTwoDependantPart(
                .backSupport, .backSupportHeadSupportJoint )
        }
        if oneOfEachPartInAllPartChain.contains(.backSupportHeadSupportLink) {
            initialiseOneOrTwoDependantPart(
                .backSupportHeadSupportJoint, .backSupportHeadSupportLink )
        }
        if oneOfEachPartInAllPartChain.contains(.backSupportHeadSupport) {
            initialiseOneOrTwoDependantPart(
                .backSupportHeadSupportLink, .backSupportHeadSupport )
        }

        if oneOfEachPartInAllPartChain.contains(.footSupportHangerLink) {
            initialiseOneOrTwoIndependantPart(
                .footSupportHangerLink )
        }
        for part in oneOfEachPartInAllPartChain {
            switch part {
                case //already initialised
                    .sitOn,
                    .backSupport,
                    .footSupportHangerLink:
                        break
                case //part depends on sitOn
                    .backSupportRotationJoint,
                    .footSupportHangerJoint,
                    .sideSupport,
                    .sideSupportRotationJoint,
                    .sitOnTiltJoint:
                        initialiseOneOrTwoDependantPart(
                            .sitOn, part )
                case
                    .backSupportHeadSupportJoint,
                    .backSupportHeadSupportLink,
                    .backSupportHeadSupport:
                        break
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


    func initialilseOneOrTwoSitOn ()
        -> PartData {
         StructFactory(
            objectType,
            dictionaries)
                 .createOneOrTwoSitOn(
                    nil,
                    nil)
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
            var allPartInThisObject: [Part] = []
            for label in chainLabels {
                allPartInThisObject +=
                getPartChain(label)
            }
           oneOfEachPartInAllChainLabel =
            Array(Set(allPartInThisObject))
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
    
    case casterForkAtRear = "casterForkAtRear"
    case casterForkAtMid = "casterForkAtMid"
    case casterForkAtFront = "casterForkAtFront"
    
    case casterWheelAtRear = "casterWheelAtRear"
    case casterWheelAtMid = "casterWheelAtMid"
    case casterWheelAtFront = "casterWheelAtFront"

    case ceiling = "ceiling"

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
    case footSupportHangerLink = "footSupportHangerLink"
    case footSupportHangerJoint = "footSupportHangerSitOnVerticalJoint"
  
    case joint = "Joint"
    
    case joyStickForOccupant = "occupantControlledJoystick"
 
    case leftToRightDimension = "xIos"
   // case legSupportAngle = "legSupportAngle"

    case object = "object"
    case objectOrigin = "objectOrigin"

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
    
    case sitOnTiltJoint = "tiltInSpaceHorizontalJoint"
    
    case topToBottomDimension = "yIos"
}


enum ObjectTypes: String, CaseIterable {
    
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

    .fixedWheelSolo: [.fixedWheelAtMid] + [.sitOn] + [.sideSupport] ]
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
                    .sideSupportRotationJoint,
                    .casterVerticalJointAtFront,
                    .casterForkAtFront,
                    .casterWheelAtFront:
                
                    return .two(left: .id0, right: .id1)
                
//                case
//                    .casterVerticalJointAtFront,
//                    .casterForkAtFront,
//                    .casterWheelAtFront:
//                    return getIdForFrontAccountingForDriveLocation()
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
                    return .one(one: .id0)
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
        globalOrigin: OneOrTwo<PositionAsIosAxes> =
            .one(one: ZeroValue.iosLocation),
        minMaxAngle: OneOrTwo<AngleMinMax>?,
        angles: OneOrTwo<RotationAngles>?,
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
            self.globalOrigin = globalOrigin
            
            self.id = id
            self.sitOnId = sitOnId
            self.scopesOfRotation = scopesOfRotation
            self.angles = getAngles()
            self.minMaxAngle = getMinMaxAngle()
            

            func getAngles() -> OneOrTwo<RotationAngles> {
                let defaultAngles = ZeroValue.rotationAngles
                guard let angles = angles else {
                    switch id {
                    case .one:
                        return .one(one: defaultAngles)
                    case .two:
                        return .two(left: defaultAngles, right: defaultAngles)
                    }
                }
                return angles
            }

            
            func getMinMaxAngle() -> OneOrTwo<AngleMinMax> {
                let defaultAngles = ZeroValue.angleMinMax
                guard let minMaxAngles = minMaxAngle else {
                    switch id {
                    case .one:
                        return .one(one: defaultAngles)
                    case .two:
                        return .two(left: defaultAngles, right: defaultAngles)
                    }
                }
                return minMaxAngles
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

enum Second<V>{
    case one (one: V)
    case two (two: V)
}

enum First<V>{
case one (one: V?)
case two (two: V?)

func process(_ value: V) -> Second<V> {
    var firstToSecond: Second<V>
       switch self {
    case .one (let one):
           firstToSecond = (.one(one: one ?? value))
    case .two (let two):
           firstToSecond = (.two(two: two ?? value))
    
       }
      return firstToSecond
}
}



//enum OneOrTwoOptional <V> {
//    case two (left:  V?, right: V?)
//    case one (one: V?)
//
//
//    func processOptionalValues<T>(_ value: T) -> OneOrTwo<T> {
//        var optionalToNonOptionalForOne: OneOrTwo<T> = .one(one: ZeroValue.dimension3d as! T)
//        var returnForOne: T
//        var returnForLeft: T
//        var returnForRight: T
//        switch self {
//            case .one(let one):
//                if let one{
//                    returnForOne = value
//                } else {
//                    returnForOne = one as! T
//                }
//                optionalToNonOptionalForOne = .one(one: returnForOne)
//
//                case .two(let left, let right):
//                    if let left {
//                        returnForLeft = value
//                    } else {
//                        returnForLeft = left as! T
//                    }
//                    if let right {
//                        returnForRight = value
//                    } else {
//                        returnForRight = left as! T
//                    }
//                    optionalToNonOptionalForOne = .two(left: returnForLeft, right: returnForRight)
//                }
//            return optionalToNonOptionalForOne
//            }
//}

enum OneOrTwoOptional <V> {
    case two(left: V?, right: V?)
    case one(one: V?)
    
    
    func mapOptionalToNonOptionalOneOrTwo<T>(_ value: T) -> OneOrTwo<T> {
        var optionalToNonOptional: OneOrTwo<T> = .one(one: ZeroValue.dimension3d as! T)
        switch self {
        case .one(let one):
            if let one {
                optionalToNonOptional = .one(one: value)
            } else {
                optionalToNonOptional = .one(one: one as! T)
            }
            
        case .two(let left, let right):
            var returnForLeft: T
            var returnForRight: T
            if let left {
                returnForLeft = value
            } else {
                returnForLeft = left as! T
            }
            if let right {
                returnForRight = value
            } else {
                returnForRight = right as! T
            }
            optionalToNonOptional = .two(left: returnForLeft, right: returnForRight)
        }
        return optionalToNonOptional
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
    
//    var values: (left: T?, right: T?, one: T?) {
//        (left: left, right: right, one: one)
//    }
    
//    func map1() -> T{
//        switch self {
//        case .one(let value):
//            return value
//        case .two(let value, let value):
//            return left: left, right: right)
//        }
//    }
    
    
  static func processOptionalValues(_ oneOrTwo: OneOrTwo<T?>, _ defaultValue: T) -> OneOrTwo<T> {
            switch oneOrTwo {
            case .one(let one):
                if let unwrappedValue = one {
                    return .one(one: unwrappedValue)
                } else {
                    return .one(one: defaultValue)
                }
            case .two(let left , let right ):
                // Check if either value is nil and use the default in that case
                if let unwrappedValue1 = left, let unwrappedValue2 = right {
                    return .two(left: unwrappedValue1, right: unwrappedValue2)
                } else {
                    return .two(left: defaultValue, right: defaultValue)
                }
            }
        }
    

    
    
    func mapSingleOneOrTwoWithOneValue(_ value: T) -> OneOrTwo<T> {
        switch self {
        case .one(let value):
            return .one(one: value)
        case .two(let left, let right):
            return .two(left: left, right: right)
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
    
    
//    func mapSingleOneOrTwoAndOneValue(
//        _ value: (left: T, right: T, one: T))
//    -> (left: T, right: T, one: T) {
//        switch self {
//        case .one(let one):
//            return (left: value.left, right: value.right, one: one)
//        case .two(let left , let right):
//            return
//                (left: left , right: right, one: value.one )
//        }
//    }
    
    
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
        
    func map1WithOneValueAndTwoTransforms<U, V>(
        _ second: V,
        _ transform1: (T, V) -> U,
        _ transform2: (T, V) -> U)
    -> OneOrTwo<U> {
        switch (self) {
        case let (.one(value1)):
            return .one(one: transform1(value1, second))
            
        case let (.two(left1, right1)):
            return .two(
                left: transform2(left1, second),
                right: transform2(right1, second))
        }
    }
       
    func map1WithOneValueAndTwoTransformsWithoutReturn<V>(
         _ second: V,
         _ transform1: (T, V) -> (),
         _ transform2: (T, V) -> ()) {
         switch self {
         case let .one(value1):
             transform1(value1, second)
             
         case let .two(left1, right1):
             transform2(left1, second)
             transform2(right1, second)
         }
     }
    
    func mapWithSingleOneOrTwoAndTwoValueAndTwoTransformWithVoidReturn<U>(
         _ value1: U,
         _ value2: OneOrTwoPositionsAsTuple,
         _ transform1: (T, U, PositionAsIosAxes)  -> (),
         _ transform2: (T, U, PositionAsIosAxes) -> ()) {
         switch self {
         case let .one(one):
             transform1(one, value1, value2.one)
             
         case let .two(left, right):
             transform2(left, value1, value2.left)
             transform2(right, value1, value2.right)
         }
     }
    
    
    func mapWithDoubleOneOrTwoAndOneValueAndTwoTransformWithVoidReturnNew< U>(
         _ value1: U,
         _ value2: OneOrTwo<PositionAsIosAxes>,
         _ transform1: (T, U, PositionAsIosAxes)  -> (),
         _ transform2: (T, U, PositionAsIosAxes) -> ()) {
         switch (self, value2) {
         case let (.one(id), .one(position)):
             transform1(id, value1, position)
         case let (.two(leftId, rightId), .two(leftPosition, rightPosition) ):
             transform2(leftId, value1, leftPosition)
             transform2(rightId, value1, rightPosition)
         default:
             fatalError("\n\n\(String(describing: type(of: self))): \(#function ) the fmap has either one globalPosition and two id or vice versa )")
         }
     }
    



    
    func map3<U, V, W>(_ second: OneOrTwo<V>, _ third: OneOrTwo<W>,_ transform: (T, V, W) -> U) -> OneOrTwo<U> {

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


struct AccessOneOrTwo {
     func getForThreeValues<T, U, W, V>(//enum would not work without this
            _ first: OneOrTwo<T>,
            _ second: OneOrTwo<U>,
            _ third: OneOrTwo<W>,
            _ transform: (T, U, W) -> V)
        -> OneOrTwo<V> {
            first.map3(second, third, transform)
        }
    
   func getFromOneOrTwoEnumMap2<T, U, V>(
            _ first: OneOrTwo<T>,
            _ second: OneOrTwo<U>,
            _ transform: (T, U) -> V)
        -> OneOrTwo<V> {
            first.mapSingleOneOrTwoAndOneFuncWithReturn(second, transform)
        }

    
    func usingSingleOneOrTwoAndOneValueAndTwoTransforms<T, U, V>(
             _ first: OneOrTwo<T>,
             _ second: U,
             _ transform1: (T, U) -> V,
             _ transform2: (T, U) -> V)
         -> OneOrTwo<V> {
             first.map1WithOneValueAndTwoTransforms(second, transform1, transform2)
         }

        
    func usingDoubleOneOrTwoAndOneValueAndTwoTransformsWithVoidReturn< U >(
             _ first: OneOrTwo<Part>,
             _ value1: U,
             _ value2: OneOrTwo<PositionAsIosAxes>,
             _ transform1: (Part, U, PositionAsIosAxes) -> (),
             _ transform2: (Part, U, PositionAsIosAxes) -> ()) {
             first.mapWithDoubleOneOrTwoAndOneValueAndTwoTransformWithVoidReturnNew(
                value1, value2, transform1, transform2)
    }
    
    func usingFiveOneOrTwoAndOneFuncWithVoidReturn(
       _ oneOrTwoDimension: OneOrTwo<Dimension3d>,
       _ oneOrTwoName: OneOrTwo<String>,
       _ oneOrTwoAngle: OneOrTwo<RotationAngles>,
       _ oneOrTwoMinMaxAngle: OneOrTwo<AngleMinMax>,
       _ globalOrigin: OneOrTwo<PositionAsIosAxes>,
       _ transform: (Dimension3d, String, RotationAngles, AngleMinMax, PositionAsIosAxes) -> ()) {
           oneOrTwoDimension.mapFiveOneOrTwoAndToOneFuncWithVoidReturn(
            oneOrTwoName,
            oneOrTwoAngle,
            oneOrTwoMinMaxAngle,
            globalOrigin,
            transform
           )
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
        //let oneOrTwoSitOnId: OneOrTwo<Part> = .one(one: .id0)
            
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
                id: .one(one: .id0) )
            
            
        func getSitOnDimension() -> OneOrTwo<Dimension3d> {
            let dimensionDic: BaseObject3DimensionDictionary =
                [.allCasterStretcher: (width: 600.0, length: 1200.0, height: 10.0),
                 .allCasterBed: (width: 900.0, length: 2000.0, height: 150.0),
                 .allCasterHoist: (width: 0.0, length: 0.0, height: 0.0)
                    ]
            let defaultDimension: Dimension3d = dimensionDic[objectType] ?? (width: 400.0, length: 400.0, height: 10.0)
           // print(defaultDimension)
            
            let optionalDimension = oneOrTwoUserEditedValues.optionalDimension
            
            
//            print(
//            optionalDimension.processOptionalValues(defaultDimension) )
//            print(type(of: optionalDimension.processOptionalValues(defaultDimension)))
//            print( optionalDimension.processOptionalValues(defaultDimension))
        return
            optionalDimension.mapOptionalToNonOptionalOneOrTwo(defaultDimension)
//            OneOrTwo.processOptionalValues(
//                oneOrTwoUserEditedValues.dimension,
//                defaultDimension)
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
                    OneOrTwo.processOptionalValues(oneOrTwoUserEditedValues.origin, defaultOrigin)
                
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
        
        let oneOrTwoUserEditedValues = //optional values apart from id
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
        var childAnglesMinMax: OneOrTwo<AngleMinMax>? = nil
        var childAngles:  OneOrTwo<RotationAngles>? = nil
            
         
        var originName: OneOrTwo<String> = .one(one: "")
        
            setOriginNames()
        if let parent {
            parentDimension = getOneDimensionFromOneOrTwo(parent.dimension)
            
           // print("\(parent.originName) \(parent.childOrigin) "
           //)
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
                
                [.backSupport, .backSupportHeadSupport, .sitOn, .sideSupport, .footSupport],
                [.backSupport, .backSupportHeadSupport,.sideSupport],
                [.sideSupport, .footSupport],
               
                [.backSupport, .backSupportHeadSupport],
                [.backSupport, .backSupportHeadSupport, .sideSupport],

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
            _ defaultAngles: AngleMinMax) {
                
                switch oneOrTwoUserEditedValues.angleMinMax {
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
    var partChainId: [PartChain: OneOrTwo<Part> ]
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
        partChainId: [PartChain : OneOrTwo<Part>] = [:],
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
    let partChainIdDic: [PartChain: OneOrTwo<Part>]
    let part: Part
    let sitOnId: Part
    
    var originName:  OneOrTwo <String?> = .one(one: nil)

    var angles: OneOrTwo <RotationAngles?> = .one(one: nil)
    var angleMinMax: OneOrTwo <AngleMinMax?> = .one(one: nil)
    var dimension: OneOrTwo <Dimension3d?> = .one(one: nil)
    var optionalDimension: OneOrTwoOptional <Dimension3d?> = .one(one: nil)
    var origin: OneOrTwo <PositionAsIosAxes?> = .one(one: nil)
    var partId: OneOrTwo <Part>
    
    init(
        _ objectType: ObjectTypes,
        _ dictionaries: Dictionaries,
        _ sitOnId: Part,
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
            OneOrTWoId(objectType, childPart).forPart // default
            
            
            optionalDimension =
            getOptionalValue(partId, from: dimensionDic) { part in
                return CreateNameFromParts([.sitOn, sitOnId, part]).name }
            
            dimension =
            getValue(partId, from: dimensionDic) { part in
                return CreateNameFromParts([.sitOn, sitOnId, part]).name }
            
            origin =
            getValue(partId, from: parentToPartOriginDic) { part in
                return CreateNameFromParts([.sitOn, sitOnId, part]).name }
            
            originName = getOriginName(partId)

            angles = getAngles()

            angleMinMax =
            getValue(partId, from: angleMinMaxDic) { part in
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
    
    func getAngles() -> OneOrTwo<RotationAngles?>{
        //let z = ZeroValue.rotationAngles
        var angles: OneOrTwo<RotationAngles?> = .one(one: nil)
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
    
    
    func getValue<T>(
        _ partIds: OneOrTwo<Part>,
        from dictionary: [String: T?],
        using closure: @escaping (Part) -> String
    ) -> OneOrTwo<T?> {
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
    
    
    func getOptionalValue<T>(
        _ partIds: OneOrTwo<Part>,
        from dictionary: [String: T?],
        using closure: @escaping (Part) -> String
    ) -> OneOrTwoOptional<T?> {
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


