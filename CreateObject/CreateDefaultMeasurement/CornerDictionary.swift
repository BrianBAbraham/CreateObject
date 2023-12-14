//
//  CornerDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation
//MARK: ANGLE
//struct OccupantBodySupportDefaultAngleMinMax {
//    let dictionary: BaseObjectAngelMinMaxDictionary =
//    [.allCasterTiltInSpaceShowerChair: (min: Measurement(value: 0.0, unit: UnitAngle.degrees), max: Measurement(value: 45.0, unit: UnitAngle.degrees) ) ]
//    
//    static let general = (min: Measurement(value: 0.0, unit: UnitAngle.degrees), max: Measurement(value: 30.0, unit: UnitAngle.degrees) )
//    
//    let value: AngleMinMax
//    
//    init(
//        _ baseType: ObjectTypes) {
//            value =
//                dictionary[baseType] ??
//                Self.general
//    }
//}


//struct OccupantBackSupportDefaultAngleChange {
//    var dictionary: BaseObjectAngleDictionary =
//    [:]
//    
//    static let general = Measurement(value: 0.0 , unit: UnitAngle.radians)
//    
//    let value: Measurement<UnitAngle>
//    
//    init(
//        _ baseType: ObjectTypes) {
//            value =
//                dictionary[baseType] ??
//                Self.general
//    }
//}
//MARK: FOOT ANGLE
//struct OccupantFootSupportDefaultAngleChange {
//    var dictionary: BaseObjectAngleDictionary =
//    [:]
//
//    static let general = Measurement(value: 0.0, unit: UnitAngle.radians)
//
//    let value: Measurement<UnitAngle>
//
//    init(
//        _ baseType: ObjectTypes) {
//            value =
//                dictionary[baseType] ??
//                Self.general
//    }
//}


//struct OccupantBodySupportDefaultAngleChange {
//    let dictionary: BaseObjectAngleDictionary =
//    [.allCasterTiltInSpaceShowerChair: OccupantBodySupportDefaultAngleMinMax(.allCasterTiltInSpaceShowerChair).value.max]//Measurement(value: 90.0, unit: UnitAngle.degrees)]
//
//    static let general = Measurement(value: 0.0, unit: UnitAngle.degrees)
//
//    let value: Measurement<UnitAngle>
//
//    init(
//        _ baseType: ObjectTypes) {
//            value =
//                dictionary[baseType] ??
//                Self.general
//    }
//}
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
            
