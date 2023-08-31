//
//  CreateDefaultDimensionDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation


struct DimensionDictionary {
    var forPart: Part3DimensionDictionary = [:]
    
    /// makes uses of dictionary value
    /// or uses passsed default value
    /// - Parameters:
    ///   - parts: all the parts associated with that section of the object
    ///   - defaultDimensions: default
    ///   - twinSitOnOptions:
    ///   - dimensionIn: may have no value, a default value or an edited value
    init(
        _ parts: [Part],
        _ defaultDimensions: [Dimension3d],
        _ twinSitOnOptions: TwinSitOnOptionDictionary,
        _ dimensionIn: Part3DimensionDictionary) {
            
        var idsForPart: [Part] = [.id0, .id1]
        let idsForSitOn: [Part] =  TwinSitOn(twinSitOnOptions).state ? [.id0, .id1]: [.id0]
        
        // any part with backSupport in the name will only have one item per sitOn
        let onlyOneExists = [Part.backSupport.rawValue]
        let enumCodedSoAnyMemberCanBeUsed = 0
        idsForPart =
            onlyOneExists.contains(where: parts[enumCodedSoAnyMemberCanBeUsed].rawValue.contains) ? [.id0]: idsForPart

        for index in 0..<parts.count{
            for partId in  idsForPart {
                for sitOnId in idsForSitOn {
                    let nameStart: [Part] = [.object, .id0, .stringLink]
                    let nameEnd: [Part] = parts[index] == .sitOn ?
                    [sitOnId, .stringLink, .sitOn, .id0] : [partId, .stringLink, .sitOn, sitOnId]
                    let x = nameStart + [parts[index]] + nameEnd
                    let partName = CreateNameFromParts(x).name
                    let dimension = dimensionIn[partName] ?? defaultDimensions[index]
                    self.forPart +=
                    [partName: dimension ]
                }
            }
        }
    }
}


/// The parts have a root like structure
/// each node forms a pair with its neighbour
///  the neighbour pairs require the correct ids

///  for right or umitary id is id0
///   for left  or other id i id1
///   object is always id0
///   sitOn varies as sit on
struct Root {
    
    // from array to [ [array[0], array[1]], [array[1], array[2]] and etc ]
    func getNodePairsToDeepestRoot (
        _ allNodes: [Part])
        -> [[Part]] {
        var nodePairs: [[Part]] = []
        for i in stride(from: 0, to: allNodes.count - 1, by: 1) {
            let pair = [allNodes[i], allNodes[i + 1]]
            nodePairs.append(pair)
        }
        return nodePairs
    }
    
    
    func getNamesFromNodePairs(
        _ nodePairs: [[Part]],
        _ idForFirstAndSecondNode: [[Part]],
        _ sitOnId: Part)
        -> [String]{
//print(nodePairs)
//print(idPairs)

            var nodePairNames: [String] = []
            for index in 0..<nodePairs.count {
                let name =
                    CreateNameFromParts( [
                        nodePairs[index][0],
                        idForFirstAndSecondNode[index][0],
                        .stringLink,
                        nodePairs[index][1],
                        idForFirstAndSecondNode[index][1],
                        .stringLink,
                        .sitOn,
                        sitOnId
                    ]).name
                nodePairNames.append(name)
            }
        return nodePairNames
    }
   

    
    
    
    func getIdForFirstAndSecondNode(
        _ sitOnId: Part,
        // eg [ [sitOn, side], [side, joyStick] ]
        _ nodePairsToDeepestRoot: [[Part]],
        // three parts require three arrays of id as below
        //eg [ [id0] ,[id0, id1], [id0] ] 1 or 2 if the part is bilateral
        _ partIdsForSecondOfNodePair: [[Part]],
        _ usingIdZeroOrOne: Int)
        -> [[Part]] {//for eg side0 [[id0, id0],[id0, id0]], side1 [[id0, id1]]
        var idForFirstAndSecondNode: [[Part]] = []
                  
        let sideIndex = 0
        let oneIndex = 0
        var idZeroOrOne: Int
        for index in 0..<nodePairsToDeepestRoot.count {
            let firstId =
            nodePairsToDeepestRoot[index][oneIndex] == .sitOn ?
            sitOnId: (nodePairsToDeepestRoot[index][oneIndex] == .object ? .id0: partIdsForSecondOfNodePair[index][sideIndex] )

            idZeroOrOne = partIdsForSecondOfNodePair[index].count == 2 && usingIdZeroOrOne == 1 ? 1: 0
            
            let secondId =
                nodePairsToDeepestRoot[index][oneIndex] == .sitOn ? sitOnId: partIdsForSecondOfNodePair[index][idZeroOrOne]
            
            print(partIdsForSecondOfNodePair[index].count)

            idForFirstAndSecondNode.append([firstId,secondId])
        }


            return idForFirstAndSecondNode
    }
    

    func getNamesFromNodePairsToDeepestRoot (
        _ allNodes: [Part],
        _ partIds: [[Part]],
       usingIdZeroOrOne: Int)
        -> [String] {
        let sitOnId = allNodes.contains(.sitOn) ?
            partIds[0][0]: .id0 // some roots, eg wheels exclude sitOn so use id0
        let allNodeFromObject = [Part.object] + allNodes // first node is always object
        // from array to [ [array[0], array[1]], [array[1], array[2]] and etc ]
        let nodePairsToDeepestRoot =
            getNodePairsToDeepestRoot(allNodeFromObject)
        
        let idForFirstAndSecondNodeToDeepestRoot: [[Part]] =
            getIdForFirstAndSecondNode(
                sitOnId,
                nodePairsToDeepestRoot,
                partIds,
                usingIdZeroOrOne)
        return
            getNamesFromNodePairs(
                nodePairsToDeepestRoot,
                idForFirstAndSecondNodeToDeepestRoot,
                sitOnId)
    }
}

///first step create names for dictionary
/// get origin for left parts
/// create parentToPartDic
///  use names to extract origin in correct order from parentToPartDic
///  func to create new  object to part orgiins
///  create objecToPartDic
///  for object to part

//MARK:- DICTIONARY
struct ParentAndObjectToPartOriginDictionary {
    let rightOrUnilateralOrigin: [PositionAsIosAxes]
    var leftOrigin: [PositionAsIosAxes] = []
    let partIds: [[Part]]
    let partNodes: [Part]
    let preTiltParentToPartOriginIn: PositionDictionary
    let namesForRightOrUnilateral: [String]
    let namesForLeft: [String]
    let allNames: [String]
    
