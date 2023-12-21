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
        createPreTiltDictionaryFromStructFactory()
        createPostTiltDictionaryFromStructFactory()
     
        
        
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
            
        //createPostTiltDictionaryFromStructFactory()
        
        
        postTiltObjectToFourCornerPerKeyDic =
            Replace(
                initial:
                    preTiltObjectToPartFourCornerPerKeyDic,
                replacement:
                    getRotatedObjectToPartFourCornerPerKeyDic(            getRotatingPartDataTupleFromStruct(
                    partsToRotate))
            ).intialWithReplacements

            

          
///by definition the preceeding part in a partChain is the parent of the subsequent  part
///the subsequent part global origin is therefore dependent on the preceeing part origin
///therefore. if the global origin of the subsequent part is to be maintained independently of the
///preceeding part, such as a sideSupport maintaining its relative position to the sitOn  irrespective
///of jointOrigin between sideSupport and sitOn the partChain ought to be processed as a whole
            
//MARK: createPreTiltDic
        func createPreTiltDictionaryFromStructFactory(_ global: Bool = true) {
            guard let chainLabels = objectsAndTheirChainLabelsDicIn[objectType] ?? ObjectsAndTheirChainLabels().dictionary[objectType] else {
                fatalError("No values exist for the specified chainLabels.")
            }
            for chainLabel in chainLabels {
                processChainLabelForDictionaryCreation(chainLabel, global)
            }
        }
        

       
