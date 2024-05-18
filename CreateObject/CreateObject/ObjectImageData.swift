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
    var preTiltObjectToPartEightCornerPerKeyDic: CornerDictionary = [:]
    
    //post-tilt
    var postTiltObjectToRotatedPartOriginDic: PositionDictionary = [:]
    var postTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    var postTiltObjectToPartEightCornerPerKeyDic: CornerDictionary = [:]
    var postTiltObjectToOneCornerPerKeyDic: PositionDictionary = [:]
    var arcPointDic: PositionDictionary = [:]
    
    let partIdDicIn: [Part: OneOrTwo<PartTag>]
    
    let objectChainLabelsUserEditedDic: ObjectChainLabelDictionary
    let objectChainLabelsDefaultDic: ObjectChainLabelDictionary = ObjectChainLabel.dictionary
    
    var partDataDic: [Part: PartData] = [:]
    let chainLabelsAccountingForEdit: [Part]
    
    var objectDimension: Dimension = (width: 0.0, length: 0.0)
    var maximumDimension: Double {
        objectDimension.width > objectDimension.length ? objectDimension.width: objectDimension.length
    }
    var rotators: [Part] = []
    var rotatedParts: [[Part]] = []
    let objectData: ObjectData
    
    init(
        _ objectType: ObjectTypes,
        _ userEditedDic: UserEditedDictionaries?) {
            
            self.objectType = objectType
            
            self.partIdDicIn = userEditedDic?.partIdsUserEditedDic ?? [:]
            
            self.objectChainLabelsUserEditedDic = userEditedDic?.objectChainLabelsUserEditDic ?? [:]
            
            chainLabelsAccountingForEdit = ObjectImageData.getChainLabelsAccountingForEdit(
                for: objectType,
                using: objectChainLabelsUserEditedDic,
                defaultDic: objectChainLabelsDefaultDic)
            
            objectData = ObjectData(
                objectType,
                userEditedDic,
                chainLabelsAccountingForEdit)
            
            partDataDic =
                objectData.partDataDic
            
            DictionaryService.shared.partDataSharedDic = partDataDic//provide intial values
            
            createPreTiltDictionaryFromStructFactory()
            
            createPostTiltDictionaries()
            
            addOriginToDictionary()
            
            addArcPointsToDictionary()
            
            getSize()
            
            
//            print(postTiltObjectToPartFourCornerPerKeyDic["object_id0_originWheelStabiliser_id0_sitOn_id0"])
//                    DictionaryInArrayOut().getNameValue(preTiltObjectToPartOriginDic
//                    ).forEach{print($0)}
        }
    
    mutating func addOriginToDictionary() {
        let z = ZeroValue.iosLocation
        let name =
            CreateNameFromIdAndPart(PartTag.id0, PartTag.origin).name

        postTiltObjectToPartFourCornerPerKeyDic[name] = [z,z,z,z]
    }

    
   mutating func getSize() {
        let  postTiltObjectToOneCornerPerKeyDic =
        ConvertFourCornerPerKeyToOne(
            fourCornerPerElement:  postTiltObjectToPartFourCornerPerKeyDic
        ).oneCornerPerKey
       
        let minMax =
        CreateIosPosition.minMaxPosition(
            postTiltObjectToOneCornerPerKeyDic
        )
        
      objectDimension =
       CreateIosPosition.convertMinMaxToDimension(minMax)

    }
    
    
    mutating func addArcPointsToDictionary( ) {
        let arcPoints =
        CreateIosPosition.filterPointsToConvexHull( points:
            postTiltObjectToOneCornerPerKeyDic.map {$0.value}
        )
        
        var arcNames = postTiltObjectToOneCornerPerKeyDic.map{$0.key}
        arcNames = PrependArcNameToGenericNamePart.get(arcNames)
                
        for index in 0..<arcNames.count {
            
            if arcPoints[index].x != Double.infinity {
                let corners = Array(repeating: arcPoints[index], count: 4)
                postTiltObjectToPartFourCornerPerKeyDic += [arcNames[index]: corners]
            }
            
        }
    }
    
    

    


    
    
    
    static func getChainLabelsAccountingForEdit(
        for objectType: ObjectTypes,
        using userEditedDic: [ObjectTypes: [Part]],
        defaultDic: [ObjectTypes: [Part]]
    ) -> [Part] {
        guard let unwrapped = userEditedDic[objectType] ?? defaultDic[objectType] else {
            fatalError(
                "no chain labels for this object \(objectType)"
            )
        }
        return unwrapped
    }
    

    

    
}




