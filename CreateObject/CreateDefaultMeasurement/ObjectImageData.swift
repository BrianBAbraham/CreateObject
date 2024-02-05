//
//
// ObjectImageData
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation


struct ObjectImageData {

    let objectType: ObjectTypes
  
    var dimensionDic: Part3DimensionDictionary = [:]
    
    var angleUserEditDic: AnglesDictionary = [:]

    var angleMinMaxDic: AngleMinMaxDictionary = [:]
  
    //pre-tilt
    var preTiltObjectToPartOriginDic: PositionDictionary = [:]
    var preTiltParentToPartOriginDic: PositionDictionary = [:]
    var preTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    
    //post-tilt
    var postTiltObjectToPartOriginDic: PositionDictionary = [:]
    var postTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    var postTiltObjectToOneCornerPerKeyDic: PositionDictionary = [:]
    
    let partIdDicIn: [Part: OneOrTwo<PartTag>]

    let objectChainLabelsUserEditedDic: ObjectChainLabelDictionary
    let objectChainLabelsDefaultDic: ObjectChainLabelDictionary = ObjectChainLabel.dictionary

    var partDataDic: [Part: PartData] = [:]
    let chainLabels: [Part]
    
    var dimension: Dimension = (width: 0.0, length: 0.0)
    var maximumDimension: Double {
        dimension.width > dimension.length ? dimension.width: dimension.length
    }
    

    init(
        _ objectType: ObjectTypes,
        _ userEditedDic: UserEditedDictionaries?) {
        self.objectType = objectType
        self.partIdDicIn = userEditedDic?.partIdsUserEditedDic ?? [:]
        self.objectChainLabelsUserEditedDic = userEditedDic?.objectChainLabelsUserEditDic ?? [:]
            
        guard let unwrapped = objectChainLabelsUserEditedDic[objectType] ?? objectChainLabelsDefaultDic[objectType] else {
            fatalError("no chain labels for this object \(objectType)")
        }
        
        chainLabels = unwrapped
            
        partDataDic =
            ObjectData(
                objectType,
                userEditedDic)
                    .partValuesDic
        DataService.shared.partDataSharedDic = partDataDic
//MARK: - ORIGIN/DIMENSION DICTIONARY

            func createPreTiltParentToPartOriginDictionary() {
                
            }
            
            
        createPreTiltDictionaryFromStructFactory()
        createPostTiltDictionaryFromStructFactory()

//DictionaryInArrayOut().getNameValue(anglesMinMaxDic
//).forEach{print($0)}
  
//MARK: - POST-TILT
        // initially set postTilt to preTilt values
        postTiltObjectToPartFourCornerPerKeyDic =
            preTiltObjectToPartFourCornerPerKeyDic
   
        createPostTiltDictionaryFromStructFactory()
            
        postTiltObjectToOneCornerPerKeyDic =
            ConvertFourCornerPerKeyToOne(
                fourCornerPerElement: postTiltObjectToPartFourCornerPerKeyDic).oneCornerPerKey
            
        dimension = getSize()
            
            
            
            
        //createExteriorPointDictionary()
    }
    
    func getSize() ->Dimension{
        let minMax =
            CreateIosPosition.minMaxPosition(postTiltObjectToOneCornerPerKeyDic)
        
        let objectDimension =
                (width: minMax[1].x - minMax[0].x,length: minMax[1].y - minMax[0].y )
        
       return
        objectDimension
        
        func getMaximumDimensionOfObject (
        _ dictionary: PositionDictionary)
            -> Double {
            let minMax =
            CreateIosPosition
               .minMaxPosition(dictionary)
            let objectDimensions =
            (length: minMax[1].y - minMax[0].y, width: minMax[1].x - minMax[0].x)
            return
                [objectDimensions.length, objectDimensions.width].max() ?? objectDimensions.length
        }
        
    }
    
    
//    func createExteriorPointDictionary() {
//
//        let postTiltOneCornerPerKeyDic =
//            ConvertFourCornerPerKeyToOne(fourCornerPerElement: postTiltObjectToFourCornerPerKeyDic).oneCornerPerKey
//        let allCornersXYZ = postTiltOneCornerPerKeyDic.values.map { ($0.x, $0.y) }
//        let points = allCornersXYZ
//
//        print(points.count)
//
//
//        let filteredPoints = points.filter { point in
//                let isInterior = points.allSatisfy { otherPoint in
//                    // Check if the magnitude of the current point is greater than or equal to other points in both x and y coordinates
//                    let isGreaterX = abs(point.0) >= abs(otherPoint.0)
//                    let isGreaterY = abs(point.1) >= abs(otherPoint.1)
//                    return isGreaterX && isGreaterY
//                }
//                return !isInterior
//            }
//
//        print(filteredPoints.count)
//        print("")
//    }
}




