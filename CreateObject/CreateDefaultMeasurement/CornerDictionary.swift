//
//  CornerDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation
//MARK: ANGLE
struct OccupantBodySupportDefaultAngleMinMax {
    let dictionary: BaseObjectAngelMinMaxDictionary =
    [.allCasterTiltInSpaceShowerChair: (min: Measurement(value: 0.0, unit: UnitAngle.degrees), max: Measurement(value: 45.0, unit: UnitAngle.degrees) ) ]
    
    static let general = (min: Measurement(value: 0.0, unit: UnitAngle.degrees), max: Measurement(value: 30.0, unit: UnitAngle.degrees) )
    
    let value: AngleMinMax
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


struct OccupantBackSupportDefaultAngleChange {
    var dictionary: BaseObjectAngleDictionary =
    [:]
    
    static let general = Measurement(value: 0.0 , unit: UnitAngle.radians)
    
    let value: Measurement<UnitAngle>
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}
//MARK: FOOT ANGLE
struct OccupantFootSupportDefaultAngleChange {
    var dictionary: BaseObjectAngleDictionary =
    [:]
    
    static let general = Measurement(value: 0.0, unit: UnitAngle.radians)
    
    let value: Measurement<UnitAngle>
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}


struct OccupantBodySupportDefaultAngleChange {
    let dictionary: BaseObjectAngleDictionary =
    [.allCasterTiltInSpaceShowerChair: OccupantBodySupportDefaultAngleMinMax(.allCasterTiltInSpaceShowerChair).value.max]//Measurement(value: 90.0, unit: UnitAngle.degrees)]
    
    static let general = Measurement(value: 0.0, unit: UnitAngle.degrees)
    
    let value: Measurement<UnitAngle>
    
    init(
        _ baseType: ObjectTypes) {
            value =
                dictionary[baseType] ??
                Self.general
    }
}
//MARK: - PARENT
///This provides
///The array of objects available
///Dictionary for objects
///An input for edited dimensions to replace default dimensions
struct DictionaryProvider {

   
    //UI amended dictionary
    //let userEditedDictionary: UserEditedDictionary
    let oneOrTwoUserEditedDictionary: OneOrTwoUserEditedDictionary
    let dimensionDicIn: Part3DimensionDictionary
    let preTiltParentToPartOriginDicIn: PositionDictionary
    let preTiltObjectToPartOriginDicIn: PositionDictionary
    let angleDicIn: AnglesDictionary
    let anglesMinMaxDicIn: AnglesMinMaxDictionary
    let partChainIdDicIn: [PartChain: OneOrTwo<Part> ]
 
    let objectType: ObjectTypes
    let twinSitOnOption: TwinSitOnOptionDictionary

    let oneOrTwoIds: [Part]
    var objectPartChainLabelDic: ObjectPartChainLabelsDictionary = [:]


    var partChainDictionary: PartChainDictionary = [:]
    var partChainIdDic: PartChainIdDictionary  = [:]
    

    var dimensionDicNew: Part3DimensionDictionary = [:]
    var angleDic: AnglesDictionary = [:]
    var anglesMinMaxDic: AnglesMinMaxDictionary = [:]
  
    //pre-tilt
    var preTiltObjectToPartOriginDicNew: PositionDictionary = [:]
    var preTiltParentToPartOriginDic: PositionDictionary = [:]
    var preTiltObjectToCornerDic: PositionDictionary = [:]
    var preTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    
    
    //post-tilt
    var postTiltObjectToPartOriginDicIn: PositionDictionary = [:]
    var postTiltObjectToPartOriginDic: PositionDictionary = [:]
    var postTiltObjectToCornerDic: PositionDictionary = [:]
    var postTiltObjectToFourCornerPerKeyDic: CornerDictionary = [:]
    
    
    let objectsAndTheirChainLabels: ObjectPartChainLabelsDictionary = ObjectsAndTheirChainLabels().dictionary
    