//MARK: PretTiltDic
extension ObjectImageData {

    mutating func createPreTiltDictionaryFromStructFactory() {
        for chainLabel in chainLabelsAccountingForEdit {
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
            
//            if part == .stabiliser {
//                print("ObjectImage detects stabiliser")
//            }
            
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
        let allCorners = createCorner(dimension, globalOrigin)
        let displayedCorners = [4,5,6,7].map {allCorners[$0]}
//            if name.contains(Part.stabiliser.rawValue) {
//                print(name)
//            }
        let dictionaryUpdate =
            DictionaryUpdate(
                name: name,
                dimension: dimension,
                globalOrigin: globalOrigin,
                childOrigin: childOrigin,
                angle: angle,
                minMaxAngle: minMaxAngle,
                allCorners: allCorners,
                dispayedCorners: displayedCorners)
            
        process(dictionaryUpdate)
            
            
        func process(_ update: DictionaryUpdate) {
            let name = update.name
            
//            if name.contains(Part.stabiliser.rawValue) {
//                print(update.dispayedCorners)
//            }
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
              [name: update.dispayedCorners]
            preTiltObjectToPartEightCornerPerKeyDic +=
              [name: update.allCorners]
        }
         

        struct DictionaryUpdate {
            let name: String
            let dimension: Dimension3d
            let globalOrigin: PositionAsIosAxes
            let childOrigin: PositionAsIosAxes
            let angle: RotationAngles
            let minMaxAngle: AngleMinMax
            let allCorners: [PositionAsIosAxes]
            let dispayedCorners: [PositionAsIosAxes]
            
        }
    }
    
            
    func createCorner(
        _ dimension: Dimension3d,
        _ origin: PositionAsIosAxes)
    -> [PositionAsIosAxes]{
        let corners: [PositionAsIosAxes] =  CreateIosPosition
            .getCornersFromDimension(
                dimension
            )
        let cornersFromObject =
        CreateIosPosition.addToupleToArrayOfTouples(
            origin,
            corners
        )
        //let topViewCorners = [4,5,6,7].map {cornersFromObject[$0]}
        return
            cornersFromObject
            //topViewCorners
    }
}



//MARK: PostTiltDic
    extension ObjectImageData {
   
        
    func getRotators() -> [Part] {
        var rotators: [Part] = []
        for chainLabel in self.chainLabelsAccountingForEdit {
            guard let  values = partDataDic[chainLabel] else {
               fatalError("no values defined for chain labels \(chainLabel)")
            }
            rotators += values.partsToBeRotated != [] ? [chainLabel]: []
        }
       let orderedRotators = orderRotatorsForMultipleRotations(rotators)

        return orderedRotators
        
        func orderRotatorsForMultipleRotations(_ unorderedRotators: [Part]) -> [Part] {
            let rotatorOrder: [Part] = [.sitOnTiltJoint, .backSupportTiltJoint]
            var correctedRotatorOrder: [Part] = []
            for rotator in rotatorOrder {
                if unorderedRotators.contains(rotator) {
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
        
        
    mutating func createPostTiltDictionaries(){
        // initially set postTilt to preTilt values
        postTiltObjectToPartFourCornerPerKeyDic =
            preTiltObjectToPartFourCornerPerKeyDic
        postTiltObjectToPartEightCornerPerKeyDic =
            preTiltObjectToPartEightCornerPerKeyDic
            
            
            rotators = getRotators()
            rotatedParts = getOrderedPartsToBeRotatedByEachRotator(rotators)
   
            for index in 0..<rotators.count {
                processRotationOfAllPartsByOneRotator(rotators[index],rotatedParts[index])
            }
            
            postTiltObjectToOneCornerPerKeyDic =
                ConvertFourCornerPerKeyToOne(
                    fourCornerPerElement: postTiltObjectToPartFourCornerPerKeyDic).oneCornerPerKey
    }
        
        
    mutating func processRotationOfAllPartsByOneRotator(
        _ rotatorPart: Part,
        _ allPartsRotatableByRotator:[Part]){

        let partDataForAllPartsToBeRotated = getPartData(allPartsRotatableByRotator)
            
        let rotatorPartData = getPartData([rotatorPart])[0]//only one
        let originNames: [OneOrTwo<String>] = getAllOriginNames()
            
        let rotatorData = getRotatorData()
            
        let allOriginsAfterRotationByRotator: [OneOrTwo<PositionAsIosAxes>] =
            getAllOriginsAfterRotationdByOneRotator(rotatorData)
            
        for i in 0..<rotatorData.allPartsToBeRotated.count {
            let cornerPositionFromDimension: OneOrTwo<[PositionAsIosAxes]> =
                getLocalCornerPositionsBeforePartRotation(i)
            
            //order matters start
            //do first
            let cornerPositionsAccountingForPriorRotation: OneOrTwo<[PositionAsIosAxes]> =
                    rotatorPart == .backSupportTiltJoint ?
                            getCornerPositionsAllowingForPriorDimensionRotation(
                                partDataForAllPartsToBeRotated[i],
                                cornerPositionFromDimension): cornerPositionFromDimension
            //do second otherwise prior origin is not used
            updatePostTiltObjectToRotatedPartOriginDic(i)
            //order matters end
            
            let allLocalCornerPositionsAfterRotationAccountingForPriorRotation =
                getLocalCornerPositionsForOneRotatedPartAfterRotation(cornerPositionsAccountingForPriorRotation)

            let displayedLocalCornerPositionsAfterRotationAccountingForPriorRotation =
                removeUnseenCorners(allLocalCornerPositionsAfterRotationAccountingForPriorRotation)
            
            let displayedGlobalCornerPosition =
                getDisplayedGlobalCornerPositionForOneRotatedPartAfterRotationByOneRotator(
                    displayedLocalCornerPositionsAfterRotationAccountingForPriorRotation, i)
            
            let allGlobalCornerPosition =
                getDisplayedGlobalCornerPositionForOneRotatedPartAfterRotationByOneRotator(
                    allLocalCornerPositionsAfterRotationAccountingForPriorRotation, i)
            
            originNames[i].mapPairOfOneOrTwoWithFunc(displayedGlobalCornerPosition){addPartsToFourCornerDic($0, $1)}
            originNames[i].mapPairOfOneOrTwoWithFunc(allGlobalCornerPosition){addPartsToEightCornerDic($0, $1)}
            
           // print(originNames[i])
        }
            
            
        func getPartData(_ parts: [Part]) -> [PartData]{
            var partDataForAllPartsToBeRotated: [PartData] = []
            for part in parts {// get PartData for rotated parts
                guard let partData = partDataDic[part] else {
                    fatalError("part \(parts) has no PartData \(rotatorPart)" )
                    }
                partDataForAllPartsToBeRotated.append(partData)
            }
            return partDataForAllPartsToBeRotated
        }
        

        func getAllOriginNames () -> [OneOrTwo<String>] {
            var originNames: [OneOrTwo<String>] = []
            for i in 0..<allPartsRotatableByRotator.count {
                let partData = partDataForAllPartsToBeRotated[i]
                originNames.append(partData.originName)
            }
           
            return originNames
        }
            
            
        func getRotatorData() -> Rotator {
            guard let angle: OneOrTwo<RotationAngles> = partDataDic[rotatorPart]?.angles else {
                fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no values exists for: \(rotatorPart) ") }
            var dimensions: [OneOrTwo<Dimension3d>] = []
            var globalOriginsAccountingForPriorRotations: [OneOrTwo<PositionAsIosAxes>] = []
            for i in 0..<allPartsRotatableByRotator.count {
                let partData = partDataForAllPartsToBeRotated[i]
                let originsAccountingForPriorRotations = getOneOrTwoOriginsAccountingForPriorRotation(partData)
                dimensions.append(partData.dimension)
                globalOriginsAccountingForPriorRotations.append(originsAccountingForPriorRotations)
            }
            return
                Rotator(
                    rotatorOrigin:
                        getOneOrTwoOriginsAccountingForPriorRotation(rotatorPartData),
                    originOfAllPartsToBeRotated:
                        globalOriginsAccountingForPriorRotations,
                    partsToBeRotatedDimension:
                        dimensions,
                    angle:
                        angle,
                    allPartsToBeRotated: allPartsRotatableByRotator,
                    rotator: rotatorPart)
            
                func getOneOrTwoOriginsAccountingForPriorRotation(
                    _ partData:PartData )
                -> OneOrTwo<PositionAsIosAxes>{
                    let names = partData.id.getNamesArray(partData.part)
                    var dictionaryOrigin: [PositionAsIosAxes?] = []
                    for name in names {
                        dictionaryOrigin.append( postTiltObjectToRotatedPartOriginDic[name])
                    }
                    return partData.globalOrigin.getOneOrTwoOriginAllowingForEdit(dictionaryOrigin)
                }
        }

            
        func updatePostTiltObjectToRotatedPartOriginDic(_ index: Int) {
            let partData = partDataForAllPartsToBeRotated[index]
            let originAfterRotationByRotator = allOriginsAfterRotationByRotator[index]

                let part = partData.part
                let names =  partData.id.getNamesArray( part)
                let positions = originAfterRotationByRotator.getPositionsArray(part)
         
                for (name, position) in zip (names, positions) {
                 
//                    if name == CreateNameFromIdAndPart(.id0, .backSupport).name {
//                        print("\(name) \(position)")
//                    }
                
                    postTiltObjectToRotatedPartOriginDic += [name: position]
                }
        }
     
            
        func getLocalCornerPositionsBeforePartRotation (
             _ index: Int)
        -> OneOrTwo<[PositionAsIosAxes]> {
                let dimension = rotatorData.partsToBeRotatedDimension[index]
                let allCornerPositionsBeforeRotation: OneOrTwo<[PositionAsIosAxes]> =
                    dimension.getOneOrTwoCornerArrayFromDimension
                    { CreateIosPosition.getCornersFromDimension($0) }

                return allCornerPositionsBeforeRotation
        }
        
        
        func getLocalCornerPositionsForOneRotatedPartAfterRotation (
             _ allCornerPositionsBeforeRotationByOneRotator: OneOrTwo<[PositionAsIosAxes]>)
        -> OneOrTwo<[PositionAsIosAxes]> {
           let allCornerPositionsAfterRotationByOneRotator: OneOrTwo<[PositionAsIosAxes]> =
                        allCornerPositionsBeforeRotationByOneRotator.mapOneOrTwoPairWithFunc(
                            rotatorData.angle) {calculateRotatedCornerInLocal($0, $1)}
            
            return allCornerPositionsAfterRotationByOneRotator
        }
        
        
        func removeUnseenCorners(
            _ oneLocalCornerPositionsForPartAfterRotationByOneRotator: OneOrTwo<[PositionAsIosAxes]>)
        -> OneOrTwo<[PositionAsIosAxes]> {
                oneLocalCornerPositionsForPartAfterRotationByOneRotator
                    .mapOneOrTwoSingleWithFunc {getTopViewCorners($0)}
        }
        
        
        func getDisplayedGlobalCornerPositionForOneRotatedPartAfterRotationByOneRotator(
            _ oneLocalCornerPositionsForPartAfterRotationByOneRotator:
                OneOrTwo<[PositionAsIosAxes]>,
            _ index: Int)
        -> OneOrTwo<[PositionAsIosAxes]> {
            
            let rotatedOrigin = allOriginsAfterRotationByRotator[index]//this should be backSupportTiltJoint
            let global =  oneLocalCornerPositionsForPartAfterRotationByOneRotator.addToOneOrTwo(rotatedOrigin)
            return global
        }
        
        
        func getCornerPositionsAllowingForPriorDimensionRotation(
            _ partData: PartData,
            _ cornerPositionsFromDimension: OneOrTwo<[PositionAsIosAxes]>)
        -> OneOrTwo<[PositionAsIosAxes]> {
         
            // comparing part origin to determine if prior rotation exists
            let preOrigin: OneOrTwo<PositionAsIosAxes> =
                partData.originName.getDictionaryValue(preTiltObjectToPartOriginDic)
            let postOrigin: OneOrTwo<PositionAsIosAxes> =
                partData.originName.getDictionaryValue(postTiltObjectToRotatedPartOriginDic)
            let postGlobalCorners: OneOrTwo<[PositionAsIosAxes]> =
                partData.originName.getDictionaryValues(postTiltObjectToPartEightCornerPerKeyDic)
            let localCornerPositions: OneOrTwo<[PositionAsIosAxes]> =
                preOrigin.getDefaultOrRotatedCorners(postOrigin, cornerPositionsFromDimension, postGlobalCorners)
            
            return localCornerPositions
        }
    }
            
            
    func getTopViewCorners(_ allCorners: [PositionAsIosAxes]) -> [PositionAsIosAxes]{
        return [4,5,2,3].map{allCorners[$0]}
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
         _ partCornerPosition: [PositionAsIosAxes]) {
            postTiltObjectToPartFourCornerPerKeyDic += [name: partCornerPosition]
    }

        
    mutating  func addPartsToEightCornerDic(
        _ name: String,
        _ partCornerPosition: [PositionAsIosAxes]) {
           postTiltObjectToPartEightCornerPerKeyDic += [name: partCornerPosition]
    }

        
    struct Rotator {
        let rotatorOrigin: OneOrTwo<PositionAsIosAxes>
        let originOfAllPartsToBeRotated: [OneOrTwo<PositionAsIosAxes>]
        let partsToBeRotatedDimension: [OneOrTwo<Dimension3d>]
        let angle: OneOrTwo<RotationAngles>
        let allPartsToBeRotated: [Part]
        let rotator: Part
    }
       
        
    func getAllOriginsAfterRotationdByOneRotator(
        _ rotator: Rotator)
    -> [OneOrTwo<PositionAsIosAxes>] {
        var allOriginAfterRotationByRotator: [OneOrTwo<PositionAsIosAxes>] = []
        
        for i in 0..<rotator.originOfAllPartsToBeRotated.count {
                    allOriginAfterRotationByRotator.append(
                    rotator.rotatorOrigin.mapTripleOneOrTwoWithFunc(
                    rotator.originOfAllPartsToBeRotated[i],
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
                angleChange: angle.x,
                rotationAxis: .yAxis //
            ).fromObjectOriginToPointWhichHasMoved + rotatorOrigin

        return   rotatedPosition
    }
    
    
//    func calculateRotatedCorner(
//        _ rotatedOriginOfPart: PositionAsIosAxes,
//        _ cornerPositions: [PositionAsIosAxes],
//        _ angle: RotationAngles = ZeroValue.rotationAngles)
//    -> [PositionAsIosAxes]  {
//        var rotatedCorners: [PositionAsIosAxes] = []
//        guard angle.y.value == 0.0 || angle.z.value == 0.0 else {
//            fatalError("\(String(describing: type(of: self))): \(#function ) only x rotation are coded \(angle.y.value)  \(angle.z.value) ")
//        }
//        for index in 0..<cornerPositions.count {
//            let newCornerPosition =
//            PositionOfPointAfterRotationAboutPoint(
//                staticPoint:ZeroValue.iosLocation,
//                movingPoint: cornerPositions[index],
//                angleChange: angle.x
//            ).fromObjectOriginToPointWhichHasMoved
//            rotatedCorners.append(
//             newCornerPosition + rotatedOriginOfPart)
//        }
//        return rotatedCorners
//    }
    
        
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
                angleChange: angle.x,
                rotationAxis: .yAxis
            ).fromObjectOriginToPointWhichHasMoved
            rotatedCorners.append(
             newCornerPosition)
        }
        return rotatedCorners
    }
        
}