    init(
        _ originIdNodes: OriginIdNodes,
        _ preTiltParentToPartOriginIn: PositionDictionary) {
        rightOrUnilateralOrigin = originIdNodes.origin
        partIds = originIdNodes.ids
        partNodes = originIdNodes.nodes
        self.preTiltParentToPartOriginIn =
            preTiltParentToPartOriginIn
        ///names are in order from object to part
        ///so these can be used to determine
        ///object to part origin
        namesForRightOrUnilateral =
            Root()
                .getNamesFromNodePairsToDeepestRoot(
                    partNodes,
                    partIds,
                    usingIdZeroOrOne: 0)
            print(namesForRightOrUnilateral)
            
        let numberOfNodesTillOnlyOneId =
            getNumberOfNodesTillOnlyOneId(partIds)
        let partIdsForLeft = Array(partIds.prefix(numberOfNodesTillOnlyOneId))
        let partNodesForLeft = Array(partNodes.prefix(numberOfNodesTillOnlyOneId))
        if numberOfNodesTillOnlyOneId > 0 {
            namesForLeft =
            Root().getNamesFromNodePairsToDeepestRoot(
                    partNodesForLeft,
                    partIdsForLeft,
                    usingIdZeroOrOne: 1)
            print(namesForLeft)
        } else {
            namesForLeft = []
        }

            
            
//print(namesForRightOrUnilateral)
//print(partNodes)
//print(partIds)
//print(numberOfNodesTillOnlyOneId)
//print(namesForLeft)
//print("\n\n\n")
            
       

        allNames =
            namesForRightOrUnilateral //+
            //namesForLeft
        createLeftOrigin()
        
            

            
        func getNumberOfNodesTillOnlyOneId (
            _ partIds: [[Part]])
            -> Int {
            var numberOfNodesTillOnlyOneId = 0
            let correctForCountStartAtZero = 1
                
                if let lastIndex = partIds.indices.reversed().first(where: { partIds[$0].count == 2 }) {
                    numberOfNodesTillOnlyOneId =
                        lastIndex + correctForCountStartAtZero
                }
          return numberOfNodesTillOnlyOneId
        }
            

    }
    

    
    mutating func createLeftOrigin()
        {
        let rightUnilateralAndLeftOrigin =
                LeftAndRightOrigin(
                    rightAndUnilateralOrigin: rightOrUnilateralOrigin,
                    partIds: partIds)
        leftOrigin = rightUnilateralAndLeftOrigin.left
        /// if partNodes [0] = .sitOn then as sitOn has one id
        /// there is no sitOn for right items and hence
        ///  object - sitOn origin is missing as a first origin
        ///  and this requirerd for object to part dictionary
        ///   so the following exception applies
        if partNodes[0] == .sitOn {
            leftOrigin.insert(rightOrUnilateralOrigin[0], at: 0)
        }
    }
    
    
    func createForParentToPart(_ preTiltParentToPartOriginIn: PositionDictionary)
        -> PositionDictionary {
        let allOrigin =
            rightOrUnilateralOrigin +
            leftOrigin
        var dictionary: PositionDictionary = [:]
        for (index, key) in allNames.enumerated() {
            dictionary[key] =
            preTiltParentToPartOriginIn[key] ??
                allOrigin[index]
        }
        return dictionary
    }
    
    
    func createForObjectToPart(_ preTiltObjectToPartOriginIn: PositionDictionary )
        -> PositionDictionary {
        let rightOrUnilateralOrigin =
            createObjectToPartOrigin(rightOrUnilateralOrigin)
        let leftOrigin =
        createObjectToPartOrigin(leftOrigin)
        let allOrigin =
            rightOrUnilateralOrigin +
            leftOrigin
        var dictionary: PositionDictionary = [:]
        for (index, key) in allNames.enumerated() {
            dictionary[key] =
            preTiltObjectToPartOriginIn[key] ??
                allOrigin[index]
        }
        return dictionary
        
    }
    
    
    func createObjectToPartOrigin( _ positions: [PositionAsIosAxes] )
        -> [PositionAsIosAxes] {
        let rightOrUnilateralAsArray = CreateIosPosition.getArrayFromPositions(positions)
        let transformedX = sumUp(rightOrUnilateralAsArray.x)
        let transformedY = sumUp(rightOrUnilateralAsArray.y)
        let transformedZ = sumUp(rightOrUnilateralAsArray.z)
        var objectToPartOrigin: [PositionAsIosAxes] = []
        for index in 0..<transformedX.count {
            objectToPartOrigin.append(
                (x: transformedX[index],
                 y: transformedY[index],
                 z: transformedZ[index])
                )
        }

        func sumUp(_ positionInOneAxis:[Double])
        -> [Double] {
            ///add up the indvidual axes measures to get the object to part
            ///Code by ChatGPT
            let transformedArray = positionInOneAxis.enumerated().map
            { index, element in
                return positionInOneAxis.prefix(index + 1).reduce(0, +)
            }
            return transformedArray
        }
        return objectToPartOrigin
    }
    
    func get()
        -> PositionDictionary{
            ///names are in order from object to part
            ///so these can be used to determine
            ///object to part origin
        let namesForRightOrUnilateral =
            Root().getNamesFromNodePairsToDeepestRoot(
                    partNodes,
                    partIds,
            usingIdZeroOrOne: 0)
//        let namesForLeft =
//            Root().getNamesFromNodePairsToDeepestRootForLeft(
//                    partNodes,
//                    partIds)
        let allnames =
            namesForRightOrUnilateral //+ namesForLeft
        let rightUnilateralAndLeftOrigin =
                LeftAndRightOrigin(
                    rightAndUnilateralOrigin: rightOrUnilateralOrigin,
                    partIds: partIds)
        var leftOrigin = rightUnilateralAndLeftOrigin.left
        /// if partNodes [0] = .sitOn then as sitOn has one id
        /// there is no sitOn for right items and hence
        ///  object - sitOn origin is missing as a first origin
        ///  and this requirerd for object to part dictionary
        ///   so the following exception applies
        if partNodes[0] == .sitOn {
            leftOrigin.insert(rightOrUnilateralOrigin[0], at: 0)
        }
        var allOrigin =
            rightOrUnilateralOrigin + leftOrigin
        var dictionary: PositionDictionary = [:]
        for (index, key) in namesForRightOrUnilateral.enumerated() {
            dictionary[key] =
            preTiltParentToPartOriginIn[key] ??
                rightOrUnilateralOrigin[index]
        }
        return dictionary
    }
}




struct LeftAndRightOrigin {
    let rightAndUnilateralOrigin: [PositionAsIosAxes]
    let partIds: [[Part]]
    var left:
        [PositionAsIosAxes] {
            getLeftOrigin()
        }
    var all: [PositionAsIosAxes] {
        rightAndUnilateralOrigin + left
    }

    func getLeftOrigin ()
        -> [PositionAsIosAxes] {

        var leftOrigin: [PositionAsIosAxes] = []
        for index in 0..<rightAndUnilateralOrigin.count {
            if partIds[index].count == 2 {
                let left = CreateIosPosition.getLeftFromRight(rightAndUnilateralOrigin[index])
                leftOrigin.append(left)
            }
        }
        return leftOrigin
    }
}


/// do I want the object to be passed to an origin provider which
/// determines which origins to provide
/// OR
/// do I want the obect to request a speicific origins from an origin provider

//MARK: - PARENT
struct ObjectDefaultOrEditedDictionaries {
    
    static let sitOnHeight = 500.0
    //var preTiltWheelOrigin: ObjectCreator
    var preTiltOccupantBodySupportOrigin: ObjectCreator?//PreTiltOccupantBodySupportOrigin?
    var preTiltOccupantFootBackSideSupportOrigin: ObjectCreator?
    var preTiltWheelOrigin: ObjectCreator?
    //var wheelOrigin: WheelOrigin   //var wheelOriginWithAccessibleProperties: WheelOrigin?
    //let parentOfWheelOrigin: ObjectCreator?
    var preTiltWheelOriginIdNodes: RearMidFrontOriginIdNodes = ZeroValue.rearMidFrontOriginIdNodes
    let preTiltDimensionIn: Part3DimensionDictionary
    var postTiltDimension: Part3DimensionDictionary = [:]
    