    var sitOnOrigin: PositionAsIosAxes = ZeroValue.iosLocation

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
        angleIn: AnglesDictionary = [:],
        minMaxAngleIn: AnglesMinMaxDictionary = [:],
        objectsAndTheirChainLabelsDicIn: ObjectPartChainLabelsDictionary = [:],
        partChainIdDicIn: [PartChain: OneOrTwo<Part> ] = [:]//,
    ) {
            
        self.objectType = objectType
        self.twinSitOnOption = twinSitOnOption
        self.dimensionDicIn = dimensionIn
        self.preTiltObjectToPartOriginDicIn = objectToPartOrigin
        self.preTiltParentToPartOriginDicIn = parentToPartOrigin
        self.angleDicIn = angleIn
        self.anglesMinMaxDicIn = minMaxAngleIn
        self.partChainIdDicIn = partChainIdDicIn
            
        oneOrTwoUserEditedDictionary =
                OneOrTwoUserEditedDictionary(
                    dimension: dimensionDicIn,
                    parentToPartOrigin :preTiltParentToPartOriginDicIn,
                    objectToPartOrigin :preTiltObjectToPartOriginDicIn,
                    anglesDic: angleIn,
                    anglesMinMaxDic: minMaxAngleIn,
                    partChainId: partChainIdDicIn
                )
            

        oneOrTwoIds = [.id0]
            
        angleDic = [:]
            //ObjectAngleChange(parent: self).dictionary
        anglesMinMaxDic = [:]
            //ObjectAngleMinMax(parent: self).dictionary
            
        objectPartChainLabelDic = [:]

            
//MARK: - ORIGIN/DIMENSION DICTIONARY
        initialiseAllPart()
        createDictionaryFromStructFactory()
        
//MARK: - PRE-TILT CORNERS
        preTiltObjectToPartFourCornerPerKeyDic =
            createCornerDictionary(
                preTiltObjectToPartOriginDicNew,
                   dimensionDicNew)
            
//DictionaryInArrayOut().getNameValue(preTiltParentToPartOriginDic).forEach{print($0)}
   // DictionaryInArrayOut().getNameValue(preTiltObjectToPartOriginDicNew).forEach{print($0)}
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
        func createDictionaryFromStructFactory(_ global: Bool = true){
            let chainLabels =
                objectsAndTheirChainLabelsDicIn[objectType] ??
                ObjectsAndTheirChainLabels().dictionary[objectType]
            var name: String = ""
            if let chainLabels {
                for chainLabel in chainLabels {
                    let chain = LabelInPartChainOut(chainLabel).partChain
                    
                    var currentOriginForOne = ZeroValue.iosLocation
                    var currentOriginForLeft = ZeroValue.iosLocation
                    var currentOriginForRight = ZeroValue.iosLocation
                    for index in 0..<chain.count {

                        let partValue = oneOrTwoObjectPartDic[chain[index]]
                        let parentPartValue = index == 0 ? partValue: oneOrTwoObjectPartDic[chain[index - 1]]
                        
                        if let partValue, let parentPartValue {
                            if !global {//if relative reset for each part
                                currentOriginForOne = ZeroValue.iosLocation
                                currentOriginForLeft = ZeroValue.iosLocation
                                currentOriginForRight = ZeroValue.iosLocation
                            }
                            let startParts: [Part] = index == 0 || global ? [.object]: [chain[index - 1]]
                            
                            let endParts = [
                                .stringLink,.sitOn, partValue.sitOnId]
                            
                            let extractedOrigin = OneOrTwoExtraction(partValue.origin).values
                            let extractedParentId = OneOrTwoExtraction(parentPartValue.id).values
                            let extractedDimension = OneOrTwoExtraction(partValue.dimension).values
                            
                            
                            func getName3(
                                _ childId: Part,
                                _ part: Part,
                                _ extractedParentId: (left: Part?, right: Part?, one: Part?),
                                _ label: KeyPath<(left: Part?, right: Part?, one: Part?), Part?>)
                                -> String {
                                    
                                    if var parentId = extractedParentId[keyPath: label] {
                                        if index == 0 || global {
                                            parentId = .id0
                                        }
                                        return
                                            getName2((parent: parentId, child: childId), partValue.part)
                                    } else {
                                        if var parentId = extractedParentId[keyPath: \.one] {
                                            if index == 0 || global {
                                                 parentId = .id0
                                            }
                                            return
                                                getName2((parent: parentId, child: childId), partValue.part)
                                        } else {
                                            fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no parent id exists for: \(chain[index])")
                                        }
                                    }
                            }
                            
                            
                            func getName2(
                                _ ids: (parent: Part, child: Part),
                                _ part: Part) -> String {
                                    
                                    CreateNameFromParts(startParts + [ids.parent, .stringLink, part, ids.child] + endParts).name
                            }
                            
                            func getOrigin(
                                _ currentOrigin: PositionAsIosAxes,
                                _ extraction: (left: PositionAsIosAxes?, right: PositionAsIosAxes?, one: PositionAsIosAxes?),
                                _ label: keyPathForIosPosition)
                                    -> PositionAsIosAxes{
                                    var currentOriginAllowingThatParentIsOne = ZeroValue.iosLocation
                                    if index != 0 {
                                        switch parentPartValue.id {
                                        case .one:
                                            currentOriginAllowingThatParentIsOne = currentOriginForOne
                                        case .two:
                                            currentOriginAllowingThatParentIsOne = currentOrigin
                                        }
                                        
                                    }
                                if let origin = extraction[keyPath: label] {
                                    return
                                        currentOriginAllowingThatParentIsOne + origin
                                } else {
                                    fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no origin exists for: \(chain[index])")
                                }
                                    
                            }
                            
                            
                            func addDimension(
                                _ extraction: (left: Dimension3d?, right: Dimension3d?, one: Dimension3d?),
                                _ label: KeyPath<(left: Dimension3d?, right: Dimension3d?, one: Dimension3d?), Dimension3d?>,
                                _ name: String) {
                                if let dimension = extraction[keyPath: label] {
                                    dimensionDicNew += [name: dimension]
                                } else {
                                    fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no origin exists for: \(chain[index])")
                                }
                                    
                            }
                            
                            func updateTwo(
                                _ leftOrRight: Part) {
                                    var label: keyPathForIosPosition = \.right
                                    var labelForSide: KeyPath<(left: Part?, right: Part?, one: Part?), Part?> = \.right
                                    var childId: Part = leftOrRight
                                    var labelForDimension: KeyPath<(left: Dimension3d?, right: Dimension3d?, one: Dimension3d?), Dimension3d?> = \.right
                                    var updatedOriginForSide = ZeroValue.iosLocation
                                    if leftOrRight == .id0 || leftOrRight == .id2 {
                                        label = \.left
                                        labelForSide = \.left
                                        //childId = leftOrRight
                                        labelForDimension = \.left
                                        currentOriginForLeft =  getOrigin(currentOriginForLeft, extractedOrigin,label)
                                        updatedOriginForSide = currentOriginForLeft
                                    } else {
                                        currentOriginForRight =  getOrigin(currentOriginForRight, extractedOrigin,label)
                                        updatedOriginForSide = currentOriginForRight
                                    }
                                    
                                    name = getName3(childId,partValue.part,extractedParentId, labelForSide)
                                    addDimension(extractedDimension, labelForDimension, name)
                                    preTiltObjectToPartOriginDicNew += [name: updatedOriginForSide]
                            }
                            
                            
                            switch partValue.id {
                                
                                case .one (let one):

                                    currentOriginForOne = getOrigin(currentOriginForOne, extractedOrigin,\.one)
                                    name = getName3(one,partValue.part,extractedParentId, \.one)
                                    addDimension(extractedDimension, \.one, name)
                                   
                                    preTiltObjectToPartOriginDicNew += [name: currentOriginForOne]
                                
                             
                                
                                case .two (let left, let right):
                                
                                if partValue.part == .casterVerticalJointAtFront {
    
                                }
                                    updateTwo(left)
                                    updateTwo(right)
                            }
                            
                            
                            
                            func fatalErrorGettingParentId(_ oneOrTwo: String){
                                fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) parent id does not exist for \(chain[index - 1]) for \(oneOrTwo)")
                                
                            }
                            
                            
                            func fatalErrorGettingOrigin(_ oneOrTwo: String){
                                print ( "\n\n\(String(describing: type(of: self))): \(#function ) no origin exist for these chainLabels\(String(describing: chain[index])) for \(oneOrTwo)")
                            }
                            
                            
                            
                        } else {
                            fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no values exist for this part: \(chain[index])")
                        }
                       
                    }
                }

            } else {
                fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no values exist for these chainLabels\(String(describing: chainLabels))")
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
///backSupport depends on sitOn
        ///backSupportHeadSupportRotationJoint depends on backSupport
        ///backSupportHeadSupportLink depends on backSupportHeadSupportRotationJoint
        ///backSupportHeadSupport depends on backSupportHeadSupportLink
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
                
            return [
                (part: Part.backSupport,
                 dimension: (width: 320.0, length: 10.0, height: 500.0),
                 origin: (x: 0.0, y: 0.0, z: 250.0),
                 ids: [Part.id0],
                 angles: ZeroValue.rotationAngles),
                (part: Part.backSupportHeadSupportJoint,
                 dimension: (width: 20.0, length: 20.0, height: 20.0),
                 origin: (x: 0.0, y: 0.0, z: 250.0),
                 ids: [Part.id0],
                 angles: ZeroValue.rotationAngles),
                (part: Part.backSupportHeadSupportLink,
                 dimension: (width: 20.0, length: 20.0, height: 100.0),
                 origin: (x: 0.0, y: 0.0, z: 50.0),
                 ids: [Part.id0],
                 angles: ZeroValue.rotationAngles),
                (part: Part.backSupportHeadSupport,
                 dimension: (width: 150.0, length: 100.0, height: 100.0),
                 origin: (x: 0.0, y: 0.0, z: 150.0),
                 ids: [Part.id0],
                 angles: ZeroValue.rotationAngles)]
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
        
            
//        func createPreTiltParentToPartOriginDictionary (
//            trial: [PartDataTuple]){
//
//            let parentAndObjectToPartOriginDictionary =
//                ObjectOriginDictionary(
//                    trial,
//                    preTiltParentToPartOriginDicIn)
//                preTiltParentToPartOriginDic +=
//                    parentAndObjectToPartOriginDictionary.makeAndGetForParentToPart()
//                preTiltObjectToPartOriginDic +=
//                    parentAndObjectToPartOriginDictionary.makeAndGetForObjectToPart()
//        }
            
            
//        func getObjectPartChainLabelDic  ()
//         -> ObjectPartChainLabelsDictionary {
//             objectsAndTheirChainLabelsDicIn == [:] ?
//                 ObjectsAndTheirChainLabels().dictionary:
//                 objectsAndTheirChainLabelsDicIn
//         }
            
            
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
        var dictionary: AnglesDictionary = [:]
        
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
                    parent.angleDicIn[name]?.x ?? defaultAngles[index]
                    dictionary += [name: (x: angle, y: ZeroValue.angle, z: ZeroValue.angle)]
                }
            }
        }
    }
    
    //DefaultAngleMinMax
