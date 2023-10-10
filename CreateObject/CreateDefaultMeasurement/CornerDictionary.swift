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
    let partChainsIn: [PartChain]
    let partChainsIdDicIn: [PartChain: [[Part]]]
    
    let objectType: BaseObjectTypes
    let twinSitOnOption: TwinSitOnOptionDictionary
    //let objectOptions: [OptionDictionary]
    var twinSitOnState: Bool //= false
    let oneOrTwoIds: [Part]
    var partChains: [PartChain] = []
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
    var preTiltOccupantFootBackSideSupportOrigin: InputForDictionary?
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
    
    
   
    
    ///the objects available, that is for which all code is present are included here
    static let objects: [BaseObjectTypes] = [
        .allCasterBed,.allCasterChair,.allCasterStretcher, .allCasterTiltInSpaceShowerChair,
        .fixedWheelFrontDrive, .fixedWheelMidDrive, .fixedWheelRearDrive, .showerTray]
    

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
    ///   - objectOptions: dictionary as [Enum: Bool] indicating options for object one per sitOn
    ///   - dimensionIn: empty or default or modified dictionary of part
    ///   - objectToPartOrigin: empty or default or modified dictionary as  [String: PositionAsIosAxes] indicating part origin, preTilt
    ///   - parentToPartOrigin: empty or default or modified dictionary as  [String: PositionAsIosAxes] indicating part origin, preTilt
    ///   - angleIn: empty or default or modified dictionary as [String: Measurement<UnitAngle>] indicating object configuration angles but not angles of parts which change during movement: sitOn tilt but not caster orientation
    init(
        _ objectType: BaseObjectTypes,
        _ twinSitOnOption: TwinSitOnOptionDictionary,
        //_ objectOptions: [OptionDictionary],
        _ dimensionIn: Part3DimensionDictionary = [:],
        _ objectToPartOrigin: PositionDictionary = [:],
        _ parentToPartOrigin: PositionDictionary = [:],
        angleIn: AngleDictionary = [:],
        minMaxAngleIn: AngleMinMaxDictionary = [:],
        partChainsIn: [PartChain] = [],
        partChainDictionaryIn: PartChainDictionary = [:],
        partChainsIdDicIn: PartChainIdDictionary = [:] ) {
            
        self.objectType = objectType
        self.twinSitOnOption = twinSitOnOption
       // self.objectOptions = objectOptions
        self.dimensionDicIn = dimensionIn
        self.preTiltObjectToPartOriginDicIn = objectToPartOrigin
        self.preTiltParentToPartOriginDicIn = parentToPartOrigin
        self.angleDicIn = angleIn
        self.angleMinMaxDicIn = minMaxAngleIn
        self.partChainsIn = partChainsIn
        self.partChainsIdDicIn = partChainsIdDicIn
            
  
        twinSitOnState = TwinSitOn(twinSitOnOption).state
        oneOrTwoIds = twinSitOnState ? [.id0, .id1]: [.id0]
            
            
//       print (baseType)
//            print (oneOrTwoIds)
//            print ("")
        angleDic =
            ObjectAngleChange(parent: self).dictionary
        angleMinMaxDic =
            ObjectAngleMinMax(parent: self).dictionary
//fprint(objectOptions)
            partChainDictionary = partChainDictionaryIn == [:] ? PartChainDictionaryProvider([.footSupport,.backSupportHeadSupport,.sideSupport]).dic: partChainDictionaryIn
            
            
            //partChainsIdDic =  [:]
            //DictionaryInArrayOut().getNameValue(partChainDictionaryIn).forEach{print($0)}
            //print(partChainsIn)
            
          
            
//MARK: - ORIGIN/DICTIONARY
            
        // both parent to part and
        // object to part
        if !objectGroups.noWheel.contains( objectType) {
            preTiltOccupantBodySupportOrigin =
            PreTiltOccupantBodySupportOrigin(parent: self)
            getPreTiltBodyOriginDictionary()
        }
        
        preTiltOccupantFootBackSideSupportOrigin =
            PreTiltOccupantSupportOrigin(parent: self)
            //partChains = preTiltOccupantFootBackSideSupportOrigin.partChains
            getPreTiltFootSideBackOriginDictionary()
   
            //print(partChainsIdDic)
        
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
        }

           

