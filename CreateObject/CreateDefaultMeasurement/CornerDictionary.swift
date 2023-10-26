//
//  CornerDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation



//MARK: - PARENT
///This provides
///The array of objects available
///Dictionary for objects
///An input for edited dimensions to replace default dimensions
struct DictionaryProvider {
    
    static let sitOnHeight = 500.0
    var objectGroups: BaseObjectGroups {
        BaseObjectGroups()
    }
    
    //UI amended dictionary
    let dimensionDicIn: Part3DimensionDictionary
    let preTiltParentToPartOriginDicIn: PositionDictionary
    let preTiltObjectToPartOriginDicIn: PositionDictionary
    let angleDicIn: AngleDictionary
    let angleMinMaxDicIn: AngleMinMaxDictionary
   
    let partChainsIdDicIn: [PartChain: [[Part]]]
    
    let objectType: ObjectTypes
    let twinSitOnOption: TwinSitOnOptionDictionary

    var twinSitOnState: Bool //= false
    let oneOrTwoIds: [Part]
    var objectPartChainLabelDic: ObjectPartChainLabelsDictionary = [:]

    var partChainLabels: [Part] = []
    var partChainDictionary: PartChainDictionary = [:]
    var partChainsIdDic: PartChainIdDictionary  = [:]
    
    var dimensionDic: Part3DimensionDictionary = [:]
    var angleDic: AngleDictionary = [:]
    var angleMinMaxDic: AngleMinMaxDictionary = [:]
    
    var preTiltWheelOriginIdNodes: RearMidFrontOriginIdNodes = ZeroValue.rearMidFrontOriginIdNodes
    var originIdPartChainForBackForBothSitOn: [OriginIdPartChain]  = [ZeroValue.originIdPartChain]
    

    var preTiltWheelOrigin: InputForDictionary?

    var uniqueNames: [String] = []
    
    //pre-tilt
    var preTiltParentToPartOriginDic: PositionDictionary = [:]
    var preTiltObjectToPartOriginDic: PositionDictionary = [:]
    var preTiltObjectToCornerDic: PositionDictionary = [:]
    var preTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    
    
    //post-tilt
    var postTiltObjectToPartOriginDicIn: PositionDictionary = [:]
    var postTiltObjectToPartOriginDic: PositionDictionary = [:]
    var postTiltObjectToCornerDic: PositionDictionary = [:]
    var postTiltObjectToFourCornerPerKeyDic: CornerDictionary = [:]
    
    
    let objectsAndTheirChainLabels: ObjectPartChainLabelsDictionary = ObjectsAndTheirChainLabels().dictionary
    
    var preTiltSitOnAndWheelBaseJointOrigin: PreTiltSitOnAndWheelBaseJointOrigin
    var sitOnOrigin: PositionAsIosAxes = ZeroValue.iosLocation
    var wheelBaseJointOrigin: RearMidFrontPositions = ZeroValue.rearMidFrontPositions