//DictionaryInArrayOut().getNameValue(preTiltParentToPartOriginDic).forEach{print($0)}
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
    
            
        
        
//                    var partsToRotate: [Part] = []
//                    var angleToRotate: Measurement<UnitAngle> = ZeroValue.angle
//                    var originOfRotate = ZeroValue.iosLocation
//                    if chainLabel == .sitOnTiltJoint {
//                        if let allValues = oneOrTwoObjectPartDic[.sitOnTiltJoint] {
//                            let partChainToRotate =
//                            allValues.scopesOfRotation[0]
//                            if partChainToRotate != [] {
//                                angleToRotate =
//                                OneOrTwoExtraction(allValues.angles).values.one?.x
//                                ?? ZeroValue.angle
//                                partsToRotate = LabelInPartChainOut(partChainToRotate).partChains.flatMap{$0}
//                                print("ROTATION REQUIRED for chains: \(partsToRotate) \(angleToRotate) \n")
//                            }
//                        }
//                    }
            
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
                processChainLabelNew(chainLabel, global)
            }
        }
        
        
        func processChainLabelNew(_ chainLabel: Part, _ global: Bool ) {
            let chain = LabelInPartChainOut(chainLabel).partChain
                        var currentOriginForOne = ZeroValue.iosLocation
                        var currentOriginForLeft = ZeroValue.iosLocation
                        var currentOriginForRight = ZeroValue.iosLocation
            for index in 0..<chain.count {
               processPart(
                &currentOriginForOne,
                &currentOriginForLeft,
                &currentOriginForRight,
               index,
               chain,
               global)
            }
        }
        

        func processPart(
        _ currentOriginForOne: inout PositionAsIosAxes,
        _ currentOriginForLeft: inout PositionAsIosAxes,
        _ currentOriginForRight: inout PositionAsIosAxes,
        _ index: Int,
        _ chain: [Part],
        _ global: Bool) {
            guard let partValue = oneOrTwoObjectPartDic[chain[index]],
                let parentPartValue = (index == 0 ? partValue: oneOrTwoObjectPartDic[chain[index - 1]])  else {
                    return fatalErrorGettingPartValue() }

            if !global {//if relative reset for each part
                resetOrign()
            }

            let extractedOrigin = OneOrTwoExtraction(partValue.childOrigin).values
            let extractedParentId = OneOrTwoExtraction(parentPartValue.id).values
            let extractedDimension = OneOrTwoExtraction(partValue.dimension).values

           let parametersForOneOrTwo =
                ParametersForOneOrTwo(
                    currentOriginForOne: currentOriginForOne,
                    currentOriginForLeft: currentOriginForLeft,
                    currentOriginForRight: currentOriginForRight,
                    extractedOrigin: extractedOrigin,
                    extractedParentId: extractedParentId,
                    extractedDimension: extractedDimension,
                    partValue: partValue,
                    parentPartValue: parentPartValue,
                    index: index,
                    chain: chain,
                    global: global)
            
            switch partValue.id {
                case .one (let one):
                    currentOriginForOne = updateOne(one, parametersForOneOrTwo)
                case .two (let left, let right):
                    currentOriginForLeft = updateTwo(left, parametersForOneOrTwo)
                    currentOriginForRight = updateTwo(right, parametersForOneOrTwo)
            }
              
            
          func resetOrign() {
            currentOriginForOne = ZeroValue.iosLocation
            currentOriginForLeft = ZeroValue.iosLocation
            currentOriginForRight = ZeroValue.iosLocation
          }
            
          func fatalErrorGettingPartValue(){
              fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no values exist for this part: \(chain[index])")}
          
          
          func fatalErrorGettingParentId(_ oneOrTwo: String){
              fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) parent id does not exist for \(chain[index - 1]) for \(oneOrTwo)") }
          
          func fatalErrorGettingOrigin(_ oneOrTwo: String){
              print ( "\n\n\(String(describing: type(of: self))): \(#function ) no origin exist for these chainLabels\(String(describing: chain[index])) for \(oneOrTwo)") }
        }
        
        
        struct ParametersForOneOrTwo {
            let currentOriginForOne: PositionAsIosAxes
            let currentOriginForLeft: PositionAsIosAxes
            let currentOriginForRight: PositionAsIosAxes
            let extractedOrigin: (left: PositionAsIosAxes?, right: PositionAsIosAxes?, one: PositionAsIosAxes?)
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
        _ update: ParametersForOneOrTwo)
            -> PositionAsIosAxes {
            var labelForPosition: KeyPathForIosPosition = \.right
            var labelForSide: KeyPathForSide  = \.right
            var labelForDimension: KeyPathForDimension = \.right

            var updatedOriginForSide = ZeroValue.iosLocation
            
            //var newOrigin = ZeroValue.iosLocation
            
            if childId == .id0 || childId == .id2 {
              labelForPosition = \.left
              labelForSide = \.left
             
              labelForDimension = \.left
              let currentOriginForLeft =
                  getOrigin(
                    update.currentOriginForLeft,
                    update.currentOriginForOne,
                    update.extractedOrigin,
                    labelForPosition,
                    update.parentPartValue,
                    update.index,
                    update.chain)
              updatedOriginForSide = currentOriginForLeft
            } else {
              let currentOriginForRight =
                  getOrigin(
                    update.currentOriginForRight,
                    update.currentOriginForOne,
                    update.extractedOrigin,
                    labelForPosition,
                    update.parentPartValue,
                    update.index,
                    update.chain)
              updatedOriginForSide = currentOriginForRight
            }
              
            let dimension = getDimensionX(update.extractedDimension, labelForDimension, update.chain[update.index])
            
            let dictionaryUpdate =
              DictionaryUpdate(
                name: getName3(
                    childId,
                    update.chain[update.index],//partValue.part,
                    update.extractedParentId,
                    labelForSide,
                    update.global,
                    update.index,
                    update.chain,
                    update.partValue//,
                    //update.parentPartValue
                ),
                dimension: dimension,
                origin: updatedOriginForSide,
                corners: createCorner(dimension, updatedOriginForSide))
            
            updateDictionary(dictionaryUpdate)
            
            return updatedOriginForSide

        }
          
        
        func updateOne (
        _ childId: Part,
        _ update: ParametersForOneOrTwo)
            -> PositionAsIosAxes {
           let currentOriginForOne =
            getOrigin(
                ZeroValue.iosLocation,
                update.currentOriginForOne,
                update.extractedOrigin,
                \.one,
                update.parentPartValue,
                update.index,
                update.chain)
            let dimension = getDimensionX(update.extractedDimension, \.one, update.chain[update.index])
            let dictionaryUpdate =
                    DictionaryUpdate(
                        name: getName3(
                            childId,
                            update.partValue.part,
                            update.extractedParentId,
                            \.one,
                            update.global,
                            update.index,
                            update.chain,
                            update.partValue//,
                            //update.parentPartValue
                        
                        ),
                        dimension: dimension,
                        origin:
                            currentOriginForOne,
                        corners: createCorner(dimension, currentOriginForOne))
                
                updateDictionary(dictionaryUpdate)
                
                return currentOriginForOne

 
          }
          
        
        struct DictionaryUpdate {
            let name: String
            let dimension: Dimension3d
            let origin: PositionAsIosAxes
            let corners: [PositionAsIosAxes]
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
        
        
    func getOrigin(
    _ currentOrigin: PositionAsIosAxes,
    _ currentOriginForOne: PositionAsIosAxes,
    _ extraction: (left: PositionAsIosAxes?, right: PositionAsIosAxes?, one: PositionAsIosAxes?),
    _ label: KeyPathForIosPosition,
    _ parentPartValue: OneOrTwoGenericPartValue,
    _ index: Int,
    _ chain: [Part])
        -> PositionAsIosAxes {
        var currentOriginAllowingThatParentIsOne = ZeroValue.iosLocation
        if index != 0 {
            switch parentPartValue.id {
                case .one:
                    currentOriginAllowingThatParentIsOne = currentOriginForOne
                case .two:
                    currentOriginAllowingThatParentIsOne = currentOrigin
            }
        }
        guard let origin = extraction[keyPath: label] else {
            fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no origin exists for: \(chain[index])")
        }
        return
            currentOriginAllowingThatParentIsOne + origin
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
        
        
        
        
        func getGlobalName(
            _ childId: Part,
            _ part: Part,
            _ extractedParentId: (left: Part?, right: Part?, one: Part?),
            _ label: KeyPath<(left: Part?, right: Part?, one: Part?), Part?>,
            _ global: Bool,
            _ index: Int,
            _ chain: [Part],
            _ partValue: OneOrTwoGenericPartValue)
            -> String {
                
                let startParts: [Part] = index == 0 || global ? [.object]: [chain[index - 1]]
                
                let endParts = [
                    .stringLink,.sitOn, partValue.sitOnId]
                
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
                
                func getName2(
                    _ ids: (parent: Part, child: Part),
                    _ part: Part) -> String {
                        
                        CreateNameFromParts(startParts + [ids.parent, .stringLink, part, ids.child] + endParts).name
                }
                
        }
        
        
        
    
    func getName3X(
        _ childId: Part,
        _ part: Part,
        _ extractedParentId: (left: Part?, right: Part?, one: Part?),
        _ labelForSide: KeyPath<(left: Part?, right: Part?, one: Part?), Part?>,
        _ global: Bool,
        _ index: Int,
        _ chain: [Part],
        _ partValue: OneOrTwoGenericPartValue)
        -> String {
            
            let startParts: [Part] = index == 0 || global ? [.object]: [chain[index - 1]]
            
            let endParts = [
                .stringLink,.sitOn, partValue.sitOnId]
            
            if var parentId = extractedParentId[keyPath: labelForSide] {
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
            
            func getName2(
                _ ids: (parent: Part, child: Part),
                _ part: Part) -> String {
                    
                    CreateNameFromParts(startParts + [ids.parent, .stringLink, part, ids.child] + endParts).name
            }
            
    }
        
        
        func getName3(
            _ childId: Part,
            _ part: Part,
            _ extractedParentId: (left: Part?, right: Part?, one: Part?),
            _ labelForLeftRightOrOne: KeyPath<(left: Part?, right: Part?, one: Part?), Part?>,
            _ global: Bool,
            _ index: Int,
            _ chain: [Part],
            _ partValue: OneOrTwoGenericPartValue)
            -> String {
                
                let startParts: [Part] = index == 0 || global ? [.object]: [chain[index - 1]]
                
                let endParts = [
                    .stringLink,.sitOn, partValue.sitOnId]
                
                if var parentId = extractedParentId[keyPath: labelForLeftRightOrOne] {
                    if index == 0 || global {
                        parentId = .id0
                    }
                    return
                        getName2((parent: parentId, child: childId), partValue.part)
                    
                } else {
                    guard var parentId = extractedParentId[keyPath: \.one] else {
                        fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no parent id exists for: \(chain[index])")
                    }
                  
                        if index == 0 || global {
                             parentId = .id0
                        }
                        return
                            getName2((parent: parentId, child: childId), partValue.part)
        
                }
                
                func getName2(
                    _ ids: (parent: Part, child: Part),
                    _ part: Part) -> String {
                        
                        CreateNameFromParts(startParts + [ids.parent, .stringLink, part, ids.child] + endParts).name
                }
                
        }

        func getName3Z (
            _ childId: Part,
            _ part: Part,
            _ extractedParentId: (left: Part?, right: Part?, one: Part?),
            _ labelForLeftRightOrOne: KeyPath<(left: Part?, right: Part?, one: Part?), Part?>,
            _ global: Bool,
        
        _ index: Int,
        _ chain: [Part],
        _ partValue: OneOrTwoGenericPartValue,
        _ parentPartValue: OneOrTwoGenericPartValue
        )
            -> String {
            let startParts: [Part] = index == 0  ? [.object]: [chain[index - 1]]
            let endParts = [
                .stringLink,.sitOn, partValue.sitOnId]
                              
            var parentId = index == 0 ? .id0: getId(parentPartValue)
            let childId = getId(partValue)
                
                
                
                switch labelForLeftRightOrOne {
                case \.left:
                    if let leftPart = extractedParentId.left {
                        // Code for left parameter
                    } else {
                        // Code when left parameter is nil
                    }
                case \.right:
                    if let rightPart = extractedParentId.right {
                        // Code for right parameter
                    } else {
                        // Code when right parameter is nil
                    }
                case \.one:
                    if let onePart = extractedParentId.one {
                        // Code for one parameter
                    } else {
                        // Code when one parameter is nil
                    }
                default: break
                }
            
            return
                getName2((parent: parentId, child: childId), partValue.part)
            
            
            func getId(_ value: OneOrTwoGenericPartValue) -> Part {
                switch parentPartValue.id {
                    case .one (let one):
                        return one
                    case .two(let left, let right):
                        return right //right and left parent have same id
                }
            }
            
            func getName2(
                _ ids: (parent: Part, child: Part),
                _ part: Part) -> String {
                    
                    CreateNameFromParts(startParts + [ids.parent, .stringLink, part, ids.child] + endParts).name
            }
        }


        
        
    func getDimensionX (
        _ extraction: (left: Dimension3d?, right: Dimension3d?, one: Dimension3d?),
        _ label: KeyPath<(left: Dimension3d?, right: Dimension3d?, one: Dimension3d?), Dimension3d?>,
        _ part: Part) -> Dimension3d {
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