//    struct ObjectAngleMinMax {
//        var dictionary: AngleMinMaxDictionary = [:]
//
//        init(
//            parent: DictionaryProvider) {
//
//                for id in parent.oneOrTwoIds {
//                    setAngleDictionary( id)
//                }
//
//
//                func setAngleDictionary( _ id: Part) {
//                let partForNames: [[Part]] =
//                    [
//                    [.sitOnTiltJoint, .stringLink, .sitOn, id]]
//                let defaultMinMax =
//                    [
//                    OccupantBodySupportDefaultAngleMinMax(parent.objectType).value]
//                var name: String
//                var angleMinMax: AngleMinMax
//                    for index in 0..<partForNames.count {
//                    name =
//                        CreateNameFromParts(partForNames[index]).name
//                    angleMinMax =
//                        parent.anglesMinMaxDicIn[name]?.max.x ??
//                        defaultMinMax[index]
//                    dictionary += [name: angleMinMax]
//                      //print (dictionary)
//                }
//            }
//        }
//    }
    
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

            if let originOfRotation = parent.preTiltObjectToPartOriginDicNew[originOfRotationName] {
                
                let angleName =
                    CreateNameFromParts( [rotationJoint, .stringLink, .sitOn, sitOnId]).name
                let angleChange =
                parent.angleDicIn[angleName]?.x ??
                parent.angleDic[angleName]?.x ?? ZeroValue.angle
                
                for index in  0..<originIdPartChain.chain.count {
                    let partIds: [Part] =  originIdPartChain.ids[index]
                    
                    for partId in partIds {
 
                        var tiltedCornersFromObject: Corners = []
                        let partName =
                            CreateNameFromParts([
                                .object, .id0, .stringLink, originIdPartChain.chain[index], partId, .stringLink, .sitOn, sitOnId]).name

                        let originOfPart = parent.preTiltObjectToPartOriginDicNew[partName]
                        
                        let dimensionOfPart = parent.dimensionDicNew[partName]
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



protocol RotationAngle {
    var minAngle: RotationAngle {get}
    var maxAngle: RotationAngle {get}

}
