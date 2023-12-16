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
    var  preTiltObjectToPartFourCornerPerKeyDicNew: CornerDictionary = [:]
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
        preTiltObjectToPartFourCornerPerKeyDicNew
//            createCornerDictionary(
//                preTiltObjectToPartOriginDicNew,
//                   dimensionDicNew)
            
//DictionaryInArrayOut().getNameValue(preTiltObjectToPartOriginDicNew).forEach{print($0)}
   // DictionaryInArrayOut().getNameValue(preTiltObjectToPartOriginDicNew).forEach{print($0)}
//print(preTiltObjectToPartFourCornerPerKeyDic)

//MARK: - POST-TILT

        var partsToRotate: [Part] = oneOrTwoObjectPartDic[.sitOnTiltJoint]?.scopesOfRotation[0] ?? []

        
        // initially set postTilt to preTilt values
        postTiltObjectToFourCornerPerKeyDic =
            preTiltObjectToPartFourCornerPerKeyDic
            

        postTiltObjectToFourCornerPerKeyDic =
            Replace(
                initial:
                    preTiltObjectToPartFourCornerPerKeyDic,
                replacement:
                    getRotatedObjectToPartFourCornerPerKeyDic(            getRotatingPartDataTupleFromStruct(
                    partsToRotate))
            ).intialWithReplacements
    
            
        
        

            
        // if let chainLabels {
//                let allChainLableWhichRotate:[Part] = [.sitOnTiltJoint]
//                let chainLabelsWhichRotate = chainLabels.filter{allChainLableWhichRotate.contains($0)}
//                let chainLabelsExcludingRotator =
//                    chainLabels.filter{!allChainLableWhichRotate.contains($0)}
          
///by definition the preceeding part in a partChain is the parent of the subsequent  part
///the subsequent part global origin is therefore dependent on the preceeing part origin
///therefore. if the global origin of the subsequent part is to be maintained independently of the
///preceeding part, such as a sideSupport maintaining its relative position to the sitOn  irrespective
///of jointOrigin between sideSupport and sitOn the partChain ought to be processed as a whole
            
//MARK: InitialiseAllPart
        func createDictionaryFromStructFactory(_ global: Bool = true) {
            guard let chainLabels = objectsAndTheirChainLabelsDicIn[objectType] ?? ObjectsAndTheirChainLabels().dictionary[objectType] else {
                fatalError("No values exist for the specified chainLabels.")
            }

            for chainLabel in chainLabels {
                processChainLabel(chainLabel, global)
            }
            
            for chainLabel in chainLabels {
                if chainLabel == .sitOnTiltJoint {
                    createRotatedDictionary(chainLabel)
                }
            }
        }
        

        func updateDictionary(_ update: DictionaryUpdate) {
          let name = update.name
          dimensionDicNew +=
              [name: update.dimension]
          preTiltObjectToPartOriginDicNew +=
              [name: update.origin]
          preTiltObjectToPartFourCornerPerKeyDicNew +=
              [name: update.corners]
        }
        
        
        struct DictionaryUpdate {
            let name: String
            let dimension: Dimension3d
            let origin: PositionAsIosAxes
            let corners: [PositionAsIosAxes]
        }
        
        