    /// using values taken from dictionaries
    /// either passed in, which may be the result of UI edit,
    /// or if nil value provide default values
    /// and make the necessary changes to all dictionaries
    /// resulting from those values.  For example, if the UI
    /// alters an angle, all the values dependant on that angle
    /// are changed
    ///
    /// - Parameters:
    ///   - baseType: as Enum
    ///   - twinSitOnOption: dictionary as [Enum: Bool] indicating a configuration with two seats
    ///   - dimensionIn: empty or default or modified dictionary of part
    ///   - objectToPartOrigin: empty or default or modified dictionary as  [String: PositionAsIosAxes] indicating part origin, preTilt
    ///   - parentToPartOrigin: empty or default or modified dictionary as  [String: PositionAsIosAxes] indicating part origin, preTilt
    ///   - angleIn: empty or default or modified dictionary as [String: Measurement<UnitAngle>] indicating object configuration angles but not angles of parts which change during movement: sitOn tilt but not caster orientation
    init(
        _ objectType: ObjectTypes,
        _ twinSitOnOption: TwinSitOnOptionDictionary,
        _ dimensionIn: Part3DimensionDictionary = [:],
        _ objectToPartOrigin: PositionDictionary = [:],
        _ parentToPartOrigin: PositionDictionary = [:],
        angleIn: AngleDictionary = [:],
        minMaxAngleIn: AngleMinMaxDictionary = [:],
        objectsAndTheirChainLabelsDicIn: ObjectPartChainLabelsDictionary = [:],
        partChainsIdDicIn: PartChainIdDictionary = [:] ) {
            
        self.objectType = objectType
        self.twinSitOnOption = twinSitOnOption
        self.dimensionDicIn = dimensionIn
        self.preTiltObjectToPartOriginDicIn = objectToPartOrigin
        self.preTiltParentToPartOriginDicIn = parentToPartOrigin
        self.angleDicIn = angleIn
        self.angleMinMaxDicIn = minMaxAngleIn
        self.partChainsIdDicIn = partChainsIdDicIn
        preTiltSitOnAndWheelBaseJointOrigin = PreTiltSitOnAndWheelBaseJointOrigin(objectType)
  
        twinSitOnState = TwinSitOn(twinSitOnOption).state
        oneOrTwoIds = twinSitOnState ? [.id0, .id1]: [.id0]
            
        angleDic =
            ObjectAngleChange(parent: self).dictionary
        angleMinMaxDic =
            ObjectAngleMinMax(parent: self).dictionary
            
       //this order required start
        objectPartChainLabelDic = getObjectPartChainLabelDic()
        partChainLabels = getPartChainLabels()
        //this order required end
            
            
//MARK: - ORIGIN/DICTIONARY
        // both parent to part and
        // object to part

                    
            
        getPreTiltFootSideBackOriginDictionary()
       

            //do not add wheels to for example a shower tray
        if !objectGroups.noWheel.contains( objectType) {
            wheelBaseJointOrigin = preTiltSitOnAndWheelBaseJointOrigin.wheelBaseJointOriginForOnlyOneSitOn
        }

           


            
//MARK: - PRE-TILT
        preTiltObjectToPartFourCornerPerKeyDic =
            createCornerDictionary(
                   preTiltObjectToPartOriginDic,
                   dimensionDic)

        uniqueNames = UniqueNamesForDimensions(dimensionDic).are
            
            
//MARK: - POST-TILT
        postTiltObjectToFourCornerPerKeyDic =
            createPostTiltObjectToPartFourCornerPerKeyDic()
            //no dimension for
            
//DictionaryInArrayOut().getNameValue(preTiltObjectToPartOriginDic).forEach{print($0)}
                      
        
        func getPreTiltWheelOriginDictionary(
            _ frontMidRearOriginIdNodes: RearMidFrontOriginIdNodes) {
                
            createPreTiltWheelOriginDictionary(frontMidRearOriginIdNodes.rear)
                
            if BaseObjectGroups().midWheels.contains(objectType) {
                createPreTiltWheelOriginDictionary(frontMidRearOriginIdNodes.mid)
            }
                
            createPreTiltWheelOriginDictionary(frontMidRearOriginIdNodes.front)
                
            func createPreTiltWheelOriginDictionary(
                _ originIdNodes: OriginIdPartChain ) {
                let parentAndObjectToPartOriginDictionary =
                    OriginIdPartChainInDictionariesOut(
                        originIdNodes,
                        preTiltParentToPartOriginDicIn
                        )
                preTiltObjectToPartOriginDic +=
                    parentAndObjectToPartOriginDictionary
                        .makeAndGetForObjectToPart()
                preTiltParentToPartOriginDic +=
                    parentAndObjectToPartOriginDictionary
                        .makeAndGetForParentToPart()
                }
        }
            
            
        func getPartChainLabels ()
            -> [Part] {
                objectPartChainLabelDic[objectType] ?? [.sitOn]
        }
        
            
       func getObjectPartChainLabelDic  ()
        -> ObjectPartChainLabelsDictionary {
            objectsAndTheirChainLabelsDicIn == [:] ?
                ObjectsAndTheirChainLabels().dictionary:
                objectsAndTheirChainLabelsDicIn
        }
            
        
        func getPreTiltFootSideBackOriginDictionary () {
            //chainLabels are determined by the object
                for index in 0..<partChainLabels.count {
                    createAnyOriginAndDimensionDic(
                        partChainLabels[index])
                }
        }
            

        func createAnyOriginAndDimensionDic(
            _ chainLabel: Part) {
            //Chain
            let chain =
                LabelInPartChainOut([chainLabel]).partChains[0]
                
                //print(chainLabel)
            //OriginIdPartChain
            let allOriginIdPartChainForBothSitOn =
                PreTiltOccupantAnyPart(
                    .id0,
                    parent: self,
                    chainLabel: chainLabel
                ).allOriginIdPartChain[0]
                //print(allOriginIdPartChainForBothSitOn)
                var dimensionData: PartDimension?
                
                switch chainLabel {
                    case .footSupport:
                        dimensionData =
                            OccupantFootSupportDefaultDimension(objectType)
                    case .footOnly:
                        dimensionData =
                            OccupantFootSupportDefaultDimension(objectType)
                    case .sideSupport:
                        dimensionData =
                            OccupantSideSupportDefaultDimension(objectType)
                    case .backSupport:
                        dimensionData =
                            OccupantBackSupportDefaultDimension(objectType)
                        //this is required for post tilt
                        originIdPartChainForBackForBothSitOn = allOriginIdPartChainForBothSitOn
                    case .backSupportHeadSupport:
                        dimensionData =
                            OccupantBackSupportDefaultDimension(objectType)
                        //this is required for post tilt
                        originIdPartChainForBackForBothSitOn = allOriginIdPartChainForBothSitOn
                    case . sitOn:
                        dimensionData =
                            OccupantBodySupportDefaultDimension(objectType)
                    case .sitOnTiltJoint:
                        dimensionData =
                            OccupantBodySupportAngleJointDefaultDimension(objectType)
                    case .fixedWheelAtRear, .fixedWheelAtMid, .fixedWheelAtFront:
                        dimensionData =
                            ObjectWheelDefaultDimension(objectType)
                    case .casterWheelAtFront:
                        dimensionData =
                        ObjectWheelDefaultDimension(objectType)
                    default:
                        fatalError("Not yet defined for createAnyOriginAndDimensionDic")
                }

            //OriginDic
            for allOriginIdPartChain in
                    allOriginIdPartChainForBothSitOn {
               
                createPreTiltParentToPartFootSideBackOriginDictionary(allOriginIdPartChain)
               // print(#function)
                if var dimensionData {
                    var allDimensions: [Dimension3d] = []
                    for part in chain {
                        dimensionData.reinitialise(part)
                        allDimensions.append(dimensionData.dimension)
                        
//                        if part == .fixedWheelAtMid {
//                            print(dimensionData.dimension)
//                        }
                    }

                    dimensionDic +=
                    DimensionDictionary(
                        [allOriginIdPartChain],
                        allDimensions,
                        dimensionDicIn,
                        0).forPart
                }
            }
        }
                
            
        func createPreTiltParentToPartFootSideBackOriginDictionary (
            _ allOriginIdNodes: OriginIdPartChain){
            let parentAndObjectToPartOriginDictionary =
                OriginIdPartChainInDictionariesOut(
                allOriginIdNodes,
                preTiltParentToPartOriginDicIn
                )
                
                preTiltParentToPartOriginDic +=
                    parentAndObjectToPartOriginDictionary.makeAndGetForParentToPart()
                
                preTiltObjectToPartOriginDic +=
                    parentAndObjectToPartOriginDictionary.makeAndGetForObjectToPart()
        }

            
        func createCornerDictionary(
            _ dictionary: PositionDictionary,
            _ dimension: Part3DimensionDictionary)
            -> CornerDictionary{
            let removeObjectName = RemoveObjectName() // key starts object_id0, remove
            var cornerDictionary: CornerDictionary = [:]//pre and post tilt
            var corners: [PositionAsIosAxes] = []
            for (key, value) in dimension {
                let originValue = dictionary[key]
                if let originValue {
                    corners =
                        CreateIosPosition
                        .getCornersFromDimension( value)
                    let cornersFromObject =
                        CreateIosPosition.addToupleToArrayOfTouples(
                            originValue,
                            corners)
                    let topViewCorners = [4,5,6,7].map {cornersFromObject[$0]}
                    //
                    let sideViewCorners = CreateIosPosition.swapXY([4,7,3,0].map {cornersFromObject[$0]})
                    
                    // for compatability with prevous code
                    //object_id0_ is removed from the start
                    //of the name
                    let nameWithoutObject = removeObjectName.remove(key)
                    
                    cornerDictionary += [nameWithoutObject: topViewCorners]
                }
            }
            return cornerDictionary
        }
            
            
        func createPostTiltObjectToPartFourCornerPerKeyDic()
            -> CornerDictionary{
                //replace the part origin positions with the rotated values
                // and rotate the corners of the part
            var tilted: CornerDictionary = [:]
                if BaseObjectGroups().backSupport.contains(objectType) {
                    tilted =
                    OriginPostTilt(
                        parent: self,
                        originIdPartChainForBackForBothSitOn,
                        .sitOnTiltJoint).objectToTiltedCorners
                }
                
                return
                    Replace(
                        initial:
                            preTiltObjectToPartFourCornerPerKeyDic,
                        replacement: tilted
                        
                    ).intialWithReplacements
        }
            
    } // Init ends
    

//    func rotationIsRequired (
//        _ key: String)
//        -> Bool {
//        let part = FindGeneralPart(key).partCase
//        return
//            TiltPartChain().allAngle.contains( part) &&
//            SupportObjectGroups().canTilt.contains(baseType)
//    }
//
    
    
    
    
    
