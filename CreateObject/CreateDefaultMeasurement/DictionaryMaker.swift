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
    }
}



//MARK: PretTiltDic
extension DictionaryMaker {

    mutating func createPreTiltDictionaryFromStructFactory() {
        guard let chainLabels = objectsAndTheirChainLabelsDicIn[objectType] ?? ObjectsAndTheirChainLabels().dictionary[objectType] else {
            fatalError("No values exist for the specified chainLabels.")
        }
        for chainLabel in chainLabels {
            processChainLabelForDictionaryCreation(chainLabel)
        }
    }

    
    mutating  func processChainLabelForDictionaryCreation(_ chainLabel: Part) {
        let chain = LabelInPartChainOut(chainLabel).partChain
        for part in chain {
           processPartForDictionaryCreation(
           part)
        }
    }
            
    
    mutating func processPartForDictionaryCreation(
        _ part: Part) {
        guard let partValue = partValuesDic[part]
            else {
            return fatalErrorGettingPartValue() }
            
        let globalOrigin = partValue.globalOrigin
 
            
        partValue.dimension.mapFiveOneOrTwoAndToOneFuncWithVoidReturn  (
            partValue.originName,
            partValue.angles,
            partValue.minMaxAngle,
            globalOrigin,
            { (dimension,
               originName,
               angles,
               minMaxAngle,
               globalOrigin)
                in self.updateDictionaries(//the whole point
                    dimension,
                    originName,
                    angles,
                    minMaxAngle,
                    globalOrigin) }
        )
            
        func fatalErrorGettingPartValue(){
            fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no values exist for this part: \(part)")
        }
    }
            
    
    mutating func updateDictionaries(
        _ dimension: Dimension3d,
        _ name: String,
        _ angle: RotationAngles,
        _ minMaxAngle: AngleMinMax,
        _ globalOrigin: PositionAsIosAxes) {
        
        let dictionaryUpdate =
            DictionaryUpdate(
                name: name,
                dimension: dimension,
                origin: globalOrigin,
                angle: angle,
                minMaxAngle: minMaxAngle,
                corners: createCorner(dimension, globalOrigin))
            
        process(dictionaryUpdate)
            
            
        func process(_ update: DictionaryUpdate) {
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
        var globalOrigins: [OneOrTwo<PositionAsIosAxes>] = []
        
        for partToBeRotated in allPartsToBeRotatedByRotator {
            guard let partValues = partValuesDic[partToBeRotated] else {
                fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no values exists for: \(partToBeRotated) ") }
            dimensions.append(partValues.dimension)
            originNames.append(partValues.originName)
            globalOrigins.append(partValues.globalOrigin)
        }

        guard let rotatorPartData = partValuesDic[rotatorPart] else {
            fatalError()
        }
        
        guard let angle: OneOrTwo<RotationAngles> = partValuesDic[rotatorPart]?.angles else {
            fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no values exists for: \(rotatorPart) ") }
        let rotatorData =
            Rotator(
                rotatorOrigin:
                    rotatorPartData.globalOrigin,
                originOfAllPartsToBeRotated:
                    globalOrigins,
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
                allCorners.mapSingleOneOrTwoWithOneFuncWithReturn {getTopViewCorners($0)}
        
            originName.mapSingleOneOrTwoAndOneFuncWithReturn(corners){addPartsToFourCornerDic($0, $1)}
        }
    }
            
            
    func getTopViewCorners(_ allCorners: [PositionAsIosAxes]) -> [PositionAsIosAxes]{
        [4,5,2,3].map{allCorners[$0]}
    }
    
//    func getSideViewCorners(_ allCorners: [PositionAsIosAxes]) -> [PositionAsIosAxes]{
//        let corners = [7,3,0,4].map{allCorners[$0]}
//        var sideWaysCorners: [PositionAsIosAxes] = []
//        for corner in corners {
//            sideWaysCorners.append((x: corner.y, y:corner.z ,z: corner.x))
//        }
                
        //print(corners.count)
//        return sideWaysCorners
//    }
            
     mutating  func addPartsToFourCornerDic(
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
                rotator.rotatorOrigin.map3New(
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
            let corners = dimension.mapSingleOneOrTwoWithOneFuncWithReturn { CreateIosPosition.getCornersFromDimension($0) }
            let result =
//                getFromOneOrTwo.getForThreeValues(
//                            originAfterRotationByRotator,
//                            corners,
//                            rotator.angle ) { calculateRotatedCorner($0, $1, $2) }
            originAfterRotationByRotator.map3New(
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
         //   print(chainLabels)
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

}
