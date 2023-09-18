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
struct DimensionOriginCornerDictionaries {
    
    static let sitOnHeight = 500.0
    
    //UI amended dictionary
    let dimensionIn: Part3DimensionDictionary
    let preTiltParentToPartOriginIn: PositionDictionary
    let preTiltObjectToPartOriginIn: PositionDictionary
    let angleIn: AngleDictionary
    
    let baseType: BaseObjectTypes
    let twinSitOnOption: TwinSitOnOptionDictionary
    let objectOptions: [OptionDictionary]
    var twinSitOnState: Bool //= false
    let oneOrTwoIds: [Part]
    
    var dimension: Part3DimensionDictionary = [:]
  
    
    var preTiltWheelOriginIdNodes: RearMidFrontOriginIdNodes = ZeroValue.rearMidFrontOriginIdNodes
    
    //InputForDictionary is a prelimary for
    // dictionary creation
    var preTiltOccupantBodySupportOrigin: InputForDictionary?
    var preTiltOccupantFootBackSideSupportOrigin: InputForDictionary?
    var preTiltWheelOrigin: InputForDictionary?


    
    //pre-tilt
    var preTiltParentToPartOrigin: PositionDictionary = [:]
    var preTiltObjectToPartOrigin: PositionDictionary = [:]
    var preTiltObjectToCornerOrigin: PositionDictionary = [:]
    var uniqueNames: [String] = []
    var pretTiltObjectToAllPartCornerOrigin: PositionCornerDictionary = [:]
    
    
    //post-tilt
    var postTiltObjectToPartOrigin: PositionDictionary = [:]
    
    var angle: AngleDictionary = [:]
    