//        func checkForRotation (_ chainLabels: [Part]) {
//            for chainLabel in chainLabels {
//                if chainLabel == .sitOnTiltJoint {
//                    createRotatedDictionary(chainLabel)
//                }
//            }
//
//        }
//
        
        func createRotatedDictionary(
        _ chainLabel: Part) {
            var partsToRotate: [Part] = []
            var angleToRotate: Measurement<UnitAngle> = ZeroValue.angle
            var tiltedCornersFromObject: Corners = []
            var originOfRotate = getRotationOrigin(chainLabel) //from dictiionary to use global
     
            guard let allValues = oneOrTwoObjectPartDic[chainLabel] else {
                fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no values exist for this part: \(chainLabel)")
            }
            
            let alwaysUseFirstAsElementsRotatedByUI = 0
            let partChainToRotate =
                allValues.scopesOfRotation[alwaysUseFirstAsElementsRotatedByUI]
                if partChainToRotate != [] {
                    angleToRotate =
                    allValues.angles.values.one?.x
                    ?? ZeroValue.angle
                    partsToRotate =
                        Array(Set(LabelInPartChainOut(partChainToRotate).partChains.flatMap{$0}))
                    print("ROTATION REQUIRED for chains: \(partsToRotate) \(angleToRotate) \n")
            }
        }
        
        
        func getRotationOrigin (
        _ part: Part)
            -> PositionAsIosAxes{
            var rotationOrigin: PositionAsIosAxes = ZeroValue.iosLocation
            for (key, value) in preTiltObjectToPartOriginDicNew {
                if key.contains( part.rawValue ) {
                    // The dictionary contains the specified key, assign the value
                    rotationOrigin = value
                    print("Found: \(key) - \(rotationOrigin)")
                }
            }
            return rotationOrigin
        }
        
        
        func processChainLabel(_ chainLabel: Part, _ global: Bool ) {
            let chain = LabelInPartChainOut(chainLabel).partChain
            let z = ZeroValue.iosLocation
            var currentOrigins = (left: z, right: z, one: z)
            for index in 0..<chain.count {
               processPart(
                &currentOrigins,
               index,
               chain,
               global)
            }
        }
        

        func processPart(
        _ currentOriginsForChain: inout (left: PositionAsIosAxes, right: PositionAsIosAxes, one: PositionAsIosAxes),
        _ index: Int,
        _ chain: [Part],
        _ global: Bool) {
            guard let partValue = oneOrTwoObjectPartDic[chain[index]],
                  let parentPartValue =
                    (index == 0 ? partValue: oneOrTwoObjectPartDic[chain[index - 1]])  else {
            return fatalErrorGettingPartValue() }

            if !global {//if relative reset for each part
                resetOrign()
            }
            let childOrigin = partValue.childOrigin.values
            let extractedParentId = parentPartValue.id.values
            let extractedDimension = partValue.dimension.values
            var parametersForOneOrTwo = getParameters()
               
            switch partValue.id {
                case .one (let one):
                    currentOriginsForChain =
                        (left: currentOriginsForChain.left, right: currentOriginsForChain.right, one:  updateOne(one, parametersForOneOrTwo))
                case .two (let left, let right):
                    currentOriginsForChain =
                        (left: currentOriginsForChain.left, right: updateTwo(right, parametersForOneOrTwo), one: currentOriginsForChain.one)
            
                    currentOriginsForChain =
                        (left: updateTwo(left, parametersForOneOrTwo), right: currentOriginsForChain.right, one: currentOriginsForChain.one)
            }
            func getParameters() -> ParametersForOneOrTwo {
                ParametersForOneOrTwo(
                    currentOriginsForChain: currentOriginsForChain,
                    newOrigin: childOrigin,
                    extractedParentId: extractedParentId,
                    extractedDimension: extractedDimension,
                    partValue: partValue,
                    parentPartValue: parentPartValue,
                    index: index,
                    chain: chain,
                    global: global)
            }
                        
            func resetOrign() {
              let z = ZeroValue.iosLocation
              currentOriginsForChain = (left: z, right: z, one: z)
            }

            func fatalErrorGettingPartValue(){
              fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no values exist for this part: \(chain[index])")}


            func fatalErrorGettingParentId(_ oneOrTwo: String){
              fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) parent id does not exist for \(chain[index - 1]) for \(oneOrTwo)") }


            func fatalErrorGettingOrigin(_ oneOrTwo: String){
              print ( "\n\n\(String(describing: type(of: self))): \(#function ) no origin exist for these chainLabels\(String(describing: chain[index])) for \(oneOrTwo)") }
        }
        
        
        struct ParametersForOneOrTwo {
            let currentOriginsForChain: (left: PositionAsIosAxes, right: PositionAsIosAxes, one: PositionAsIosAxes)
            let newOrigin: (left: PositionAsIosAxes?, right: PositionAsIosAxes?, one: PositionAsIosAxes?)
            let extractedParentId: (left: Part?, right: Part?, one: Part?)
            let extractedDimension:  (left: Dimension3d?, right: Dimension3d?, one: Dimension3d?)
            let partValue: OneOrTwoGenericPartValue
            let parentPartValue: OneOrTwoGenericPartValue
            let index: Int
            let chain: [Part]
            let global: Bool
        }
        
        
        func updateTwo (
        _ childId: Part,
        _ parameters: ParametersForOneOrTwo)
            -> PositionAsIosAxes {
            var updatedCurrentOrigin: PositionAsIosAxes
            var labelForSide: KeyPathForSide
            var labelForDimension: KeyPathForDimension

            switch childId {
            case .id1, .id3:
                (updatedCurrentOrigin, labelForSide, labelForDimension) =
                    initializeValues(\.right, \.right, \.right)
            case .id0, .id2:
                (updatedCurrentOrigin, labelForSide, labelForDimension) =
                    initializeValues(\.left, \.left, \.left)
            default:
                fatalError("\n\n\(String(describing: type(of: self))): \(#function ) the following childId is not used here: \(childId)")
            }

            func initializeValues(
            _ labelForPosition: KeyPathForIosPosition,
            _ labelForSide: KeyPathForSide,
            _ labelForDimension: KeyPathForDimension)
                -> (PositionAsIosAxes, KeyPathForSide, KeyPathForDimension) {
                (getOrigin(labelForPosition, parameters), labelForSide, labelForDimension)
            }


            let dimension = getDimension(parameters.extractedDimension, labelForDimension, parameters.chain[parameters.index])
            let name =
                getName(parameters, childId,labelForSide)
            let dictionaryUpdate =
              DictionaryUpdate(
                name: name,
                dimension: dimension,
                origin: updatedCurrentOrigin,
                corners: createCorner(dimension, updatedCurrentOrigin))
            updateDictionary(dictionaryUpdate)
            
            return updatedCurrentOrigin
        }
          
        
        func updateOne (
        _ childId: Part,
        _ parameters: ParametersForOneOrTwo)
            -> PositionAsIosAxes {
            let currentOriginForOne =
                getOrigin(
                        \.one,
                    parameters)
            let dimension =
                getDimension(parameters.extractedDimension, \.one, parameters.chain[parameters.index])
            let name = getName(parameters, childId,\.one)
            let dictionaryUpdate =
                DictionaryUpdate(
                    name: name,
                    dimension: dimension,
                    origin: currentOriginForOne,
                    corners: createCorner(dimension, currentOriginForOne))
            updateDictionary(dictionaryUpdate)
            return  currentOriginForOne
          }
        
        func getName(
        _ parameters: ParametersForOneOrTwo,
        _ childId: Part,
        _ labelForLeftRightOrOne: KeyPath<(left: Part?, right: Part?, one: Part?), Part?>)
            -> String {
            // Extracting individual parameters for clarity
            let extractedParentId = parameters.extractedParentId
            let part = parameters.partValue.part
            let global = parameters.global
            let index = parameters.index
            let chain =  parameters.chain
            let partValue = parameters.partValue

            // Determine start parts based on conditions
            let startParts: [Part] = index == 0 || global ? [.object] : [chain[index - 1]]

            // Define end parts
            let endParts: [Part] = [.stringLink, .sitOn, partValue.sitOnId]

            // Determine parentId based on the specified KeyPath
            var parentId: Part
            if let extractedId = extractedParentId[keyPath: labelForLeftRightOrOne] {
                parentId = index == 0 || global ? .id0 : extractedId
            } else {
                guard let oneId = extractedParentId[keyPath: \.one] else {
                    fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no parent id exists for: \(chain[index])")
                }
                parentId = index == 0 || global ? .id0 : oneId
            }

            // Create the name using the specified parts
            let name = CreateNameFromParts(startParts + [parentId, .stringLink, part, childId] + endParts).name

            return name
        }

        
        func getOrigin(
        _ label: KeyPathForIosPosition, //left or right or one
        _ parameters: ParametersForOneOrTwo)
            -> PositionAsIosAxes {
                let currentOriginsForChain = parameters.currentOriginsForChain
                let newOrigins = parameters.newOrigin
                let parentPartValue = parameters.parentPartValue
                let index = parameters.index
                let chain = parameters.chain
                var updatedOrigins = ZeroValue.iosLocation
                guard let newOrigin = newOrigins[keyPath: label] else {
                    fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no origin exists for: \(chain[index])")
                }

                var allowForSideWithOneParent = //otherwise a sided child of a one parent does not use its origin
                    index != 0 ? (parentPartValue.childOrigin.one ?? ZeroValue.iosLocation) : ZeroValue.iosLocation
              
                switch label {
                    case \.left:
                        updatedOrigins = currentOriginsForChain.left + newOrigin + allowForSideWithOneParent
                    case \.right:
                        updatedOrigins = currentOriginsForChain.right + newOrigin + allowForSideWithOneParent
                    case \.one:
                        updatedOrigins = currentOriginsForChain.one + newOrigin
                default: break
                }

            return updatedOrigins
        }
        
        
        func createCorner(
            _ dimension: Dimension3d,
            _ origin: PositionAsIosAxes)
        -> [PositionAsIosAxes]{
            let corners: [PositionAsIosAxes] =  CreateIosPosition
                .getCornersFromDimension(dimension)
            let cornersFromObject =
                CreateIosPosition.addToupleToArrayOfTouples(
                    origin,
                    corners)
            let topViewCorners = [4,5,6,7].map {cornersFromObject[$0]}
            return
                topViewCorners
        }
        
        
        func getDimension (
            _ extraction: (left: Dimension3d?, right: Dimension3d?, one: Dimension3d?),
            _ label: KeyPath<(left: Dimension3d?, right: Dimension3d?, one: Dimension3d?), Dimension3d?>,
            _ part: Part)
            -> Dimension3d {
            guard let dimension = extraction[keyPath: label] else {
                fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no dimension exists for: \(part)")
            }
                return
                    dimension
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