    /// rules if parent is object if contains
    /// rules if parent is sitOn if contains  sitOn_id0_n
    /// rules if parent is backSupport
    /// tilt: get  part centre from rotation centtre and transfrom origin and transform part  dimension then sum transformed origin and transformed dimension for viewed size in plane
    ///  get % + child from parent and transform
    ///  repeat for each child
    ///  recline:  repeat above using new rotation centre and new angle but acting on tillted origin and tilted dimension
    
    
    

    
   
} //Parent struct ends



//MARK: SET ANGLES
extension DictionaryProvider {
    
    /// Provides extant  passed in value or if not default
    /// of the change in angle from the neutral configuration
    struct ObjectAngleChange {
        var dictionary: AngleDictionary = [:]
        
        init(
            parent: DictionaryProvider) {
            
                for id in parent.oneOrTwoIds {
                    setAngleDictionary( id)
                }
                
                
                func setAngleDictionary( _ id: Part) {
                let partForNames: [[Part]] =
                    [
                        [.sitOnTiltJoint, .stringLink, .sitOn, id],
                        [.backSupportTiltJoint, .stringLink, .sitOn, id],
                        [.legSupportAngle, .stringLink, .sitOn, id]
                    ]
                let defaultAngles =
                    [
                        OccupantBodySupportDefaultAngleChange(parent.objectType).value,
                        OccupantBackSupportDefaultAngleChange(parent.objectType).value,
                        OccupantFootSupportDefaultAngleChange(parent.objectType).value
                    ]
                var name: String
                var angle: Measurement<UnitAngle>
                for index in 0..<partForNames.count {
                    name =
                        CreateNameFromParts(partForNames[index]).name
                    angle =
                        parent.angleDicIn[name] ?? defaultAngles[index]
                    dictionary += [name: angle]
                }
            }
        }
    }
    