    var preTiltParentToPartOrigin: PositionDictionary = [:]
    
    var preTiltObjectToPartOrigin: PositionDictionary = [:]
    var postTiltObjectToPartOrigin: PositionDictionary = [:]

    let preTiltObjectToPartOriginIn: PositionDictionary
    let preTiltParentToPartOriginIn: PositionDictionary
    
    let angleChangeIn: AngleDictionary
    var angleChangeDefault: AngleDictionary = [:]

    let baseType: BaseObjectTypes
    let twinSitOnOption: TwinSitOnOptionDictionary
    let objectOptions: [OptionDictionary]
    var twinSitOnState: Bool //= false
    let oneOrTwoIds: [Part]
    
//    static func initalisePreTiltWheelOrigin (
//    using preTiltWheelchairOrigin: ObjectCreator)
//    -> ObjectCreator {
//        return PreTiltWheelOrigin(parent: self,  bodySupportOrigin: preTiltOccupantBodySupportOrigin)
//    }
    
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
    ///   - preTiltDimension: empty or default or modified dictionary of part  UI does produce postTilttDimesnsion it supplies angle
    ///   - objectToPartOrigin: empty or default or modified dictionary as  [String: PositionAsIosAxes] indicating part origin, preTilt
    ///   - parentToPartOrigin: empty or default or modified dictionary as  [String: PositionAsIosAxes] indicating part origin, preTilt
    ///   - angleChange: empty or default or modified dictionary as [String: Measurement<UnitAngle>] indicating object configuration angles but not angles of parts which change during movement: sitOn tilt but not caster orientation
    init(
        _ baseType: BaseObjectTypes,
        _ twinSitOnOption: TwinSitOnOptionDictionary,
        _ objectOptions: [OptionDictionary],
        _ preTiltDimension: Part3DimensionDictionary = [:],
        _ objectToPartOrigin: PositionDictionary = [:],
        _ parentToPartOrigin: PositionDictionary = [:],
        _ angleChangeIn: AngleDictionary = [:] ) {
            
        self.baseType = baseType
        self.twinSitOnOption = twinSitOnOption
        self.objectOptions = objectOptions
        self.preTiltDimensionIn = preTiltDimension
        self.preTiltObjectToPartOriginIn = objectToPartOrigin
        self.preTiltParentToPartOriginIn = parentToPartOrigin
        self.angleChangeIn = angleChangeIn
            
      
        twinSitOnState = TwinSitOn(twinSitOnOption).state
        oneOrTwoIds = twinSitOnState ? [.id0, .id1]: [.id0]
        
        angleChangeDefault =
            ObjectAngleChange(parent: self).dictionary
        
            
            
        /// Data Type OriginIdNodes
        /// origin: [PositionAsIosAxes]
        /// ids: [[Part]] : [.ida, .idb] where a,b is 0,1 or 2,3 or 4,5
        /// or [.id0] for a unilateral or centre part
        /// nodes: [part] where part is the part of the object
        ///
        /// nodes are ordered from .object to most distant node eg
        /// .sitOn,
        /// .backSupport.backSupporRotationJoint,
        /// .backSupport,
        /// .backSupportHeadSupportJoint
        /// an origin is the relative origin from part to next part
        /// nodes excludes first node .object

        /// each of the three data elements contains n members

        //PRE TILT
        // Checks for value in preTiltParentToPartOriginIn
        // used if present else default used
        preTiltOccupantBodySupportOrigin =
            PreTiltOccupantBodySupportOrigin(parent: self)
        createPreTiltParentToPartBodyOriginDictionary()
            
        preTiltOccupantFootBackSideSupportOrigin =
            PreTiltOccupantSupportOrigin(parent: self)
        
        preTiltWheelOrigin = getPreTiltWheelOrigin()
            if let preTiltWheelOrigin {
                preTiltWheelOriginIdNodes =
                getPreTiltWheelOriginIdNodes(
                    preTiltWheelOrigin as!
                        ObjectDefaultOrEditedDictionaries.PreTiltWheelOrigin)
            }
                
    
        //createPreTiltParentToPartWheelOriginDictionary(preTiltWheelOriginIdNodes) //

        createPreTiltParentToPartFootSideBackOriginDictionary()

            
            
//createPreTiltObjectToPartOriginDictionary()
            
        //POST TILT
        createOccupantSupportPostTiltDimensionDictionary()
        creatPostTiltObjectToPartOriginDictionary()

  


            
            
            
            

//DictionaryInArrayOut().getNameValue( preTiltParentToPartOrigin).forEach{print($0)}
//print("")
//DictionaryInArrayOut().getNameValue( preTiltObjectToPartOrigin).forEach{print($0)}
//DictionaryInArrayOut().getNameValue( postTiltDimension).forEach{print($0)}
//print("")
        createCornerDictionary ()
  

        func getPreTiltWheelOrigin()
            -> ObjectCreator? {
            var preTiltWheelOrigin: ObjectCreator?
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
                .sixWheels.contains(baseType) ?
            preTiltWheelOrigin.allOriginIdNodes[midIndex][indexForNodeGroup] : ZeroValue.originIdNodes
            
            let allOriginIdNodes =
                (rear: preTiltWheelOrigin.allOriginIdNodes[rearIndex][indexForNodeGroup] ,
                 mid: allOriginIdNodesForMid,
                 front: preTiltWheelOrigin.allOriginIdNodes[frontIndex][indexForNodeGroup])
            
            return
                allOriginIdNodes
        }
            
            
        func createPreTiltParentToPartBodyOriginDictionary( ) {

            if let data =
                preTiltOccupantBodySupportOrigin{
                let indexForNodeGroup = 0
                let allOriginIdNodesForSitOnForBothSitOn = data.allOriginIdNodes[indexForNodeGroup]

                for allOriginIdNodesForSitOn in allOriginIdNodesForSitOnForBothSitOn {

                    preTiltParentToPartOrigin +=
                        ParentAndObjectToPartOriginDictionary(
                            allOriginIdNodesForSitOn,
                            preTiltParentToPartOriginIn
                            ).createForParentToPart(preTiltParentToPartOriginIn)
                    
                }
            }
        }
            
        //
        func createPreTiltParentToPartWheelOriginDictionary(
            _ frontMidRearOriginIdNodes: RearMidFrontOriginIdNodes) {
            preTiltParentToPartOrigin +=
                ParentAndObjectToPartOriginDictionary(
                    frontMidRearOriginIdNodes.rear,
                    preTiltParentToPartOriginIn
                    ).get()
            if BaseObjectGroups().midWheels.contains(baseType) {
                preTiltParentToPartOrigin +=
                    ParentAndObjectToPartOriginDictionary(
                        frontMidRearOriginIdNodes.mid,
                        preTiltParentToPartOriginIn
                        ).get()
            }
            preTiltParentToPartOrigin +=
                ParentAndObjectToPartOriginDictionary(
                    frontMidRearOriginIdNodes.front,
                    preTiltParentToPartOriginIn
                    ).createForParentToPart(preTiltParentToPartOriginIn)
        }
            
            
        func createPreTiltParentToPartFootSideBackOriginDictionary () {
            if let data =
                preTiltOccupantFootBackSideSupportOrigin
                    as? PreTiltOccupantSupportOrigin {

                let allOriginIdNodesForSideForBothSitOn = data.allOriginIdNodesForSideSupportForBothSitOn
                
                for allOriginIdNodesForSide in
                        allOriginIdNodesForSideForBothSitOn {

                    let parentAndObjectToPartOriginDictionary =
                        ParentAndObjectToPartOriginDictionary(
                        allOriginIdNodesForSide,
                        preTiltParentToPartOriginIn
                        )
                    preTiltParentToPartOrigin +=
                        parentAndObjectToPartOriginDictionary.createForParentToPart(preTiltParentToPartOriginIn)
                    preTiltObjectToPartOrigin +=
                        parentAndObjectToPartOriginDictionary.createForObjectToPart(preTiltObjectToPartOriginIn)
                }
                
//                let allOriginIdNodesForBackForBothSitOn = data.allOriginIdNodesForBackSupportForBothSitOn
//
//                for allOriginIdNodesForBack in
//                        allOriginIdNodesForBackForBothSitOn {
//
//                    let parentAndObjectToPartOriginDictionary =
//                        ParentAndObjectToPartOriginDictionary(
//                        allOriginIdNodesForBack,
//                        preTiltParentToPartOriginIn
//                        )
//                    preTiltParentToPartOrigin +=
//                        parentAndObjectToPartOriginDictionary.createForParentToPart(preTiltParentToPartOriginIn)
//                    preTiltObjectToPartOrigin +=
//                        parentAndObjectToPartOriginDictionary.createForObjectToPart(preTiltObjectToPartOriginIn)
//                }
            }
        }

        // Rotations are applied
        func createOccupantSupportPostTiltDimensionDictionary() {
            let occupantSupportDimensionDictionary =
                OccupantSupportPostTiltDimensionDictionary(parent: self)
            postTiltDimension += occupantSupportDimensionDictionary.forBack
            postTiltDimension += occupantSupportDimensionDictionary.forBody
            postTiltDimension += occupantSupportDimensionDictionary.forFoot
            postTiltDimension += occupantSupportDimensionDictionary.forSide
        }
      

        func creatPostTiltObjectToPartOriginDictionary() {
            //replace the part origin positions which are rotated with the rotated values
            postTiltObjectToPartOrigin +=
            Replace(
                initial:
                    preTiltObjectToPartOrigin,
                replacement:
                    OriginPostTilt(parent: self).forObjectToPartOrigin
                ).intialWithReplacements
        }
        
            
            /// corners c0...c7 of a cuboid are located as follows
            /// they are viewed as per IOS axes facing the screen
            /// c0...c3 are z = 0 in the UI
            /// c4..c7 are z = 1 in the UI
            /// c0 top left,,
            /// c1 top right,
            /// c2 bottom left,
            /// c3 bottom left
            /// repeat for c4...c7
        func createCornerDictionary(){
            
            let noJointPostTiltOrigin = postTiltObjectToPartOrigin.filter({!$0.key.contains("Joint")})
            
            for (key, _) in noJointPostTiltOrigin {
                let O = noJointPostTiltOrigin[key]!
                let D = postTiltDimension[key] ?? ZeroValue.dimension3D

                let hD = HalfThis(D).dimension
                let c0 = (x: O.x - hD.width, y: O.y - hD.length, z: O.z - hD.height)
                let c1 = (x: O.x + hD.width, y: O.y - hD.length, z: O.z - hD.height)
                let c2 = (x: O.x + hD.width, y: O.y + hD.length, z: O.z - hD.height)
                let c3 = (x: O.x - hD.width, y: O.y + hD.length, z: O.z - hD.height)
                let c4 = (x: O.x - hD.width, y: O.y - hD.length, z: O.z + hD.height)
                let c5 = (x: O.x + hD.width, y: O.y - hD.length, z: O.z + hD.height)
                let c6 = (x: O.x + hD.width, y: O.y + hD.length, z: O.z + hD.height)
                let c7 = (x: O.x - hD.width, y: O.y + hD.length, z: O.z + hD.height)
                let corners =
                    [ c0,c1,c2,c3,c4,c5,c6,c7]
//print(key)
//print(corners)
            }
            
            /// given tilted dimensions and origins create the eight corners
            /// extract x-y or y-z or x-z corners
            ///
        }
            
    }
    
    
    