//MARK: PretTiltDic
extension ObjectImageData {

    mutating func createPreTiltDictionaryFromStructFactory() {

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
        guard let partValue = partDataDic[part]
            else {
            return fatalErrorGettingPartValue() }
            
        let globalOrigin = partValue.globalOrigin
        let childOrigin = partValue.childOrigin
 
            
        partValue.dimension.mapSixOneOrTwoToOneFuncWithVoidReturn  (
        partValue.originName,
        partValue.angles,
        partValue.minMaxAngle,
        globalOrigin,
        childOrigin,
            { (dimension,
               originName,
               angles,
               minMaxAngle,
               globalOrigin,
               childOrigin)
                in self.updateDictionaries(//the whole point
                    dimension,
                    originName,
                    angles,
                    minMaxAngle,
                    globalOrigin,
                    childOrigin) }
        )
            
        func fatalErrorGettingPartValue(){
            fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no values exist for this part: \(part)")
        }
    }
            
    
//    mutating func updateDictionaries(
//        _ dimension: Dimension3d,
//        _ name: String,
//        _ angle: RotationAngles,
//        _ minMaxAngle: AngleMinMax,
//        _ globalOrigin: PositionAsIosAxes) {
//
//        let dictionaryUpdate =
//            DictionaryUpdate(
//                name: name,
//                dimension: dimension,
//                globalOrigin: globalOrigin,
//                angle: angle,
//                minMaxAngle: minMaxAngle,
//                corners: createCorner(dimension, globalOrigin))
//
//        process(dictionaryUpdate)
//
//
//        func process(_ update: DictionaryUpdate) {
//            let name = update.name
//            angleUserEditDic +=
//             [name: update.angle]
//            angleMinMaxDic +=
//             [name: update.minMaxAngle]
//            dimensionDic +=
//              [name: update.dimension]
//            preTiltObjectToPartOriginDic +=
//              [name: update.globalOrigin]
//            preTiltObjectToPartFourCornerPerKeyDic +=
//              [name: update.corners]
//        }
//
//
//        struct DictionaryUpdate {
//            let name: String
//            let dimension: Dimension3d
//            let globalOrigin: PositionAsIosAxes
//            let angle: RotationAngles
//            let minMaxAngle: AngleMinMax
//            let corners: [PositionAsIosAxes]
//        }
//    }
     
    
    mutating func updateDictionaries(
        _ dimension: Dimension3d,
        _ name: String,
        _ angle: RotationAngles,
        _ minMaxAngle: AngleMinMax,
        _ globalOrigin: PositionAsIosAxes,
        _ childOrigin: PositionAsIosAxes) {
        
        let dictionaryUpdate =
            DictionaryUpdate(
                name: name,
                dimension: dimension,
                globalOrigin: globalOrigin,
                childOrigin: childOrigin,
                angle: angle,
                minMaxAngle: minMaxAngle,
                corners: createCorner(dimension, globalOrigin))
            
        process(dictionaryUpdate)
            
            
        func process(_ update: DictionaryUpdate) {
            let name = update.name
            angleUserEditDic +=
             [name: update.angle]
            angleMinMaxDic +=
             [name: update.minMaxAngle]
            dimensionDic +=
              [name: update.dimension]
            preTiltObjectToPartOriginDic +=
              [name: update.globalOrigin]
            preTiltParentToPartOriginDic +=
              [name: update.childOrigin]
            preTiltObjectToPartFourCornerPerKeyDic +=
              [name: update.corners]
        }
         

        struct DictionaryUpdate {
            let name: String
            let dimension: Dimension3d
            let globalOrigin: PositionAsIosAxes
            let childOrigin: PositionAsIosAxes
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
extension ObjectImageData {
   
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
            guard let partValues = partDataDic[partToBeRotated] else {
                fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no values exists for: \(partToBeRotated) ") }
            dimensions.append(partValues.dimension)
            originNames.append(partValues.originName)
            globalOrigins.append(partValues.globalOrigin)
        }

        guard let rotatorPartData = partDataDic[rotatorPart] else {
            fatalError()
        }
        
        guard let angle: OneOrTwo<RotationAngles> = partDataDic[rotatorPart]?.angles else {
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
            postTiltObjectToPartFourCornerPerKeyDic += [name: partCornerPosition]
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

        var rotatingParts: [Part] = []
        var allPartsToBeRotatedByOneRotatorPart: [[Part]] = []
        for chainLabel in chainLabels {
            guard let  values = partDataDic[chainLabel] else {
               fatalError("no values defined for chain labels \(chainLabel)")
            }
            
            if values.scopeOfRotation != [] {//there may be no rotators
                rotatingParts.append(chainLabel)
                
                allPartsToBeRotatedByOneRotatorPart.append( getOneOfEachPartFromSomePartChainLabel(
                    values.scopeOfRotation) //unique parts returned
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