    //DefaultAngleMinMax
    struct ObjectAngleMinMax {
        var dictionary: AngleMinMaxDictionary = [:]

        init(
            parent: DictionaryProvider) {

                for id in parent.oneOrTwoIds {
                    setAngleDictionary( id)
                }


                func setAngleDictionary( _ id: Part) {
                let partForNames: [[Part]] =
                    [
                    [.sitOnTiltJoint, .stringLink, .sitOn, id]]
                let defaultMinMax =
                    [
                    OccupantBodySupportDefaultAngleMinMax(parent.objectType).value]
                var name: String
                var angleMinMax: AngleMinMax
                    for index in 0..<partForNames.count {
                    name =
                        CreateNameFromParts(partForNames[index]).name
                    angleMinMax =
                       parent.angleMinMaxDicIn[name] ??
                        defaultMinMax[index]
                    dictionary += [name: angleMinMax]
                      //print (dictionary)
                }
            }
        }
    }
    
}


//MARK: ORIGIN POST TILT
extension DictionaryProvider {
    
    ///all parts in the partChain are tilted
    ///about the Ios x axis
    ///at the parameter rotationJoint
    ///but the angle of rotation is zero
    ///unless the option dictionary permits the UI to set a
    ///non-zero angle in angleChangeIn
    ///or an object has a non-zero angle
    ///set in angleChangeDefault
    struct OriginPostTilt {
        let parent: DictionaryProvider
        var objectToTiltedCorners: CornerDictionary = [:]
        