    ///the objects available, that is for which all code is present are included here
    static let objects: [BaseObjectTypes] = [
        .allCasterBed,.allCasterChair,.allCasterStretcher,
        .fixedWheelFrontDrive, .fixedWheelMidDrive, .fixedWheelRearDrive]
    

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
        _ baseType: BaseObjectTypes,
        _ twinSitOnOption: TwinSitOnOptionDictionary,
        _ objectOptions: [OptionDictionary],
        _ dimensionIn: Part3DimensionDictionary = [:],
        _ objectToPartOrigin: PositionDictionary = [:],
        _ parentToPartOrigin: PositionDictionary = [:],
        _ angleIn: AngleDictionary = [:] ) {
            
        self.baseType = baseType
        self.twinSitOnOption = twinSitOnOption
        self.objectOptions = objectOptions
        self.dimensionIn = dimensionIn
        self.preTiltObjectToPartOriginIn = objectToPartOrigin
        self.preTiltParentToPartOriginIn = parentToPartOrigin
        self.angleIn = angleIn
      
        twinSitOnState = TwinSitOn(twinSitOnOption).state
        oneOrTwoIds = twinSitOnState ? [.id0, .id1]: [.id0]
        
        angle =
            ObjectAngleChange(parent: self).dictionary

            
//MARK: - ORIGIN/DICTIONARY
            
        // both parent to part and
        // object to part
        preTiltOccupantBodySupportOrigin =
            PreTiltOccupantBodySupportOrigin(parent: self)
        getPreTiltBodyOriginDictionary()
            
        preTiltOccupantFootBackSideSupportOrigin =
            PreTiltOccupantSupportOrigin(parent: self)
        getPreTiltFootSideBackOriginDictionary()
        
        preTiltWheelOrigin = getPreTiltWheelOrigin()
            if let preTiltWheelOrigin {
                preTiltWheelOriginIdNodes =
                getPreTiltWheelOriginIdNodes(
                    preTiltWheelOrigin as!
                        DimensionOriginCornerDictionaries.PreTiltWheelOrigin)
            }
        getPreTiltWheelOriginDictionary(preTiltWheelOriginIdNodes)

            
            
//MARK: - DIMENSIONS
        createOccupantSupportDimensionDictionary()


        createPreTiltCornerDictionary()

//MARK: - CHANGE USE DIMENSIONS
            //requires GetUniquesNames to be changed
        uniqueNames = GetUniqueNames(preTiltObjectToCornerOrigin).forPart
            
        //POST TILT
        creatPostTiltObjectToPartOriginDictionary()

  
//print("DIMENSION")
//DictionaryInArrayOut().getNameValue( dimension).forEach{print($0)}
            
            //print("\n\n\n")
//DictionaryInArrayOut().getNameValue( preTiltParentToPartOrigin).forEach{print($0)}
                //print("/n ORIGIN")
//DictionaryInArrayOut().getNameValue( preTiltObjectToPartOrigin).forEach{print($0)}
//DictionaryInArrayOut().getNameValue( preTiltObjectToCornerOrigin).forEach{print($0)}
//
//print("\n\n\n")
            
            
        //createCornerDictionary ()
  

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
                .sixWheels.contains(baseType) ?
            preTiltWheelOrigin.allOriginIdNodes[midIndex][indexForNodeGroup] : ZeroValue.originIdNodes
            
            let allOriginIdNodes =
                (rear: preTiltWheelOrigin.allOriginIdNodes[rearIndex][indexForNodeGroup] ,
                 mid: allOriginIdNodesForMid,
                 front: preTiltWheelOrigin.allOriginIdNodes[frontIndex][indexForNodeGroup])
            
            return
                allOriginIdNodes
        }
            
            
        func getPreTiltBodyOriginDictionary( ) {
            if let data =
                preTiltOccupantBodySupportOrigin{
                let indexForNodeGroup = 0
                let allOriginIdNodesForSitOnForBothSitOn = data.allOriginIdNodes[indexForNodeGroup]

                for allOriginIdNodesForSitOn in allOriginIdNodesForSitOnForBothSitOn {

                    
                let preTiltParentToPartBodyOrigin =
                        OriginPartInDictionariesOut(
                            allOriginIdNodesForSitOn,
                            preTiltParentToPartOriginIn
                    ).makeAndGetForParentToPart()

                //for the body origin
                //parent and object are identical
                preTiltObjectToPartOrigin += preTiltParentToPartBodyOrigin
                preTiltParentToPartOrigin += preTiltParentToPartBodyOrigin
                }
            }
        }
            
        
        func getPreTiltWheelOriginDictionary(
            _ frontMidRearOriginIdNodes: RearMidFrontOriginIdNodes) {
                
            createPreTiltWheelOriginDictionary(frontMidRearOriginIdNodes.rear)
                
            if BaseObjectGroups().midWheels.contains(baseType) {
                createPreTiltWheelOriginDictionary(frontMidRearOriginIdNodes.mid)
            }
                
            createPreTiltWheelOriginDictionary(frontMidRearOriginIdNodes.front)
                
            func createPreTiltWheelOriginDictionary(
                _ originIdNodes: OriginIdNodes ) {
                let parentAndObjectToPartOriginDictionary =
                    OriginPartInDictionariesOut(
                        originIdNodes,
                        preTiltParentToPartOriginIn
                        )
                preTiltObjectToPartOrigin +=
                    parentAndObjectToPartOriginDictionary
                        .makeAndGetForObjectToPart()
                preTiltParentToPartOrigin +=
                    parentAndObjectToPartOriginDictionary
                        .makeAndGetForParentToPart()
                }
        }
            
            
        func getPreTiltFootSideBackOriginDictionary () {
            if let data =
                preTiltOccupantFootBackSideSupportOrigin
                    as? PreTiltOccupantSupportOrigin {

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
                
                let allOriginIdNodesForBackForBothSitOn = data.allOriginIdNodesForBackSupportForBothSitOn
                for allOriginIdNodesForBack in
                        allOriginIdNodesForBackForBothSitOn {
                            createPreTiltParentToPartFootSideBackOriginDictionary(allOriginIdNodesForBack)
                }
                
                func createPreTiltParentToPartFootSideBackOriginDictionary (
                    _ allOriginIdNodes: OriginIdNodes){
                        let parentAndObjectToPartOriginDictionary =
                            OriginPartInDictionariesOut(
                            allOriginIdNodes,
                            preTiltParentToPartOriginIn
                            )
                        preTiltParentToPartOrigin +=
                            parentAndObjectToPartOriginDictionary.makeAndGetForParentToPart()
                        preTiltObjectToPartOrigin +=
                            parentAndObjectToPartOriginDictionary.makeAndGetForObjectToPart()
                }
            }
        }

      
        func createOccupantSupportDimensionDictionary() {
            let occupantSupportDimensionDictionary =
                OccupantSupportDimensionDictionary(parent: self)
            
            dimension += occupantSupportDimensionDictionary.forWheels
            dimension +=
                occupantSupportDimensionDictionary.forBack
            dimension += occupantSupportDimensionDictionary.forFoot
            dimension += occupantSupportDimensionDictionary.forSide
            
            ///dimensionForBody must be subsequent to for... which have sitOn in their nodes
            ///otherwise§
            let dimensionForBody  = occupantSupportDimensionDictionary.forBody
            dimension += dimensionForBody
        }
      

     
        func createPreTiltCornerDictionary () {
            let nameToBeRemovedCharacterCount = CreateNameFromParts([.object, .id0, .stringLink]).name.count
            for (key, value) in dimension {
                let originValue = preTiltObjectToPartOrigin[key]
                if let originValue {
                    let corners = CreateIosPosition.getCornersFromDimension( value)
                    let cornersFromObject =
                        CreateIosPosition.addToupleToArrayOfTouples(
                            originValue,corners)
                    let topViewCorners = [4,5,6,7].map {cornersFromObject[$0]}
                    let sideViewCorners = [4,7,3,0].map {cornersFromObject[$0]}
                    
                    let startIndex =
                    key.index(key.startIndex, offsetBy: nameToBeRemovedCharacterCount)
                    // for compatability with prevous code
                    //object_id0_ is removed from the start
                    //of the name
                    let nameWithoutObject =
                    String(key[startIndex...])


                    for index in 0..<topViewCorners.count {
                        preTiltObjectToCornerOrigin +=
                        [nameWithoutObject + Part.stringLink.rawValue + "corner" + String(index): topViewCorners[index]]
                       
                    }
//    print (nameWithoutObject)
//    print (topViewCorners)
                    pretTiltObjectToAllPartCornerOrigin += [nameWithoutObject: topViewCorners]
                }

            }
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
    }
    
    