//MARK: - DIMENSIONS
        createOccupantSupportDimensionDictionary()

            
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

            // produces object_id0_tiltInSpaceHorizontalJoint_id1_sitOn_id0: 0.0, 250.0, 1500.0
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
            
            
        func getPreTiltFootSideBackOriginDictionary () {
            let objectPartChains = partChainsIn != [] ?
                partChainsIn: ObjectPartChains(objectType).partChains
            
            print (objectPartChains)
            print ("")
            let onlyOne = 0
            for objectPartChain in objectPartChains {
                let footChain =  LabelInPartChainOut([.footSupport]).partChains[onlyOne]
                if objectPartChain == footChain {
//                    PreTiltOccupantFootSupport(
//                        parent: self,
//                        chain: footChain)
                }
                
            }
            
            
            
            if let data =
                preTiltOccupantFootBackSideSupportOrigin
                    as? PreTiltOccupantSupportOrigin {
                
                partChains = data.partChains
                
                partChainsIdDic = data.idsDictionary
                
                if BaseObjectGroups().sitOnBackFootTiltJoint.contains(objectType) {
                    
                    let allOriginIdNodesForTiltInSpaceeForBothSitOn =
                        data.allOriginIdPartChainForSitOnBackFootTiltJointForBothSitOn
                    for allOriginIdNodesForTiltInSpace in
                            allOriginIdNodesForTiltInSpaceeForBothSitOn {
                                createPreTiltParentToPartFootSideBackOriginDictionary(allOriginIdNodesForTiltInSpace)
                       
                    }
                }


                let allOriginIdNodesForSideForBothSitOn = data.allOriginIdNodesForSideSupportForBothSitOn
                for allOriginIdNodesForSide in
                        allOriginIdNodesForSideForBothSitOn {
                            createPreTiltParentToPartFootSideBackOriginDictionary(allOriginIdNodesForSide)
                }
                
                let allOriginIdNodesForFootForBothSitOn = data.allOriginIdNodesForFootSupportForBothSitOn
                for allOriginIdNodesForFoot in
                        allOriginIdNodesForFootForBothSitOn {
                            createPreTiltParentToPartFootSideBackOriginDictionary(allOriginIdNodesForFoot)
                }
                
                originIdPartChainForBackForBothSitOn = data.originIdPartChainForBackForBothSitOn
                for originIdPartChainForBack in
                        originIdPartChainForBackForBothSitOn {
                            createPreTiltParentToPartFootSideBackOriginDictionary(originIdPartChainForBack)
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
            }
        }

      
        func createOccupantSupportDimensionDictionary() {
            let occupantSupportDimensionDictionary =
                    OccupantSupportDimensionDictionary(parent: self)
            
            dimensionDic += occupantSupportDimensionDictionary.forWheels
            dimensionDic +=
                occupantSupportDimensionDictionary.forBack
            dimensionDic += occupantSupportDimensionDictionary.forFoot
            dimensionDic += occupantSupportDimensionDictionary.forSide

            dimensionDic += occupantSupportDimensionDictionary.forTiltInSpace

            ///dimensionForBody must be subsequent to for... which have sitOn in their nodes
            ///otherwise§
            let dimensionForBody  = occupantSupportDimensionDictionary.forBody
            dimensionDic += dimensionForBody
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
                partChainProvider.casterWheelPartChain
//print(parent.baseType)
        }
        
        if BaseObjectGroups().rearFixedWheel.contains(parent.objectType) {
            chain =
                partChainProvider.fixedWheelNodes
        }
            return chain
    }
    
    func getMidNodes()
        -> [Part] {
        var chain: [Part] = []
        if BaseObjectGroups().midCaster.contains(parent.objectType) {
            chain =
                partChainProvider.casterWheelPartChain
        }
        
        if BaseObjectGroups().midFixedWheel.contains(parent.objectType) {
            chain =
                partChainProvider.fixedWheelNodes
        }
            return chain
    }
    
    
    func getFrontNodes()
        -> [Part] {
        var chain: [Part] = []
        if BaseObjectGroups().frontCaster.contains(parent.objectType) {
            chain =
                partChainProvider.casterWheelPartChain
        }
        
        if BaseObjectGroups().frontFixedWheel.contains(parent.objectType) {
            chain =
                partChainProvider.fixedWheelNodes
        }
            return chain
    }
            
}