    //MARK: ORIGIN POST TILT
    struct OriginPostTilt {
        var forObjectToPartOrigin: PositionDictionary = [:]
        var forDimension: Part3DimensionDictionary = [:]

        init(
            parent: ObjectDefaultOrEditedDictionaries ) {
            for sitOnId in parent.oneOrTwoIds {
                let tiltOriginPart: [Part] =
                    [.object, .id0, .stringLink, .bodySupportRotationJoint, .id0, .stringLink, .sitOn, sitOnId]
                let originOfRotationName =
                    CreateNameFromParts(tiltOriginPart).name
                let angleName =
                    CreateNameFromParts([.bodySupportAngle, .stringLink, .sitOn, sitOnId]).name

                if let originOfRotation = parent.preTiltObjectToPartOrigin[originOfRotationName] {
                    let angleChange =
                        parent.angleChangeDefault[angleName] ??
                        ZeroValue.angle
                    
                    forSitOnWithFootTilt(
                        parent,
                        originOfRotation,
                        angleChange,
                        sitOnId)
                    }
                }
            }
       /*
        all parts attached to the body support are rotated
        about the Ios x axis
        but the angle of rotation is zero
        unless the option dictionary permits the UI to set a
        non-zero angle in angleChangeIn
        or an object has a non-zero angle
        set in angleChangeDefault
        if an object with only some parts attached
        to the body support are to be rotated then additional code
        which checks the base type can be added
        */
        
       mutating func forSitOnWithFootTilt (
            _ parent: ObjectDefaultOrEditedDictionaries,
            _ originOfRotation: PositionAsIosAxes,
            _ changeOfAngle: Measurement<UnitAngle>,
            _ sitOnId: Part) {
                
            let allPartsSubjectToAngle = PartGroupsFor().allAngle
            let partsOnLeftAndRight = PartGroupsFor().leftAndRight
            
            for part in  allPartsSubjectToAngle {
                let partIds: [Part] =  partsOnLeftAndRight.contains(part) ? [.id0, .id1]: [.id0]
                
                for partId in partIds {
                    let partName =
                    CreateNameFromParts([
                        .object, .id0, .stringLink, part, partId, .stringLink, .sitOn, sitOnId]).name
                    
                    if let originOfPart = parent.preTiltObjectToPartOrigin[partName] {
                        
                        let newPosition =
                        PositionOfPointAfterRotationAboutPoint(
                            staticPoint: originOfRotation,
                            movingPoint: originOfPart,
                            angleChange: changeOfAngle).fromObjectOriginToPointWhichHasMoved
                        
                        forObjectToPartOrigin += [partName: newPosition]
                    }
                }
            }
        }
        
        // MARK: write code
        mutating func forSitOnWithoutFootTilt() {}
        
