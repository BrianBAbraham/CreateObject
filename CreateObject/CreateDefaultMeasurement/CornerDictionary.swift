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
    //var originIdsPartChainDimension: [[OriginIdPartDimensionChain]] = []
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


    var partChainDictionary: PartChainDictionary = [:]
    var partChainsIdDic: PartChainIdDictionary  = [:]
    
    var dimensionDic: Part3DimensionDictionary = [:]
    var angleDic: AngleDictionary = [:]
    var angleMinMaxDic: AngleMinMaxDictionary = [:]
    
    var preTiltWheelOriginIdNodes: RearMidFrontOriginIdNodes = ZeroValue.rearMidFrontOriginIdNodes
    var originIdPartChainForBackForBothSitOn: [OriginIdPartChain]  = [ZeroValue.originIdPartChain]
    

    var preTiltWheelOrigin: InputForDictionary?

    var uniqueNames: [String] = []
    
   var partDimensionOriginIdChains: [[PartDimensionOriginIdsChain]] = []
    
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
            

        objectPartChainLabelDic = getObjectPartChainLabelDic()

//MARK: - ORIGIN/DICTIONARY
        // both parent to part and
        // object to part
            
            
        partDimensionOriginIdChains =
            PartDimensionOriginIdChains(objectType).partDimensionOriginIdChains
         

       
            
            
            
        for item in partDimensionOriginIdChains {
            
            createPreTiltParentToPartDictionary2(trial: item)
            
            dimensionDic +=
            DimensionDictionary2(
                item,
                dimensionDicIn,
                0).forPart
            
            
            if (item.last != nil)  {
                if [Part.backSupportHeadSupport, Part.backSupport].contains(item.last![0].part) {
                    print ("TILT REQUIRERD")
                }
            }
           
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

            
//DictionaryInArrayOut().getNameValue(preTiltObjectToPartOriginDic).forEach{print($0)}
                      

            

        func prepareObjectDataForCreationOfOriginAndDimensionDic(
            _ originIdPartDimensionChain: OriginIdPartDimensionChain) {

            let chain =
                originIdPartDimensionChain.chain

            let allOriginIdPartChainForBothSitOn =
                    [(origin: originIdPartDimensionChain.origin,
                      ids: originIdPartDimensionChain.ids,
                      chain: originIdPartDimensionChain.chain)]
            
            let chainLabel = originIdPartDimensionChain.chain.last
     
            switch chainLabel {
                case .backSupport, .backSupportHeadSupport:
                //this is required for post tilt
                originIdPartChainForBackForBothSitOn = allOriginIdPartChainForBothSitOn
                default:
                    break
            }
           
            for allOriginIdPartChain in
                    allOriginIdPartChainForBothSitOn {
//                        createPreTiltParentToPartDictionary(
//                            allOriginIdPartChain)

//                    dimensionDic +=
//                    DimensionDictionary(
//                        [allOriginIdPartChain],
//                        originIdPartDimensionChain.dimension,
//                        dimensionDicIn,
//                        0).forPart
            }
        }
                

            
//        func createPreTiltParentToPartDictionary (
//            _ allOriginIdPartChain: OriginIdPartChain){
//
//            let parentAndObjectToPartOriginDictionary =
//                OriginIdPartChainInDictionariesOut(
//                allOriginIdPartChain,
//                preTiltParentToPartOriginDicIn
//                )
//
//                preTiltParentToPartOriginDic +=
//                    parentAndObjectToPartOriginDictionary.makeAndGetForParentToPart()
//
//                preTiltObjectToPartOriginDic +=
//                    parentAndObjectToPartOriginDictionary.makeAndGetForObjectToPart()
//        }

            
            
        func createPreTiltParentToPartDictionary2 (
            
            trial: [PartDimensionOriginIdsChain]){
                
            
            let parentAndObjectToPartOriginDictionary =
                OriginIdPartChainInDictionariesOut2(
               trial,
                preTiltParentToPartOriginDicIn
                )
                preTiltParentToPartOriginDic +=
                    parentAndObjectToPartOriginDictionary.makeAndGetForParentToPart()
                
                preTiltObjectToPartOriginDic +=
                    parentAndObjectToPartOriginDictionary.makeAndGetForObjectToPart()
        }
            
            
            
            
        func getObjectPartChainLabelDic  ()
         -> ObjectPartChainLabelsDictionary {
             objectsAndTheirChainLabelsDicIn == [:] ?
                 ObjectsAndTheirChainLabels().dictionary:
                 objectsAndTheirChainLabelsDicIn
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
