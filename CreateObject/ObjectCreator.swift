//
//  ObjectCreator.swift
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation

struct ObjectData {
    let objectChainLabelsDefaultDic: ObjectChainLabelDictionary
    
    let objectChainLabelsUserEditedDic: ObjectChainLabelDictionary
    
    var partValuesDic: [Part: PartData] = [:]
    
    let objectType: ObjectTypes
    
    let userEditedDictionaries: UserEditedDictionaries
    
    let size: Dimension = (width: 0.0, length: 0.0)

    var allPartChainLabels: [Part] = []
    
    let linkedPartsDictionary = LinkedParts().dictionary
    
    init(
        _ objectType: ObjectTypes,
        _ dictionaries: UserEditedDictionaries) {
        
        self.objectType = objectType
        self.userEditedDictionaries = dictionaries
        self.objectChainLabelsDefaultDic = ObjectChainLabel().dictionary
        self.objectChainLabelsUserEditedDic = dictionaries.objectChainLabelsUserEditDic
        allPartChainLabels = getAllPartChainLabels()
            
        checkObjectHasAtLeastOnePartChain()
        
        initialiseAllPart()
        
        postProcessGlobalOrigin()
            
    }
    
    func checkObjectHasAtLeastOnePartChain(){
        for label in allPartChainLabels {
            let labelInPartChainOut = LabelInPartChainOut(label)
            guard labelInPartChainOut.partChain.isEmpty == false else {
                fatalError("chainLabel \(label) has no partChain in LabelInPartChainOut")
            }
        }
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
            var allPartChain: [[Part]] = []
            for label in allPartChainLabels {
                allPartChain.append(getPartChain(label))
            }
            return allPartChain
        }

        
       func setGlobalOrigin(
        _ part: Part,
        _ parentGlobalOrigin: OneOrTwo<PositionAsIosAxes>) {
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



extension ObjectData {
    mutating func initialiseAllPart() {
       setUniqueInitialisation()
        func setUniqueInitialisation(){
            setObjectOriginPartValue()
        }
        
        //e,g. .sitOn is foundational to .fixedWheelHorizontalJoint...
        // object width is depenent on .sitOn
        let orderedSoLinkedOrParentPartInitialisedFirst = getOneOfEachPartInAllPartChain()
      
        if orderedSoLinkedOrParentPartInitialisedFirst.contains(.sitOn) {
            initialiseLinkedOrParentPart(.sitOn)
        }
        
        for part in orderedSoLinkedOrParentPartInitialisedFirst {
            if part != .sitOn {
                let parentPart = getLinkedOrParentPart(part)
                initialisePart(parentPart, part )
            }
        
        }
    }

    mutating func initialiseLinkedOrParentPart(
        _ child: Part) {
        let foundationalData =
                StructFactory(
                   objectType,
                   userEditedDictionaries,
                  independantPart: child)
                    .partData
        
        partValuesDic +=
            [child: foundationalData]
    }
    
    
    mutating func initialisePart(
        _ linkedlOrParentPart: Part,
        _ child: Part
    ) {
        var childData: PartData = ZeroValue.partData
            guard let linkedOrParentData = partValuesDic[linkedlOrParentPart] else {
                fatalError("no partValue for \(linkedlOrParentPart)")
            }
        childData =
            StructFactory(
                objectType,
                userEditedDictionaries,
                linkedOrParentData,
                child,
                allPartChainLabels)
                    .partData
        
        partValuesDic +=
            [child: childData]
    }
    

    func getOneOfEachPartInAllPartChain() -> [Part]{
        var oneOfEachPartInAllChainLabel: [Part] = []
            for label in allPartChainLabels {
               let partChain = LabelInPartChainOut(label).partChain
                for part in partChain {
                    if !oneOfEachPartInAllChainLabel.contains(part) {
                        oneOfEachPartInAllChainLabel.append(part)
                    }
                }
            }
        return oneOfEachPartInAllChainLabel
    }
    
    
    

//MARK: Development
    ///defaults are determined on one depenancy code alteration required for more than one dependancy
    func getLinkedOrParentPart(_ childPart: Part) -> Part {
        var linkedOrParentPart: Part = .objectOrigin
        
        for label in allPartChainLabels {
            let partChain = LabelInPartChainOut(label).partChain

            for i in 0..<partChain.count {
                if let linkedPart = linkedPartsDictionary[childPart], linkedPart != .notFound {
                    linkedOrParentPart = linkedPart
                } else if childPart == partChain[i] && i != 0 {
                    linkedOrParentPart = partChain[i - 1]
                }
            }
        }
        return linkedOrParentPart
    }

    
    
    func getPartChain(_ label: Part) -> [Part] {
        LabelInPartChainOut(label).partChain
    }
    
    
    func getAllPartChainLabels() -> [Part] {
      //  print(objectsAndTheirChainLabelsDicIn[objectType] )
        guard let chainLabels =
        objectChainLabelsUserEditedDic[objectType] ??
                objectChainLabelsDefaultDic[objectType] else {
            fatalError("there are no partChainLabel for object \(objectType)")
        }
        return chainLabels
    }
    
    mutating func setObjectOriginPartValue() {
        partValuesDic +=
        [.objectOrigin: ZeroValue.partData]
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
    
    case assistantFootLever = "assistantFootLever"
    
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

    case stabilizerAtRear = "stabilityAtRear"
    case stabilizerAtMid = "stabilityAtMid"
    case stabilizerAtFront = "stabilityAtFront"
    
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


struct LinkedParts {
    
    let dictionary: [Part: Part] = [
        
        .fixedWheelHorizontalJointAtRear: .sitOn,
        .fixedWheelHorizontalJointAtMid: .sitOn,
        .fixedWheelHorizontalJointAtFront: .sitOn,
        .casterVerticalJointAtRear: .sitOn,
        .casterVerticalJointAtMid: .sitOn,
        .casterVerticalJointAtFront: .sitOn,
           
        ]
}

struct ObjectModifiers {
    static let supportDimension: [UserModifiers] = [.supportLength, .supportWidth]
    static let footControl: [UserModifiers] = [.footSupport, .footSeparation]
    static let standardWheeledChair = footControl + supportDimension + [.tiltInSpace] + [.headRest] + [.legLength]
    static var dictionary: [ObjectTypes: [UserModifiers]] = {
        [
            .allCasterBed: supportDimension,
            .allCasterChair: supportDimension,
            .allCasterTiltInSpaceShowerChair: standardWheeledChair,
            .allCasterTiltInSpaceArmChair: supportDimension + [.tiltInSpace] + [.headRest],
            .fixedWheelFrontDrive: standardWheeledChair,
            .fixedWheelMidDrive: standardWheeledChair,
            .fixedWheelRearDrive: standardWheeledChair ,
            .fixedWheelManualRearDrive: standardWheeledChair ,
            .fixedWheelSolo: standardWheeledChair,
                //.fixedWheelTransfer : ,
            .showerTray: supportDimension
        ]
    }()
}

struct UserModifiersPartDependency {
    static var dictionary: [UserModifiers: [Part]] = {
        [.footSupport: [.footSupport],
         .footSeparation: [.footSupport]
        ]
    }()
}


enum UserModifiers: String {
    
    case casterBaseSeparator = "open"
    case casterSepartionAtFront = "front caster"
    case casterSeparationAtRear = "rear caster"
    case backRecline = "back recline"
    case footSupport = "foot support"
    case footSeparation = "foot separtion"
    case headRest = "head rest"
    case independantJoyStick = "joy stick"
    case legLength = "leg length"
    case propelleers = "propellers"
    case rearJoyStick = "rear joy stick"
    case supportLength = "support length"
    case supportWidth = "support width"
    case tiltInSpace = "tilt-in-space"
}

enum ObjectTypes: String, CaseIterable, Hashable {
    
    case allCasterBed = "Bed with caster base"
    case allCasterChair = "Chair with caster base"
    case allCasterHoist = "Hoist with caster base"
    case allCasterSixHoist = "Hoist with caster base and six caster"
    case allCasterTiltInSpaceShowerChair = "Tilting shower chair with caster base"
    case allCasterTiltInSpaceArmChair = "Tilting arm chair with caster base"
    case allCasterStandAid = "Stand aid with caster base"
    case allCasterStretcher = "Stretcher with caster Base "
    
//    case bathIntegralHoist = "IntegralBathHoist"
//    case bathFloorFixedHoistOneRotationPoint = "SingleRotationPointBathHoist"
//    case bathFloorFixedHoistTwoRotationPoint = "DoubleRotationPointBathHoist"
    
    case fixedWheelRearDriveAssisted = "Assisted wheelchair"
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
/// provides the chainLabels for each object
//MARK: ObjectsChainLabels
struct ObjectChainLabel {
    static let chairSupport: [Part] =
        [.sitOn,
        .backSupportHeadSupport,
        .footSupport,
        .sideSupport,
        .sitOnTiltJoint]
    static let chairSupportWithOutFoot: [Part] =
        [.sitOn,
        .backSupportHeadSupport,
        .sideSupport,
        .sitOnTiltJoint]
    static let rearAndFrontCasterWheels: [Part] =
        [.casterWheelAtRear, .casterWheelAtFront]
    static let chairSupportWithFixedRearWheel: [Part] =
    chairSupport + [.fixedWheelAtRear]
    
    let dictionary: ObjectChainLabelDictionary =
        [
        .allCasterBed:
            [.sitOn, .sideSupport ],
          
        .allCasterChair:
            chairSupport + rearAndFrontCasterWheels,
    
        .allCasterTiltInSpaceArmChair:
            chairSupportWithOutFoot + rearAndFrontCasterWheels + [.sitOnTiltJoint],
          
        .allCasterTiltInSpaceShowerChair:
            chairSupport + rearAndFrontCasterWheels + [.sitOnTiltJoint],
        
        .allCasterStretcher:
            [ .sitOn, .sideSupport] + rearAndFrontCasterWheels,
        
        .fixedWheelRearDriveAssisted:
            chairSupport + [.fixedWheelAtRear] + [.casterWheelAtFront] + [.assistantFootLever],
        
        .fixedWheelMidDrive:
            chairSupport + [.fixedWheelAtMid] + rearAndFrontCasterWheels,
        
        .fixedWheelFrontDrive:
            chairSupport + [.fixedWheelAtFront] + [.casterWheelAtRear],
         
        .fixedWheelRearDrive:
            chairSupportWithFixedRearWheel + [.casterWheelAtFront] ,
        
        .fixedWheelManualRearDrive:
            chairSupportWithFixedRearWheel + [.casterWheelAtFront] + [.fixedWheelAtRearWithPropeller],
        
        .showerTray: [.footOnly],

        .fixedWheelSolo: [.sitOn] + [.fixedWheelAtMid]  + [.sideSupport] ]
}



//Source of truth for partChain
//chainLabel is the last item in array
//MARK: ChainLabel
struct LabelInPartChainOut {
    static let partChainArrays: [[Part]] = [
            [.sitOn, .assistantFootLever],
            [.sitOn, .backSupport],
            [.sitOn, .footSupportHangerLink,  .footSupport],
            [.footOnly],
            [.sitOn, .backSupport,.backSupportHeadSupportJoint, .backSupportHeadSupportLink, .backSupportHeadSupport],
            [.sitOn, .sideSupport],
            [.sitOn],
            [.sitOn, .sitOnTiltJoint],
            [.fixedWheelHorizontalJointAtRear, .fixedWheelAtRear],
            [.fixedWheelHorizontalJointAtMid, .fixedWheelAtMid],
            [.fixedWheelHorizontalJointAtFront, .fixedWheelAtFront],
            [.fixedWheelHorizontalJointAtRear, .fixedWheelAtRear, .fixedWheelAtRearWithPropeller],
            [.fixedWheelHorizontalJointAtFront, .fixedWheelAtFront, .fixedWheelAtFrontWithPropeller],
            [.casterVerticalJointAtRear, .casterForkAtRear, .casterWheelAtRear],
            [.casterVerticalJointAtMid, .casterForkAtMid, .casterWheelAtMid],
            [.casterVerticalJointAtFront, .casterForkAtFront, .casterWheelAtFront]
        ]

        // Create the dictionary dynamically from the PartChain arrays
        static let partChainDictionary: [Part: PartChain] = {
            var dictionary: [Part: PartChain] = [:]

            for (index, partChain) in partChainArrays.enumerated() {
                guard let key = partChain.last else {
                                fatalError("no last part")
                            }
                dictionary[key] = partChain
            }

            return dictionary
        }()

    var partChains: [PartChain] = []
    var partChain: PartChain = []

    init(_ parts: [Part]) {//many partChain label
        for part in parts {
            if let partChain = Self.partChainDictionary[part] {
                partChains.append(partChain)
            }
        }
    }

    init(_ part: Part) { //one partChain label
        if let partChain = Self.partChainDictionary[part] {
            self.partChain = partChain
        }
    }

    mutating func getPartChain(_ part: Part) -> PartChain {
        return Self.partChainDictionary[part] ?? []
    }
}



struct PartInRotationScopeOut {
    let partChainLabel: [Part]
    let dictionary: [Part: [Part]] = [
        .sitOnTiltJoint:
            [.backSupport, .backSupportHeadSupport, .sitOn, .sideSupport, .footSupport],
    ]
    
    let part: Part
    
    var defaultRotationScope: [Part] {
        dictionary[part] ?? []
    }
    
    var rotationScopeAllowingForEditToChainLabel: [Part] {
        defaultRotationScope.filter { partChainLabel.contains($0) }
        
    }
    
    init(_ part: Part, _ partChainLabel: [Part]) {
        self.part = part
        self.partChainLabel = partChainLabel
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
                return .two(left: PartTag.id0, right: PartTag.id1)
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
    
    var scopeOfRotation: [Part]
    
  //  var color: Color = .black
    
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
        scopesOfRotation: [Part] = [] ) {
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
            self.scopeOfRotation = scopesOfRotation
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


///provide proprties for tuple for part-id access to dictionary
struct PartId: Hashable {
    let part: Part
    let id: PartTag
    
    init (_ part: Part, _ id: PartTag) {
        self.part = part
        self.id = id
    }
}



struct PartDefaultAngle {
    
    let angle: RotationAngles
    var minMaxAngle: AngleMinMax = ZeroValue.angleMinMax
  
    
    init(_ part: Part, _ objectType: ObjectTypes) {
        self.angle = getDefault(part, objectType)
        minMaxAngle = getMinMaxAngle()
    
        func getDefault(_ part: Part, _ objectType: ObjectTypes)  -> RotationAngles {
            let partObject = PartObject(part, objectType)
            guard let angle =
                    getFineTunedAngleDefault(partObject) ??
                    getGeneralAngleDfault(part) else {
                fatalError("no angle defined for part \(part)")
            }
            return angle
        }
        
        
        func getFineTunedAngleDefault(_ partObject: PartObject) -> RotationAngles?{
            let dictionary: [PartObject: RotationAngles] = [:]
            
            return dictionary[partObject]
        }
        
        
        func getGeneralAngleDfault(_ part: Part) -> RotationAngles?{
            let z: Measurement<UnitAngle> = ZeroValue.angleDeg
            let dictionary: [Part: RotationAngles] = [
                .sitOnTiltJoint: (x: Measurement(value: 30.0, unit: UnitAngle.degrees), y: z , z: z)
            ]
            return dictionary[part]
        }
        
        func getMinMaxAngle() -> AngleMinMax {
            let min = Measurement(value: 0.0, unit: UnitAngle.degrees)
            
            let max = extractNonZeroAngle(angle)
            
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
    static let poweredWheelDimension = (width: 50.0, length: 200.0, height: 200.0)
    static let joint = (width: 20.0, length: 20.0, height: 20.0)

    var linkedOrParentDimension = ZeroValue.dimension3d
    var partDimension = ZeroValue.dimension3d
    let part: Part
    let objectType: ObjectTypes
    var parentPart: Part
    
    
    init (_ part: Part, _ objectType: ObjectTypes, _ linkedOrParentData: PartData = ZeroValue.partData, _ userEditedDimension: Dimension3d? = nil) {
        self.part = part
        self.objectType = objectType
        self.parentPart = linkedOrParentData.part
        

        
        linkedOrParentDimension = linkedOrParentData.dimension.mapOneOrTwoToOneValue()
        
        guard let unwrapped = getDefault(part) else {
            fatalError("no dimension exists for part \(part)")
        }
        
        partDimension = unwrapped

        func getDefault(_ childOrParent: Part)  -> Dimension3d? {
            userEditedDimension ??
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
                PartObject(.sideSupport, .allCasterTiltInSpaceArmChair): (width: 100.0, length: linkedOrParentDimension.length, height: 150.0),
                PartObject(.sitOn, .allCasterBed): (width: 900.0, length: 2000.0, height: 150.0),
                PartObject(.sitOn, .allCasterStretcher): (width: 600.0, length: 1400.0, height: 10.0),
                PartObject(.stabilizerAtMid, .fixedWheelMidDrive): (width: 50.0, length: 0.0, height: 0.0),
                PartObject(.stabilizerAtFront, .fixedWheelMidDrive): (width: -50.0, length: 20.0, height: 0.0),
                PartObject(.stabilizerAtRear, .allCasterTiltInSpaceShowerChair): (width: 150.0, length: -100.0, height: 0.0),
                PartObject(.stabilizerAtRear, .fixedWheelRearDriveAssisted): (width: 50.0, length: -100.0, height: 0.0),
            ][PartObject(childOrParent, objectType)]
        }
    
    
        func  getGeneralDimensionDefault(_ childOrParent: Part) -> Dimension3d? {
            let z = ZeroValue.dimension3d
            let j = Self.joint
            return
                [
                .assistantFootLever: (width: 20.0, length: 300.0, height: 20.0),
                .backSupport: (width: linkedOrParentDimension.width, length: 20.0 , height: 500.0),
                .backSupportHeadSupport: (width: 150.0, length: 50.0, height: 100.0) ,
                .backSupportHeadSupportJoint: Self.joint,
                .backSupportHeadSupportLink: (width: 20.0, length: 20.0, height: 150.0),
                .backSupportRotationJoint: j,
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
                .fixedWheelAtRearWithPropeller: (width: 10.0, length: linkedOrParentDimension.length * 0.9, height: linkedOrParentDimension.length * 0.9),
                .footSupport: (width: 150.0, length: 100.0, height: 20.0),
                .footSupportJoint: j,
                .footSupportInOnePiece: (width: 50.0, length: 200.0, height: 200.0),
                .footSupportHangerJoint: j,
                .footSupportHangerLink: (width:20.0, length: 300.0, height: 20.0),
                .objectOrigin: z,
                .sideSupport: (width: 50.0, length: linkedOrParentDimension.length, height: 150.0),
                .sitOn: (width: 400.0, length: 400.0, height: 10.0),
                .sitOnTiltJoint: j,
                .stabilizerAtFront: z,
                .stabilizerAtMid: z,
                .stabilizerAtRear: z,
                ] [childOrParent]
        }
    }
}


struct PartDefaultOrigin {
    var partOrigin: PositionAsIosAxes = ZeroValue.iosLocation
    var linkedOrParentDimension: Dimension3d
    var selfDimension: Dimension3d
    let part: Part
    let objectType: ObjectTypes
    var wheelBaseJointOrigin: PositionAsIosAxes = ZeroValue.iosLocation
    let parentData: PartData

    
    
    init (_ part: Part, _ object: ObjectTypes, _ linkedOrParentData: PartData, _ userEditedDimension: Dimension3d? = nil
          ) {
        self.part = part
        self.objectType = object
      
        self.parentData = linkedOrParentData
        
        selfDimension = PartDefaultDimension(part, objectType, linkedOrParentData, userEditedDimension).partDimension
        
     

        linkedOrParentDimension = linkedOrParentData.dimension.mapOneOrTwoToOneValue()

        guard let unwrapped = getDefault() else {
            fatalError("no origin exists for part \(part)")
        }
        
        partOrigin = unwrapped
//
//        if part == .footSupportHangerLink {
//            print(selfDimension)
//        }
        
     
        wheelBaseJointOrigin = getWheelBaseJointOrigin()

        func getDefault()  -> PositionAsIosAxes? {
        getFineTuneOriginDefault() ??
            getGeneralOriginDefault()
        }
                     
        
        func getFineTuneOriginDefault() -> PositionAsIosAxes? {
            let chairHeight = 500.0
            return
                [
                PartObject(.fixedWheelAtRear, .fixedWheelManualRearDrive): (x: 75.0, y: 0.0, z: 0.0),
                PartObject(.sitOn, .fixedWheelSolo): (x: 0.0, y: 0.0, z: chairHeight),
                PartObject(.sitOn, .fixedWheelMidDrive): (x: 0.0, y: 0.0, z: chairHeight ),
                PartObject(.sitOn, .fixedWheelFrontDrive): (x: 0.0, y: -selfDimension.length/2, z: chairHeight),
                PartObject(.sitOn, .allCasterBed): (x: 0.0, y: selfDimension.length/2, z: 900.0),
                PartObject(.sitOn, .allCasterStretcher): (x: 0.0, y: selfDimension.length/2, z: 900.0),
                
                ][PartObject(part, object)]
        }
    
    
        func  getGeneralOriginDefault() -> PositionAsIosAxes? {
           let wheelBaseJointOrigin = getWheelBaseJointOrigin()
            
            return
                [
                .assistantFootLever: (x: linkedOrParentDimension.width/2, y: -(selfDimension.length + linkedOrParentDimension.length)/2, z: wheelBaseJointOrigin.z),
                .backSupport: (x: 0.0, y: -(linkedOrParentDimension.length + selfDimension.length)/2, z: selfDimension.height/2.0 ),
                .backSupportHeadSupport: (x: 0.0, y: 0.0, z: linkedOrParentDimension.height/2),
                .backSupportHeadSupportJoint: (x: 0.0, y: 0.0, z: linkedOrParentDimension.height/2.0),
                .backSupportHeadSupportLink:   (x: 0.0, y: 0.0, z: selfDimension.height/2),
                .backSupportRotationJoint: (x: 0.0, y: -linkedOrParentDimension.length/2, z: 0.0) ,
                
                .casterForkAtFront: (x: 0.0, y: -selfDimension.length * 2.0/3.0, z: 0.0),
                .casterForkAtRear: (x: 0.0, y: -selfDimension.length * 2.0/3.0, z: 0.0),
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
                .fixedWheelAtRearWithPropeller: (x: PartDefaultDimension(.fixedWheelAtRear,objectType, linkedOrParentData).partDimension.width * 1.1, y: 0.0, z: 0.0),
                .footOnly: ZeroValue.iosLocation,
                
                
                .footSupport: (x: -PartDefaultDimension(.footSupport,objectType, linkedOrParentData).partDimension.width/2.0,
                               y: linkedOrParentDimension.length/2.0, z: 0.0),
                
                
                .footSupportJoint: (x: 0.0, y: linkedOrParentDimension.length/2.0, z: 0.0),
                .footSupportHangerJoint: (x: linkedOrParentDimension.width/2.0, y: linkedOrParentDimension.length/2.0, z: 0.0),
                
                
                .footSupportHangerLink: (x: linkedOrParentDimension.width/2.0, y: (linkedOrParentDimension.length + selfDimension.length)/2.0, z: selfDimension.height/2.0),
                
                .footSupportInOnePiece: ZeroValue.iosLocation,
             
                .sideSupport: (x: linkedOrParentDimension.width/2 + selfDimension.width/2, y: 0.0, z: selfDimension.height/2),
                .sideSupportRotationJoint: (x: linkedOrParentDimension.width/2, y: -linkedOrParentDimension.length/2, z: selfDimension.height),
                .sitOn:  (x: 0.0, y: selfDimension.length/2, z: 500.0 ),
                .sitOnTiltJoint: (x: 0.0, y: -linkedOrParentDimension.length/4, z: -100.0),

                ] [part]
        }
    }
    
    
    func getWheelBaseJointOrigin() -> PositionAsIosAxes {
        
        var origin = ZeroValue.iosLocation
        
        let frontStability = PartDefaultDimension(.stabilizerAtFront, objectType).partDimension
        let midStability = PartDefaultDimension(.stabilizerAtMid, objectType).partDimension
        let rearStability = PartDefaultDimension(.stabilizerAtRear, objectType ).partDimension
        
//        let fixedFrontWheel = PartDefaultDimension(.fixedWheelAtFront, objectType, .fixedWheelHorizontalJointAtFront)
//        let fixedMidWheel = PartDefaultDimension(.fixedWheelAtMid, objectType, .fixedWheelHorizontalJointAtMid)
//        let fixedRearWheel = PartDefaultDimension(.fixedWheelAtRear, objectType, .fixedWheelHorizontalJointAtRear)
//
//        let casterFrontWheel = PartDefaultDimension(.casterWheelAtFront, objectType, .casterVerticalJointAtFront)
//        let casterMidWheel = PartDefaultDimension(.casterWheelAtMid, objectType, .casterVerticalJointAtMid)
//        let casterRearWheel = PartDefaultDimension(.casterWheelAtRear, objectType, .casterVerticalJointAtRear)
        
        

        let sitOnWidth = linkedOrParentDimension.width
       // print(sitOnWidth)
        let sitOnLength = linkedOrParentDimension.length
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
            let xPositionAtFront = sitOnWidth/2 + frontStability.width


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
                                x: xPosition + midStability.width,
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
                                    x: xPositionAtFront,
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
            case is String:
                return OneOrTwo.one(one: "") as! OneOrTwo<T>
            case is AngleMinMax:
                return OneOrTwo.one(one: ZeroValue.angleMinMax) as! OneOrTwo<T>
            default:
                fatalError()
            }
        }
    }
    
    func isNotNil() -> V? {
        switch self {
        case .one (let one):
            if let value = one {
                return value
            } else {
                return nil
            }
        case .two (let left, let right):
            if left == nil && right == nil {
                return nil
                } else {
                    if left == nil {
                       return right
                    } else {
                        return left
                    }
                }
        }
    }
    
    //MARK: DEVELPOMENT REFACTOR
//    func mapOptionalToNonOptionalOneOrTwoOriginX(_ defaultValue: OneOrTwo<PositionAsIosAxes>) -> OneOrTwo<PositionAsIosAxes> {
//
//        switch self { //assign default to one or left and right if nil
//        case .one(let one):
//            if let one {
//                return .one(one: one as! PositionAsIosAxes )
//            } else {
//                if let unwrapped = defaultValue.one {
//                    return .one(one: unwrapped)
//                } else {
//                    fatalError("id is .one but default is .two")
//                }
//            }
//
//        case .two(let left, let right):
//            var returnForLeft: PositionAsIosAxes
//            var returnForRight: PositionAsIosAxes
//            if let left {
//                returnForLeft = left as! PositionAsIosAxes
//            } else {
//                switch defaultValue {
//                case .two( let left, _):
//                        returnForLeft = left
//                    default:
//                        fatalError("id is .two but default is .one")
//                    }
//            }
//
//            if let right {
//                returnForRight = right as! PositionAsIosAxes
//            } else {
//                switch defaultValue {
//                case .two( _, let right):
//                        returnForRight = right
//                    default:
//                        fatalError("id is .two but default is .one")
//                    }
//            }
//
//            return .two(left: returnForLeft, right: returnForRight)
//        }
//
//    }
    
    func mapOptionalToNonOptionalOneOrTwoOrigin(_ defaultValue: OneOrTwo<PositionAsIosAxes>) -> OneOrTwo<PositionAsIosAxes> {
        
    

        switch self { //assign default to one or left and right if nil
        case .one(let one):
            if let one {
                return .one(one: one as! PositionAsIosAxes )
            } else {
               return defaultValue
            }

        case .two(let left, let right):
            var leftDefault: PositionAsIosAxes = ZeroValue.iosLocation
            var rightDefault: PositionAsIosAxes = ZeroValue.iosLocation
            switch defaultValue{
                case .two( let left, let right):
                leftDefault = left
                rightDefault = right
                default:
                    break
            }
            
            var returnForLeft: PositionAsIosAxes
            var returnForRight: PositionAsIosAxes
            if let left {
                returnForLeft = left as! PositionAsIosAxes
            } else {
                returnForLeft = leftDefault
            }
            if let right {
                returnForRight = right as! PositionAsIosAxes
            } else {
                returnForRight = rightDefault
            }
            return .two(left: returnForLeft, right: returnForRight)
        }

    }
}

///representing  OneOrTwo when either of Two is removed
///transform to .one(one: id) where id indicates left or right
///-id of .one must always be read/  reprentativeness of double-sidedness is weaker  , + no nil simplifies
///or to nil left or right
///nil is more complex code,  representativeness of double-sidedness is stronger, .one is always .id0



enum OneOrTwo <T> {
    case two (left: T, right: T)
    case one (one: T)
    
    func mapDefaultToOneOrTwo(_ defaultValue: PositionAsIosAxes) -> OneOrTwo<PositionAsIosAxes>{
        let symmetryValue = CreateIosPosition.getLeftFromRight(defaultValue)
        switch self {
        case .one (let one):
            let id = one as! PartTag
            let valueAdjustedForSymmetry = id == .id0 ? symmetryValue: defaultValue
            return .one(one: valueAdjustedForSymmetry)
        case .two:
            return .two(left: symmetryValue,
                        right: defaultValue)
        }
    }
    
    
    //MARK: CHANGE TO AVERAGE
    func mapOneOrTwoToOneValue() -> T {
        switch self {
        case .one (let one):
            return one
        case .two (let left, let right):
            return left
        }
    }
    
    
    func returnValue(_ id: PartTag) -> T {
        switch self {
        case .one (let one):
           // if id == .id0 {
                return one
           // } else {
//            fatalError(" passed a non-id0 to one") }
            
        case .two (let left, let right):
            let value = id == .id0 ?  left: right
            
            return value
        }
    }
    
    
    func mapOneOrTwoToSide() -> [Side] {
        switch self {
        case .one (let one):
            if PartTag.id0 == one as! PartTag {
                return [.left]
            } else {
                return [.right]
            }
        case .two:
            return [.left, .right, .both]
        }
    }
    
    
    func createOneOrTwoWithOneValue<U>(_ value: U) -> OneOrTwo<U> {
        switch self {
        case .one:
            return .one(one: value)
        case .two:
            return .two(left: value, right: value)
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
    
    
    func adjustForTwoToOneId() -> OneOrTwo<T> {
        switch self {
        case .one:
            return self
        case .two (let left, let right):
            //if equal then the values are not user edited
            if left as! PositionAsIosAxes == right as! PositionAsIosAxes {
                return .two(left:
                                CreateIosPosition.getLeftFromRight(right as! PositionAsIosAxes) as! T,
                            right: right)
            } else {
                return .two(left: left, right: right)
            }
        }
    }

    
    func adjustForSymmetry() -> OneOrTwo<T> {
        switch self {
        case .one:
            return self
        case .two (let left, let right):
            //if equal then the values are not user edited
            if left as! PositionAsIosAxes == right as! PositionAsIosAxes {
                return .two(left:
                                CreateIosPosition.getLeftFromRight(right as! PositionAsIosAxes) as! T,
                            right: right)
            } else {
                return .two(left: left, right: right)
            }
        }
    }


    ///the default is that symmetry is applied since default values are equal
    ///
    ///
    
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

    func mapFiveOneOrTwoToOneFuncWithVoidReturn(
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
              fatalError("\n\n\(String(describing: type(of: self))): \(#function ) the fmap has either one globalPosition and two id or vice versa for \(value1)")
         }
     }
    
    func mapSixOneOrTwoToOneFuncWithVoidReturn(
         _ value1: OneOrTwo<String>,
         _ value2: OneOrTwo<RotationAngles>,
         _ value3: OneOrTwo<AngleMinMax>,
         _ value4: OneOrTwo<PositionAsIosAxes>,
         _ value5: OneOrTwo<PositionAsIosAxes>,
         _ transform: (Dimension3d, String, RotationAngles, AngleMinMax, PositionAsIosAxes, PositionAsIosAxes)  -> ()) {
             
          //   print("\(value1), \(value2), \(value3), \(value4) ")
         switch (self, value1, value2, value3, value4, value5) {
         case let (.one(one0), .one(one1), .one(one2), .one(one3), .one(one4), .one(one5)):
             transform(one0 as! Dimension3d, one1, one2, one3, one4, one5)
         
         
         case let (.two(left0, right0), .two(left1, right1), .two(left2, right2), .two(left3, right3), .two(left4, right4), .two(left5, right5) ):
             transform(left0 as! Dimension3d, left1, left2, left3, left4, left5)
             transform(right0 as! Dimension3d, right1, right2, right3, right4, right5)
         default:
              fatalError("\n\n\(String(describing: type(of: self))): \(#function ) the fmap has either one globalPosition and two id or vice versa for \(value1)")
         }
     }
}




struct StructFactory {
    let objectType: ObjectTypes
    let dictionaries: UserEditedDictionaries
    var partData: PartData = ZeroValue.partData
    let linkedOrParentData: PartData
    let part: Part
    let parentPart: Part
    let chainLabel: [Part]
    let defaultDimension: Dimension3d
    let defaultOrigin: PartDefaultOrigin
    let userEditedData: UserEditedData
    var partOrigin: OneOrTwo<PositionAsIosAxes> = .one(one: ZeroValue.iosLocation)
    var partDimension: OneOrTwo<Dimension3d> = .one(one: ZeroValue.dimension3d)

    // Designated initializer for common parts
    init(_ objectType: ObjectTypes,
         _ userEditedDictionaries: UserEditedDictionaries,
         _ linkedOrParentData: PartData,
         _ part: Part,
       //  _ linkedOrParentPart: Part,
         _ chainLabel: [Part]){
        self.objectType = objectType
        self.dictionaries = userEditedDictionaries
        self.linkedOrParentData = linkedOrParentData
        self.part = part
        self.parentPart = linkedOrParentData.part
        self.chainLabel = chainLabel

        userEditedData =
            UserEditedData(
                objectType,
                userEditedDictionaries,
                .id0,
                part)

        let dimensionAccountingForUserEdit =
       userEditedData.optionalDimension.isNotNil()
        
        defaultDimension = PartDefaultDimension(part, objectType, linkedOrParentData, dimensionAccountingForUserEdit).partDimension
        
        defaultOrigin = PartDefaultOrigin(part, objectType, linkedOrParentData, dimensionAccountingForUserEdit)
      
        

        
        setChildDimensionForPartData()
        
       

        setChildOriginAllowingForSymmetryForPartData()


        func setChildOriginAllowingForSymmetryForPartData() {
            let any: OneOrTwo<PartTag> = userEditedData.partIdAllowingForUserEdit
            let defaultOriginAdjustedForSymmetryAndUserEdtedId = any.mapDefaultToOneOrTwo(defaultOrigin.partOrigin)

            partOrigin = defaultOriginAdjustedForSymmetryAndUserEdtedId
//            userEditedData.optionalOrigin.mapOptionalToNonOptionalOneOrTwoOrigin( defaultOriginAdjustedForSymmetryAndUserEdtedId)
            
//            if part == Part.footSupportHangerLink {
//
//                print(partOrigin)
//
//            }
        }


        func setChildDimensionForPartData() {
                partDimension = userEditedData.optionalDimension.mapOptionalToNonOptionalOneOrTwo(defaultDimension)
            
//            if part == Part.footSupportHangerLink {
//
//                print(partDimension)
//
//            }
            
        }

        // Assign linkedOrParentData.part directly here
        partData = createPart()
    }

   
    init(_ objectType: ObjectTypes,
         _ userEditedDictionaries: UserEditedDictionaries,
         independantPart childPart: Part) {
        let linkedOrParentData = ZeroValue.partData
        let noChainLabelRequired: [Part] = []
        self.init(
            objectType,
            userEditedDictionaries,
            linkedOrParentData,
            childPart,
            noChainLabelRequired
        )
        
        partData = createSitOn()
     
    }

    // Convenience initializer for parts in general
    init(
        _ objectType: ObjectTypes,
         _ userEditedDictionaries: UserEditedDictionaries,
         _ linkedOrParentData: PartData,
         dependantPart childPart: Part,
         _ chainLabel: [Part]
    ) {
     
        self.init(
            objectType,
            userEditedDictionaries,
            linkedOrParentData,
            childPart,
            chainLabel)
        
    }
}





extension StructFactory {
    func createSitOn()
        -> PartData {
        let sitOnName: OneOrTwo<String> = .one(one: "object_id0_sitOn_id0_sitOn_id0")
        return
            PartData(
                part: .sitOn,
                originName:sitOnName,
                dimensionName: sitOnName,
                dimension: partDimension,
                origin: userEditedData.optionalOrigin.mapOptionalToNonOptionalOneOrTwo(defaultOrigin.partOrigin),
                minMaxAngle: nil,
                angles: nil,
                id: .one(one: PartTag.id0) )
    }

    
    func createPart()
        -> PartData {
        let partId = userEditedData.partIdAllowingForUserEdit//two sided default edited to one will be detected
        let scopesOfRotation: [Part] =  setScopeOfRotation()
        var partAnglesMinMax = partId.createOneOrTwoWithOneValue(ZeroValue.angleMinMax)
        var partAngles = partId.createOneOrTwoWithOneValue(ZeroValue.rotationAngles)
        let originName =
            userEditedData.originName.mapOptionalToNonOptionalOneOrTwo("")
     

        if [.sitOnTiltJoint].contains(part) {
            let (jointAngle, minMaxAngle) = getDefaultJointAnglesData()
            partAngles = getAngles(jointAngle)
            partAnglesMinMax = getMinMaxAngles(minMaxAngle)
        }
 
          
        return
            PartData(
                part: part,
                originName: originName,
                dimensionName: originName,
                dimension: partDimension,
                maxDimension: partDimension,
                origin: partOrigin,
                globalOrigin: .one(one: ZeroValue.iosLocation),//postProcessed
                minMaxAngle: partAnglesMinMax,
                angles: partAngles,
                id: partId,
                scopesOfRotation: scopesOfRotation)
            
            
        func setScopeOfRotation() -> [Part]{
                PartInRotationScopeOut(
                    part,
                    chainLabel)
                        .rotationScopeAllowingForEditToChainLabel
        }
         
            
        func getDefaultJointAnglesData() -> (RotationAngles, AngleMinMax){
            let  partDefaultAngle = PartDefaultAngle(part, objectType)
            return (partDefaultAngle.angle, partDefaultAngle.minMaxAngle)
        }


            
        func getAngles(
            _ defaultAngles: RotationAngles) -> OneOrTwo<RotationAngles> {
                userEditedData.optionalAngles.mapOptionalToNonOptionalOneOrTwo(defaultAngles)
        }
            
            
        func getMinMaxAngles(
            _ defaultAngles: AngleMinMax) -> OneOrTwo<AngleMinMax>{
                userEditedData.optionalAngleMinMax.mapOptionalToNonOptionalOneOrTwo(defaultAngles)
        }
    }
}



extension Array where Element == PartData {
    func getElement(withPart part: Part) -> PartData {
        if let element = self.first(where: { $0.part == part }) {
            return element
        } else {
            fatalError("StructFactory: \(#function) Element with part \(part) not found in [OneOrTwoGenericPartValue]: \(self)].")
        }
    }
}



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
struct UserEditedDictionaries {
    //relating to Part
    var dimensionUserEditedDic: Part3DimensionDictionary
    
    var angleUserEditedDic: AnglesDictionary
    var angleMinMaxDic: AngleMinMaxDictionary
    
    //relating to Object
    var parentToPartOriginUserEditedDicNew: [PartId: PositionAsIosAxes]
    var parentToPartOriginUserEditedDic: PositionDictionary
    var objectToPartOrigintUserEditedDic: PositionDictionary

    
    //relating to ObjectImage
    var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>]
    var objectChainLabelsUserEditDic: ObjectChainLabelDictionary
   
    static var shared = UserEditedDictionaries()
    
   private init(
        dimension: Part3DimensionDictionary  =
            [:],
        origin: PositionDictionary =
            [:] ,
        parentToPartOriginUserEditedDic: PositionDictionary = [:],
        parentToPartOriginUserEditedDicNew: [PartId: PositionAsIosAxes] = [:],
        objectToParOrigintUserEditedDic: PositionDictionary = [:],
        anglesDic: AnglesDictionary =
            [:],
        angleMinMaxDic: AngleMinMaxDictionary =
            [:],
        partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] =
            [:],
        objectChainLabelsUserEditDic: ObjectChainLabelDictionary =
            [:]) {
        
        self.dimensionUserEditedDic = dimension
   
        self.parentToPartOriginUserEditedDic = parentToPartOriginUserEditedDic
        self.parentToPartOriginUserEditedDicNew = parentToPartOriginUserEditedDicNew
        self.objectToPartOrigintUserEditedDic = objectToParOrigintUserEditedDic
        self.angleUserEditedDic =
            anglesDic
        self.angleMinMaxDic =
            angleMinMaxDic
        self.partIdsUserEditedDic =
            partIdsUserEditedDic
        self.objectChainLabelsUserEditDic = objectChainLabelsUserEditDic
    }
}




///All dictionary are input in userEditedDictionary
///The optional  values associated with a part are available
///dimension
///origin
///The non-optional id are available
///All values are wrapped in OneOrTwoValues
struct UserEditedData {
    let dimensionUserEditedDic: Part3DimensionDictionary
    let parentToPartOriginUserEditedDic: PositionDictionary
    let parentToPartOriginUserEditedDicNew: [PartId: PositionAsIosAxes]
    let objectToPartOrigintUserEditedDic: PositionDictionary
    let angleUserEditedDic: AnglesDictionary
    let angleMinMaxDic: AngleMinMaxDictionary
    let partIdDicIn: [Part: OneOrTwo<PartTag>]
    let part: Part
    let sitOnId: PartTag
    
    var originName:  OneOrTwoOptional <String> = .one(one: nil)
    var optionalAngles: OneOrTwoOptional <RotationAngles> = .one(one: nil)
    var optionalAngleMinMax: OneOrTwoOptional <AngleMinMax> = .one(one: nil)
    var optionalDimension: OneOrTwoOptional <Dimension3d> = .one(one: nil)
    var optionalOrigin: OneOrTwoOptional <PositionAsIosAxes> = .one(one: nil)
    var partIdAllowingForUserEdit: OneOrTwo <PartTag>
    
    init(
        _ objectType: ObjectTypes,
        _ dictionaries: UserEditedDictionaries,
        _ sitOnId: PartTag,
        _ part: Part) {
            self.sitOnId = sitOnId
            self.part = part
            dimensionUserEditedDic =
                dictionaries.dimensionUserEditedDic
            parentToPartOriginUserEditedDic =
                dictionaries.parentToPartOriginUserEditedDic
            parentToPartOriginUserEditedDicNew =
                dictionaries.parentToPartOriginUserEditedDicNew
            objectToPartOrigintUserEditedDic =
                dictionaries.objectToPartOrigintUserEditedDic
            angleUserEditedDic =
                dictionaries.angleUserEditedDic
            angleMinMaxDic =
                dictionaries.angleMinMaxDic
            partIdDicIn =
                dictionaries.partIdsUserEditedDic

            partIdAllowingForUserEdit = //non-optional as must iterate through id
            partIdDicIn[part] ?? //UI edit:.two(left:.id0,right:.id1)<->.one(one:.id0) ||.one(one:.id1)
            OneOrTwoId(objectType, part).forPart // default
                        
//            if part == .footSupportHangerLink {
//                print (partIdAllowingForUserEdit)
//                print("")
//            }
            

//            getOptionalValue(partId, from: parentToPartOriginUserEditedDic) { part in
//                return CreateNameFromParts([Part.sitOn, sitOnId, part]).name }
            
            originName = getOriginName(partIdAllowingForUserEdit)
                                       
           optionalOrigin = getOptionalOrigin()
//                                       if part == .footSupport {
//                                           print("Start")
//                                           print(optionalOrigin)
//                                           print("end")
//                                       }

            optionalAngleMinMax =
            getOptionalValue(partIdAllowingForUserEdit, from: angleMinMaxDic) { part in
                return CreateNameFromParts([Part.sitOn, sitOnId, part]).name }
            
            optionalAngles = getOptionalAngles()
            optionalDimension = getOptionalDimension()

        }
    
    
    func getOriginName(_ partId: OneOrTwo<PartTag>)
    -> OneOrTwoOptional<String>{
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
        switch originName.mapOptionalToNonOptionalOneOrTwo("") {
        case .one(let one):
            angles =
                .one(one: angleUserEditedDic[one ] )
        case .two(let left, let right):
            angles =
                .two(left: angleUserEditedDic[ left ], right: angleUserEditedDic[right ] )
        }
        return angles
    }
    
    func getOptionalDimension() -> OneOrTwoOptional<Dimension3d>{
        var dimension: OneOrTwoOptional<Dimension3d> = .one(one: nil)
        switch originName.mapOptionalToNonOptionalOneOrTwo("") {
        case .one(let one):
            dimension =
                .one(one: dimensionUserEditedDic[one ] )
        case .two(let left, let right):
            dimension =
                .two(left: dimensionUserEditedDic[ left ], right: dimensionUserEditedDic[right ] )
        }
        return dimension
    }
    
    func getOptionalOrigin() -> OneOrTwoOptional<PositionAsIosAxes>{
        var origin: OneOrTwoOptional<PositionAsIosAxes> = .one(one: nil)
        switch originName.mapOptionalToNonOptionalOneOrTwo("") {
        case .one(let one):
            origin =
                .one(one: parentToPartOriginUserEditedDic[one ] )
        case .two(let left, let right):
            origin =
                .two(left: parentToPartOriginUserEditedDic[ left ], right: parentToPartOriginUserEditedDic[right ] )
        }
        return origin
    }
        
    
    func getOrigin() -> OneOrTwoOptional<PositionAsIosAxes>{
        var origin: OneOrTwoOptional<PositionAsIosAxes>
        switch partIdAllowingForUserEdit {
        case .one(let one):
            origin =
                .one(one: parentToPartOriginUserEditedDicNew[PartId(part,one)])
        case .two(let left, let right):
            origin =
                .two(left: parentToPartOriginUserEditedDicNew[PartId(part, left)],
                     right: parentToPartOriginUserEditedDicNew[PartId(part, right)])
        }
        return origin
    }
        
    
    func getOptionalValue<T>(
        _ partIds: OneOrTwo<PartTag>,
        from dictionary: [String: T?],
        using closure: @escaping (PartTag) -> String
    ) -> OneOrTwoOptional<T> {
        if part == .sitOn {
           // print(dictionary)
        }
        
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


