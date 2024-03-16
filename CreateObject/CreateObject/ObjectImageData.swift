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
    var postTiltObjectToRotatedPartOriginDic: PositionDictionary = [:]
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
    var rotators2: [Part] = []
    var rotatedParts2: [[Part]] = []

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
            

        DictionaryService.shared.partDataSharedDic = partDataDic
                        
        createPreTiltDictionaryFromStructFactory()
            
            rotators2 = getRotators()
            rotatedParts2 = getOrderedPartsToBeRotatedByEachRotator(rotators2)



  
//MARK: - POST-TILT
        // initially set postTilt to preTilt values
        postTiltObjectToPartFourCornerPerKeyDic =
            preTiltObjectToPartFourCornerPerKeyDic
   
            for index in 0..<rotators2.count {
                
              //  print(rotators2[index])
                createPostTiltDictionaryFromPartDataDic(rotators2[index],rotatedParts2[index])
                
                //   createPostTiltDictionaryFromStructFactory()
                
                postTiltObjectToOneCornerPerKeyDic =
                ConvertFourCornerPerKeyToOne(
                    fourCornerPerElement: postTiltObjectToPartFourCornerPerKeyDic).oneCornerPerKey
                
            }
//            let z = ZeroValue.iosLocation
//            postTiltObjectToPartFourCornerPerKeyDic[Part.objectOrigin.rawValue] = [z,z,z,z]
//            
            
            
            
//        DictionaryInArrayOut().getNameValue(preTiltObjectToPartOriginDic
//        ).forEach{print($0)}
            
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