//    let array = [1, 2, 3, 4, 5]
//    let indices = [0, 2, 4]
//
//    let extractedElements = indices.map { array[$0] }
//    print(extractedElements) // This will print: [1,⬤
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
            parent: DimensionOriginCornerDictionaries) {
            
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
                        parent.angleIn[name] ?? defaultAngles[index]
                    dictionary += [name: angle]
                }
            }
        }
    }
    

    
    //MARK: BODY SUPPORT ORIGIN
    /// The ability to add two seats side by side or back to front
    /// combined with the the different object origins with respect
    /// to the body support, for example, front drive v rear drive
    /// requires the following considerable logic
    struct PreTiltOccupantBodySupportOrigin: InputForDictionary {
        var partGroup: PartGroup.Type = PartGroup.self
 
        let objectType: BaseObjectTypes
        let stability: Stability
        var origin: [PositionAsIosAxes] = []
        let frontAndRearState: Bool
        let leftandRightState: Bool

        var occupantBodySupportsDimension: [Dimension3d] = []
        var occupantSideSupportsDimension: [[Dimension3d]] = []
        var occupantFootSupportHangerLinksDimension: [Dimension3d] = []
        
        let lengthBetweenWheels: DistanceBetweenWheels
        var allOriginIdNodesForBodySupportForBothSitOn:  [OriginIdNodes] = []
        //used externally
        var allOriginIdNodes: [[OriginIdNodes]] = []
        
        init(
            parent: DimensionOriginCornerDictionaries) {
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
                DistanceBetweenWheels(
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
            
                
            if BaseObjectGroups().allFourCaster.contains(parent.baseType) {
            forRearPrimaryOrigin()
                
//                print("\n\n")
//                print("from wheels")
//                print(origin)
//                print("\n\n")
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
                let modifiedDimension = parent.dimensionIn[name] ?? OccupantBodySupportDefaultDimension(parent.baseType).value
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
                        let modifiedDimension = parent.dimensionIn[name] ??
                        OccupantSideSupportDefaultDimension(parent.baseType).value
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
                    var modifiedDimensions: [Dimension3d?] = [parent.dimensionIn[names[0]]]
                    if footSupportInOnePieceState {
                    } else {
                        let name =
                        CreateNameFromParts([.footSupportHangerLink, .id1, .stringLink, .sitOn, id]).name
                        modifiedDimensions += [parent.dimensionIn[name]]
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
                   modifiedDimension ?? OccupantFootSupportDefaultDimension(parent.baseType).getHangerLink()
            }
        }
        

        
        
        mutating func forRearPrimaryOrigin() {
            origin.append(
                (x: 0.0,
                y:
                stability.atRear +
                 occupantBodySupportsDimension[0].length/2,
                 z: DimensionOriginCornerDictionaries.sitOnHeight)
            )
            if frontAndRearState {
                origin.append(
                        (x: 0.0,
                        y:
                        stability.atRear +
                        occupantBodySupportsDimension[0].length +
                        occupantFootSupportHangerLinksDimension[0].length +
                        occupantBodySupportsDimension[1].length/2,
                         z: DimensionOriginCornerDictionaries.sitOnHeight)
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
                 z: DimensionOriginCornerDictionaries.sitOnHeight)
                ]
            }
        }
        
       mutating func forMidPrimaryOrigin(){
            let baseLength = frontAndRearState ?
                lengthBetweenWheels.frontRearIfFrontAndRearSitOn(): lengthBetweenWheels.frontRearIfNoFrontAndRearSitOn()
            
            origin.append(
            (x: 0.0,
             y: 0.5 * (baseLength - occupantBodySupportsDimension[0].length),
             z: DimensionOriginCornerDictionaries.sitOnHeight)
            )
            
            if frontAndRearState {
                origin =
                [
                (x: 0.0,
                 y: -origin[0].y,
                 z: DimensionOriginCornerDictionaries.sitOnHeight)
                 ,
                (x: 0.0,
                 y: origin[0].y,
                z: DimensionOriginCornerDictionaries.sitOnHeight)
                ]
            }
            
            if leftandRightState {
                origin =
                [
                (x: 0.0,
                 y: -origin[0].y,
                 z: DimensionOriginCornerDictionaries.sitOnHeight)
                 ,
                (x: 0.0,
                 y: origin[0].y,
                z: DimensionOriginCornerDictionaries.sitOnHeight)
                ]
            }
        }
        
        
       mutating func forFrontPrimaryOrgin() {
            origin.append(
                (x: 0.0,
                 y:
                -(stability.atFront +
                    occupantBodySupportsDimension[0].length/2),
                 z: DimensionOriginCornerDictionaries.sitOnHeight )
                 )
            
            if frontAndRearState {
                origin = [
                    (x: 0.0,
                     y:
                        -stability.atFront -
                        occupantBodySupportsDimension[0].length -
                        occupantFootSupportHangerLinksDimension[1].length -
                        occupantBodySupportsDimension[1].length/2,
                     z: DimensionOriginCornerDictionaries.sitOnHeight
                     ),
                    origin[0]
                ]
            }
            
            if leftandRightState {
                origin = [
                    (x: -leftAndRightX(),
                     y: origin[0].y,
                     z: DimensionOriginCornerDictionaries.sitOnHeight),
                    (x: leftAndRightX(),
                     y: origin[0].y,
                     z: DimensionOriginCornerDictionaries.sitOnHeight)
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
    
  
    
    
    //MARK: FOOT/SIDE/BACK/ROTATE ORIGIN
    struct PreTiltOccupantSupportOrigin: InputForDictionary {
        let parent: DimensionOriginCornerDictionaries
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
            parent: DimensionOriginCornerDictionaries) {
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
                    
                    allOriginIdNodesForSideSupportForBothSitOn.append( getOriginIdNodesForSideSupport(sitOnIndex) )
//print (allOriginIdNodesForSideSupportForBothSitOn)
                    
//                    allOriginIdNodesForBackSupportForBothSitOn.append( getOriginIdNodesForBackSupport(sitOnIndex) )

                    allOriginIdNodes =
                    [
                     allOriginIdNodesForSideSupportForBothSitOn,
                    ]
                    
                    if BaseObjectGroups().hasBackSupport.contains(parent.baseType) {
                        allOriginIdNodesForBackSupportForBothSitOn.append( getOriginIdNodesForBackSupport(sitOnIndex) )
                        
                        allOriginIdNodes.append(allOriginIdNodesForBackSupportForBothSitOn)
                    }
                    
                    if BaseObjectGroups().hasFootSupport.contains(parent.baseType) {
                        allOriginIdNodesForFootSupportForBothSitOn.append( getOriginIdNodesForFootSupport(sitOnIndex) )
                        
                        allOriginIdNodes.append(allOriginIdNodesForFootSupportForBothSitOn)
                    }
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
                bilateralWidthPositionId, // [.id1, .id0]
                bilateralWidthPositionId] // [.id1, .id0]
            return
               (
                origin: allSideSupportOrigin,
                ids: allSideSupportIds,
                nodes: allSideSupportNodes)
        }
        
//        func getDimensionForSideSupport(_ sitOnIndex: Int) {
//            
//        }
        
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
    struct PreTiltWheelOrigin: InputForDictionary {
        //assignment form for static values
        var partGroup: PartGroup.Type = PartGroup.self
        
        //ObjectCreator
        let objectType: BaseObjectTypes
        var allOriginIdNodes: [[OriginIdNodes]] = []
        
        let lengthBetweenFrontAndRearWheels: Double
        let parent: DimensionOriginCornerDictionaries
        let bodySupportOrigin: PreTiltOccupantBodySupportOrigin
        let wheelAndCasterVerticalJointOrigin: WheelAndCasterVerticalJointOrigin
        let casterOrigin: CasterOrigin
        var allOriginIdNodesForRear: OriginIdNodes = ZeroValue.originIdNodes
        var allOriginIdNodesForMid: OriginIdNodes = ZeroValue.originIdNodes
        var allOriginIdNodesForFront: OriginIdNodes = ZeroValue.originIdNodes
        

        

        init(
            parent: DimensionOriginCornerDictionaries,
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
            
                let baseObjectGroups = BaseObjectGroups()
//                if baseObjectGroups.rearFixedWheel.contains(objectType) {
//                    allOriginIdNodes.append([getOriginIdNodesForRear()])
//
//
//
//                }
//
//                if baseObjectGroups.midFixedWheel.contains(objectType) {
//                    allOriginIdNodes.append([getOriginIdNodesForMid()])
//
//                }
//
//                if baseObjectGroups.frontFixedWheel.contains(objectType) {
//                    allOriginIdNodes.append([getOriginIdNodesForFront()])
//                }
//
//                if baseObjectGroups.allFourCaster.contains(objectType) {
//
//                }
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
                
//print(allOriginIdNodes)
            
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
extension DimensionOriginCornerDictionaries.PreTiltWheelOrigin {
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
extension DimensionOriginCornerDictionaries.PreTiltWheelOrigin {
    func getRearNodes()
        -> [Part] {
        var nodes: [Part] = []
        if BaseObjectGroups().rearCaster.contains(parent.baseType) {
            nodes =
                partGroup.casterWheelNodes
//print(parent.baseType)
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
extension DimensionOriginCornerDictionaries.PreTiltOccupantBodySupportOrigin {
    
    
}


// MARK: WHEEL ORIGIN EXTENSION
/// wheelPartOrigin for rear or mid or front are required
/// and values depend on the object origin: rear, mid or front
extension DimensionOriginCornerDictionaries.PreTiltWheelOrigin {
    
    func getRearOrigin()
        -> [PositionAsIosAxes]{
        var rearOrigin: [PositionAsIosAxes] = []
            
        let forkAndCasterWheelForRear =
            [casterOrigin.forRearCasterVerticalJointToFork(),
             casterOrigin.forRearCasterForkToWheel()]

        if BaseObjectGroups().midPrimaryOrigin.contains(parent.baseType) {
            rearOrigin =
                [
                wheelAndCasterVerticalJointOrigin
                    .getRearCasterWhenMidPrimaryOrigin()] +
                forkAndCasterWheelForRear
        }
        if BaseObjectGroups().frontPrimaryOrigin.contains(parent.baseType) {
            rearOrigin =
                [
                wheelAndCasterVerticalJointOrigin
                    .getRearCasterWhenFrontPrimaryOrigin()] +
                forkAndCasterWheelForRear
        }
            
        if BaseObjectGroups().rearPrimaryOrigin.contains(parent.baseType) {
            if BaseObjectGroups().allFourCaster.contains(parent.baseType) {
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
            .allCaster.contains(parent.baseType) {
            midOrigin =
                [
                wheelAndCasterVerticalJointOrigin
                    .getRearCasterWhenRearPrimaryOrigin()] +
                forkAndCasterWheel
        }
                  
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

        return
           BaseObjectGroups()
                .allDriveOrigin.contains(parent.baseType) ?
                    [
                    wheelAndCasterVerticalJointOrigin
                        .getRightDriveWheel(),
                    ZeroValue.iosLocation]: [] //joint and wheel coterminous
    }
    
}





///Provides the origin and id and nodes (an array of parts in order from  object origin to end part for the relevant parts where id is a one or two element array indicating that the part is unilateral or bilateral respectively).   Example nodes is [.wheelJoint, .casterFork, .casterWheel] , ids is [[id0, id1], [id0, id1], [id0, id1]] indicating two caster wheels
protocol InputForDictionary {
    // the input value
    var objectType: BaseObjectTypes {get}
    // the return value
    // An array of array as some structs
    // provide more than one array of OriginIdNodes
    var allOriginIdNodes: [[OriginIdNodes]] {get}
}


/// Provides a means of passing dimenions for parts
/// to one function
protocol PartDimension {
    var parts: [Part] {get}
    var defaultDimensions: [Dimension3d] {get}
}
