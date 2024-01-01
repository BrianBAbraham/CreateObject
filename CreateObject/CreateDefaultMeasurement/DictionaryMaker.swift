//
//  CornerDictionary.swift
//  DictionaryMaker
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation


struct DictionaryMaker {

    let objectType: ObjectTypes
  
    let dimensionDicIn: Part3DimensionDictionary
    var dimensionDic: Part3DimensionDictionary = [:]
    
    var angleDic: AnglesDictionary = [:]

    var angleMinMaxDic: AngleMinMaxDictionary = [:]
  
    //pre-tilt
    var preTiltObjectToPartOriginDic: PositionDictionary = [:]
    var preTiltParentToPartOriginDic: PositionDictionary = [:]
    var preTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    
    //post-tilt
    var postTiltObjectToPartOriginDic: PositionDictionary = [:]
    var postTiltObjectToFourCornerPerKeyDic: CornerDictionary = [:]
    
    let partChainIdDicIn: PartChainIdDictionary
    var partChainIdDic: PartChainIdDictionary  = [:]
    let objectsAndTheirChainLabelsDicIn: ObjectPartChainLabelsDictionary
    let objectsAndTheirChainLabels: ObjectPartChainLabelsDictionary = ObjectsAndTheirChainLabels().dictionary

    var partValuesDic: [Part: PartData] = [:]
    
    let getFromOneOrTwo = AccessOneOrTwo()

    init(
        _ objectType: ObjectTypes,
        _ dictionaries: Dictionaries) {
        self.objectType = objectType
        self.dimensionDicIn = dictionaries.dimension
        self.partChainIdDicIn = dictionaries.partChainId
        self.objectsAndTheirChainLabelsDicIn = dictionaries.objectsAndTheirChainLabelsDic
                    
//            print("OUT \(dictionaries.anglesDic["object_id0_tiltInSpaceHorizontalJoint_id0_sitOn_id0"]) ")
   
            
        partValuesDic =
            ObjectMaker(
                objectType,
                dictionaries,
                objectsAndTheirChainLabelsDicIn).partValuesDic
            
            
//MARK: - ORIGIN/DIMENSION DICTIONARY
        createPreTiltDictionaryFromStructFactory()
        createPostTiltDictionaryFromStructFactory()

//DictionaryInArrayOut().getNameValue(anglesMinMaxDic
//).forEach{print($0)}
  
//MARK: - POST-TILT
        // initially set postTilt to preTilt values
        postTiltObjectToFourCornerPerKeyDic =
            preTiltObjectToPartFourCornerPerKeyDic
   
        createPostTiltDictionaryFromStructFactory()
    } // Init ends
} //Parent struct ends


//MARK: AngleDic
extension DictionaryMaker {
    
}


//MARK: PretTiltDic
extension DictionaryMaker {

    mutating func createPreTiltDictionaryFromStructFactory(_ global: Bool = true) {
        guard let chainLabels = objectsAndTheirChainLabelsDicIn[objectType] ?? ObjectsAndTheirChainLabels().dictionary[objectType] else {
            fatalError("No values exist for the specified chainLabels.")
        }
        for chainLabel in chainLabels {
            processChainLabelForDictionaryCreation(chainLabel, global)
        }
    }

    
    mutating  func processChainLabelForDictionaryCreation(_ chainLabel: Part, _ global: Bool ) {
        let chain = LabelInPartChainOut(chainLabel).partChain

        var currentOrigins: OneOrTwoPositionsAsTuple =
             ZeroValue.oneOrTwoPositionAsTuple//reset for each chain
        for index in 0..<chain.count {
           processPartForDictionaryCreation(
            &currentOrigins,
           index,
           chain,
           global)
        }
    }
            
    
    mutating func processPartForDictionaryCreation(
        _ currentOriginTupleForChain:
            inout OneOrTwoPositionsAsTuple,
        _ index: Int,
        _ chain: [Part],
        _ global: Bool) {
        guard let partValue = partValuesDic[chain[index]],
              let parentPartValue =
                (index == 0 ? partValue: partValuesDic[chain[index - 1]])  else {
            return fatalErrorGettingPartValue() }

        if !global {//if relative reset for each part
            resetOrign()
        }
        let parametersForOneOrTwo = getParameters()

            let updatedOrigin: OneOrTwo<PositionAsIosAxes> =
            getFromOneOrTwo.usingSingleOneOrTwoAndOneValueAndTwoTransforms(
                partValue.id,
                parametersForOneOrTwo,
                { (id, parametersForOneOrTwo) in
                    self.updateOneForDictionaryCreation(id, parametersForOneOrTwo) },
                { (id, parametersForOneOrTwo) in
                    self.updateBothSidesForDictionaryCreation(id, parametersForOneOrTwo) }
            )
                    
        currentOriginTupleForChain = updatedOrigin.map1WithOneValue( currentOriginTupleForChain)


        func getParameters() -> ParametersForOneOrTwoSides {
            let childOrigin = partValue.childOrigin.values
            let extractedParentId = parentPartValue.id.values
            let extractedDimension = partValue.dimension.values
            let extractedAngles = partValue.angles.values
            let extractedMinMaxAngles = partValue.minMaxAngle.values
            return
                ParametersForOneOrTwoSides(
                    currentOriginsForChain: currentOriginTupleForChain,
                    newOrigin: childOrigin,
                    extractedParentId: extractedParentId,
                    extractedDimension: extractedDimension,
                    partValue: partValue,
                    parentPartValue: parentPartValue,
                    index: index,
                    chain: chain,
                    global: global,
                    angles: extractedAngles,
                    minMaxAngle: extractedMinMaxAngles)
        }


        func resetOrign() {
            currentOriginTupleForChain = ZeroValue.oneOrTwoPositionAsTuple
        }


        func fatalErrorGettingPartValue(){
            fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no values exist for this part: \(chain[index])")
        }


        func fatalErrorGettingParentId(_ oneOrTwo: String){
            fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) parent id does not exist for \(chain[index - 1]) for \(oneOrTwo)")
        }