//MARK: EXTENSION PreTiltOccupantSupportOrigin DIMENSION
extension DictionaryProvider.PreTiltOccupantBodySupportOrigin {
    
    
}


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
        var partChainProvider: PartChainProvider.Type = PartChainProvider.self
        
        //ObjectCreator
        let objectType: BaseObjectTypes
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
            
                let baseObjectGroups = BaseObjectGroups()

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


//MARK: FOOT ONLY
//extension DictionaryProvider {
//    struct PreTiltOccupantFootSupport: InputForDictionary {
//        var allOriginIdPartChain: [[OriginIdPartChain]]
//
//        let parent: DictionaryProvider
//        var objectType: BaseObjectTypes
//       // var allOriginIdPartChain: [[OriginIdPartChain]]
//        let sitOnId: Part
//
//        init(
//            _ sitOnId: Part = .id0,
//            parent: DictionaryProvider,
//            chain: PartChain){
//            self.parent = parent
//            self.sitOnId = sitOnId
//            objectType = parent.objectType
//
//                func getOriginIdPartChain(_ chain: [Part])
//                -> OriginIdPartChain {
//                let objectPartChains =
//                    parent.partChainsIn != [] ?
//                    parent.partChainsIn:
//                    ObjectPartChains(objectType).partChains
//
//                let objectId =
//                    parent.partChainsIdDicIn != [:] ?
//                    parent.partChainsIdDicIn:
//                    PartChainsIdDictionary([chain], sitOnId).dic
//
//                let defaultFootOrigin =
//                    PreTiltOccupantFootSupportDefaultOrigin(parent.objectType)
//
//                    let objectToSitOn =
//                    GetValueFromDictionary(
//                        parent.preTiltParentToPartOriginDic,
//                        [.object, .id0, .stringLink,.sitOn, sitOnId, .stringLink, .sitOn, sitOnId]).value
//
//
//                    let allFootSupportOrigin =
//                        [
//                        objectToSitOn,
//                        defaultFootOrigin.getSitOnToHangerJoint( ),
//                        defaultFootOrigin.getHangerJointToFootJoint( ),
//                        footJointToFootSupportOrigin]
//
//
//                return
//                    (
//                    origin: ,
//                    ids: objectId,
//                    chain: chain)
//            }
//
//
//        }
//
//    }
//}

//MARK: FOOT/SIDE/BACK/ROTATE ORIGIN
extension DictionaryProvider {
    struct PreTiltOccupantSupportOrigin: InputForDictionary {
        let parent: DictionaryProvider
        var partChainProvider: LabelInPartChainOut.Type = LabelInPartChainOut.self
        let objectType: BaseObjectTypes
        let bilateralWidthPositionId: [Part] = [.id0, .id1]
        let unilateralWidthPositionId: [Part] = [.id0]
       // let allPartIds:[Part] = [.id0, .id1]
        let defaultFootOrigin: PreTiltOccupantFootSupportDefaultOrigin
        let defaultBackOrigin: PreTiltOccupantBackSupportDefaultOrigin
        let defaultSideOrigin: PreTiltOccupantSideSupportDefaultOrigin
        var defaultSitOnBackFootTiltJointOrigin: PositionAsIosAxes = ZeroValue.iosLocation
        var sitOnId: Part = .id0
        var objectToSitOn: PositionAsIosAxes = ZeroValue.iosLocation
        var allOriginIdNodesForFootSupportForBothSitOn:  [OriginIdPartChain]  = []
        var allOriginIdNodesForSideSupportForBothSitOn:  [OriginIdPartChain]  = []
        var originIdPartChainForBackForBothSitOn:  [OriginIdPartChain]  = []
        var allOriginIdPartChainForSitOnBackFootTiltJointForBothSitOn:  [OriginIdPartChain]  = []
        var partChains: [PartChain] = []
        var idsDictionary: [ PartChain: [[Part]] ]  = [:]
        //let partChainProvider: PartChainProvider2
     
        /// an array in an arrray to allow use of protocol InputForDictionary
        /// though not used in this struct
        /// [ [OriginIdNodes] ] is used for wheels where there are three
        /// to represent rear, mid, front
        var allOriginIdPartChain: [[OriginIdPartChain]] = []