//MARK: createPostTiltDic
        func createPostTiltDictionaryFromStructFactory() {
            var (rotatorParts, allPartsToBeRotatedByAllRotators) =
                gePartsInvolvedWithRotation()
       
            for (rotatorPart, allPartsToBeRotatedByOneRotator) in
                    zip(rotatorParts, allPartsToBeRotatedByAllRotators) {
                processRotationOfAllPartsByOneRotator(rotatorPart, allPartsToBeRotatedByOneRotator)
            }
            
            
            let oneOfEachPartInAllPartChain: Set<Part> = Set(getOneOfEachPartInAllPartChain())
            let remove: Set<Part> = Set(allPartsToBeRotatedByAllRotators.flatMap { $0 })
            print( oneOfEachPartInAllPartChain.subtracting(remove))
           
        }
        
        func processRotationOfAllPartsByOneRotator(
            _ rotatorPart: Part,
            _ allPartsToBeRotatedByRotator:[Part]){
                var dimensions: [OneOrTwo<Dimension3d>] = []
                var originNames: [OneOrTwo<String>] = []
                
                for partToBeRotated in allPartsToBeRotatedByRotator {
                    guard let values = oneOrTwoObjectPartDic[partToBeRotated] else {
                        fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no values exists for: \(partToBeRotated) ") }
                    
                    dimensions.append(values.dimension)
                    originNames.append(values.originName)
                }
                
                guard let angle: OneOrTwo<RotationAngles> = oneOrTwoObjectPartDic[rotatorPart]?.angles else {
                    fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no values exists for: \(rotatorPart) ") }
                
                let rotatorData =
                    Rotator(
                        rotatorOrigin:
                            getGlobalOriginOfRotatorFromDictionary(rotatorPart),
                        originOfAllPartsToBeRotated:
                            getOriginOfPartsToBeRotatedFromDictionary(allPartsToBeRotatedByRotator),
                        partsToBeRotatedDimension:
                            dimensions,
                        angle:
                            angle )
                
                let allOriginsAfterRotationdByRotator =
                   getAllOriginsAfterRotationdByOneRotator(rotatorData)
                
                let allPartCornerPositionAfterRotationByOneRotator: [OneOrTwo<[PositionAsIosAxes]>]  =
                getAllPartCornerPositionAfterRotationByOneRotator(
                    allOriginsAfterRotationdByRotator,
                    rotatorData)
                
                let topViewPartCornerPositionAfterRotationByOneRotator =
                    [4,5,2,3].map{allPartCornerPositionAfterRotationByOneRotator[$0]}
                
                for (originName, corners) in zip (originNames,topViewPartCornerPositionAfterRotationByOneRotator) {
                    getFromOneOrTwoEnumMap2(originName, corners) {addRotatedPartsToFourCornerDic($0, $1)}
                }
                
                
        }
        
        func addNonRotatingPartsToFourCornerDic(){
            
        }
        
        
        func addRotatedPartsToFourCornerDic(
        _ name: String,
         _ partCornerPositionAfterRotationByOneRotator: [PositionAsIosAxes]
        ){
            postTiltObjectToFourCornerPerKeyDic += [name: partCornerPositionAfterRotationByOneRotator]
           
        }


        
        struct Rotator {
            let rotatorOrigin: OneOrTwo<PositionAsIosAxes>
            let originOfAllPartsToBeRotated: [OneOrTwo<PositionAsIosAxes>]
            let partsToBeRotatedDimension: [OneOrTwo<Dimension3d>]
            let angle: OneOrTwo<RotationAngles>
        }
       
        
        func getAllOriginsAfterRotationdByOneRotator(
            _ rotator: Rotator)
        -> [OneOrTwo<PositionAsIosAxes>] {
            var allOriginAfterRotationByRotator: [OneOrTwo<PositionAsIosAxes>] = []
            for partOrigin in
                    rotator.originOfAllPartsToBeRotated {
                
                allOriginAfterRotationByRotator.append(
                    getFromOneOrTwoEnumMap3(
                        rotator.rotatorOrigin,
                        partOrigin,
                        rotator.angle ) { calculateRotatedOrigin($0, $1, $2) } )
            }
            return allOriginAfterRotationByRotator
        }

        
        func getAllPartCornerPositionAfterRotationByOneRotator (
            _ allOriginAfterRotationByRotator: [OneOrTwo<PositionAsIosAxes>],
            _ rotator: Rotator)
        -> [OneOrTwo<[PositionAsIosAxes]> ]{
            var allPartCornerPositionsAfterRotationByOneRotator: [OneOrTwo<[PositionAsIosAxes]>] = []
            
            for (dimension, originAfterRotationByRotator) in
                    zip(rotator.partsToBeRotatedDimension, allOriginAfterRotationByRotator) {
                let corners = dimension.map1 { CreateIosPosition.getCornersFromDimension($0) }
                let result =
                        getFromOneOrTwoEnumMap3(
                            originAfterRotationByRotator,
                            corners,
                            rotator.angle ) { calculateRotatedCorner($0, $1, $2) }
                allPartCornerPositionsAfterRotationByOneRotator.append(result)
            }
            return allPartCornerPositionsAfterRotationByOneRotator
        }
        
    
        func getFromOneOrTwoEnumMap2<T, U, V>(
            _ first: OneOrTwo<T>,
            _ second: OneOrTwo<U>,
            _ transform: (T, U) -> V)
        -> OneOrTwo<V> {
            first.map2(second, transform)
        }
        
        
        func getFromOneOrTwoEnumMap3<T, U, W, V>(//enum would not work without this
            _ first: OneOrTwo<T>,
            _ second: OneOrTwo<U>,
            _ third: OneOrTwo<W>,
            _ transform: (T, U, W) -> V)
        -> OneOrTwo<V> {
            first.map3(second, third, transform)
        }
        
        
        func calculateRotatedOrigin(
            _ rotatorOrigin: PositionAsIosAxes,
            _ partOrigin: PositionAsIosAxes,
            _ angle: RotationAngles)
        -> PositionAsIosAxes {
            let positionRelativeToRotator =
                CreateIosPosition.subtractSecondFromFirstTouple(partOrigin, rotatorOrigin)
            let rotatedPosition =
                PositionOfPointAfterRotationAboutPoint(
                    staticPoint:ZeroValue.iosLocation,
                    movingPoint: positionRelativeToRotator,
                    angleChange: angle.x
                ).fromObjectOriginToPointWhichHasMoved + rotatorOrigin
            return   rotatedPosition
        }
        
        
        func calculateRotatedCorner(
            _ rotatedOriginOfPart: PositionAsIosAxes,
            _ cornerPositions: [PositionAsIosAxes],
            _ angle: RotationAngles)
        -> [PositionAsIosAxes]  {
            
            var rotatedCorners: [PositionAsIosAxes] = []
            for corner in cornerPositions {
                rotatedCorners.append(
                PositionOfPointAfterRotationAboutPoint(
                    staticPoint:ZeroValue.iosLocation,
                    movingPoint: corner,
                    angleChange: angle.x
                ).fromObjectOriginToPointWhichHasMoved + rotatedOriginOfPart)
            }
            return rotatedCorners
        }
        

        
        
        func getOneOfEachPartFromSomePartChainLabel(
            _ chainLabels: [Part])
        -> [Part]{
            var oneOfEachPartInAllChainLabel: [Part] = []
                var allPartInThisObject: [Part] = []
                let onlyOne = 0
                for label in chainLabels {
                    allPartInThisObject +=
                    LabelInPartChainOut([label]).partChains[onlyOne]
                }
               oneOfEachPartInAllChainLabel =
                Array(Set(allPartInThisObject))
            return oneOfEachPartInAllChainLabel
        }
        
        
        func getOriginOfPartsToBeRotatedFromDictionary(//changes may have been made by UI to default
            _ partsToBeRotated: [Part])
        -> [OneOrTwo<PositionAsIosAxes>] {
            var scopeOrigin: [OneOrTwo<PositionAsIosAxes>] = []
            for item in partsToBeRotated {
                scopeOrigin.append(getGlobalOriginOfRotatorFromDictionary(item))
            }
            return scopeOrigin
        }
        
        
        func getGlobalOriginOfRotatorFromDictionary(//from dictionary as property is origin from parent
            _ part: Part)
        -> OneOrTwo<PositionAsIosAxes> {
            guard let values = oneOrTwoObjectPartDic[part] else {
                fatalError("No values defined for part \(part)")
            }
            let name = values.originName
            let origin: OneOrTwo<PositionAsIosAxes> = name.map1 { getOrigin($0) }
            return origin
        }

    
        func getOrigin(_ name: String) -> PositionAsIosAxes {
            guard let origin = preTiltObjectToPartOriginDicNew[name] else {
                fatalError("\(String(describing: type(of: self))): \(#function ) \(name) is not in origin dictionary")
            }
            return origin
        }
        
        func gePartsInvolvedWithRotation ()
            -> ([Part], [[Part]]) {
            guard let chainLabels = objectsAndTheirChainLabels[objectType] else {
                fatalError("no chain labels defined for object \(objectType)") }
            var rotatingParts: [Part] = []
            var allPartsToBeRotatedByOneRotatorPart: [[Part]] = []
            for chainLabel in chainLabels {
                guard let  values = oneOrTwoObjectPartDic[chainLabel] else {
                   fatalError("no values defined for chain labels \(chainLabel)")
                }
                let currentScopeOrderedAsByUI = 0 // UI edits parts rotated by same rotator
                if values.scopesOfRotation != [] {//there may be no rotators
                    rotatingParts.append(chainLabel)
                    allPartsToBeRotatedByOneRotatorPart.append( getOneOfEachPartFromSomePartChainLabel(
                        values.scopesOfRotation[currentScopeOrderedAsByUI]) //unique parts returned
                    )
                }
            }
                return (rotatingParts, allPartsToBeRotatedByOneRotatorPart)
        }
        

        
        
        func processPartForRotationForDictionary(
            _ part: Part){
                guard let partValue = oneOrTwoObjectPartDic[part] else {
                    fatalError("\n\n\(String(describing: type(of: self))): \(#function ) partValue exist for this part: \(part)")
                }
                
                switch partValue.originName {
                case .one (let one):
                    if let name = partValue.originName.one {
                        if let origin = preTiltObjectToPartOriginDicNew[name] {
                            //print(origin)
                        }
                      
                    }
                  
                case .two(let left, let right):
                    break
                    
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
                   // print("Found: \(key) - \(rotationOrigin)")
                }
            }
            return rotationOrigin
        }
        
        
        
        
        
//MARK: PretTiltDic
        func processChainLabelForDictionaryCreation(_ chainLabel: Part, _ global: Bool ) {
            let chain = LabelInPartChainOut(chainLabel).partChain
            let z = ZeroValue.iosLocation
            var currentOrigins = (left: z, right: z, one: z)
            for index in 0..<chain.count {
               processPartForDictionaryCreation(
                &currentOrigins,
               index,
               chain,
               global)
            }
        }
        

        func processPartForDictionaryCreation(
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
            let extractedOriginName = partValue.originName.values
           
            let parametersForOneOrTwo = getParameters()
         
            switch partValue.id {
                case .one (let one):
                    currentOriginsForChain =
                        (left: currentOriginsForChain.left,
                         right: currentOriginsForChain.right,
                         one:  updateOneForDictionaryCreation(one, parametersForOneOrTwo))
                case .two (let left, let right):
                    currentOriginsForChain =
                        (left: currentOriginsForChain.left,
                         right: updateBothSidesForDictionaryCreation(right, parametersForOneOrTwo),
                         one: currentOriginsForChain.one)
            
                    currentOriginsForChain =
                        (left: updateBothSidesForDictionaryCreation(left, parametersForOneOrTwo),
                         right: currentOriginsForChain.right,
                         one: currentOriginsForChain.one)
            }
            
            
            func getParameters() -> ParametersForOneOrTwoSides {
                ParametersForOneOrTwoSides(
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
        
        
        struct ParametersForOneOrTwoSides {
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
        
        
        func updateBothSidesForDictionaryCreation (
        _ childId: Part,
        _ parameters: ParametersForOneOrTwoSides)
            -> PositionAsIosAxes {
            var updatedCurrentOrigin: PositionAsIosAxes
            var labelForSide: KeyPathForSide
            var labelForDimension: KeyPathForDimension
                var labelForName: KeyPathForName

            switch childId {
            case .id1, .id3:
                (updatedCurrentOrigin, labelForSide, labelForDimension, labelForName) =
                initializeValues(\.right, \.right, \.right, \.right)
            case .id0, .id2:
                (updatedCurrentOrigin, labelForSide, labelForDimension, labelForName) =
                initializeValues(\.left, \.left, \.left, \.left)
            default:
                fatalError("\n\n\(String(describing: type(of: self))): \(#function ) the following childId is not used here: \(childId)")
            }

            func initializeValues(
            _ labelForPosition: KeyPathForIosPosition,
            _ labelForSide: KeyPathForSide,
            _ labelForDimension: KeyPathForDimension,
            _ labelForName: KeyPathForName)
                -> (PositionAsIosAxes, KeyPathForSide, KeyPathForDimension, KeyPathForName) {
                (getOrigin(labelForPosition, parameters), labelForSide, labelForDimension,labelForName)
            }

            let dimension =
                getDimension(
                    parameters.extractedDimension,
                    labelForDimension,
                    parameters.chain[parameters.index])
            let name = getNameNew(parameters.partValue, labelForName)
                
            let dictionaryUpdate =
              DictionaryUpdate(
                name: name,
                dimension: dimension,
                origin: updatedCurrentOrigin,
                corners: createCorner(dimension, updatedCurrentOrigin))
            updateDictionary(dictionaryUpdate)
            
            return updatedCurrentOrigin
        }
          
        
        func updateOneForDictionaryCreation (
        _ childId: Part,
        _ parameters: ParametersForOneOrTwoSides)
            -> PositionAsIosAxes {
            let currentOriginForOne =
                getOrigin(
                        \.one,
                    parameters)
            let dimension =
                getDimension(parameters.extractedDimension, \.one, parameters.chain[parameters.index])
            //let name = getName(parameters, childId,\.one)
            let name = getNameNew(parameters.partValue, \.one)
       
                            
                
            let dictionaryUpdate =
                DictionaryUpdate(
                    name: name,
                    dimension: dimension,
                    origin: currentOriginForOne,
                    corners: createCorner(dimension, currentOriginForOne))
            updateDictionary(dictionaryUpdate)
            return  currentOriginForOne
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
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        func getNameNew (
        _   partValue: OneOrTwoGenericPartValue,
        _ key:  KeyPath<(left: String?, right: String?, one: String?
        ), String?> )
            -> String {
            guard let name = partValue.originName.values[keyPath: key] else {
                fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no origin name exists for: \(partValue.part)")
            }
            return name
        }

        


        
        func getOrigin(
        _ label: KeyPathForIosPosition, //left or right or one
        _ parameters: ParametersForOneOrTwoSides)
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
            
            
//        func createCornerDictionary(
//            _ dictionary: PositionDictionary,
//            _ dimension: Part3DimensionDictionary)
//            -> CornerDictionary{
//            let removeObjectName = RemoveObjectName() // key starts object_id0, remove
//            var cornerDictionary: CornerDictionary = [:]//pre and post tilt
//            var corners: [PositionAsIosAxes] = []
//            for (key, value) in dimension {
//                let originValue = dictionary[key]
//                if let originValue {
//                    corners =
//                        CreateIosPosition
//                        .getCornersFromDimension( value)
//                    let cornersFromObject =
//                        CreateIosPosition.addToupleToArrayOfTouples(
//                            originValue,
//                            corners)
//                    let topViewCorners = [4,5,6,7].map {cornersFromObject[$0]}
//                    //
//                    let sideViewCorners = CreateIosPosition.swapXY([4,7,3,0].map {cornersFromObject[$0]})
//
//                    // for compatability with prevous code
//                    //object_id0_ is removed from the start
//                    //of the name
//                    let nameWithoutObject = removeObjectName.remove(key)
//                    print(nameWithoutObject)
//                    cornerDictionary += [nameWithoutObject: topViewCorners]
//                }
//            }
//            return cornerDictionary
//        }
            
            

            
            
            
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
//print(partName)
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
