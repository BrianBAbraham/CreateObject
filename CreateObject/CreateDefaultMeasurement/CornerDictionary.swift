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
    //let userEditedDictionary: UserEditedDictionary
    let oneOrTwoUserEditedDictionary: OneOrTwoUserEditedDictionary
    let dimensionDicIn: Part3DimensionDictionary
    let preTiltParentToPartOriginDicIn: PositionDictionary
    let preTiltObjectToPartOriginDicIn: PositionDictionary
    let angleDicIn: AngleDictionary
    let angleMinMaxDicIn: AngleMinMaxDictionary
    let partChainIdDicIn: [PartChain: OneOrTwo<Part> ]
   
    //let partChainsIdDicIn: [PartChain: [[Part]]]
    
    let objectType: ObjectTypes
    let twinSitOnOption: TwinSitOnOptionDictionary

    //var twinSitOnState: Bool //= false
    let oneOrTwoIds: [Part]
    var objectPartChainLabelDic: ObjectPartChainLabelsDictionary = [:]


    var partChainDictionary: PartChainDictionary = [:]
    var partChainIdDic: PartChainIdDictionary  = [:]
    
    var dimensionDic: Part3DimensionDictionary = [:]
    var angleDic: AngleDictionary = [:]
    var angleMinMaxDic: AngleMinMaxDictionary = [:]
    

    var originIdPartChainForBackForBothSitOn: [PartDataTuple] = []
    
   var chainsWithTouple: [[PartDataTuple]] = []
    
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

    var object: Object
    
    /// each part has a either .leftRight or .one GenericPartVqalue
    //var objectPartDic: [Part: Symmetry<GenericPartValue>] = [:]
    var oneOrTwoObjectPartDic: [Part: OneOrTwoGenericPartValue] = [:]

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
        partChainIdDicIn: [PartChain: OneOrTwo<Part> ] = [:]//,
    //    partIdsDicIn: [Part: OneOrTwo<Part>] = [:]
    ) {
            
        self.objectType = objectType
        self.twinSitOnOption = twinSitOnOption
        self.dimensionDicIn = dimensionIn
        self.preTiltObjectToPartOriginDicIn = objectToPartOrigin
        self.preTiltParentToPartOriginDicIn = parentToPartOrigin
        self.angleDicIn = angleIn
        self.angleMinMaxDicIn = minMaxAngleIn
        self.partChainIdDicIn = partChainIdDicIn
            
        oneOrTwoUserEditedDictionary =
                OneOrTwoUserEditedDictionary(
                    dimension: dimensionDicIn,
                    parentToPartOrigin :preTiltParentToPartOriginDicIn,
                    objectToPartOrigin :preTiltObjectToPartOriginDicIn,
                    angle: angleDicIn,
                    partChainId: partChainIdDicIn
                )
            
        object = (Object(objectType))
            
        preTiltSitOnAndWheelBaseJointOrigin = PreTiltSitOnAndWheelBaseJointOrigin(objectType)
  
       //twinSitOnState = TwinSitOn(twinSitOnOption).state
            oneOrTwoIds = [.id0]//twinSitOnState ? [.id0, .id1]: [.id0]
            
        angleDic =
            ObjectAngleChange(parent: self).dictionary
        angleMinMaxDic =
            ObjectAngleMinMax(parent: self).dictionary
            
        objectPartChainLabelDic = getObjectPartChainLabelDic()

        chainsWithTouple = object.partDataTupleChain
            
//MARK: - ORIGIN/DIMENSION DICTIONARY
        // both parent to part and
        // object to part
        for chain in chainsWithTouple {
            createPreTiltParentToPartOriginDictionary(trial: chain)
            
            dimensionDic +=
                DimensionDictionary(
                    chain,
                    dimensionDicIn,
                    0).forPart
        }

           
//MARK: - PRE-TILT CORNERS
        preTiltObjectToPartFourCornerPerKeyDic =
            createCornerDictionary(
                   preTiltObjectToPartOriginDic,
                   dimensionDic)
            
//DictionaryInArrayOut().getNameValue(preTiltObjectToPartFourCornerPerKeyDic).forEach{print($0)}
//print(preTiltObjectToPartFourCornerPerKeyDic)

//MARK: - POST-TILT
        let rotatableParts =
            RotatableParts()
        var partsToRotate: [Part] = []
        if let partsRotatedBySitOnTiltJoint =
            rotatableParts.dictionary[.sitOnTiltJoint] {// get lable
            partsToRotate = // use label to select rotated parts
                rotatableParts.getScopeOfParts(partsRotatedBySitOnTiltJoint[0])
        }
        
        // initially set postTilt to preTilt values
        postTiltObjectToFourCornerPerKeyDic =
            preTiltObjectToPartFourCornerPerKeyDic
            

        postTiltObjectToFourCornerPerKeyDic =
            Replace(
                initial:
                    preTiltObjectToPartFourCornerPerKeyDic,
                replacement:             getRotatedObjectToPartFourCornerPerKeyDic(            getRotatingPartDataTupleFromStruct(
                    partsToRotate))
            ).intialWithReplacements
    
            
            
            
          
///by definition the preceeding part in a partChain is the parent of the subsequent  part
///the subsequent part global origin is therefore dependent on the preceeing part origin
///therefore. if the global origin of the subsequent part is to be maintained independently of the
///preceeding part, such as a sideSupport maintaining its relative position to the sitOn  irrespective
///of jointOrigin between sideSupport and sitOn the partChain ought to be processed as a whole
            
//MARK: InitialiseAllPart
    initialiseAllPart()
    createDictionaryFromStructFactory()
        print(oneOrTwoObjectPartDic.values.map{$0.part})
        
        func createDictionaryFromStructFactory(){
            let chainLabels =
                objectsAndTheirChainLabelsDicIn[objectType] ??
                ObjectsAndTheirChainLabels().dictionary[objectType]
            if let chainLabels {
                for chainLabel in chainLabels {
                    let chain = LabelInPartChainOut(chainLabel).partChain
                    var currentOrigin: OneOrTwo<PositionAsIosAxes> = .one(one: ZeroValue.iosLocation )
                    for part in chain {
                       let partValue = oneOrTwoObjectPartDic[part]
                        if let partValue {
                            switch partValue.origin {
                                case .one (let one):
                                    print ("\(part) \(one)")
                                case .two (let left, let right):
                                    print ("\(part) left: \(left), right: \(right)")
                            }
                        } else {
                            fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no values exist for this part: \(part)")
                        }
                    }
                }

            } else {
                fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no values exist for these chainLabels\(chainLabels)")
            }

        }
        
    func initialiseAllPart() {
        let oneOfEachPartInAllPartChain =  getOneOfEachPartInAllPartChain()
        if oneOfEachPartInAllPartChain.contains(.sitOn) {
            oneOrTwoObjectPartDic +=
                [.sitOn: initialilseOneOrTwoSitOn()]
        }
        
        if oneOfEachPartInAllPartChain.contains(.backSupport) {
            initialiseOneOrTwoDependantPart(
                .sitOn,.backSupport )
        }
        
        if oneOfEachPartInAllPartChain.contains(.footSupportHangerLink) {
            initialiseOneOrTwoIndependantPart(
                .footSupportHangerLink )
        }
        
        if oneOfEachPartInAllPartChain.contains(.backSupportHeadSupportLink) {
            initialiseOneOrTwoIndependantPart(
                .backSupportHeadSupportLink )
        }
//print(oneOfEachPartInAllPartChain)

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
                            .backSupportHeadSupportJoint:
                                initialiseOneOrTwoDependantPart(
                                    .backSupport, part)
                        
                        case  .backSupportHeadSupportLink:
                            break// already intialised
                        
                        case .backSupportHeadSupport:
                            initialiseOneOrTwoDependantPart(
                            .backSupportHeadSupportLink, part)
                        case .footSupport:
                                initialiseOneOrTwoIndependantPart(part)
                        case .footSupportJoint:
                                initialiseOneOrTwoDependantPart(.footSupportHangerLink, part )
                        
                        case .footSupportInOnePiece:
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
 
  
        func initialiseOneOrTwoWheel(_ oneChainLabel: Part ) {
            let partChain = LabelInPartChainOut(oneChainLabel).partChain
            let partWithJoint: [Part] = [
                    .fixedWheelHorizontalJointAtRear,
                    .fixedWheelHorizontalJointAtMid,
                    .fixedWheelHorizontalJointAtFront,
                    .casterVerticalJointAtRear,
                    .casterVerticalJointAtMid,
                    .casterVerticalJointAtFront]
            var siblings: [OneOrTwoGenericPartValue] = []
            var jointPart:Part = .notFound
            
            if let jointIndex = partChain.firstIndex(where: { partWithJoint.contains($0) }) {
                jointPart = partChain[jointIndex]
                for index in 0..<partChain.count {
                    let part = partChain[index]
                    if index != jointIndex {
                        initialiseOneOrTwoIndependantPart(part)
                        
                        if let values = oneOrTwoObjectPartDic[part] {
                            siblings.append(values)
                        } else {
                            fatalError( "\n\nDictionary Provider: \(#function) initialisation did not succedd this part: \(part)")                        }
                       
                    }
                }
            }
            initialiseOneOrTwoDependantPart(
                .sitOn,
                jointPart,
                siblings)
        }
        
        
        func initialilseOneOrTwoSitOn ()
            -> OneOrTwoGenericPartValue {
             StructFactory(
                objectType,
                oneOrTwoUserEditedDictionary)
                     .createOneOrTwoSitOn(
                        nil,
                        nil)
        }
           
            
        func initialiseOneOrTwoDependantPart(
            _ parent: Part,
            _ child: Part,
            _ siblings: [OneOrTwoGenericPartValue] = []) {
            if let parentValue = oneOrTwoObjectPartDic[parent] {
//                if child == .backSupportRotationJoint {
//                    print (child)
//                    //print(parentValue.dimension)
//                }
//               
                oneOrTwoObjectPartDic +=
                    [child:
                        StructFactory(
                            objectType,
                            oneOrTwoUserEditedDictionary)
                                .createOneOrTwoDependentPartForSingleSitOn(
                                    parentValue,
                                    child,
                                    []) ]
            } else {
                 fatalError( "\n\nDictionary Provider: \(#function) no initialisation defined for this part: \(parent)")
            }
        }
            
            
        func initialiseOneOrTwoIndependantPart(_ child: Part) {
            //print (child)
            oneOrTwoObjectPartDic +=
                [child:
                    StructFactory(
                       objectType,
                       oneOrTwoUserEditedDictionary)
                            .createOneOrTwoDependentPartForSingleSitOn(
                                nil,
                                child,
                                []) ]
        }
                   
               
        func getOneOfEachPartInAllPartChain() -> [Part]{
            let chainLabels =
                objectsAndTheirChainLabelsDicIn[objectType] ??
                ObjectsAndTheirChainLabels().dictionary[objectType]
            var oneOfEachPartInAllChainLabel: [Part] = []
            if let chainLabels{
                var allPartInThisObject: [Part] = []
                let onlyOne = 0
                for label in chainLabels {
                    allPartInThisObject +=
                    LabelInPartChainOut([label]).partChains[onlyOne]
                }
               oneOfEachPartInAllChainLabel =
                Array(Set(allPartInThisObject))
            }
            return oneOfEachPartInAllChainLabel
        }
        
    }
                     
            
            
            
                    
        //generally all parts in a chain are not rotated
        //therefore non-rotated parts
        //are filitered out
        func getRotatingPartDataTupleFromStruct(
        _ partsToRotate: [Part])
            -> [PartDataTuple] {
            var rotatedPartData: [PartDataTuple] = []
            
            let allPartDataTuple = object.allPartDataTuple
                for partDataTouple in allPartDataTuple {
                    if partsToRotate.contains(partDataTouple.part) {
                        rotatedPartData.append(partDataTouple)
                    }
                }
            return rotatedPartData
        }
         

            
        func getRotatedObjectToPartFourCornerPerKeyDic(
           _ partDimensionOriginIdsChain: [PartDataTuple])
            -> CornerDictionary{
                // rotate the corners of the part
            var tilted: CornerDictionary = [:]
                tilted =
                    OriginPostTilt(
                        parent: self,
                        partDimensionOriginIdsChain,
                        .sitOnTiltJoint).objectToTiltedCorners
            return tilted
        }
        
            
        func createPreTiltParentToPartOriginDictionary (
            trial: [PartDataTuple]){
                
            let parentAndObjectToPartOriginDictionary =
                ObjectOriginDictionary(
                    trial,
                    preTiltParentToPartOriginDicIn)
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
            
            

            
            
            
    } // Init ends
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
        var partIds: [[Part]] = []
        var partChain: [Part] = []
        var partOrigin: [PositionAsIosAxes] = []
        
        init(
            parent: DictionaryProvider,
            _ partDimensionOriginIdsChain: [PartDataTuple],
            _ rotationJoint: Part) {

            self.parent = parent
                      
            for item in partDimensionOriginIdsChain {
              partChain.append(item.part)
              partIds.append(item.ids)
              partOrigin.append(item.origin)
            }
            
            //print(partChain)
                
            for index in 0..<parent.oneOrTwoIds.count {
                forTilt(
                    parent,
                    parent.oneOrTwoIds[index],
                    (origin: partOrigin, ids: partIds, chain: partChain),
                    rotationJoint)
            }
        }
        
        
        mutating func forTilt (
            _ parent: DictionaryProvider,
            _ sitOnId: Part,
            _ originIdPartChain:
                (
                origin: [PositionAsIosAxes],
                ids: [[Part]],
                chain: [Part]),
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

protocol RotationAngle {
    var minAngle: RotationAngle {get}
    var maxAngle: RotationAngle {get}
    
}