        init(
            parent: DictionaryProvider) {
                self.parent = parent
                objectType = parent.objectType
                defaultFootOrigin =
                    PreTiltOccupantFootSupportDefaultOrigin(parent.objectType)
                
                defaultBackOrigin =
                    PreTiltOccupantBackSupportDefaultOrigin(parent.objectType)
                
                defaultSideOrigin =
                    PreTiltOccupantSideSupportDefaultOrigin(parent.objectType)
                
                partChains = parent.partChainsIn != [] ?
                    parent.partChainsIn: ObjectPartChains(objectType).partChains
                
//                print(parent.partChainsIn)
//                print("")
                
                let sitOnIds = parent.oneOrTwoIds
                
                for sitOnIndex in 0..<sitOnIds.count {
                    sitOnId = sitOnIds[sitOnIndex]
                    
                    //as UI can amend the dic to alter bilateral parts
                    //use the UI amended dic if extant
                    idsDictionary =
                        parent.partChainsIdDicIn == [:] ?
                        PartChainsIdDictionary(partChains, sitOnId).dic: parent.partChainsIdDicIn
                    
                    
                    //access sit on position from dictionary
                    objectToSitOn =
                        GetValueFromDictionary(
                            parent.preTiltParentToPartOriginDic,
                            [.object, .id0, .stringLink,.sitOn, sitOnId, .stringLink, .sitOn, sitOnId]).value
                    
                    if BaseObjectGroups().sitOnBackFootTiltJoint.contains(parent.objectType) {
                        defaultSitOnBackFootTiltJointOrigin =
                            PreTiltSitOnBackFootTiltJointDefaultOrigin(parent.objectType).value
                        
                        allOriginIdPartChainForSitOnBackFootTiltJointForBothSitOn.append(
                            getOriginIdPartChainForTitltInSpace(sitOnIndex))
                    
                        errorCheckForIdenticalOriginIdNodes(allOriginIdPartChainForSitOnBackFootTiltJointForBothSitOn)
                    }
                    
//SIDE
                    let sideSupport = LabelInPartChainOut.sideSupport
                    if partChains.contains(sideSupport) {
                        allOriginIdNodesForSideSupportForBothSitOn.append( getOriginIdNodesForSideSupport(sitOnIndex, sideSupport) )
                        errorCheckForIdenticalOriginIdNodes(allOriginIdNodesForSideSupportForBothSitOn)
                    }
//BACK
                    /// any of the partChain which are used for parts attached to back
                    let backRelatedSupport: [PartChain] =
                        LabelInPartChainOut([
                            .backSupport,
                            .backSupportHeadSupport]).partChains
                    if partChains.contains(where: { element in return backRelatedSupport.contains(element) }){
                        originIdPartChainForBackForBothSitOn.append( getOriginIdPartChainForBackSupport(
                            sitOnIndex, backRelatedSupport) )
                        errorCheckForIdenticalOriginIdNodes(originIdPartChainForBackForBothSitOn)
                    }
//FOOT
                    if BaseObjectGroups().footSupport.contains(parent.objectType) {
                        allOriginIdNodesForFootSupportForBothSitOn.append( getOriginIdNodesForFootSupport(sitOnIndex) )
                        //print(allOriginIdNodesForFootSupportForBothSitOn)
                        errorCheckForIdenticalOriginIdNodes(allOriginIdNodesForFootSupportForBothSitOn)
                    }
                }
            }
        
        
        func errorCheckForIdenticalOriginIdNodes (
            _ allOriginIdNodesForBothSitOn: [OriginIdPartChain] ) {
                for allOriginIdNode in allOriginIdNodesForBothSitOn {
                    let originCount = allOriginIdNode.origin.count
                    let idCount = allOriginIdNode.ids.count
                    let nodeCount = allOriginIdNode.chain.count
                    let requiredCondition =
                        originCount == idCount && idCount == nodeCount
                
                    if !requiredCondition {
                        print("\(originCount)  \(idCount) \(nodeCount)")
                        fatalError (
                            "PreTiltOccupantSupportOrigin: originIdNodes must have equal count")
                }
            }
        }
        