        init(
            parent: DictionaryProvider,
              _ originIdPartChain: [OriginIdPartChain],
              _ rotationJoint: Part) {
//print(originIdPartChain)
            self.parent = parent
                  
                  for index in 0..<parent.oneOrTwoIds.count {
                forTilt(
                    parent,
                    parent.oneOrTwoIds[index],
                    originIdPartChain[index],
                    rotationJoint)
            }
        }
        
        mutating func forTilt (
            _ parent: DictionaryProvider,
            _ sitOnId: Part,
            _ originIdPartChain: OriginIdPartChain,
            _ rotationJoint: Part) {
            let tiltOriginPart: [Part] =
                [.object, .id0, .stringLink, rotationJoint, .id0, .stringLink, .sitOn, sitOnId]
            let originOfRotationName =
                    CreateNameFromParts(tiltOriginPart).name

            if let originOfRotation = parent.preTiltObjectToPartOriginDic[originOfRotationName] {
                
                let angleName =
                    CreateNameFromParts( [rotationJoint, .stringLink, .sitOn, sitOnId]).name
                let angleChange =
                    parent.angleDicIn[angleName] ??
                    parent.angleDic[angleName] ?? ZeroValue.angle
                
                for index in  0..<originIdPartChain.chain.count {
                    let partIds: [Part] =  originIdPartChain.ids[index]
                    
                    for partId in partIds {
                        var tiltedCornersFromObject: Corners = []
                        let partName =
                            CreateNameFromParts([
                                .object, .id0, .stringLink, originIdPartChain.chain[index], partId, .stringLink, .sitOn, sitOnId]).name

                        let originOfPart = parent.preTiltObjectToPartOriginDic[partName]
                        
                        let dimensionOfPart = parent.dimensionDic[partName]
                        if originOfPart != nil && dimensionOfPart != nil {
                            let allTiltedCornersFromPart =
                                PartToCornersPostTilt(
                                    dimensionIn: dimensionOfPart!,
                                    angleChangeIn: angleChange).aferRotationAre
                            let topViewTiltedCornersFromPart =
                                [4,5,2,3].map {allTiltedCornersFromPart[$0]}
                            let newPosition =
                                PositionOfPointAfterRotationAboutPoint(
                                    staticPoint: originOfRotation,
                                    movingPoint: originOfPart!,
                                    angleChange: angleChange
                                ).fromObjectOriginToPointWhichHasMoved
                            for corner in topViewTiltedCornersFromPart {
                                tiltedCornersFromObject.append(
                                    CreateIosPosition.addTwoTouples(
                                        newPosition,
                                        corner)
                                )
                            }
                            objectToTiltedCorners += [partName: tiltedCornersFromObject]
                        }
                    }
                }
            } else {
                print("no such origin of rotation as \(originOfRotationName)")
            }
        }
        
    }
    
}