        func fatalErrorGettingOrigin(_ oneOrTwo: String){
            fatalError ( "\n\n\(String(describing: type(of: self))): \(#function ) no origin exist for these chainLabels\(String(describing: chain[index])) for \(oneOrTwo)")
        }
    }
            
            
    struct ParametersForOneOrTwoSides {
        let currentOriginsForChain: (left: PositionAsIosAxes, right: PositionAsIosAxes, one: PositionAsIosAxes)
        let newOrigin: (left: PositionAsIosAxes?, right: PositionAsIosAxes?, one: PositionAsIosAxes?)
        let extractedParentId: (left: Part?, right: Part?, one: Part?)
        let extractedDimension:  (left: Dimension3d?, right: Dimension3d?, one: Dimension3d?)
        let partValue: PartData
        let parentPartValue: PartData
        let index: Int
        let chain: [Part]
        let global: Bool
        let angles:  (left: RotationAngles?, right: RotationAngles?, one: RotationAngles?)
        let minMaxAngle: (left: AngleMinMax?, right: AngleMinMax?, one: AngleMinMax?)
    }
            
    
    mutating func updateBothSidesForDictionaryCreation(
        _ childId: Part,
        _ parameters: ParametersForOneOrTwoSides)
    -> PositionAsIosAxes {
        var updatedCurrentOrigin: PositionAsIosAxes
        var labelForSide: KeyPathForSide
        var labelForDimension: KeyPathForDimension
        var labelForName: KeyPathForName
        var labelForAngles: KeyPathForAngles
        var labelForMinMaxAngle: KeyPathForMinMaxAngle

        switch childId {
        case .id1, .id3:
            (updatedCurrentOrigin, labelForSide, labelForDimension, labelForName, labelForAngles, labelForMinMaxAngle) =
            initializeValues(\.right, \.right, \.right, \.right, \.right, \.right, parameters)
        case .id0, .id2:
            (updatedCurrentOrigin, labelForSide, labelForDimension, labelForName, labelForAngles, labelForMinMaxAngle) =
            initializeValues(\.left, \.left, \.left, \.left, \.left,  \.left, parameters)
        default:
            fatalError("\n\n\(String(describing: type(of: self))): \(#function ) the following childId is not used here: \(childId)")
        }

        prepareForUpdatedDictionary()
        
        
        
        
        func prepareForUpdatedDictionary() {
            let dimension = getDimension(parameters.extractedDimension, labelForDimension, parameters.chain[parameters.index])
            let name = getName(parameters.partValue, labelForName)
            let angle =
                getRotationAngles(
                    parameters.angles,
                    labelForAngles,
                    parameters.partValue.part)
            let minMaxAngle =
                getMinMaxRotationAngles(parameters.minMaxAngle, labelForMinMaxAngle, parameters.partValue.part)
            
            let dictionaryUpdate =
                    DictionaryUpdate(
                        name: name,
                        dimension: dimension,
                        origin: updatedCurrentOrigin,
                        angle: angle,
                        minMaxAngle: minMaxAngle,
                        corners: createCorner(dimension, updatedCurrentOrigin))
            updateDictionary(dictionaryUpdate)
        }
        
        
        return updatedCurrentOrigin
    }

    private func initializeValues(
        _ labelForPosition: KeyPathForIosPosition,
        _ labelForSide: KeyPathForSide,
        _ labelForDimension: KeyPathForDimension,
        _ labelForName: KeyPathForName,
        _ labelForAngles: KeyPathForAngles,
        _ labelForMinMaxAngle: KeyPathForMinMaxAngle,
        _ parameters: ParametersForOneOrTwoSides
    ) -> (PositionAsIosAxes, KeyPathForSide, KeyPathForDimension, KeyPathForName, KeyPathForAngles, KeyPathForMinMaxAngle) {
        (
            getOrigin(labelForPosition, parameters),
            labelForSide,
            labelForDimension,
            labelForName,
            labelForAngles,
            labelForMinMaxAngle
        )
    }
             
            
      mutating  func updateOneForDictionaryCreation (
        _ childId: Part,
        _ parameters: ParametersForOneOrTwoSides)
        -> PositionAsIosAxes {
            let updatedCurrentOrigin =
                getOrigin(
                    \.one,
                    parameters)
           
            
           prepareForUpdatedDictionary()
            
            
            func  prepareForUpdatedDictionary() {
                let dimension =
                    getDimension(
                        parameters.extractedDimension,
                        \.one,
                        parameters.chain[parameters.index])
                let name = getName(parameters.partValue, \.one)
                let angle = getRotationAngles(parameters.angles, \.one, parameters.partValue.part)
                let minMaxAngle = getMinMaxRotationAngles(parameters.minMaxAngle, \.one, parameters.partValue.part)
                    
                let dictionaryUpdate =
                    DictionaryUpdate(
                        name: name,
                        dimension: dimension,
                        origin: updatedCurrentOrigin,
                        angle: angle,
                        minMaxAngle: minMaxAngle,
                        corners: createCorner(dimension, updatedCurrentOrigin))
                updateDictionary(dictionaryUpdate)
                
            }
            
            
            return  updatedCurrentOrigin
        }
    
        
         mutating func updateDictionary(_ update: DictionaryUpdate) {
            let name = update.name
            angleDic +=
             [name: update.angle]
             angleMinMaxDic +=
             [name: update.minMaxAngle]
            dimensionDic +=
              [name: update.dimension]
            preTiltObjectToPartOriginDic +=
              [name: update.origin]
            preTiltObjectToPartFourCornerPerKeyDic +=
              [name: update.corners]
        }
     
        
        struct DictionaryUpdate {
            let name: String
            let dimension: Dimension3d
            let origin: PositionAsIosAxes
            let angle: RotationAngles
            let minMaxAngle: AngleMinMax
            let corners: [PositionAsIosAxes]
        }
        
        
        func getName (
            _   partValue: PartData,
            _ key:  KeyPath<(left: String?, right: String?, one: String?),
            String?> )
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

            let allowForSideWithOneParent = //otherwise a sided child of a one parent does not use its origin
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
            return dimension
    }
    
    
    func getRotationAngles (
        _ extraction: (left: RotationAngles?, right: RotationAngles?, one: RotationAngles?),
        _ label: KeyPath<(left: RotationAngles?, right: RotationAngles?, one: RotationAngles?), RotationAngles?>,
        _ part: Part)
    -> RotationAngles {

        guard let rotationAngles = extraction[keyPath: label] else {
            fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no dimension exists for: \(part)")
        }
        return rotationAngles
    }
    
    
    func getMinMaxRotationAngles(
        _ extraction: (left: AngleMinMax?, right: AngleMinMax?, one: AngleMinMax?),
        _ label: KeyPath<(left: AngleMinMax?, right: AngleMinMax?, one: AngleMinMax?), AngleMinMax?>,
        _ part: Part)
    -> AngleMinMax {

        guard let minMaxAngle = extraction[keyPath: label] else {
            fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no dimension exists for: \(part)")
        }
        return minMaxAngle
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



//MARK: Apply Rotations
extension DictionaryMaker {
   
    mutating func createPostTiltDictionaryFromStructFactory() {
        let (rotatorParts, allPartsToBeRotatedByAllRotators) =
            gePartsInvolvedWithRotation()

        for (rotatorPart, allPartsToBeRotatedByOneRotator) in
                zip(rotatorParts, allPartsToBeRotatedByAllRotators) {
                    processRotationOfAllPartsByOneRotator(rotatorPart, allPartsToBeRotatedByOneRotator)
        }
    }

            
    mutating func processRotationOfAllPartsByOneRotator(
        _ rotatorPart: Part,
        _ allPartsToBeRotatedByRotator:[Part]){
            var dimensions: [OneOrTwo<Dimension3d>] = []
            var originNames: [OneOrTwo<String>] = []
            
            for partToBeRotated in allPartsToBeRotatedByRotator {
                guard let values = partValuesDic[partToBeRotated] else {
                    fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no values exists for: \(partToBeRotated) ") }
                
                dimensions.append(values.dimension)
                originNames.append(values.originName)
            }

            guard let angle: OneOrTwo<RotationAngles> = partValuesDic[rotatorPart]?.angles else {
                fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no values exists for: \(rotatorPart) ") }
            let rotatorData =
                Rotator(
                    rotatorOrigin:
                        getGlobalOriginOfRotatorFromDictionary(rotatorPart),
                    originOfAllPartsToBeRotated:
                        getGlobalOriginOfPartsFromDictionary(allPartsToBeRotatedByRotator),
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
            
            for (originName, allCorners) in zip (originNames,allPartCornerPositionAfterRotationByOneRotator) {
                let corners =
                    allCorners.map1WithOneTransform {getTopViewConers($0)}
                
                getFromOneOrTwo.getFromOneOrTwoEnumMap2(originName, corners) {addPartsToFourCornerDic($0, $1)}
            }
    }
            
            
    func getTopViewConers(_ allCorners: [PositionAsIosAxes]) -> [PositionAsIosAxes]{
        [4,5,2,3].map{allCorners[$0]}
    }
    
            
     mutating   func addPartsToFourCornerDic(
         _ name: String,
         _ partCornerPosition: [PositionAsIosAxes]
        ){
            postTiltObjectToFourCornerPerKeyDic += [name: partCornerPosition]
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
                getFromOneOrTwo.getForThreeValues(
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
            let corners = dimension.map1WithOneTransform { CreateIosPosition.getCornersFromDimension($0) }
            let result =
                getFromOneOrTwo.getForThreeValues(
                            originAfterRotationByRotator,
                            corners,
                            rotator.angle ) { calculateRotatedCorner($0, $1, $2) }
            
            allPartCornerPositionsAfterRotationByOneRotator.append(result)
        }
      
        return allPartCornerPositionsAfterRotationByOneRotator
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
        _ angle: RotationAngles = ZeroValue.rotationAngles)
    -> [PositionAsIosAxes]  {
        var rotatedCorners: [PositionAsIosAxes] = []
     
        guard angle.y.value == 0.0 || angle.z.value == 0.0 else {
            fatalError("\(String(describing: type(of: self))): \(#function ) only x rotation are coded \(angle.y.value)  \(angle.z.value) ")
        }

        for index in 0..<cornerPositions.count {
            let newCornerPosition =
            PositionOfPointAfterRotationAboutPoint(
                staticPoint:ZeroValue.iosLocation,
                movingPoint: cornerPositions[index],
                angleChange: angle.x
            ).fromObjectOriginToPointWhichHasMoved
            rotatedCorners.append(
             newCornerPosition + rotatedOriginOfPart)
        }
        return rotatedCorners
    }
    
    
    func gePartsInvolvedWithRotation ()
        -> ([Part], [[Part]]) {
        guard let chainLabels = objectsAndTheirChainLabels[objectType] else {
            fatalError("no chain labels defined for object \(objectType)") }
        var rotatingParts: [Part] = []
        var allPartsToBeRotatedByOneRotatorPart: [[Part]] = []
        for chainLabel in chainLabels {
            guard let  values = partValuesDic[chainLabel] else {
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
    
    
    func getGlobalOriginOfRotatorFromDictionary(//from dictionary as property is origin from parent
        _ part: Part)
    -> OneOrTwo<PositionAsIosAxes> {
        guard let values = partValuesDic[part] else {
            fatalError("No values defined for part \(part)")
        }
        let name = values.originName
        let origin: OneOrTwo<PositionAsIosAxes> = name.map1WithOneTransform { getOrigin($0) }
        return origin
    }

    
    func getOrigin(_ name: String) -> PositionAsIosAxes {
        guard let origin = preTiltObjectToPartOriginDic[name] else {
            fatalError("\(String(describing: type(of: self))): \(#function ) \(name) is not in origin dictionary")
        }
        return origin
    }
    
    
    func getGlobalOriginOfPartsFromDictionary(//default is local these are global
        _ partsToBeRotated: [Part])
    -> [OneOrTwo<PositionAsIosAxes>] {
        var scopeOrigin: [OneOrTwo<PositionAsIosAxes>] = []
        for item in partsToBeRotated {
            scopeOrigin.append(getGlobalOriginOfRotatorFromDictionary(item))
        }
        return scopeOrigin
    }
}