        func getOriginIdPartChainForTitltInSpace(_ sitOnIndex: Int)
        -> OriginIdPartChain {
            let tiltInSpacePartChain: [Part] =
                partChainProvider.sitOnTiltJoint
            let allTiltInSpaceJointOrigin =
                [ objectToSitOn,
                 defaultSitOnBackFootTiltJointOrigin]
             let allTiltInSpaceIds =
                 [
                unilateralWidthPositionId,
                 unilateralWidthPositionId]
            return
               (
                origin: allTiltInSpaceJointOrigin,
                ids: allTiltInSpaceIds,
                chain: tiltInSpacePartChain)
        }
                
        
        func getOriginIdNodesForSideSupport(
            _ sitOnIndex: Int,
            _ sideSupport: PartChain)
            -> OriginIdPartChain {
//            let sideSupportPartChain: [Part] =
//                    partChain.sideSupport
            let allSideSupportOrigin =
                [
                objectToSitOn,
                defaultSideOrigin.getSitOnToSideSupportRotationJoint(),
                defaultSideOrigin.getSideSupportRotationJointToSideSupport()]
            let allSideSupportIds =
                [
                [sitOnId],
                bilateralWidthPositionId, // [.id1, .id0]
                bilateralWidthPositionId] // [.id1, .id0]
            return
               (
                origin: allSideSupportOrigin,
                ids: allSideSupportIds,
                chain: sideSupport)
        }

        
        func getOriginIdPartChainForBackSupport(
            _ sitOnIndex: Int,
            _ backRelated: [PartChain] )
            -> OriginIdPartChain {
           
               
            var backSupportPartChain = partChainProvider.backSupport
            var allBackSupportOrigin =
                [
                objectToSitOn,
                defaultBackOrigin.getSitOnToBackSupportRotationJoint(),
                defaultBackOrigin.getRotationJointToBackSupport()]
            var allBackSupportIds =
                [
                [sitOnId],
                unilateralWidthPositionId,
                unilateralWidthPositionId
                ]
                
                let backSupportHeadSupport = LabelInPartChainOut(
                    [.backSupportHeadSupport]).partChains[0]
                if partChains.contains(backSupportHeadSupport) {
//print ("HEAD SUPPORT")
                backSupportPartChain =
                    backSupportHeadSupport
                allBackSupportOrigin
                    .append(
                        defaultBackOrigin.getBackSupportToHeadLinkRotationJoint())
                allBackSupportOrigin
                    .append(
                        defaultBackOrigin.getHeadLinkRotationJointToHeadLink())
                allBackSupportOrigin
                    .append(
                        defaultBackOrigin.getHeadSupportLinkToHeadSupport())
              
                allBackSupportIds.append(unilateralWidthPositionId)
                allBackSupportIds.append(unilateralWidthPositionId)
                allBackSupportIds.append(unilateralWidthPositionId)
              
            }
                
            return
                (
                origin: allBackSupportOrigin,
                ids: allBackSupportIds,
                chain: backSupportPartChain)
        }
        
        

        
        func getOriginIdNodesForFootSupport(_ sitOnIndex: Int)
            -> OriginIdPartChain {
            
            let footPlateInOnePieceState =
                //parent.objectOptions[sitOnIndex][.footSupportInOnePiece] ?? false ||
                parent.objectType == .showerTray
            
            var footSupportInOneOrTwoPieces: Part
            var footJointToFootSupportOrigin: PositionAsIosAxes
            var footSupportIds: [Part]
                
                let unilateralOnLeft: [Part]? = nil//[Part.id1]
                
            if footPlateInOnePieceState {
                footSupportInOneOrTwoPieces =
                    .footSupportInOnePiece
                footJointToFootSupportOrigin =
                    defaultFootOrigin.getJointToOnePieceFoot( unilateralOnLeft)
                footSupportIds =
                    unilateralWidthPositionId
            } else {
                footSupportInOneOrTwoPieces =
                    .footSupport
                footJointToFootSupportOrigin =
                defaultFootOrigin.getJointToTwoPieceFoot(unilateralOnLeft)
                footSupportIds =
                    bilateralWidthPositionId
            }
            let allFootSupportNodes: [Part] =
                [
                .sitOn,
                .footSupportHangerJoint,
                .footSupportJoint,
                footSupportInOneOrTwoPieces]
            let allFootSupportOrigin =
                [
                objectToSitOn,
                defaultFootOrigin.getSitOnToHangerJoint( unilateralOnLeft),
                defaultFootOrigin.getHangerJointToFootJoint( unilateralOnLeft),
                footJointToFootSupportOrigin]
     //print(idsDictionary[allFootSupportNodes])
            let uniOrBilateralWidthPositionIdForFootSupport =
                idsDictionary[allFootSupportNodes]
                ??
                [
                [sitOnId],
                [.id1],
                [.id1],
                [.id1]]
                
            return
                (
                origin: allFootSupportOrigin,
                ids: uniOrBilateralWidthPositionIdForFootSupport,
                chain: allFootSupportNodes)
        }
    }

    
}