        mutating func forBackRecline (
             _ parent: ObjectDefaultOrEditedDictionaries,
             _ originOfRotation: PositionAsIosAxes,
             _ changeOfAngle: Measurement<UnitAngle>,
             _ sitOnId: Part) {
                 
             let allPartsSubjectToAngle = PartGroupsFor().backAndHead
             let partsOnLeftAndRight = PartGroupsFor().leftAndRight
             
             for part in  allPartsSubjectToAngle {
                 let partIds: [Part] =  partsOnLeftAndRight.contains(part) ? [.id0, .id1]: [.id0]
                 
                 for partId in partIds {
                     let partName =
                     CreateNameFromParts([
                         .object, .id0, .stringLink, part, partId, .stringLink, .sitOn, sitOnId]).name
                     
                     if let originOfPart = parent.preTiltObjectToPartOrigin[partName] {
                         
                         let newPosition =
                         PositionOfPointAfterRotationAboutPoint(
                             staticPoint: originOfRotation,
                             movingPoint: originOfPart,
                             angleChange: changeOfAngle).fromObjectOriginToPointWhichHasMoved
                         
                         forObjectToPartOrigin += [partName: newPosition]
                     }
                 }
             }
         }
        
        // MARK: write code
        mutating func forHeadSupport(){}
    }
    
    
    
    
    
    
    
    
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
            parent: ObjectDefaultOrEditedDictionaries) {
            
                for id in parent.oneOrTwoIds {
                    setAngleDictionary( id)
                }
                
                
                func setAngleDictionary( _ id: Part) {
                let partForNames: [[Part]] =
                    [
                        [.bodySupportAngle, .stringLink, .sitOn, id],
                        [.backSupportReclineAngle, .stringLink, .sitOn, id],
                        [.legSupportAngle, .stringLink, .sitOn, id]
                    ]
                let defaultAngles =
                    [
                        OccupantBodySupportDefaultAngleChange(parent.baseType).value,
                        OccupantBackSupportDefaultAngleChange(parent.baseType).value,
                        OccupantFootSupportDefaultAngleChange(parent.baseType).value
                    ]
                var name: String
                var angle: Measurement<UnitAngle>
                for index in 0..<partForNames.count {
                    name =
                        CreateNameFromParts(partForNames[index]).name
                    angle =
                        parent.angleChangeIn[name] ?? defaultAngles[index]
                    dictionary += [name: angle]
                }
            }
        }
    }
    
    
    //retrieves a passed value if extant else a default value
    struct OccupantSupportPostTiltDimensionDictionary {
        var forBack:  Part3DimensionDictionary = [:]
        var forBody:  Part3DimensionDictionary = [:]
        var forFoot:  Part3DimensionDictionary = [:]
        var forSide: Part3DimensionDictionary = [:]
        
        init(
            parent: ObjectDefaultOrEditedDictionaries) {
            
            forBack = getDictionaryForBack()
            forBody = getDictionaryForBody()
            forFoot = getDictionaryForFoot()
            forSide = getDictionaryForSide()
                
            func  getDictionaryForBack()
            -> Part3DimensionDictionary {
                
                let allOccupantRelated =
                    AllOccupantBackRelated(
                        parent.baseType)
                
                return
                    DimensionDictionary(
                        allOccupantRelated.parts,
                        allOccupantRelated.dimensions,
                        parent.twinSitOnOption,
                        parent.preTiltDimensionIn
                    ).forPart
            }
                
            func  getDictionaryForBody()
                -> Part3DimensionDictionary {
                    let dimension =
                        PreTiltOccupantBodySupportDefaultDimension(
                            parent.baseType).value
                    
                    let angle =
                        OccupantBodySupportDefaultAngleChange(parent.baseType).value
                    
                    let rotatedDimension =
                        ObjectCorners(
                            dimensionIn: dimension,
                            angleChangeIn:  angle
                        ).rotatedDimension
                    
//print(parent.baseType.rawValue)
//print(rotatedDimension)
//print("")
                    
                    let dimensions =
                        parent.twinSitOnState ? [rotatedDimension, rotatedDimension]: [rotatedDimension]
                    
                    let parts: [Part] =
                        parent.twinSitOnState ? [.sitOn, .sitOn]: [.sitOn]
                    
                    return
                        DimensionDictionary(
                            parts,
                            dimensions,
                            parent.twinSitOnOption,
                            parent.preTiltDimensionIn
                        ).forPart
            }
                
            func  getDictionaryForFoot()
                -> Part3DimensionDictionary {
                
                    let allOccupantRelated =
                        AllOccupantFootRelated(
                            parent.baseType,
                            parent.preTiltDimensionIn)
                    return
                        DimensionDictionary(
                            allOccupantRelated.parts,
                            allOccupantRelated.dimensions,
                            parent.twinSitOnOption,
                            parent.preTiltDimensionIn
                        ).forPart
            }
                
            func  getDictionaryForSide()
                -> Part3DimensionDictionary {
                    let dimension =
                    PreTiltOccupantSideSupportDefaultDimension(
                        parent.baseType).value
                    let angle =
                    OccupantBodySupportDefaultAngleChange(parent.baseType).value
                    let rotatedDimension =
                    ObjectCorners(
                        dimensionIn: dimension,
                        angleChangeIn:  angle
                    ).rotatedDimension
                    
                   return
                        DimensionDictionary(
                            [.armSupport],
                            [rotatedDimension],
                            parent.twinSitOnOption,
                            parent.preTiltDimensionIn
                        ).forPart
            }
        }
    }
    


    
    //MARK: BODY SUPPORT ORIGIN
    /// The ability to add two seats side by side or back to front
    /// commbined with the the different object origins with respect
    /// to the body support, for example, front drive v rear drive
    /// requires the following considerable logic
    struct PreTiltOccupantBodySupportOrigin: ObjectCreator {
//        var parentToPartDictionary: PositionDictionary = [:]
//        var objectToPartDictionary: PositionDictionary = [:]
        var partGroup: PartGroup.Type = PartGroup.self
 
        let objectType: BaseObjectTypes
        let stability: Stability
        var origin: [PositionAsIosAxes] = []
        let frontAndRearState: Bool
        let leftandRightState: Bool

        var occupantBodySupportsDimension: [Dimension3d] = []
        var occupantSideSupportsDimension: [[Dimension3d]] = []
        var occupantFootSupportHangerLinksDimension: [Dimension3d] = []
        
        let lengthBetweenWheels: LengthBetween
        var allOriginIdNodesForBodySupportForBothSitOn:  [OriginIdNodes] = []
        var allOriginIdNodes: [[OriginIdNodes]] = []
        
        init(
            parent: ObjectDefaultOrEditedDictionaries) {
                objectType = parent.baseType
            stability = Stability(parent.baseType)
            
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
                LengthBetween(
                    parent.baseType,
                    occupantBodySupportsDimension,
                    occupantFootSupportHangerLinksDimension)
                
            if BaseObjectGroups().rearFixedWheel.contains(parent.baseType) {
            forRearPrimaryOrigin()
            }
                
            if BaseObjectGroups().frontFixedWheel.contains(parent.baseType) {
            forFrontPrimaryOrgin()
            }
                
            if BaseObjectGroups().midFixedWheel.contains(parent.baseType) {
            forMidPrimaryOrigin()
            }
                
            getAllOriginIdNodesForBodySupportForBothSitOn()
                
            allOriginIdNodes.append(allOriginIdNodesForBodySupportForBothSitOn)
                
            func getAllOriginIdNodesForBodySupportForBothSitOn() {
                for index in 0..<parent.oneOrTwoIds.count {
                    let ids = [[parent.oneOrTwoIds[index]]]
                    allOriginIdNodesForBodySupportForBothSitOn.append(
                        (
                        origin: [origin[index]],
                        ids: ids,
                        nodes: [.sitOn] ) )
                }
            }
   
            func getModifiedOrDefaultSitOnDimension(_ id: Part)
                -> Dimension3d {
                let name =
                    CreateNameFromParts([.object, .id0, .stringLink, .sitOn, id, .stringLink, .sitOn, id]).name
                let modifiedDimension = parent.preTiltDimensionIn[name] ?? PreTiltOccupantBodySupportDefaultDimension(parent.baseType).value
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
                        let modifiedDimension = parent.preTiltDimensionIn[name] ??
                        PreTiltOccupantSideSupportDefaultDimension(parent.baseType).value
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
                    let footSupportInOnePieceState = parent.objectOptions[index][.footSupportInOnePiece] ?? false
                    let names: [String] =
                    [CreateNameFromParts([.footSupportHangerLink, .id0, .stringLink, .sitOn, id]).name]
                    var modifiedDimensions: [Dimension3d?] = [parent.preTiltDimensionIn[names[0]]]
                    if footSupportInOnePieceState {
                    } else {
                        let name =
                        CreateNameFromParts([.footSupportHangerLink, .id1, .stringLink, .sitOn, id]).name
                        modifiedDimensions += [parent.preTiltDimensionIn[name]]
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
                   modifiedDimension ?? PretTiltOccupantFootSupportDefaultDimension(parent.baseType).getHangerLink()
            }
        }
        

        
        
        mutating func forRearPrimaryOrigin() {
            origin.append(
                (x: 0.0,
                y:
                stability.atRear +
                 occupantBodySupportsDimension[0].length/2,
                 z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
            )
            if frontAndRearState {
                origin.append(
                        (x: 0.0,
                        y:
                        stability.atRear +
                        occupantBodySupportsDimension[0].length +
                        occupantFootSupportHangerLinksDimension[0].length +
                        occupantBodySupportsDimension[1].length/2,
                         z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
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
                 z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                ]
            }
        }
        
       mutating func forMidPrimaryOrigin(){
            let baseLength = frontAndRearState ?
                lengthBetweenWheels.frontRearIfFrontAndRearSitOn(): lengthBetweenWheels.frontRearIfNoFrontAndRearSitOn()
            
            origin.append(
            (x: 0.0,
             y: 0.5 * (baseLength - occupantBodySupportsDimension[0].length),
             z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
            )
            
            if frontAndRearState {
                origin =
                [
                (x: 0.0,
                 y: -origin[0].y,
                 z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                 ,
                (x: 0.0,
                 y: origin[0].y,
                z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                ]
            }
            
            if leftandRightState {
                origin =
                [
                (x: 0.0,
                 y: -origin[0].y,
                 z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                 ,
                (x: 0.0,
                 y: origin[0].y,
                z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
                ]
            }
        }
        
        
       mutating func forFrontPrimaryOrgin() {
            origin.append(
                (x: 0.0,
                 y:
                -(stability.atFront +
                    occupantBodySupportsDimension[0].length/2),
                 z: ObjectDefaultOrEditedDictionaries.sitOnHeight )
                 )
            
            if frontAndRearState {
                origin = [
                    (x: 0.0,
                     y:
                        -stability.atFront -
                        occupantBodySupportsDimension[0].length -
                        occupantFootSupportHangerLinksDimension[1].length -
                        occupantBodySupportsDimension[1].length/2,
                     z: ObjectDefaultOrEditedDictionaries.sitOnHeight
                     ),
                    origin[0]
                ]
            }
            
            if leftandRightState {
                origin = [
                    (x: -leftAndRightX(),
                     y: origin[0].y,
                     z: ObjectDefaultOrEditedDictionaries.sitOnHeight),
                    (x: leftAndRightX(),
                     y: origin[0].y,
                     z: ObjectDefaultOrEditedDictionaries.sitOnHeight)
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
    
    // occupantBodySupportsDimension[0].width + occupantBodySupportsDimension[1].width +                         PreTiltOccupantSideSupportDefaultDimension(parent.baseType
    //).value.width * 2
    
    
    
    
    //MARK: FOOT/SIDE/BACK/ROTATE ORIGIN
    struct PreTiltOccupantSupportOrigin: ObjectCreator {
        let parent: ObjectDefaultOrEditedDictionaries

        var partGroup: PartGroup.Type = PartGroup.self
        let objectType: BaseObjectTypes
        let bilateralWidthPositionId: [Part] = [.id1, .id0]
        let unilateralWidthPositionId: [Part] = [.id0]
        let allPartIds:[Part] = [.id0, .id1]
        let defaultFootOrigin: PreTiltOccupantFootSupportDefaultOrigin
        let defaultBackOrigin: PreTiltOccupantBackSupportDefaultOrigin
        let defaultSideOrigin: PreTiltOccupantSideSupportDefaultOrigin
        var sitOnId: Part = .id0
        var objectToSitOn: PositionAsIosAxes = ZeroValue.iosLocation
        var allOriginIdNodesForFootSupportForBothSitOn:  [OriginIdNodes]  = []
        var allOriginIdNodesForSideSupportForBothSitOn:  [OriginIdNodes]  = []
        var allOriginIdNodesForBackSupportForBothSitOn:  [OriginIdNodes]  = []
     
        var allOriginIdNodes: [[OriginIdNodes]] = []

        init(
            parent: ObjectDefaultOrEditedDictionaries) {
                self.parent = parent
                objectType = parent.baseType
                defaultFootOrigin =
                    PreTiltOccupantFootSupportDefaultOrigin(parent.baseType)
                
                defaultBackOrigin =
                    PreTiltOccupantBackSupportDefaultOrigin(parent.baseType)
                
                defaultSideOrigin =
                    PreTiltOccupantSideSupportDefaultOrigin(parent.baseType)
                
                let sitOnIds = parent.oneOrTwoIds
                
                for sitOnIndex in 0..<sitOnIds.count {
                    sitOnId = sitOnIds[sitOnIndex]
                    
                    //access sit on position from dictionary
                    objectToSitOn =
                    GetValueFromDictionary(
                        parent.preTiltParentToPartOrigin,
                        [.object, .id0, .stringLink,.sitOn, sitOnId, .stringLink, .sitOn, sitOnId]).value
//print(parent.preTiltParentToPartOrigin)
                    allOriginIdNodesForFootSupportForBothSitOn.append( getOriginIdNodesForFootSupport(sitOnIndex) )
                    allOriginIdNodesForSideSupportForBothSitOn.append( getOriginIdNodesForSideSupport(sitOnIndex) )
                    allOriginIdNodesForBackSupportForBothSitOn.append( getOriginIdNodesForBackSupport(sitOnIndex) )
                    allOriginIdNodes =
                    [allOriginIdNodesForFootSupportForBothSitOn,
                     allOriginIdNodesForSideSupportForBothSitOn,
                    allOriginIdNodesForBackSupportForBothSitOn]
                }
                
            }
                
        func getOriginIdNodesForSideSupport(_ sitOnIndex: Int)
            -> OriginIdNodes {
            let allSideSupportNodes: [Part] =
                    partGroup.sideSupport
            let allSideSupportOrigin =
                [
                objectToSitOn,
                defaultSideOrigin.getSitOnToSideSupportRotationJoint(),
                defaultSideOrigin.getSideSupportRotationJointToSideSupport()]
            let allSideSupportIds =
                [
                [sitOnId],
                bilateralWidthPositionId,
                bilateralWidthPositionId]
            return
               (
                origin: allSideSupportOrigin,
                ids: allSideSupportIds,
                nodes: allSideSupportNodes)
        }
        
        
        func getOriginIdNodesForBackSupport(_ sitOnIndex: Int)
            -> OriginIdNodes {
            let headSupportState =
                parent.objectOptions[sitOnIndex][.headSupport] ?? false
            var allBackSupportNodes = partGroup.backSupport
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
                
            if headSupportState {
                allBackSupportNodes =
                    partGroup.backWithHeadSupport
                allBackSupportOrigin
                    .append(
                        defaultBackOrigin.getBackSupportToHeadLinkRotationJoint())
                allBackSupportIds.append(unilateralWidthPositionId)
            }
                
            return
                (
                origin: allBackSupportOrigin,
                ids: allBackSupportIds,
                nodes: allBackSupportNodes)
        }
        
        
        func getOriginIdNodesForFootSupport(_ sitOnIndex: Int)
            -> OriginIdNodes {
            
            let footPlateInOnePieceState =
            parent.objectOptions[sitOnIndex][.footSupportInOnePiece] ?? false
            
            var footSupportInOneOrTwoPieces: Part
            var footJointToFootSupportOrigin: PositionAsIosAxes
            var footSupportIds: [Part]
            
            if footPlateInOnePieceState {
                footSupportInOneOrTwoPieces =
                    .footSupportInOnePiece
                footJointToFootSupportOrigin =
                    defaultFootOrigin.getJointToOnePieceFoot()
                footSupportIds =
                    unilateralWidthPositionId
            } else {
                footSupportInOneOrTwoPieces =
                    .footSupport
                footJointToFootSupportOrigin =
                    defaultFootOrigin.getJointToTwoPieceFoot()
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
                defaultFootOrigin.getSitOnToHangerJoint(),
                defaultFootOrigin.getHangerJointToFootJoint(),
                footJointToFootSupportOrigin]
     
            let uniOrBilateralWidthPositionIdForFootSupport =
                [
                [sitOnId],
                bilateralWidthPositionId,
                bilateralWidthPositionId,
                footSupportIds]
                
            return
                (
                origin: allFootSupportOrigin,
                ids: uniOrBilateralWidthPositionIdForFootSupport,
                nodes: allFootSupportNodes)
        }
        
    }


//MARK: WHEEL ORIGIN
    struct PreTiltWheelOrigin: ObjectCreator {
        //assignment form for static values
        var partGroup: PartGroup.Type = PartGroup.self
        
        //ObjectCreator
        let objectType: BaseObjectTypes
        var allOriginIdNodes: [[OriginIdNodes]] = []
        
        let lengthBetweenFrontAndRearWheels: Double
        let parent: ObjectDefaultOrEditedDictionaries
        let bodySupportOrigin: PreTiltOccupantBodySupportOrigin
        let wheelAndCasterVerticalJointOrigin: WheelAndCasterVerticalJointOrigin
        let casterOrigin: CasterOrigin
        var allOriginIdNodesForRear: OriginIdNodes = ZeroValue.originIdNodes
        var allOriginIdNodesForMid: OriginIdNodes = ZeroValue.originIdNodes
        var allOriginIdNodesForFront: OriginIdNodes = ZeroValue.originIdNodes
        

        init(
            parent: ObjectDefaultOrEditedDictionaries,
            bodySupportOrigin: PreTiltOccupantBodySupportOrigin ) {
                
            self.parent = parent
            self.bodySupportOrigin = bodySupportOrigin
            
            lengthBetweenFrontAndRearWheels =
            getLengthBetweenFrontAndRearWheels()
            
            objectType = parent.baseType
                
            let widthBetweenWheelsAtOrigin = getWidthBetweenWheels()
            
            wheelAndCasterVerticalJointOrigin =
                WheelAndCasterVerticalJointOrigin(
                    parent.baseType,
                    lengthBetweenFrontAndRearWheels,
                    widthBetweenWheelsAtOrigin)
            
            casterOrigin = CasterOrigin(parent.baseType)
            
            allOriginIdNodesForRear =
                getOriginIdNodesForRear()
            
            allOriginIdNodesForMid =
                getOriginIdNodesForMid ()
            
            allOriginIdNodesForFront =
                getOriginIdNodesForFront()
                
            allOriginIdNodes =
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
                    Stability(parent.baseType).atLeft +
                    Stability(parent.baseType).atRight
                    
                    func forIndex(_ id: Int) -> Double {
                        return
                            bodySupportDimension[id].width + sideSupportDimension[id][0].width + sideSupportDimension[id][1].width
                    }
            return width
            }
        }
    }
} //Parent struct ends

// MARK: WHEEL ORIGINIDNODES EXTENSION
extension ObjectDefaultOrEditedDictionaries.PreTiltWheelOrigin {
    func getOriginIdNodesForRear()
        -> OriginIdNodes {
        let allRearNodes =
            getRearNodes()
        let uniOrBilateralWidthPositionIdAtRear =
                Array(repeating: WheelId(parent.baseType).atRear,
                      count: allRearNodes.count)
          return
                (
                origin: getRearOrigin(),
                ids: uniOrBilateralWidthPositionIdAtRear,
                nodes: allRearNodes)
    }
    
    
    func getOriginIdNodesForMid ()
        -> OriginIdNodes {
        var originIdNodesForMid = ZeroValue.originIdNodes
        if BaseObjectGroups().midWheels.contains(parent.baseType) {
            let allMidNodes =
                getMidNodes()
            let
            uniOrBilateralWidthPositionIdAtMid =
            Array(repeating: WheelId(parent.baseType).atMid,
                  count: allMidNodes.count)
            originIdNodesForMid =
                (
                origin: getMidOrigin(),
                ids:   uniOrBilateralWidthPositionIdAtMid,
                nodes: allMidNodes)
        }
        return
            originIdNodesForMid
    }
    
    
    func getOriginIdNodesForFront ()
    -> OriginIdNodes {
        let allFrontNodes =
                getFrontNodes()
        let dualOrSingleWidthPositionIdAtFront =
                Array(repeating: WheelId(parent.baseType).atFront,
                      count: allFrontNodes.count)
        return
            (
            origin: getFrontOrigin(),
            ids: dualOrSingleWidthPositionIdAtFront,
            nodes: allFrontNodes)
    }
                // fetch the wheel origins for the base type one, two or three with +x or x =0
                // baseWheelJointIndex are ordered so that
                // each origin if a pair assigns to the next baseWheelJointIndexPair
    
}


// MARK: WHEEL NODES EXTENSION
extension ObjectDefaultOrEditedDictionaries.PreTiltWheelOrigin {
    func getRearNodes()
        -> [Part] {
        var nodes: [Part] = []
        if BaseObjectGroups().rearCaster.contains(parent.baseType) {
            nodes =
                partGroup.casterWheelNodes
        }
        
        if BaseObjectGroups().rearFixedWheel.contains(parent.baseType) {
            nodes =
                partGroup.fixedWheelNodes
        }
            return nodes
    }
    
    func getMidNodes()
        -> [Part] {
        var nodes: [Part] = []
        if BaseObjectGroups().midCaster.contains(parent.baseType) {
            nodes =
                partGroup.casterWheelNodes
        }
        
        if BaseObjectGroups().midFixedWheel.contains(parent.baseType) {
            nodes =
                partGroup.fixedWheelNodes
        }
            return nodes
    }
    
    
    func getFrontNodes()
        -> [Part] {
        var nodes: [Part] = []
        if BaseObjectGroups().frontCaster.contains(parent.baseType) {
            nodes =
                partGroup.casterWheelNodes
        }
        
        if BaseObjectGroups().frontFixedWheel.contains(parent.baseType) {
            nodes =
                partGroup.fixedWheelNodes
        }
            return nodes
    }
            
}

//MARK: EXTENSION PreTiltOccupantSupportOrigin DIMENSION
extension ObjectDefaultOrEditedDictionaries.PreTiltOccupantBodySupportOrigin {
    
    
}


// MARK: WHEEL ORIGIN EXTENSION
extension ObjectDefaultOrEditedDictionaries.PreTiltWheelOrigin {
    
    func getRearOrigin()
        -> [PositionAsIosAxes]{
        var rearOrigin: [PositionAsIosAxes] = []
            
        let forkAndCasterWheel =
            [casterOrigin.forRearCasterVerticalJointToFork(),
             casterOrigin.forRearCasterForkToWheel()]
        //rear caster
        if BaseObjectGroups()
            .allCaster.contains(parent.baseType) {
            rearOrigin =
                [
                wheelAndCasterVerticalJointOrigin
                    .getRearCasterWhenRearPrimaryOrigin()] +
                forkAndCasterWheel
        }
       //no rear caster if rear primary origin
        if BaseObjectGroups().midPrimaryOrigin.contains(parent.baseType) {
            rearOrigin =
                [
                wheelAndCasterVerticalJointOrigin
                    .getRearCasterWhenMidPrimaryOrigin()] +
                forkAndCasterWheel
        }
        if BaseObjectGroups().frontPrimaryOrigin.contains(parent.baseType) {
            rearOrigin =
                [
                wheelAndCasterVerticalJointOrigin
                    .getRearCasterWhenFrontPrimaryOrigin()] +
                forkAndCasterWheel
        }
            
        //fixed wheel
        if BaseObjectGroups().rearPrimaryOrigin.contains(parent.baseType) {
            rearOrigin =
                getForWheelDrive()
        }
//print(rearOrigin)
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
            .allCaster.contains(parent.baseType) {
            midOrigin =
                [
                wheelAndCasterVerticalJointOrigin
                    .getRearCasterWhenRearPrimaryOrigin()] +
                forkAndCasterWheel
        }
            
        //for midPrimaryOrigin no objects with mid casters
        
        //for frontPrimaryOrigin no objects with mid casters
            
            
        if BaseObjectGroups()
            .midFixedWheel.contains(parent.baseType) {
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
            
        if BaseObjectGroups().rearPrimaryOrigin.contains(parent.baseType) {
                frontOrigin =
                    [
                    wheelAndCasterVerticalJointOrigin
                        .getFrontCasterWhenRearPrimaryOrigin()] +
                    forkAndCasterWheel
        }
            
        if BaseObjectGroups().midPrimaryOrigin.contains(parent.baseType) {
            
                frontOrigin =
                    [
                    wheelAndCasterVerticalJointOrigin
                        .getFrontCasterWhenMidPrimaryOrigin()] +
                    forkAndCasterWheel
        }
             
        //for frontPrimaryOrigin no objects with front casters
            
        if BaseObjectGroups().frontFixedWheel.contains(parent.baseType) {
        
            frontOrigin =
                getForWheelDrive()
        }
        
        return frontOrigin
    }
    
    func getForWheelDrive()
        -> [PositionAsIosAxes] {
//print("for wheel drive")
        return
           BaseObjectGroups()
                .allDriveOrigin.contains(parent.baseType) ?
                    [
                    wheelAndCasterVerticalJointOrigin
                        .getRightDriveWheel(),
                    ZeroValue.iosLocation]: [] //joint and wheel coterminous
    }
    
}



//protocol PreTiltOrigin {
//    var partGroup: PartGroup.Type {get}
//}

protocol ObjectCreator {
    // the input value
    var objectType: BaseObjectTypes {get}
    // the return value
    // An array of array as some structs
    // provide more than one array of OriginIdNodes
    var allOriginIdNodes: [[OriginIdNodes]] {get}
}

//MARK: CORNERS
/// Provide all eight corner positions for part
/// Rotate about x axis left to rigth on screen
/// Provide maximum y length resulting from rotation
struct ObjectCorners {
    let dimensionIn: Dimension3d
    let angleChangeIn: Measurement<UnitAngle>
    var are: [PositionAsIosAxes] {
        calculateFrom(dimension: dimensionIn) }
    var aferRotationAre: [PositionAsIosAxes] {
        calculatePositionAfterRotation(are, angleChangeIn)
    }
    var maximumLengthAfterRotationAboutX: Double {
        calculateMaximumLength(aferRotationAre)
    }
    var rotatedDimension: Dimension3d {
        (
        width: dimensionIn.width,
        length: maximumLengthAfterRotationAboutX,
        height: dimensionIn.height)
    }
    

    func calculateFrom( dimension: Dimension3d)
    -> [PositionAsIosAxes] {
        let (w,l,h) = dimension
        return
            [
            ZeroValue.iosLocation,
            (x: w,      y: 0.0, z: 0.0 ),
            (x: w,      y: l,   z: 0.0 ),
            (x: 0.0,    y: l,   z: 0.0),
            (x: 0.0,    y: 0.0, z: h),
            (x: w,      y: 0.0, z: h),
            (x: w,      y: l,   z: h ),
            (x: 0.0,    y: l,   z: h )
            ]
    }
    
    func calculatePositionAfterRotation(
        _ corners: [PositionAsIosAxes],
        _ angleChange: Measurement<UnitAngle>)
        -> [PositionAsIosAxes] {
        var rotatedCorners: [PositionAsIosAxes] = []
        
        let useAnyIndexForRotation = 0
        for corner in corners {
            rotatedCorners.append(
                PositionOfPointAfterRotationAboutPoint(
                    staticPoint: corners[useAnyIndexForRotation],
                    movingPoint: corner,
                    angleChange: angleChange).fromStaticToPointWhichHasMoved )
        }
//print(rotatedCorners)
        return rotatedCorners
    }
    
    func calculateMaximumLength(
        _ corners: [PositionAsIosAxes])
        -> Double {
        let yValues =
            CreateIosPosition.getArrayFromPositions(corners).y
        return
            yValues.max()! - yValues.min()!
    }
}
