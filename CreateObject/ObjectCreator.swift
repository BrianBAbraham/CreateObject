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
     // print(partsToHaveGlobalOriginSet)
        for chain in allPartChain {
            processPart( chain)
        }

        func processPart(_ chain: [Part]) {
            for index in 0..<chain.count {
                let part = chain[index]
                if partsToHaveGlobalOriginSet.contains(part){
                let parentGlobalOrigin = getParentGlobalOrigin(index)
//                    if part  == .fixedWheelAtRear {
//                        print(parentGlobalOrigin)
//                    }
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
                    initialiseDependantPart(
                        .sitOn,.backSupport )
                case .backSupportHeadSupportJoint:
                    initialiseDependantPart(
                        .backSupport, .backSupportHeadSupportJoint )
                case .backSupportHeadSupportLink:
                    initialiseDependantPart(
                        .backSupportHeadSupportJoint, .backSupportHeadSupportLink )
                case .backSupportHeadSupport:
                    initialiseDependantPart(
                          .backSupportHeadSupportLink, .backSupportHeadSupport )
                case .footSupportHangerLink:
                    initialiseIndependentPart(
                        .footSupportHangerLink )
                case //part depends on sitOn
                        .backSupportRotationJoint,
                        .footSupportHangerJoint,
                        .sideSupport,
                        .sideSupportRotationJoint,
                        .sitOnTiltJoint:
                            initialiseDependantPart(
                                .sitOn, part )
                case .footSupport:
                        initialiseIndependentPart(part)
                case .footSupportJoint:
                        initialiseDependantPart(.footSupportHangerLink, part )
                case .footSupportInOnePiece, .footOnly:
                            initialiseIndependentPart(part)
                
                case  .fixedWheelHorizontalJointAtRear,
                    .fixedWheelHorizontalJointAtMid,
                    .fixedWheelHorizontalJointAtFront,
                    .casterVerticalJointAtRear,
                    .casterVerticalJointAtMid,
                    .casterVerticalJointAtFront:
                initialiseDependantPart(.sitOn, part)
                
                case
                    .fixedWheelAtRear,
                    .fixedWheelAtMid,
                    .fixedWheelAtFront,
                    .casterWheelAtRear,
                    .casterWheelAtMid,
                    .casterWheelAtFront,
                    .casterForkAtRear,
                    .casterForkAtMid,
                    .casterForkAtFront:
                initialiseIndependentPart(part)
                default:
                    fatalError( "\n\nDictionary Provider: \(#function) no initialisation defined for this part: \(part)")
            }
        }
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


    mutating func initialiseDependantPart(
        _ parent: Part,
        _ child: Part
//        ,
//        _ siblings: [PartData] = []
    ) {
        if let parentValue = partValuesDic[parent] {
            partValuesDic +=
                [child:
                    StructFactory(
                        objectType,
                        dictionaries)
                            .createOneOrTwoDependentPartForSingleSitOn(
                                parentValue,
                                child
//                                ,
//                                []
                            ) ]
        } else {
             fatalError( "\n\nDictionary Provider: \(#function) no initialisation defined for this part: \(parent)")
        }
    }


    mutating func initialiseIndependentPart(_ child: Part) {
        partValuesDic +=
            [child:
                StructFactory(
                   objectType,
                   dictionaries)
                        .createOneOrTwoDependentPartForSingleSitOn(
                            nil,
                            child
//                            ,
//                            []
                        ) ]
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
    case stabilityAtMid = "stabilityAtMid"
    case stabilityAtFront = "stabilityAtFront"
    
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
        [ .sitOn, .sideSupport] + rearAndFrontCasterWheels,
    
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

///provide proprties for tuple for part-object access to dictionary
struct PartObject: Hashable {
    let part: Part
    let object: ObjectTypes
    
    init (_ part: Part, _ object: ObjectTypes) {
        self.part = part
        self.object = object
    }
}


struct PartDefaultDimension {
    static let casterForDimension = (width: 50.0, length: 100.0, height: 50.0)
    static let casterWheelDimension = (width: 20.0, length: 75.0, height: 75.0)
    static let poweredWheelDimension = (width: 50.0, length: 200.0, height: 200.0)
    static let joint = (width: 20.0, length: 20.0, height: 20.0)

    var parentDimension = ZeroValue.dimension3d
    var partDimension = ZeroValue.dimension3d
    let part: Part
    let objectType: ObjectTypes
    var parentPart: Part?
    
    
    init (_ part: Part, _ objectType: ObjectTypes, _ parentPart: Part? = nil) {
        self.part = part
        self.objectType = objectType
        self.parentPart = parentPart
        
        if let unwrapped = parentPart {
            guard let dimension = getDefault(unwrapped)  else {
                fatalError("no parent dimension exists for part \(part) with parent \(unwrapped)")
            }
            parentDimension = dimension
        }
        
        guard let unwrapped = getDefault(part) else {
            fatalError("no dimension exists for part \(part)")
        }
        
      
        
        partDimension = unwrapped


        func getDefault(_ childOrParent: Part)  -> Dimension3d? {
        getFineTuneDimensionDefault(childOrParent) ??
            getGeneralDimensionDefault(childOrParent)
        }
                     
        
        func getFineTuneDimensionDefault(_ childOrParent: Part) -> Dimension3d? {
            [
                PartObject(.casterForkAtFront, .fixedWheelMidDrive): (width: 20.0, length: 50.0, height: 50.0),
                PartObject(.casterWheelAtFront, .fixedWheelMidDrive): (width: 20.0, length: 50.0, height: 50.0),
                PartObject(.fixedWheelAtRear, .fixedWheelManualRearDrive): (width: 20.0, length: 600.0, height: 600.0),
                PartObject(.footOnly, .showerTray): (width: 900.0, length: 1200.0, height: 10.0),
                
                PartObject(.sitOn, .allCasterBed): (width: 900.0, length: 2000.0, height: 150.0),
                PartObject(.sitOn, .allCasterStretcher): (width: 600.0, length: 1400.0, height: 10.0),
                PartObject(.stabilityAtFront, .fixedWheelMidDrive): (width: -75.0, length: 20.0, height: 0.0),
                PartObject(.stabilityAtRear, .allCasterTiltInSpaceShowerChair): (width: 150.0, length: -100.0, height: 0.0),
            ][PartObject(childOrParent, objectType)]
        }
    
    
        func  getGeneralDimensionDefault(_ childOrParent: Part) -> Dimension3d? {
            let z = ZeroValue.dimension3d
            let j = Self.joint
            return
                [
                .backSupport: (width: parentDimension.width, length: 20.0 , height: 500.0),
                .backSupportHeadSupport: (width: 150.0, length: 50.0, height: 100.0) ,
                .backSupportHeadSupportJoint: Self.joint,
                .backSupportHeadSupportLink: (width: 20.0, length: 20.0, height: 150.0),
                .backSupportRotationJoint: j,
                .casterForkAtFront: Self.casterForDimension,
                .casterForkAtRear: Self.casterForDimension,
                .casterWheelAtFront: Self.casterWheelDimension,
                .casterWheelAtRear: Self.casterWheelDimension,
                .casterVerticalJointAtFront:j,
                .casterVerticalJointAtRear: j,
                .fixedWheelAtFront: Self.poweredWheelDimension,
                .fixedWheelAtMid: Self.poweredWheelDimension,
                .fixedWheelAtRear: Self.poweredWheelDimension,
                .fixedWheelHorizontalJointAtFront: j,
                .fixedWheelHorizontalJointAtMid: j,
                .fixedWheelHorizontalJointAtRear:j,
                .footSupport: (width: 150.0, length: 100.0, height: 20.0),
                .footSupportJoint: j,
                .footSupportInOnePiece: (width: 50.0, length: 200.0, height: 200.0),
                .footSupportHangerJoint: j,
                .footSupportHangerLink: (width:20.0, length: 300.0, height: 20.0),
                .sideSupport: (width: 50.0, length: parentDimension.length, height: 150.0),
                .sitOn: (width: 400.0, length: 400.0, height: 10.0),
                .sitOnTiltJoint: j,
                .stabilityAtFront: z,
                .stabilityAtRear: z,
                ] [childOrParent]
        }
    }
}


struct PartDefaultOrigin {
    var partOrigin: PositionAsIosAxes = ZeroValue.iosLocation
    var parentDimension: Dimension3d
    var childDimension: Dimension3d
    var partDimension = ZeroValue.dimension3d
    let part: Part
    let objectType: ObjectTypes
    let bodySupportHeight: Double
    var wheelBaseJointOrigin: PositionAsIosAxes = ZeroValue.iosLocation

    
    
    init (_ part: Part, _ object: ObjectTypes, _ parentDimension: Dimension3d,
          _ childDimension: Dimension3d = ZeroValue.dimension3d) {
        self.part = part
        self.objectType = object
        self.parentDimension = parentDimension
        self.childDimension = childDimension
        bodySupportHeight =
            MiscObjectParameters(object).getMainBodySupportAboveFloor()
        
        guard let unwrapped = getDefault() else {
            fatalError("no origin exists for part \(part)")
        }
        
        partOrigin = unwrapped

        wheelBaseJointOrigin = getWheelBaseJointOrigin()

        func getDefault()  -> PositionAsIosAxes? {
        getFineTuneOriginDefault() ??
            getGeneralOriginDefault()
        }
                     
        
        func getFineTuneOriginDefault() -> PositionAsIosAxes? {
            [
//                PartObject(.casterForkAtFront, .fixedWheelMidDrive): (width: 20.0, length: 50.0, height: 50.0),
//                PartObject(.casterWheelAtFront, .fixedWheelMidDrive): (width: 20.0, length: 50.0, height: 50.0),
//                PartObject(.fixedWheelAtRear, .fixedWheelManualRearDrive): (width: 20.0, length: 600.0, height: 600.0),
//                PartObject(.footOnly, .showerTray): (width: 900.0, length: 1200.0, height: 10.0),
//
                PartObject(.sitOn, .fixedWheelSolo): (x: 0.0, y: 0.0, z: bodySupportHeight),
                PartObject(.sitOn, .fixedWheelMidDrive): (x: 0.0, y: 0.0, z: bodySupportHeight ),
                PartObject(.sitOn, .fixedWheelFrontDrive): (x: 0.0, y: -childDimension.length/2, z: bodySupportHeight),
            ][PartObject(part, object)]
        }
    
    
        func  getGeneralOriginDefault() -> PositionAsIosAxes? {
           let wheelBaseJointOrigin = getWheelBaseJointOrigin()
            
            return
                [
                .backSupport: (x: 0.0, y: 0.0, z: childDimension.height/2.0 ),
                .backSupportHeadSupport: (x: 0.0, y: 0.0, z: parentDimension.height/2.0),
                .backSupportHeadSupportJoint: (x: 0.0, y: 0.0, z: parentDimension.height/2.0),
                .backSupportHeadSupportLink:   (x: 0.0, y: 0.0, z: childDimension.height/2),
                .backSupportRotationJoint: (x: 0.0, y: -parentDimension.length/2, z: 0.0) ,
                
                .casterForkAtFront: (x: 0.0, y: -childDimension.length * 2.0/3.0, z: 0.0),
                .casterForkAtRear: (x: 0.0, y: -childDimension.length * 2.0/3.0, z: 0.0),
                .casterWheelAtFront: (x: 0.0, y: -childDimension.height/2.0, z: 0.0),
                .casterWheelAtRear: (x: 0.0, y: -childDimension.height/2.0, z: 0.0),
                .casterVerticalJointAtFront: wheelBaseJointOrigin,
                .casterVerticalJointAtRear: wheelBaseJointOrigin,
                .fixedWheelAtFront: ZeroValue.iosLocation,
                .fixedWheelAtMid: ZeroValue.iosLocation,
                .fixedWheelAtRear: ZeroValue.iosLocation,
                .fixedWheelHorizontalJointAtFront: wheelBaseJointOrigin,
                .fixedWheelHorizontalJointAtMid: wheelBaseJointOrigin,
                .fixedWheelHorizontalJointAtRear: wheelBaseJointOrigin,
                .footOnly: ZeroValue.iosLocation,
                .footSupport: (x: -PartDefaultDimension(.footSupport,objectType).partDimension.width/2.0, y: 0.0, z: 0.0),
                .footSupportJoint: (x: 0.0, y: parentDimension.length/2.0, z: 0.0),
                .footSupportHangerJoint: (x: parentDimension.width/2.0, y: parentDimension.length/2.0, z: 0.0),
                .footSupportHangerLink: (x: 0.0, y: childDimension.length/2.0, z: childDimension.height/2.0),
                
                .sideSupport: (x: 0.0, y: -parentDimension.length/2, z: childDimension.height),
                .sitOn:  (x: 0.0, y: childDimension.length/2, z: bodySupportHeight ),
                .sitOnTiltJoint: (x: 0.0, y: -parentDimension.length/4, z: -100.0),

                ] [part]
        }
    }
    
    
    func getWheelBaseJointOrigin() -> PositionAsIosAxes {
        var origin = ZeroValue.iosLocation
        
        
            let rearStability = PartDefaultDimension(.stabilityAtRear, objectType).partDimension
            let frontStability = PartDefaultDimension(.stabilityAtFront, objectType).partDimension

            let sitOnWidth = parentDimension.width
            let sitOnLength = parentDimension.length
        
        
            let wheelJointHeight = 100.0
        
        
        let rearCasterVerticalJointOriginForMidDrive = (
                x: sitOnWidth/2 + rearStability.width,
                y: -sitOnLength/2 + rearStability.length,
                z: wheelJointHeight)
            let midDriveOrigin = (
                x: sitOnWidth/2 + rearStability.width,
                y: sitOnLength/2 + rearStability.length,
                z: wheelJointHeight)
            let xPosition = sitOnWidth/2 + rearStability.width

            switch part {
                case
                    .fixedWheelHorizontalJointAtRear,
                    .casterVerticalJointAtRear:
                        origin = [
                            .fixedWheelManualRearDrive: (
                                x: xPosition + rearStability.width,
                                y: rearStability.length,
                                z: wheelJointHeight),
                            .fixedWheelFrontDrive: (
                                x: xPosition + rearStability.width,
                                y: -sitOnLength + rearStability.length,
                                        z: wheelJointHeight),
                            .fixedWheelMidDrive: rearCasterVerticalJointOriginForMidDrive ][objectType] ?? (
                                        x: xPosition,
                                        y: rearStability.length,
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
                                y: (rearStability.length + sitOnLength)/2.0,
                                z: wheelJointHeight)
                case
                    .fixedWheelHorizontalJointAtFront,
                    .casterVerticalJointAtFront:
                        origin = [
                            .fixedWheelFrontDrive: (
                                    x: xPosition,
                                    y: frontStability.length,
                                    z: wheelJointHeight),
                            .fixedWheelMidDrive: (
                                    x: xPosition + frontStability.width,
                                    y: sitOnLength/2 + frontStability.length,
                                    z: wheelJointHeight),
                            .fixedWheelSolo: midDriveOrigin][objectType] ?? (
                                    x: xPosition,
                                    y: sitOnLength + frontStability.length,
                                    z: wheelJointHeight)
                default:
                    break
            }
        
        return origin
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
   // var defaultDimension: PartDefaultDimension
    
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
            var defaultDimensions = PartDefaultDimension(.sitOn, objectType)
            let defaultDimension = defaultDimensions.partDimension
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
    _ childPart: Part)
        -> PartData {
            
        let defaultDimensions = PartDefaultDimension(childPart, objectType, parent?.part)

        
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
        
                
        if let parent {
            parentDimension = getOneDimensionFromOneOrTwo(parent.dimension)
        }
            
//        guard let parent else {
//            fatalError("origin sought witout parent dimension for \(childPart)")
//        }
        
        let defaultOrigin = PartDefaultOrigin(childPart, objectType, parentDimension)
            
        setOriginNames()
        
        setChildDimensionForObject()
        
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

                setBackSupportRotationJointOrigin()
                case .backSupport:
                           setBackSupportChildOrigin()
                case .backSupportHeadSupportJoint:
               
                        setBackSupportHeadSupportJointChildOrigin()
                case .backSupportHeadSupportLink:
             
                setBackSupportHeadSupportLinkChildOrigin()
                case .backSupportHeadSupport:
          
                        setBackSupportHeadSupportChildOrigin()
                case .casterForkAtRear,.casterForkAtMid, .casterForkAtFront:
                 
                        setCasterForkChildOrigin()
                case .casterWheelAtRear,.casterWheelAtMid, .casterWheelAtFront:
                
                        setCasterWheelChildOrigin()
                case .fixedWheelAtRear,.fixedWheelAtMid, .fixedWheelAtFront:

                        setFixedWheelChildOrigin()
                
                case
                    .fixedWheelHorizontalJointAtRear,
                    .fixedWheelHorizontalJointAtMid,
                    .fixedWheelHorizontalJointAtFront,
                    .casterVerticalJointAtRear,
                    .casterVerticalJointAtMid,
                    .casterVerticalJointAtFront:
            
                        setWheelBaseJointChildOrigin(childPart)
               
                case .footSupport:
               
                        setFootSupportChildOrigin()
                case .footSupportHangerJoint:
                  
                        setFootSupportHangerJointChildOrigin()
                case .footSupportHangerLink:
                      
                        setFootSupportHangerLinkChildOrigin()
                case .footSupportJoint:
                   
                        setFootSupportJointChildOrigin()
        
                case .footSupportInOnePiece, .footOnly:
                        childOrigin = .one(one: ZeroValue.iosLocation)
              
                case .sideSupport:
                       
                        setSideSupportChildOrigin()
                case .sideSupportRotationJoint:
                
                        setSideSupportRotationJointChildOrigin()
                case .sitOnTiltJoint:
              
                        setSitOnTiltJointChildOrigin()
                        setScopesOfRotationForSitOnTiltJoint()
                        setSitOnTiltJointAngles()
                
                
                default:
                    fatalError(
                        "StructFactory: \(#function) unkown case of \(childPart)")
            }
        }
    
            
        func setChildDimensionForObject() {
            childDimension = userEditedValues.optionalDimension.mapOptionalToNonOptionalOneOrTwo(defaultDimensions.partDimension)
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
     
    
func setBackSupportChildOrigin() {
let dimension = getOneDimensionFromOneOrTwo(childDimension)
setChildOriginForObject(
    defaultOrigin.partOrigin
//    [:
//    ][objectType] ??
//    (x: 0.0,
//     y: 0.0,
//     z: dimension.height/2.0 )
    )
}
func setBackSupportHeadSupportChildOrigin() {
setChildOriginForObject(
    defaultOrigin.partOrigin
//    [:
//    ][objectType] ??
//    (x: 0.0,
//     y: 0.0,
//     z: parentDimension.height/2.0)
)
}
          
func setBackSupportHeadSupportJointChildOrigin() {
    setChildOriginForObject(
        defaultOrigin.partOrigin
//        [:
//        ][objectType] ??
//        (x: 0.0,
//         y: 0.0,
//         z: parentDimension.height/2.0)
    )
}
            
            
func setBackSupportHeadSupportLinkChildOrigin() {
   // let dimension = getOneDimensionFromOneOrTwo(childDimension)
    setChildOriginForObject(
        defaultOrigin.partOrigin
//        [:
//        ][objectType] ??
//        (x: 0.0,
//         y: 0.0,
//         z: dimension.height/2)
    )
}
func setBackSupportRotationJointOrigin() {
setChildOriginForObject(
    defaultOrigin.partOrigin
//[:
//][objectType] ??
//(x: 0.0,
// y: -parentDimension.length/2,
// z: 0.0)
)
}

func setCasterForkChildOrigin() {
    // let originLength = getChildOneDimensionSize(keyPath: \.length)
     setChildOriginForObject(
        defaultOrigin.partOrigin
//         [
//             : ][objectType] ??
//         (x: 0.0,
//          y: -originLength * 2.0/3.0,
//          z: 0.0)
     )
 }
            
 func setCasterWheelChildOrigin() {
   //  let originHeight = getChildOneDimensionSize(keyPath: \.height)
     setChildOriginForObject(
        defaultOrigin.partOrigin
//         [
//             : ][objectType] ??
//         (x: 0.0,
//          y: -originHeight/2.0,
//          z: 0.0)
     )
 }
    func setFixedWheelChildOrigin() {
        setChildOriginForObject(
            defaultOrigin.partOrigin
//            [
//                : ][objectType] ??
//            (x: 0.0,
//             y: 0.0,
//             z: 0.0)
        )
    }
            
func setFootSupportChildOrigin() {
//    let dimensionWidth = getChildOneDimensionSize( keyPath: \.width)
   // print (-dimensionWidth/2.0)
    setChildOriginForObject(
        defaultOrigin.partOrigin
//        [
//            : ][objectType] ??
//        (x: -dimensionWidth/2.0,
//         y: 0.0,
//         z: 0.0)
    )
}
            
func setFootSupportJointChildOrigin() {
   // let dimension = getOneDimensionFromOneOrTwo(parentDimension)
    setChildOriginForObject(
        defaultOrigin.partOrigin
        
//        [
//            : ][objectType] ??
//        (x: 0.0,
//         y: parentDimension.length/2.0,
//         z: 0.0)
    )
}

            
func setFootSupportHangerJointChildOrigin() {
setChildOriginForObject(
    defaultOrigin.partOrigin
//    [
//        : ][objectType] ??
//    (x: parentDimension.width/2.0,
//     y: parentDimension.length/2.0,
//     z: 0.0)
)
}
func setFootSupportHangerLinkChildOrigin() {
   let dimension = getOneDimensionFromOneOrTwo(childDimension)
    setChildOriginForObject(
       // defaultOrigin.partOrigin
        [
            .fixedWheelRearDrive:
                (x: 0.0,
                 y: dimension.length/2,
                 z: dimension.height/2) ][objectType] ??
        (x: 0.0,
         y: dimension.length/2,
         z: dimension.height/2)
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
            let origin = PartDefaultOrigin(childPart, objectType, parentDimension).wheelBaseJointOrigin

       
            setChildOriginForObject(origin)


        }
            
            
            
        func setChildAnglesForObject(
            _ defaultAngles: RotationAngles) {
                childAngles = userEditedValues.optionalAngles.mapOptionalToNonOptionalOneOrTwo(defaultAngles)
        }
            
            
        func setChildMinMaxAnglesForObject(
            _ defaultAngles: AngleMinMax) {
                childAnglesMinMax = userEditedValues.optionalAngleMinMax.mapOptionalToNonOptionalOneOrTwo(defaultAngles)
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