//MARK: ANY originIdPartChain
extension DictionaryProvider {
    struct PreTiltOccupantAnyPart: InputForDictionary {
        var allOriginIdPartChain: [[OriginIdPartChain]] = []
        let chain: PartChain
        let parent: DictionaryProvider
        var objectType: ObjectTypes
        var allOrigin: [PositionAsIosAxes] = []
        let sitOnId: Part
       // var widthBetweenWheels: Double = 0.0

        init(
            _ sitOnId: Part = .id0,//only coded for one sitOn
            parent: DictionaryProvider,
            chainLabel: Part){
            self.parent = parent
            self.sitOnId = sitOnId
            objectType = parent.objectType
         
            chain = LabelInPartChainOut([chainLabel]).partChains[0]

           if chain == [] {
                fatalError("a chain without any chainLabel  ")
            }
            allOriginIdPartChain = [[getOriginIdPartChain(chainLabel)]]
                
            func getOriginData(_ chainLabel: Part) {
               
                let sitOnOrigin = getSitOnOrigin()
                
                switch chainLabel {
                case .footSupport, .footOnly:
                    getOrigin(PreTiltOccupantFootSupportDefaultOrigin(parent.objectType))
                case .sideSupport:
                    getOrigin(PreTiltOccupantSideSupportDefaultOrigin(parent.objectType))
                case .backSupport, .backSupportHeadSupport:
                    getOrigin(PreTiltOccupantBackSupportDefaultOrigin(parent.objectType))
                    
                case .sitOn:
                    allOrigin.append(sitOnOrigin)
                    
                case .sitOnTiltJoint:
                    getOrigin(PreTiltWheelBaseJointDefaultOrigin(parent.objectType))
                    
                case .fixedWheelAtRear, .fixedWheelAtMid, .fixedWheelAtFront, .casterWheelAtFront:
                    getOrigin(PreTiltWheelBaseJointDefaultOrigin(parent.objectType) )
               
                    
                default:
                    fatalError("part not defined for chainLabel: \(chainLabel)")
                }
                
                
            func getOrigin(_ partOrigin: PartOrigin) {
                for part in chain {
                    if part == .sitOn {
                        allOrigin.append(sitOnOrigin)
                    } else {

                        var newPartOrigin = partOrigin
                        newPartOrigin.reinitialise(part)
                        allOrigin.append( newPartOrigin.origin)
                        
                    }
                }
            }
                  
                    
            func getSitOnOrigin() -> PositionAsIosAxes {
                let onlyOne = 0
                return
                    PreTiltSitOnAndWheelBaseJointOrigin(objectType).sitOnOrigins.onlyOne [onlyOne]
                }
            }

            
          func getOriginIdPartChain(_ chainLabel: Part)
                -> OriginIdPartChain {
                let objectId =
                    parent.partChainsIdDicIn [chain] ?? // UI may have changed the chain
                    PartChainsIdDictionary([chain], sitOnId).dic[chain]!
                getOriginData(chainLabel)
                let originIdPartChain =
                    (
                    origin: allOrigin,
                    ids: objectId,
                    chain: chain)
                    
                    //print(originIdPartChain)
                return
                    originIdPartChain
            }
        }
    }
}














///Provides the origin and id and nodes (an array of parts in order from  object origin to end part for the relevant parts where id is a one or two element array indicating that the part is unilateral or bilateral respectively).   Example nodes is [.wheelJoint, .casterFork, .casterWheel] , ids is [[id0, id1], [id0, id1], [id0, id1]] indicating two caster wheels
protocol InputForDictionary {
    // the input value
    var objectType: ObjectTypes {get}
    // the return value
    // An array of array as some structs
    // provide more than one array of OriginIdNodes
    var allOriginIdPartChain: [[OriginIdPartChain]] {get}
}


/// Provides a means of passing dimenions for parts
/// to one function
protocol PartDimension {
    //var part: Part? {get}
    var dimension: Dimension3d {get}
    mutating func reinitialise(_ part: Part?)
}

/// Provides a means of passing origin for parts
/// to one function
protocol PartOrigin{
    //var part: Part? {get}
    var origin: PositionAsIosAxes {get}
    mutating func reinitialise(_ part: Part?)
}