//if values.scopeOfRotation != [] {//this may  not be a rotator
//    rotatorParts.append(chainLabelAsPart)//MARK: Apply Rotations

    
    extension ObjectImageData {
   
        
    func getRotators() -> [Part] {
        var rotators: [Part] = []
        for chainLabel in self.chainLabels {
            guard let  values = partDataDic[chainLabel] else {
               fatalError("no values defined for chain labels \(chainLabel)")
            }
            rotators += values.partsToBeRotated != [] ? [chainLabel]: []
        }
        return orderRotatorsForMultipleRotations(rotators)
        
        func orderRotatorsForMultipleRotations(_ unorderedRotators: [Part]) -> [Part] {
            let rotatorOrder: [Part] = [.sitOnTiltJoint, .backSupportTiltJoint]
            var correctedRotatorOrder: [Part] = []
            for rotator in rotatorOrder {
                if rotatorOrder.contains(rotator) {
                    correctedRotatorOrder.append(rotator)
                }
            }
            return correctedRotatorOrder
        }
    }
    func getOrderedPartsToBeRotatedByEachRotator(_ rotators: [Part]) -> [[Part]] {
        var orderedPartsToBeRotatedByEachRotator: [[Part]] = []
        for rotator in rotators {
            guard let partData = partDataDic[rotator] else {fatalError("\(rotator)")}
            orderedPartsToBeRotatedByEachRotator.append( partData.partsToBeRotated)
        }
        return orderedPartsToBeRotatedByEachRotator
    }
        
        
    mutating func createPostTiltDictionaryFromPartDataDic(
            _ rotators2: Part, _ rotatedParts2: [Part]) {
            processRotationOfAllPartsByOneRotator(
            rotators2, rotatedParts2)
    }

            
    mutating func processRotationOfAllPartsByOneRotator(
        _ rotatorPart: Part,
        _ allPartsToBeRotatedByRotator:[Part]){

        var dimensions: [OneOrTwo<Dimension3d>] = []
        var originNames: [OneOrTwo<String>] = []
        var globalOriginsAccountingForPriorRotations: [OneOrTwo<PositionAsIosAxes>] = []
        
        let partDataForAllPartsToBeRotated = getPartData(allPartsToBeRotatedByRotator)
        let rotatorPartData = getPartData([rotatorPart])[0]//only one
            
            func getPartData(_ parts: [Part]) -> [PartData]{
                var partDataForAllPartsToBeRotated: [PartData] = []
                for part in parts {// get PartData for rotated parts
                    guard let partData = partDataDic[part] else {
                        fatalError("part \(part) has no PartData" )
                        }
                    partDataForAllPartsToBeRotated.append(partData)
                }
                return partDataForAllPartsToBeRotated
            }
            
            
        for i in 0..<allPartsToBeRotatedByRotator.count {
            let partData = partDataForAllPartsToBeRotated[i]
            let originsAccountingForPriorRotations = getOneOrTwoOriginsAccountingForPriorRotation(partData)
            
            //Form data for Rotator
            dimensions.append(partData.dimension)
            originNames.append(partData.originName)
            globalOriginsAccountingForPriorRotations.append(originsAccountingForPriorRotations)
        }


        func getOneOrTwoOriginsAccountingForPriorRotation(_ partData:PartData ) -> OneOrTwo<PositionAsIosAxes>{
            let names = partData.id.getNamesArray(partData.part)
            var dictionaryOrigin: [PositionAsIosAxes?] = []
            for name in names {
                dictionaryOrigin.append( postTiltObjectToRotatedPartOriginDic[name])
            }
            return partData.globalOrigin.getOneOrTWoDictionaryOrUseDefaultOrgin(dictionaryOrigin)
        }
        func getOneOrTwoDisplayedCornersAccountingForPriorRotation(
            _ partData: PartData, _ displayedGlobalCornerPosition: OneOrTwo<[PositionAsIosAxes]> ) -> OneOrTwo<[PositionAsIosAxes]>{
            let names = partData.id.getNamesArray(partData.part)
            var dictionaryOrigin: [[PositionAsIosAxes]?] = []
            for name in names {
                
                if 
                    let pre = preTiltObjectToPartFourCornerPerKeyDic[name],
                    let post = postTiltObjectToPartFourCornerPerKeyDic[name] {
                    let useAnyOf4 = 0
                    pre[useAnyOf4] == post[useAnyOf4] ? print("no rotation so far for \(partData.part)"): print("already rotated \(partData.part)")
                    print(pre[useAnyOf4])
                    print(post[useAnyOf4])
                    print("")
                }
                
                
                dictionaryOrigin.append(
                    postTiltObjectToPartFourCornerPerKeyDic[name]
                    
     
                )
            }
//                print(partData.part)
//                print(dictionaryOrigin)
//                print("")
            return displayedGlobalCornerPosition.getOneOrTWoDictionaryOrUseDefaultOrgin2(dictionaryOrigin)
        }
        
        guard let angle: OneOrTwo<RotationAngles> = partDataDic[rotatorPart]?.angles else {
            fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no values exists for: \(rotatorPart) ") }
                        
        let rotatorData =
            Rotator(
                rotatorOrigin:
                    getOneOrTwoOriginsAccountingForPriorRotation(rotatorPartData),
                originOfAllPartsToBeRotated:
                    globalOriginsAccountingForPriorRotations,
                partsToBeRotatedDimension:
                    dimensions,
                angle:
                    angle,
            allPartsToBeRotated: allPartsToBeRotatedByRotator)
           
        let allOriginsAfterRotationByRotator: [OneOrTwo<PositionAsIosAxes>] =
           getAllOriginsAfterRotationdByOneRotator(rotatorData)
        
            //Create dictionary
        for (partData, originAfterRotationByRotator) in
                zip(partDataForAllPartsToBeRotated, allOriginsAfterRotationByRotator) {
            let part = partData.part
            let names =  partData.id.getNamesArray( part)
            let positions = originAfterRotationByRotator.getPositionsArray(part)
            
            for (name, position) in zip (names, positions) {
                postTiltObjectToRotatedPartOriginDic += [name: position]
            }
        }
       
        var allDisplayedGlobalCornerPositions: [OneOrTwo<[PositionAsIosAxes]>] = []
            
            
        for i in 0..<rotatorData.allPartsToBeRotated.count {
            let localCornerPosition =
                getOneLocalCornerPositionsForRotatedPartAfterRotationByOneRotator(i)
            
            let viewedLocalCornerPosition =
                removeUnseenCorners(localCornerPosition)

            
            let displayedGolobalCornerDefaultPosition =
                getOneDisplayedGlobalCornerPositionForRotatedPartAfterRotationByOneRotator(
                    viewedLocalCornerPosition, i)
            let displayedGlobalCornerPositionsAccountingForPriorRotation =
                getOneOrTwoDisplayedCornersAccountingForPriorRotation(
                    partDataForAllPartsToBeRotated[i], displayedGolobalCornerDefaultPosition)
            
            allDisplayedGlobalCornerPositions.append(displayedGolobalCornerDefaultPosition)
        }
            

        for (originName, allCorners) in zip(originNames, allDisplayedGlobalCornerPositions) {
            originName.mapPairOfOneOrTwoWithFunc(allCorners){addPartsToFourCornerDic($0, $1)}
        }
            
            func getOneLocalCornerPositionsForRotatedPartAfterRotationByOneRotator (
                 _ index: Int) -> OneOrTwo<[PositionAsIosAxes]> {
                    let dimension = rotatorData.partsToBeRotatedDimension[index]
                    let allCornerPositionsBeforeRotationByOneRotator: OneOrTwo<[PositionAsIosAxes]> =
                        dimension.getOneOrTwoCornerArrayFromDimension
                        { CreateIosPosition.getCornersFromDimension($0) }
                    let allCornerPositionsAfterRotationByOneRotator: OneOrTwo<[PositionAsIosAxes]> =
                            allCornerPositionsBeforeRotationByOneRotator.mapOneOrTwoPairWithFunc(
                                rotatorData.angle) {calculateRotatedCornerInLocal($0, $1)}
                    return
                        allCornerPositionsAfterRotationByOneRotator
            }
            func removeUnseenCorners(
                _ oneLocalCornerPositionsForPartAfterRotationByOneRotator: OneOrTwo<[PositionAsIosAxes]>) -> OneOrTwo<[PositionAsIosAxes]> {
                    oneLocalCornerPositionsForPartAfterRotationByOneRotator
                        .mapOneOrTwoSingleWithFunc {getTopViewCorners($0)}
            }
            func getOneDisplayedGlobalCornerPositionForRotatedPartAfterRotationByOneRotator(
                _ oneLocalCornerPositionsForPartAfterRotationByOneRotator:
                    OneOrTwo<[PositionAsIosAxes]>,
                _ index: Int) -> OneOrTwo<[PositionAsIosAxes]> {
                    let rotatedOrigin = allOriginsAfterRotationByRotator[index]
                    return
                        oneLocalCornerPositionsForPartAfterRotationByOneRotator
                            .addOneOrTwoPair(rotatedOrigin)
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
            print([name: partCornerPosition])
            postTiltObjectToPartFourCornerPerKeyDic += [name: partCornerPosition]
    }


    struct Rotator {
        let rotatorOrigin: OneOrTwo<PositionAsIosAxes>
        let originOfAllPartsToBeRotated: [OneOrTwo<PositionAsIosAxes>]
        let partsToBeRotatedDimension: [OneOrTwo<Dimension3d>]
        let angle: OneOrTwo<RotationAngles>
        let allPartsToBeRotated: [Part]
    }
       
        
    func getAllOriginsAfterRotationdByOneRotator(
        _ rotator: Rotator)
    -> [OneOrTwo<PositionAsIosAxes>] {
        var allOriginAfterRotationByRotator: [OneOrTwo<PositionAsIosAxes>] = []
       
            for partOrigin in
                rotator.originOfAllPartsToBeRotated {
                    allOriginAfterRotationByRotator.append(
                    rotator.rotatorOrigin.mapTripleOneOrTwoWithFunc(
                    partOrigin,
                    rotator.angle ) { calculateRotatedOrigin($0, $1, $2) } )
        }
        return allOriginAfterRotationByRotator
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
        
        //print("\(rotatorOrigin)  \(angle.x) \(Int(rotatedPosition.y))")
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
    
        
    func calculateRotatedCornerInLocal(
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
             newCornerPosition)
        }
        return rotatedCorners
    }
        
    
    func getPartsToBeRotated ()
        -> ([Part], [[Part]]) {
        var rotatorParts: [Part] = []
        var allPartsToBeRotatedByOneRotatorPart: [[Part]] = []
        for chainLabelAsPart in chainLabels {
            guard let  values = partDataDic[chainLabelAsPart] else {
               fatalError("no values defined for chain labels \(chainLabelAsPart)")
            }
            if values.partsToBeRotated != [] {//this may  not be a rotator
                rotatorParts.append(chainLabelAsPart)
                
                allPartsToBeRotatedByOneRotatorPart.append(values.partsToBeRotated)
                
            }
        }
            return (rotatorParts, allPartsToBeRotatedByOneRotatorPart)
    }
    
}
