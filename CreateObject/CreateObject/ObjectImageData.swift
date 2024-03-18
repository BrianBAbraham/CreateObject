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
                
              // print(rotators2[index])
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
       let orderedRotators = orderRotatorsForMultipleRotations(rotators)
       // print(orderedRotators)
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
        
        
    mutating func createPostTiltDictionaryFromPartDataDic(
            _ rotators2: Part, _ rotatedParts2: [Part]) {
            processRotationOfAllPartsByOneRotator(
            rotators2, rotatedParts2)
    }

            
        
        
    mutating func processRotationOfAllPartsByOneRotator(
        _ rotatorPart: Part,
        _ allPartsToBeRotatedByRotator:[Part]){
//print("*\(rotatorPart)*")
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
            

        let originNames: [OneOrTwo<String>] = getAllOriginNames()

            func getAllOriginNames () -> [OneOrTwo<String>] {
                var originNames: [OneOrTwo<String>] = []
                for i in 0..<allPartsToBeRotatedByRotator.count {
                    let partData = partDataForAllPartsToBeRotated[i]
                    originNames.append(partData.originName)
                }
                return originNames
            }
            
            
        let rotatorData = getRotatorData()
            
            func getRotatorData() -> Rotator {
                guard let angle: OneOrTwo<RotationAngles> = partDataDic[rotatorPart]?.angles else {
                    fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no values exists for: \(rotatorPart) ") }
                var dimensions: [OneOrTwo<Dimension3d>] = []
                var globalOriginsAccountingForPriorRotations: [OneOrTwo<PositionAsIosAxes>] = []
                for i in 0..<allPartsToBeRotatedByRotator.count {
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
                        allPartsToBeRotated: allPartsToBeRotatedByRotator,
                        rotator: rotatorPart)
                
                    func getOneOrTwoOriginsAccountingForPriorRotation(
                        _ partData:PartData )
                    -> OneOrTwo<PositionAsIosAxes>{
                        let names = partData.id.getNamesArray(partData.part)
                        var dictionaryOrigin: [PositionAsIosAxes?] = []
                        for name in names {
                            dictionaryOrigin.append( postTiltObjectToRotatedPartOriginDic[name])
                        }
                        return partData.globalOrigin.getOneOrTWoDictionaryOrUseDefaultOrgin(dictionaryOrigin)
                    }
            }

            
            


        

        let allOriginsAfterRotationByRotator: [OneOrTwo<PositionAsIosAxes>] =
           getAllOriginsAfterRotationdByOneRotator(rotatorData)
        
        updatePostTiltObjectToRotatedPartOriginDic()

            func updatePostTiltObjectToRotatedPartOriginDic() {
                for (partData, originAfterRotationByRotator) in
                        zip(partDataForAllPartsToBeRotated, allOriginsAfterRotationByRotator) {
                    let part = partData.part
                    let names =  partData.id.getNamesArray( part)
                    let positions = originAfterRotationByRotator.getPositionsArray(part)
                    
                    for (name, position) in zip (names, positions) {

                        postTiltObjectToRotatedPartOriginDic += [name: position]
//                        if partData.part == .backSupport && rotatorPart == .sitOnTiltJoint {
//    print ("dictionary when sitOnTiltJoint \(names) \(postTiltObjectToRotatedPartOriginDic[name])")
//}
//                        if partData.part == .backSupport && rotatorPart == .backSupportTiltJoint {
//    print ("dictionary when backSupportTiltJoint \(names) \(postTiltObjectToRotatedPartOriginDic[name])")
//}
//print("")
                        
                    }
                }
            }
       
     
            
        for i in 0..<rotatorData.allPartsToBeRotated.count {
            let localCornerPosition: OneOrTwo<[PositionAsIosAxes]> =
                getLocalCornerPositionsForOneRotatedPartAfterRotationByOneRotator(i)
            
            let displayedLocalCornerPosition =
                removeUnseenCorners(localCornerPosition)
            
            let displayedGlobalCornerDefaultPosition =
                getDisplayedGlobalCornerPositionForOneRotatedPartAfterRotationByOneRotator(
                    displayedLocalCornerPosition, i)
            
            let displayedGlobalCornerPositionsAccountingForPriorRotation: OneOrTwo<[PositionAsIosAxes]> =
                getDisplayedCornersAccountingForPriorRotation(
                    partDataForAllPartsToBeRotated[i], 
                    displayedGlobalCornerDefaultPosition,
                allOriginsAfterRotationByRotator[i])
            
            let  cornerPosition = rotatorPart == .backSupportTiltJoint ?
                displayedGlobalCornerPositionsAccountingForPriorRotation: displayedGlobalCornerDefaultPosition
            
//            if originNames[i].one == "object_id0_backSupport_id0_sitOn_id0" && rotatorPart == .backSupportTiltJoint {
//                print(displayedGlobalCornerPositionsAccountingForPriorRotation.one?[0].y)
//            }
            originNames[i].mapPairOfOneOrTwoWithFunc(cornerPosition){addPartsToFourCornerDic($0, $1)}
        }
            

            
            
            func getLocalCornerPositionsForOneRotatedPartAfterRotationByOneRotator (
                 _ index: Int) 
            -> OneOrTwo<[PositionAsIosAxes]> {
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
                    let rotatedOrigin = allOriginsAfterRotationByRotator[index]
                    return
                        oneLocalCornerPositionsForPartAfterRotationByOneRotator
                            .addOneOrTwoPair(rotatedOrigin)
            }
            func getDisplayedCornersAccountingForPriorRotation(
                _ partData: PartData,
                _ displayedGlobalCornerDefaultPosition: OneOrTwo<[PositionAsIosAxes]>,
                _ oneOriginAfterRotationByRotator: OneOrTwo<PositionAsIosAxes>)
            -> OneOrTwo<[PositionAsIosAxes]> {
                var corners = displayedGlobalCornerDefaultPosition
                let names: [String] = partData.id.getNamesArray(partData.part)
                var dictionaryOrigin: [[PositionAsIosAxes]?] = []
                
                let preValues = partData.originName.getDictionaryValue(preTiltObjectToPartOriginDic)
                let postValues = partData.originName.getDictionaryValue(postTiltObjectToRotatedPartOriginDic)
                
                //pass both part origin values for equality test
                //pass: equality test, defaultValues, postValues, corners after tilt
                // pass default untilted corners
                // if fails equality test return corners after tilt in local form
                    for name in names {
                       var useDictionaryValues = false
                            if
                                let pre = preTiltObjectToPartOriginDic[name],
                                let post = postTiltObjectToRotatedPartOriginDic[name] {
                                
                                 if pre.y != post.y {
                                     let negative = oneOriginAfterRotationByRotator.negateOneOrTwoValues()
                                     //let localCorner = post.addOneOrTwoPair(negative)
                                 //   print("prior rotation")
                                     useDictionaryValues = true
                                     
                                 } else {
                                 //    print("no prior rotation")
                                 }
                               
                            }
                        dictionaryOrigin.append(//there is no change to priorly rotated
                            useDictionaryValues ?  postTiltObjectToPartFourCornerPerKeyDic[name]: nil)
                        }

                    
                    let displayedCornersAccountingForPriorRotation: OneOrTwo<[PositionAsIosAxes]> = displayedGlobalCornerDefaultPosition.getOneOrTwoDictionaryOrUseDefaultOrgin2(dictionaryOrigin)
//                if partData.part == .backSupport {
//                    print("prior:\(displayedCornersAccountingForPriorRotation.one!)\n no prior:\(displayedGlobalCornerDefaultPosition.one!)\n\n")
//                }
                return displayedCornersAccountingForPriorRotation
            }
            
            func priorRotationStates(_ partData: PartData) -> OneOrTwo<Bool> {
                var priorRotationStates: [Bool] = []
              
                let names: [String] = partData.id.getNamesArray(partData.part)
                    for name in names {
                            if
                                let pre = preTiltObjectToPartOriginDic[name],
                                let post = postTiltObjectToRotatedPartOriginDic[name] {
                                priorRotationStates += (pre.y != post.y ? [true]: [false])
                            } else {
                                priorRotationStates += [false]
                            }
                    }
                
                let oneOrTwoPriorRotationStates: OneOrTwo<Bool> = priorRotationStates.count == 2 ?
                    .two(left: priorRotationStates[0], right: priorRotationStates[1]):
                    .one(one: priorRotationStates[0])

                return oneOrTwoPriorRotationStates
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
            //print("DETECT")
            //print([name: partCornerPosition])
            postTiltObjectToPartFourCornerPerKeyDic += [name: partCornerPosition]
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
                
  //              if rotator.rotator == .backSupportTiltJoint{
//                    if rotator.allPartsToBeRotated[i] == .backSupport {
//                        print ("backtilt of backSupport")
//                        print(allOriginAfterRotationByRotator[i])
//                        print(rotator.angle)
//                        print("")
//                    }
//
//                }
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