//MARK: BODY SUPPORT ORIGIN
extension DictionaryProvider {

    /// The ability to add two seats side by side or back to front
    /// combined with the the different object origins with respect
    /// to the body support, for example, front drive v rear drive
    /// requires the following considerable logic
    struct PreTiltOccupantBodySupportOrigin: InputForDictionary {
        //var partChainProvider: PartChainProvider.Type = PartChainProvider.self
 
        let objectType: BaseObjectTypes
        let stability: Stability
        var origin: [PositionAsIosAxes] = []
        let frontAndRearState: Bool
        let leftandRightState: Bool

        var occupantBodySupportsDimension: [Dimension3d] = []
        var occupantSideSupportsDimension: [[Dimension3d]] = []
        var occupantFootSupportHangerLinksDimension: [Dimension3d] = []
        
        let lengthBetweenWheels: DistanceBetweenWheels
        var allOriginIdNodesForBodySupportForBothSitOn:  [OriginIdPartChain] = []
        //used externally
        var allOriginIdPartChain: [[OriginIdPartChain]] = []
        
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
                
            func getAllOriginIdNodesForBodySupportForBothSitOn() {
                for index in 0..<parent.oneOrTwoIds.count {
                    let ids = [[parent.oneOrTwoIds[index]]]
                    allOriginIdNodesForBodySupportForBothSitOn.append(
                        (
                        origin: [origin[index]],
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
            origin.append(
                (x: 0.0,
                y:
                stability.atRear +
                 occupantBodySupportsDimension[0].length/2,
                 z: DictionaryProvider.sitOnHeight)
            )
            if frontAndRearState {
                origin.append(
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
                
            origin =
                [(x: xOrigin0,
                  y: origin[0].y,
                  z: 0.0),
                (x: xOrigin1,
                 y: origin[0].y,
                 z: DictionaryProvider.sitOnHeight)
                ]
            }
        }
        
        
       mutating func forMidPrimaryOrigin(){
            let baseLength = frontAndRearState ?
                lengthBetweenWheels.frontRearIfFrontAndRearSitOn(): lengthBetweenWheels.frontRearIfNoFrontAndRearSitOn()
            
            origin.append(
            (x: 0.0,
             y: 0.5 * (baseLength - occupantBodySupportsDimension[0].length),
             z: DictionaryProvider.sitOnHeight)
            )
            
            if frontAndRearState {
                origin =
                [
                (x: 0.0,
                 y: -origin[0].y,
                 z: DictionaryProvider.sitOnHeight)
                 ,
                (x: 0.0,
                 y: origin[0].y,
                z: DictionaryProvider.sitOnHeight)
                ]
            }
            
            if leftandRightState {
                origin =
                [
                (x: 0.0,
                 y: -origin[0].y,
                 z: DictionaryProvider.sitOnHeight)
                 ,
                (x: 0.0,
                 y: origin[0].y,
                z: DictionaryProvider.sitOnHeight)
                ]
            }
        }
        
        
       mutating func forFrontPrimaryOrgin() {
            origin.append(
                (x: 0.0,
                 y:
                -(stability.atFront +
                    occupantBodySupportsDimension[0].length/2),
                 z: DictionaryProvider.sitOnHeight )
                 )
            
            if frontAndRearState {
                origin = [
                    (x: 0.0,
                     y:
                        -stability.atFront -
                        occupantBodySupportsDimension[0].length -
                        occupantFootSupportHangerLinksDimension[1].length -
                        occupantBodySupportsDimension[1].length/2,
                     z: DictionaryProvider.sitOnHeight
                     ),
                    origin[0]
                ]
            }
            
            if leftandRightState {
                origin = [
                    (x: -leftAndRightX(),
                     y: origin[0].y,
                     z: DictionaryProvider.sitOnHeight),
                    (x: leftAndRightX(),
                     y: origin[0].y,
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
    var objectType: BaseObjectTypes {get}
    // the return value
    // An array of array as some structs
    // provide more than one array of OriginIdNodes
    var allOriginIdPartChain: [[OriginIdPartChain]] {get}
}


/// Provides a means of passing dimenions for parts
/// to one function
protocol PartDimension {
    var parts: [Part] {get}
    var defaultDimensions: [Dimension3d] {get}
}
