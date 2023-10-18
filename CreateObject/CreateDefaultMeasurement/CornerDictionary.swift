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
    
    //InputForDictionary is a prelimary for
    // dictionary creation
    var preTiltOccupantBodySupportOrigin: InputForDictionary?
    //var preTiltOccupantFootBackSideSupportOrigin: InputForDictionary?
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
        if !objectGroups.noWheel.contains( objectType) {
            preTiltOccupantBodySupportOrigin =
            PreTiltOccupantBodySupportOrigin(parent: self)
            getPreTiltBodyOriginDictionary()
        }
        
        getPreTiltFootSideBackOriginDictionary()
        
        //do not add wheels to for example a shower tray
        if !objectGroups.noWheel.contains( objectType) {
            preTiltWheelOrigin = getPreTiltWheelOrigin()
                if let preTiltWheelOrigin {
                    preTiltWheelOriginIdNodes =
                    getPreTiltWheelOriginIdNodes(
                        preTiltWheelOrigin as!
                            DictionaryProvider.PreTiltWheelOrigin)
                }
            getPreTiltWheelOriginDictionary(preTiltWheelOriginIdNodes)
            //MARK: - DIMENSIONS
                    createWheelDimensionDictionary()
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
            
      
        func getPreTiltWheelOrigin()
            -> InputForDictionary? {
            var preTiltWheelOrigin: InputForDictionary?
            //I could not reselve errors if I moved
            //wheelOrigin assignment to init
            if let preTiltOccupantBodySupportOrigin {
               let preTiltOccupantBodySupportOriginDowncast =
                    preTiltOccupantBodySupportOrigin as?
                        PreTiltOccupantBodySupportOrigin
                preTiltWheelOrigin =
                    PreTiltWheelOrigin(
                        parent: self,
                        bodySupportOrigin:
                            preTiltOccupantBodySupportOriginDowncast!)
            }

            return preTiltWheelOrigin
        }
            
            
        func getPreTiltWheelOriginIdNodes (
            _ preTiltWheelOrigin: PreTiltWheelOrigin)
            -> RearMidFrontOriginIdNodes {
            let rearIndex = 0
            let midIndex = 1
            let frontIndex = 2
            let indexForNodeGroup = 0
            let allOriginIdNodesForMid =
            BaseObjectGroups()
                .sixWheels.contains(objectType) ?
            preTiltWheelOrigin.allOriginIdPartChain[midIndex][indexForNodeGroup] : ZeroValue.originIdPartChain
            
            let allOriginIdNodes =
                (rear: preTiltWheelOrigin.allOriginIdPartChain[rearIndex][indexForNodeGroup] ,
                 mid: allOriginIdNodesForMid,
                 front: preTiltWheelOrigin.allOriginIdPartChain[frontIndex][indexForNodeGroup])
            
            return
                allOriginIdNodes
        }
            
            
        func getPreTiltBodyOriginDictionary( ) {
            if let data =
                preTiltOccupantBodySupportOrigin{
                let indexForNodeGroup = 0
                let allOriginIdNodesForSitOnForBothSitOn = data.allOriginIdPartChain[indexForNodeGroup]

                for allOriginIdNodesForSitOn in allOriginIdNodesForSitOnForBothSitOn {

                    
                let preTiltParentToPartBodyOrigin =
                        OriginIdPartChainInDictionariesOut(
                            allOriginIdNodesForSitOn,
                            preTiltParentToPartOriginDicIn
                    ).makeAndGetForParentToPart()

//                for the body origin
//                parent and object are identical
                preTiltObjectToPartOriginDic += preTiltParentToPartBodyOrigin
                preTiltParentToPartOriginDic += preTiltParentToPartBodyOrigin
                }
            }
        }
            
        
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
//            let chainLabels:[Part] =
//            objectsAndTheirChainLabels[objectType] ?? [.sitOn]//
           
//            for chainLabel in chainLabels {
//                createAnyOriginAndDimensionDic(
//                    chainLabel)
//
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
                    PreTiltOccupantAnySupport(
                        .id0,
                        parent: self,
                        chainLabel: chainLabel
                    ).allOriginIdPartChain[0]
                    
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
                                OccupantSideSupportDefaultDimension2(objectType)
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
                            dimensionData = OccupantBodySupportAngleJointDefaultDimension(objectType)
                        default:
                            fatalError("Not yet defined for createAnyOriginAndDimensionDic")
                    }

                //OriginDic
                for allOriginIdPartChain in
                        allOriginIdPartChainForBothSitOn {
                   
                            createPreTiltParentToPartFootSideBackOriginDictionary(allOriginIdPartChain)
                    //print(#function)
                    if var dimensionData {
                        var allDimensions: [Dimension3d] = []
                        for part in chain {
                            dimensionData.reinitialise(part)
                            allDimensions.append(dimensionData.dimension)
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

        //}
            
    
        func createWheelDimensionDictionary() {
            let wheelDimensionDictionary =
            WheelDimensionDictionary(parent: self)
            
            dimensionDic += wheelDimensionDictionary.forWheels
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
    
    
    //MARK: SET ANGLES
    
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
                    [.sitOnTiltJoint, .stringLink, .sitOn, id],
//                    [.backSupportReclineAngle, .stringLink, .sitOn, id],
//                    [.legSupportAngle, .stringLink, .sitOn, id]
                    ]
                let defaultMinMax =
                    [
                        OccupantBodySupportDefaultAngleMinMax(parent.objectType).value,
                      
                    ]
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
    
    //DefaultAngleMinMax
} //Parent struct ends


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






// MARK: WHEEL ORIGINIDNODES EXTENSION
extension DictionaryProvider.PreTiltWheelOrigin {
    func getOriginIdNodesForRear()
        -> OriginIdPartChain {
        let allRearNodes =
                getRearNodes()
        let uniOrBilateralWidthPositionIdAtRear =
                Array(repeating: WheelId(parent.objectType).atRear,
                      count: allRearNodes.count)
          return
                (
                origin: getRearOrigin(),
                ids: uniOrBilateralWidthPositionIdAtRear,
                chain: allRearNodes)
    }
    
    
    func getOriginIdNodesForMid ()
        -> OriginIdPartChain {
        var originIdNodesForMid = ZeroValue.originIdPartChain
        if BaseObjectGroups().midWheels.contains(parent.objectType) {
            let allMidNodes =
                getMidNodes()
            let
            uniOrBilateralWidthPositionIdAtMid =
            Array(repeating: WheelId(parent.objectType).atMid,
                  count: allMidNodes.count)
            originIdNodesForMid =
                (
                origin: getMidOrigin(),
                ids:   uniOrBilateralWidthPositionIdAtMid,
                chain: allMidNodes)
        }
        return
            originIdNodesForMid
    }
    
    
    func getOriginIdNodesForFront ()
    -> OriginIdPartChain {
        let allFrontNodes =
                getFrontNodes()
        let dualOrSingleWidthPositionIdAtFront =
                Array(repeating: WheelId(parent.objectType).atFront,
                      count: allFrontNodes.count)
        return
            (
            origin: getFrontOrigin(),
            ids: dualOrSingleWidthPositionIdAtFront,
            chain: allFrontNodes)
    }
                // fetch the wheel origins for the base type one, two or three with +x or x =0
                // baseWheelJointIndex are ordered so that
                // each origin if a pair assigns to the next baseWheelJointIndexPair
    
}


// MARK: WHEEL NODES EXTENSION
extension DictionaryProvider.PreTiltWheelOrigin {
    func getRearNodes()
        -> [Part] {
        var chain: [Part] = []
        if BaseObjectGroups().rearCaster.contains(parent.objectType) {
            chain =
                partChainWheelProvider.casterWheelPartChain
//print(parent.baseType)
        }
        
        if BaseObjectGroups().rearFixedWheel.contains(parent.objectType) {
            chain =
                partChainWheelProvider.fixedWheelNodes
        }
            return chain
    }
    
    func getMidNodes()
        -> [Part] {
        var chain: [Part] = []
        if BaseObjectGroups().midCaster.contains(parent.objectType) {
            chain =
                partChainWheelProvider.casterWheelPartChain
        }
        
        if BaseObjectGroups().midFixedWheel.contains(parent.objectType) {
            chain =
                partChainWheelProvider.fixedWheelNodes
        }
            return chain
    }
    
    
    func getFrontNodes()
        -> [Part] {
        var chain: [Part] = []
        if BaseObjectGroups().frontCaster.contains(parent.objectType) {
            chain =
                partChainWheelProvider.casterWheelPartChain
        }
        
        if BaseObjectGroups().frontFixedWheel.contains(parent.objectType) {
            chain =
                partChainWheelProvider.fixedWheelNodes
        }
            return chain
    }
            
}

//MARK: EXTENSION PreTiltOccupantSupportOrigin DIMENSION
//extension DictionaryProvider.PreTiltOccupantBodySupportOrigin {
//
//
//}


// MARK: WHEEL ORIGIN EXTENSION
/// wheelPartOrigin for rear or mid or front are required
/// and values depend on the object origin: rear, mid or front
extension DictionaryProvider.PreTiltWheelOrigin {
    
    func getRearOrigin()
        -> [PositionAsIosAxes]{
        var rearOrigin: [PositionAsIosAxes] = []
            
        let forkAndCasterWheelForRear =
            [casterOrigin.forRearCasterVerticalJointToFork(),
             casterOrigin.forRearCasterForkToWheel()]

        if BaseObjectGroups().midPrimaryOrigin.contains(parent.objectType) {
            rearOrigin =
                [
                wheelAndCasterVerticalJointOrigin
                    .getRearCasterWhenMidPrimaryOrigin()] +
                forkAndCasterWheelForRear
        }
        if BaseObjectGroups().frontPrimaryOrigin.contains(parent.objectType) {
            rearOrigin =
                [
                wheelAndCasterVerticalJointOrigin
                    .getRearCasterWhenFrontPrimaryOrigin()] +
                forkAndCasterWheelForRear
        }
            
        if BaseObjectGroups().rearPrimaryOrigin.contains(parent.objectType) {
            if BaseObjectGroups().allFourCaster.contains(parent.objectType) {
                rearOrigin =
                    [
                    wheelAndCasterVerticalJointOrigin
                        .getRearCasterWhenRearPrimaryOrigin()] +
                    forkAndCasterWheelForRear
            } else {         //fixed wheel
                rearOrigin =
                    getForWheelDrive()
            }
        }
        return rearOrigin
    }
    
    
    func getMidOrigin()
        -> [PositionAsIosAxes] {
        var midOrigin: [PositionAsIosAxes] = []
        let forkAndCasterWheel =
            [casterOrigin.forMidCasterVerticalJointToFork(),
             casterOrigin.forMidCasterForkToWheel()]
            //rear caster
        if BaseObjectGroups()
            .allCaster.contains(parent.objectType) {
            midOrigin =
                [
                wheelAndCasterVerticalJointOrigin
                    .getRearCasterWhenRearPrimaryOrigin()] +
                forkAndCasterWheel
        }
                  
        if BaseObjectGroups()
            .midFixedWheel.contains(parent.objectType) {
            midOrigin =
                getForWheelDrive()
        }
       
        return midOrigin
    }
    
    /// if front caster rear primary OR mid primary origin
    /// if fixed wheel
    func getFrontOrigin()
        -> [PositionAsIosAxes] {
        var frontOrigin: [PositionAsIosAxes] = []
        let forkAndCasterWheel =
            [casterOrigin.forFrontCasterVerticalJointToFork(),
             casterOrigin.forFrontCasterForkToWheel()]
            
        if BaseObjectGroups().rearPrimaryOrigin.contains(parent.objectType) {
                frontOrigin =
                    [
                    wheelAndCasterVerticalJointOrigin
                        .getFrontCasterWhenRearPrimaryOrigin()] +
                    forkAndCasterWheel
        }
            
        if BaseObjectGroups().midPrimaryOrigin.contains(parent.objectType) {
            
                frontOrigin =
                    [
                    wheelAndCasterVerticalJointOrigin
                        .getFrontCasterWhenMidPrimaryOrigin()] +
                    forkAndCasterWheel
        }
             
        //for frontPrimaryOrigin no objects with front casters
            
        if BaseObjectGroups().frontFixedWheel.contains(parent.objectType) {
        
            frontOrigin =
                getForWheelDrive()
        }
        
        return frontOrigin
    }
    
    func getForWheelDrive()
        -> [PositionAsIosAxes] {

        return
           BaseObjectGroups()
                .allDriveOrigin.contains(parent.objectType) ?
                    [
                    wheelAndCasterVerticalJointOrigin
                        .getRightDriveWheel(),
                    ZeroValue.iosLocation]: [] //joint and wheel coterminous
    }
    
}



//MARK: WHEEL ORIGIN
extension DictionaryProvider {
    struct PreTiltWheelOrigin: InputForDictionary {
        //assignment form for static values
        var partChainWheelProvider: PartChainWheelProvider.Type = PartChainWheelProvider.self
        
        //ObjectCreator
        let objectType: ObjectTypes
        var allOriginIdPartChain: [[OriginIdPartChain]] = []
        
        let lengthBetweenFrontAndRearWheels: Double
        let parent: DictionaryProvider
        let bodySupportOrigin: PreTiltOccupantBodySupportOrigin
        let wheelAndCasterVerticalJointOrigin: WheelAndCasterVerticalJointOrigin
        let casterOrigin: CasterOrigin
        var allOriginIdNodesForRear: OriginIdPartChain = ZeroValue.originIdPartChain
        var allOriginIdNodesForMid: OriginIdPartChain = ZeroValue.originIdPartChain
        var allOriginIdNodesForFront: OriginIdPartChain = ZeroValue.originIdPartChain

        init(
            parent: DictionaryProvider,
            bodySupportOrigin: PreTiltOccupantBodySupportOrigin ) {
                
            self.parent = parent
            self.bodySupportOrigin = bodySupportOrigin
            
            lengthBetweenFrontAndRearWheels =
            getLengthBetweenFrontAndRearWheels()
            
            objectType = parent.objectType
                
            let widthBetweenWheelsAtOrigin = getWidthBetweenWheels()
            
            wheelAndCasterVerticalJointOrigin =
                WheelAndCasterVerticalJointOrigin(
                    parent.objectType,
                    lengthBetweenFrontAndRearWheels,
                    widthBetweenWheelsAtOrigin)
            
            casterOrigin = CasterOrigin(parent.objectType)
            
               // let baseObjectGroups = BaseObjectGroups()

            allOriginIdNodesForRear =
                getOriginIdNodesForRear()

            allOriginIdNodesForMid =
                getOriginIdNodesForMid ()

            allOriginIdNodesForFront =
                getOriginIdNodesForFront()

            allOriginIdPartChain =
                [[allOriginIdNodesForRear],
                 [allOriginIdNodesForMid] ,
                 [allOriginIdNodesForFront]]

                
            func getLengthBetweenFrontAndRearWheels ()
                -> Double {
                TwinSitOn(parent.twinSitOnOption).frontAndRearState ?
                    bodySupportOrigin.lengthBetweenWheels.frontRearIfFrontAndRearSitOn():
                    bodySupportOrigin.lengthBetweenWheels.frontRearIfNoFrontAndRearSitOn()
            }
            
            func getWidthBetweenWheels()
                -> Double {
                
                let bodySupportDimension =
                        bodySupportOrigin.occupantBodySupportsDimension
                let sideSupportDimension =
                        bodySupportOrigin.occupantSideSupportsDimension
                   
                    let widthWithoutStability =
                        bodySupportDimension.count == 2 ?
                            (forIndex(0) + forIndex(1)): forIndex(0)
                    let width = widthWithoutStability +
                    Stability(parent.objectType).atLeft +
                    Stability(parent.objectType).atRight
                    
                    func forIndex(_ id: Int) -> Double {
                        return
                            bodySupportDimension[id].width + sideSupportDimension[id][0].width + sideSupportDimension[id][1].width
                    }
            return width
            }
        }
    }
}


//MARK: ANY originIdPartChain
extension DictionaryProvider {
    struct PreTiltOccupantAnySupport: InputForDictionary {
        var allOriginIdPartChain: [[OriginIdPartChain]] = []
        
        let chain: PartChain
        let parent: DictionaryProvider
        var objectType: ObjectTypes
        var allOrigin: [PositionAsIosAxes] = []
        let sitOnId: Part

        init(
            _ sitOnId: Part = .id0,
            parent: DictionaryProvider,
            chainLabel: Part){
            self.parent = parent
            self.sitOnId = sitOnId
            objectType = parent.objectType
            
            chain = LabelInPartChainOut([chainLabel]).partChains[0]
           if chain == [] {
                fatalError("No LabelInPartChainOut defined for this label")
            }
            allOriginIdPartChain = [[getOriginIdPartChain(chainLabel)]]
                
            func getOriginData(_ chainLabel: Part) {
                
                let sitOnOrigin = getSitOnOrigin()
                
                if [.footSupport , .footOnly] .contains(chainLabel) {
                    getOrigin(PreTiltOccupantFootSupportDefaultOrigin(parent.objectType))
                }
                if chainLabel  == .sideSupport {
                    getOrigin(PreTiltOccupantSideSupportDefaultOrigin(parent.objectType))
                }
                if chainLabel  == .backSupport {
                    getOrigin( PreTiltOccupantBackSupportDefaultOrigin(parent.objectType))
                }
                if chainLabel  == .backSupportHeadSupport {
                    getOrigin(PreTiltOccupantBackSupportDefaultOrigin(parent.objectType))
                }
                if chainLabel  == .sitOn {
                    allOrigin.append(getSitOnOrigin())
                }
                if chainLabel  == .sitOnTiltJoint {
                    getOrigin(PreTiltSitOnBackFootTiltJointDefaultOrigin(parent.objectType))
                }
                
                
            func getOrigin(_ partOrigin: PartOrigin) {
                for part in chain {
                    if part == .sitOn {
                        allOrigin.append(sitOnOrigin)
                    } else {
                        //print("detect")
                        var newPartOrigin = partOrigin
                        newPartOrigin.reinitialise(part)
                        allOrigin.append( newPartOrigin.origin)
                    }
                }
            }
                  
                    
            func getSitOnOrigin() -> PositionAsIosAxes {
                var origin: PositionAsIosAxes = ZeroValue.iosLocation
                let sitOnSupport =                        parent.preTiltOccupantBodySupportOrigin as? PartOrigin
                if var sitOnSupport {
                    sitOnSupport.reinitialise(Part.sitOn)
                    
                    origin = sitOnSupport.origin
                }
                return origin
                }
            }
     
            
          func getOriginIdPartChain(_ chainLabel: Part)
                -> OriginIdPartChain {
              
                let objectId =
                    parent.partChainsIdDicIn [chain] ??
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







//MARK: BODY SUPPORT ORIGIN
extension DictionaryProvider {

    /// The ability to add two seats side by side or back to front
    /// combined with the the different object origins with respect
    /// to the body support, for example, front drive v rear drive
    /// requires the following considerable logic
    struct PreTiltOccupantBodySupportOrigin: InputForDictionary, PartOrigin
    {
        var origin: PositionAsIosAxes = ZeroValue.iosLocation

        mutating func reinitialise(_ part: Part?) {
            
        }
        
        //var partChainProvider: PartChainProvider.Type = PartChainProvider.self
 
        let objectType: ObjectTypes
        let stability: Stability
        var origins: [PositionAsIosAxes] = []
        let frontAndRearState: Bool
        let leftandRightState: Bool

        var occupantBodySupportsDimension: [Dimension3d] = []
        var occupantSideSupportsDimension: [[Dimension3d]] = []
        var occupantFootSupportHangerLinksDimension: [Dimension3d] = []
        
        let lengthBetweenWheels: DistanceBetweenWheels
        var allOriginIdNodesForBodySupportForBothSitOn:  [OriginIdPartChain] = []
        //used externally
        var allOriginIdPartChain: [[OriginIdPartChain]] = []
        //var sitOnOrigin: [PositionAsIosAxes]
        
        init(
            parent: DictionaryProvider) {
                objectType = parent.objectType
            stability = Stability(parent.objectType)
            
            frontAndRearState = parent.twinSitOnOption[.frontAndRear] ?? false
            leftandRightState = parent.twinSitOnOption[.leftAndRight] ?? false

            //Dimension
            occupantBodySupportsDimension =
                [getModifiedOrDefaultSitOnDimension(.id0)] +
                (parent.twinSitOnState ? [getModifiedOrDefaultSitOnDimension(.id1)] : [])
                
            occupantSideSupportsDimension =
                [getModifiedSideSupportDimension(.id0)] +
                (parent.twinSitOnState ? [getModifiedSideSupportDimension(.id1)] : [])
                
            occupantFootSupportHangerLinksDimension =
                [getModifiedOrDefaultMaximumHangerLinkDimension(.id0)] +
                (parent.twinSitOnState ? [getModifiedOrDefaultMaximumHangerLinkDimension(.id1)]: [])
            
            lengthBetweenWheels =
                DistanceBetweenWheels(
                    parent.objectType,
                    occupantBodySupportsDimension,
                    occupantFootSupportHangerLinksDimension)
            if parent.objectGroups.rearFixedWheel.contains(parent.objectType) {
            forRearPrimaryOrigin()
            }
            if parent.objectGroups.frontFixedWheel.contains(parent.objectType) {
            forFrontPrimaryOrgin()
            }
            if parent.objectGroups.midFixedWheel.contains(parent.objectType) {
            forMidPrimaryOrigin()
            }
            if parent.objectGroups.allFourCaster.contains(parent.objectType) {
            forRearPrimaryOrigin()
            }
                
            getAllOriginIdNodesForBodySupportForBothSitOn()
                
            allOriginIdPartChain.append(allOriginIdNodesForBodySupportForBothSitOn)
            //sitOnOrigin.append(allOriginIdPartChain[0].origin)
             origin = origins[0]
            func getAllOriginIdNodesForBodySupportForBothSitOn() {
                for index in 0..<parent.oneOrTwoIds.count {
                    let ids = [[parent.oneOrTwoIds[index]]]
                    allOriginIdNodesForBodySupportForBothSitOn.append(
                        (
                        origin: [origins[index]],
                        ids: ids,
                        chain: [.sitOn] ) )
                }
            }
   
                
            func getModifiedOrDefaultSitOnDimension(_ id: Part)
                -> Dimension3d {
                let name =
                    CreateNameFromParts([.object, .id0, .stringLink, .sitOn, id, .stringLink, .sitOn, id]).name
                let modifiedDimension = parent.dimensionDicIn[name] ?? OccupantBodySupportDefaultDimension(parent.objectType).value
                return
                   modifiedDimension
            }
            
                
            func getModifiedSideSupportDimension(_ id: Part)
                -> [Dimension3d] {
                    var sideSupportDimension: [Dimension3d] = []
                    let sideSupportIds: [Part] = [.id0, .id1]
                    for sideId in sideSupportIds {
                        let name =
                            CreateNameFromParts([.object, .id0, .stringLink, .sideSupport, sideId, .stringLink, .sitOn, id]).name
                        let modifiedDimension = parent.dimensionDicIn[name] ??
                        OccupantSideSupportDefaultDimension(parent.objectType).value
                        //sideSupportDefaultDimension
                        sideSupportDimension.append(modifiedDimension)
                    }
                return
                    sideSupportDimension
            }
                
                
            func getModifiedOrDefaultMaximumHangerLinkDimension(
                    _ id: Part)
                -> Dimension3d {
                    let index = id == .id0 ? 0: 1
                    let footSupportInOnePieceState = false //parent.objectOptions[index][.footSupportInOnePiece] ?? false
                    let names: [String] =
                    [CreateNameFromParts([.footSupportHangerLink, .id0, .stringLink, .sitOn, id]).name]
                    var modifiedDimensions: [Dimension3d?] = [parent.dimensionDicIn[names[0]]]
                    if footSupportInOnePieceState {
                    } else {
                        let name =
                        CreateNameFromParts([.footSupportHangerLink, .id1, .stringLink, .sitOn, id]).name
                        modifiedDimensions += [parent.dimensionDicIn[name]]
                    }
                    let unwrapped = modifiedDimensions.compactMap{ $0 }
                    var modifiedDimension: Dimension3d?
                    if unwrapped.count == 0 {
                        modifiedDimension = nil
                    } else {
                        let twoDoubles = [modifiedDimensions[0]!.length, modifiedDimensions[1]!.length]
                        let maximumDouble = twoDoubles.max()!
                        let index = twoDoubles.firstIndex(of: maximumDouble)!
                        modifiedDimension = modifiedDimensions[index]
                    }
                return
                   modifiedDimension ?? OccupantFootSupportDefaultDimension(parent.objectType).getHangerLink()
            }
        }
    
        
        mutating func forRearPrimaryOrigin() {
            origins.append(
                (x: 0.0,
                y:
                stability.atRear +
                 occupantBodySupportsDimension[0].length/2,
                 z: DictionaryProvider.sitOnHeight)
            )
            if frontAndRearState {
                origins.append(
                        (x: 0.0,
                        y:
                        stability.atRear +
                        occupantBodySupportsDimension[0].length +
                        occupantFootSupportHangerLinksDimension[0].length +
                        occupantBodySupportsDimension[1].length/2,
                         z: DictionaryProvider.sitOnHeight)
                )
            }
            if leftandRightState {
                let xOrigin1 =
                    leftAndRightX()
                let xOrigin0 =
                    -leftAndRightX()
                
            origins =
                [(x: xOrigin0,
                  y: origins[0].y,
                  z: 0.0),
                (x: xOrigin1,
                 y: origins[0].y,
                 z: DictionaryProvider.sitOnHeight)
                ]
            }
        }
        
        
       mutating func forMidPrimaryOrigin(){
            let baseLength = frontAndRearState ?
                lengthBetweenWheels.frontRearIfFrontAndRearSitOn(): lengthBetweenWheels.frontRearIfNoFrontAndRearSitOn()
            
            origins.append(
            (x: 0.0,
             y: 0.5 * (baseLength - occupantBodySupportsDimension[0].length),
             z: DictionaryProvider.sitOnHeight)
            )
            
            if frontAndRearState {
                origins =
                [
                (x: 0.0,
                 y: -origins[0].y,
                 z: DictionaryProvider.sitOnHeight)
                 ,
                (x: 0.0,
                 y: origins[0].y,
                z: DictionaryProvider.sitOnHeight)
                ]
            }
            
            if leftandRightState {
                origins =
                [
                (x: 0.0,
                 y: -origins[0].y,
                 z: DictionaryProvider.sitOnHeight)
                 ,
                (x: 0.0,
                 y: origins[0].y,
                z: DictionaryProvider.sitOnHeight)
                ]
            }
        }
        
        
       mutating func forFrontPrimaryOrgin() {
            origins.append(
                (x: 0.0,
                 y:
                -(stability.atFront +
                    occupantBodySupportsDimension[0].length/2),
                 z: DictionaryProvider.sitOnHeight )
                 )
            
            if frontAndRearState {
                origins = [
                    (x: 0.0,
                     y:
                        -stability.atFront -
                        occupantBodySupportsDimension[0].length -
                        occupantFootSupportHangerLinksDimension[1].length -
                        occupantBodySupportsDimension[1].length/2,
                     z: DictionaryProvider.sitOnHeight
                     ),
                    origins[0]
                ]
            }
            
            if leftandRightState {
                origins = [
                    (x: -leftAndRightX(),
                     y: origins[0].y,
                     z: DictionaryProvider.sitOnHeight),
                    (x: leftAndRightX(),
                     y: origins[0].y,
                     z: DictionaryProvider.sitOnHeight)
                ]
            }
        }
        
        func leftAndRightX ()
            -> Double {
            (occupantBodySupportsDimension[0].width +
             occupantBodySupportsDimension[1].width)/2 +
            occupantSideSupportsDimension[0][1].width +
            occupantSideSupportsDimension[1][0].width
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
