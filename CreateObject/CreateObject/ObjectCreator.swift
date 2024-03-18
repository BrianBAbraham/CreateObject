//
//  ObjectCreator.swift
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation

struct ObjectData {
    let objectChainLabelsDefaultDic: ObjectChainLabelDictionary
    
    let objectChainLabelsUserEditedDic: ObjectChainLabelDictionary
    
    var partValuesDic: [Part: PartData] = [:]
    
    let objectType: ObjectTypes
    
    let userEditedDic: UserEditedDictionaries?
    
    let size: Dimension = (width: 0.0, length: 0.0)

    var allChainLabels: [Part] = []
    
    var oneOfEachPartInAllPartChain: [Part] = []
    
    let linkedPartsDictionary = LinkedParts().dictionary
    
    init(
        _ objectType: ObjectTypes,
        _ userEditedDic: UserEditedDictionaries?) {
        
        self.objectType = objectType
        self.userEditedDic = userEditedDic
        self.objectChainLabelsDefaultDic = ObjectChainLabel.dictionary
        self.objectChainLabelsUserEditedDic = userEditedDic?.objectChainLabelsUserEditDic ?? [:]
        
        allChainLabels = getAllPartChainLabels()
            
        oneOfEachPartInAllPartChain = getOneOfEachPartInAllPartChain()
            
        checkObjectHasAtLeastOnePartChain()
        
        initialiseAllPart()
        
        postProcessGlobalOrigin()
            
            
//            for part in allPartChainLabels {
//                if part == .fixedWheelAtRearWithPropeller {
//                    print("")
//                    print("object creator")
//                    print(partValuesDic[.fixedWheelAtRearWithPropeller]?.globalOrigin)
//                    print("")
//                }
//            }
    }
    
    func checkObjectHasAtLeastOnePartChain(){
        for label in allChainLabels {
            let labelInPartChainOut = LabelInPartChainOut(label)
            guard labelInPartChainOut.partChain.isEmpty == false else {
                fatalError("chainLabel \(label) has no partChain in LabelInPartChainOut")
            }
        }
    }
    
    
   mutating func postProcessGlobalOrigin(){
        let allPartChain = getAllPartChain()
        var partsToHaveGlobalOriginSet =
           oneOfEachPartInAllPartChain
     
        for chain in allPartChain {
            processPart( chain)
        }

        func processPart(_ chain: [Part]) {
            for index in 0..<chain.count {
                let part = chain[index]
                if partsToHaveGlobalOriginSet.contains(part){
                let parentGlobalOrigin = getParentGlobalOrigin(index)
                    setGlobalOrigin(part, parentGlobalOrigin)
                  partsToHaveGlobalOriginSet = removePartFromArray(part)
                }
            }
            
            
            func getParentGlobalOrigin(_ index: Int) -> OneOrTwo<PositionAsIosAxes> {
                if index == 0 {
                    return .one(one: ZeroValue.iosLocation)
                } else {
                   let parentPart = chain[index - 1]
                    
                    guard let parentPartValue = partValuesDic[parentPart] else {
                        fatalError()
                    }
                    return parentPartValue.globalOrigin
                }
            }
        }

       
        func getAllPartChain() -> [[Part]]{
            var allPartChain: [[Part]] = []
            for label in allChainLabels {
                allPartChain.append(getPartChain(label))
            }
            return allPartChain
        }

        
       func setGlobalOrigin(
        _ part: Part,
        _ parentGlobalOrigin: OneOrTwo<PositionAsIosAxes>) {
            guard let partValue = partValuesDic[part] else {
                fatalError("This part:\(part) has not been intialised where the parent global origin is \(parentGlobalOrigin)")
            }
            let childOrigin = partValue.childOrigin
            
            var modifiedParentGlobalOrigin: OneOrTwo<PositionAsIosAxes>
            if childOrigin.oneNotTwo() && !parentGlobalOrigin.oneNotTwo() {
                guard let childId = partValue.id.one else {
                    fatalError("no child id")
                }
                modifiedParentGlobalOrigin = parentGlobalOrigin.mapTwoToOneUsingOneId(childId)
            } else {
                modifiedParentGlobalOrigin = parentGlobalOrigin
            }
            
            
            let globalOrigin =
                   getGlobalOrigin(childOrigin, modifiedParentGlobalOrigin)
            
            let modifiedPartValue = partValue.withNewGlobalOrigin(globalOrigin)
            partValuesDic[part] = modifiedPartValue
        }
        
        
        func getGlobalOrigin(
        _ childOrigin: OneOrTwo<PositionAsIosAxes>,
        _ parentGlobalOrigin: OneOrTwo<PositionAsIosAxes>)
       -> OneOrTwo<PositionAsIosAxes> {
            let (modifiedChildOrigin, modifiedParentGlobalOrigin) =
                OneOrTwo<Any>.convert2OneOrTwoToAllTwoIfMixedOneAndTwo (childOrigin, parentGlobalOrigin)
            return
                modifiedChildOrigin.mapWithDoubleOneOrTwoWithOneOrTwoReturn(modifiedParentGlobalOrigin)
        }
       
       
       func removePartFromArray(_ elementToRemove: Part) -> [Part] {
           partsToHaveGlobalOriginSet.filter { $0 != elementToRemove }
       }
    }
}



extension ObjectData {
    mutating func initialiseAllPart() {
       setUniqueInitialisation()
        func setUniqueInitialisation(){
            setObjectOriginPartValue()
        }
        
        //e,g. .sitOn is foundational to .fixedWheelHorizontalJoint...
        // object width is depenent on .sitOn
        let orderedSoLinkedOrParentPartInitialisedFirst =
          oneOfEachPartInAllPartChain
        if orderedSoLinkedOrParentPartInitialisedFirst.contains(.mainSupport) {
            initialiseLinkedOrParentPart(.mainSupport)
        }
        
        for part in orderedSoLinkedOrParentPartInitialisedFirst {
            if part != .mainSupport {
                let parentOrLinkedPart: Part
                
                parentOrLinkedPart = getLinkedOrParentPart(part)
            
                initialisePart(parentOrLinkedPart, part )
            }
        }
    }

    mutating func initialiseLinkedOrParentPart(
        _ child: Part) {
        let foundationalData =
                StructFactory(
                   objectType,
                   userEditedDic,
                  independantPart: child)
                    .partData
        
        partValuesDic +=
            [child: foundationalData]
    }
    
    
    mutating func initialisePart(
        _ linkedlOrParentPart: Part,
        _ child: Part
    ) {
        var childData: PartData = ZeroValue.partData
            guard let linkedOrParentData = partValuesDic[linkedlOrParentPart] else {
                fatalError("no partValue for \(linkedlOrParentPart)")
            }

             
        
        childData =
            StructFactory(
                objectType,
                userEditedDic,
                linkedOrParentData,
                child,
                allChainLabels)
                    .partData
        
        partValuesDic +=
            [child: childData]
    }
    

    func getOneOfEachPartInAllPartChain() -> [Part]{
        var oneOfEachPartInAllChainLabel: [Part] = []
            for label in allChainLabels {
               let partChain = LabelInPartChainOut(label).partChain
                for part in partChain {
                    if !oneOfEachPartInAllChainLabel.contains(part) {
                        oneOfEachPartInAllChainLabel.append(part)
                    }
                }
            }
        return oneOfEachPartInAllChainLabel
    }
    
    
    

//MARK: Development
    ///defaults are determined on one depenancy code alteration required for more than one dependancy
    func getLinkedOrParentPart(_ childPart: Part) -> Part {
        var linkedOrParentPart: Part = .objectOrigin
        
        for label in allChainLabels {
            let partChain = LabelInPartChainOut(label).partChain

            for i in 0..<partChain.count {
                if let linkedPart = linkedPartsDictionary[childPart], linkedPart != .notFound {
                    linkedOrParentPart = linkedPart
                } else if childPart == partChain[i] && i != 0 {
                    linkedOrParentPart = partChain[i - 1]
                }
            }
        }
        return linkedOrParentPart
    }

    
    
    func getPartChain(_ label: Part) -> [Part] {
        LabelInPartChainOut(label).partChain
    }
    
    
    func getAllPartChainLabels() -> [Part] {

        guard let chainLabels =
        objectChainLabelsUserEditedDic[objectType] ??
                objectChainLabelsDefaultDic[objectType] else {
            fatalError("there are no partChainLabel for object \(objectType)")
        }
        return chainLabels
    }
    
    mutating func setObjectOriginPartValue() {
        partValuesDic +=
        [.objectOrigin: ZeroValue.partData]
    }
}




//MARK: PART
protocol Parts {
    var stringValue: String { get }
}



//MAARK: PARTDATA
struct PartData {
    var part: Part
    
    var originName: OneOrTwo<String>
    
    var dimensionName: OneOrTwo<String>

    var dimension: OneOrTwo<Dimension3d>
    
    var maxDimension: OneOrTwo<Dimension3d>
    
    var minDimension: OneOrTwo<Dimension3d>
    
    var childOrigin: OneOrTwo<PositionAsIosAxes>
    
    var globalOrigin: OneOrTwo<PositionAsIosAxes>
    
    var minMaxAngle: OneOrTwo<AngleMinMax>
    
    var angles: OneOrTwo<RotationAngles>
    
    var id: OneOrTwo<PartTag>
    
    var sitOnId: Parts
    
    var partsToBeRotated: [Part]
    
  //  var color: Color = .black
    
    init (
        part: Part,
        originName: OneOrTwo<String>,
        dimensionName: OneOrTwo<String>,
        dimension: OneOrTwo<Dimension3d>,
        maxDimension: OneOrTwo<Dimension3d>? = nil,
        minDimension: OneOrTwo<Dimension3d>? = nil,
        origin: OneOrTwo<PositionAsIosAxes>,
        globalOrigin: OneOrTwo<PositionAsIosAxes> =
            .one(one: ZeroValue.iosLocation),
        minMaxAngle: OneOrTwo<AngleMinMax>?,
        angles: OneOrTwo<RotationAngles>?,
        id: OneOrTwo<PartTag>,
        sitOnId: PartTag = .id0,
        scopesOfRotation: [Part] = [] ) {
            self.part = part
            self.originName = originName
            self.dimensionName = dimensionName
            self.dimension = dimension
            self.maxDimension = maxDimension ?? dimension
            self.minDimension = minDimension ?? dimension
            self.childOrigin = origin
            self.globalOrigin = globalOrigin
            
            self.id = id
            self.sitOnId = sitOnId
            self.partsToBeRotated = scopesOfRotation
            self.angles = getAngles()
            self.minMaxAngle = getMinMaxAngle()
            

            func getAngles() -> OneOrTwo<RotationAngles> {
                guard let unwrapped = angles else {
                    return  id.createOneOrTwoWithOneValue(ZeroValue.rotationAngles)
                }
                return unwrapped
            }

            
            func getMinMaxAngle() -> OneOrTwo<AngleMinMax> {
                guard let unwrapped = minMaxAngle else {
                    return  id.createOneOrTwoWithOneValue(ZeroValue.angleMinMax)
                }
                return unwrapped
            }
        }
}


extension PartData {
  func withNewGlobalOrigin(_ newGlobalOrigin: OneOrTwo<PositionAsIosAxes>) -> PartData {
        var updatedPartData = self
      updatedPartData.globalOrigin = newGlobalOrigin
        return updatedPartData
    }
}

///provide proprties for tuple for part-object access to dictionary
struct PartObject: Hashable {
    let part: Part
    let object: ObjectTypes
    
    init (_ part: Part, _ object: ObjectTypes) {
        self.part = part
        self.object = object
    }
}


///provide proprties for tuple for part-id access to dictionary
struct PartId: Hashable {
    let part: Part
    let id: PartTag
    
    init (_ part: Part, _ id: PartTag) {
        self.part = part
        self.id = id
    }
}


enum OneOrTwoOptional <V> {
    case two(left: V?, right: V?)
    case one(one: V?)
    

    func mapOptionalToNonOptionalOneOrTwo<T>(
        _ defaultValueL: T, _ defaultValueR: T? = nil) -> OneOrTwo<T> {

        var optionalToNonOptional: OneOrTwo<T> = setToParameterType(defaultValueL)
        switch self { //assign default to one or left and right if nil
        case .one(let one):
            if let one = one {
                optionalToNonOptional = .one(one: one as! T)
            } else {
                optionalToNonOptional = .one(one: defaultValueL)
            }

        case .two(let left, let right):
            var returnForLeft: T
            var returnForRight: T
            if let left = left {
                returnForLeft = left as! T
            } else {
                returnForLeft = defaultValueL
            }
            if let right = right {
                returnForRight = right as! T
            } else {
                returnForRight = defaultValueR ?? defaultValueL
            }
            optionalToNonOptional =
                .two(left: returnForLeft, right: returnForRight)
        }
        
        return optionalToNonOptional
    }

    private func setToParameterType<T>(_ defaultValue: T) -> OneOrTwo<T> {
        switch defaultValue {
        case is Dimension3d:
            return OneOrTwo.one(one: ZeroValue.dimension3d) as! OneOrTwo<T>
        case is PositionAsIosAxes:
            return OneOrTwo.one(one: ZeroValue.iosLocation) as! OneOrTwo<T>
        case is RotationAngles:
            return OneOrTwo.one(one: ZeroValue.rotationAngles) as! OneOrTwo<T>
        case is String:
            return OneOrTwo.one(one: "") as! OneOrTwo<T>
        case is AngleMinMax:
            return OneOrTwo.one(one: ZeroValue.angleMinMax) as! OneOrTwo<T>
        default:
            fatalError()
        }
    }

    
    func mapValuesToOptionalOneOrTwoAddition(
        _ defaultValue: PositionAsIosAxes,
        _ defaultValueR: PositionAsIosAxes? = nil) -> OneOrTwo <PositionAsIosAxes> {
            let z = ZeroValue.iosLocation
            var modifiedOnOrTwo: OneOrTwo<PositionAsIosAxes> = .one(one: defaultValue)
            switch self {
            case .one (let one ):
                if one == nil {
                    return .one(one: defaultValue)
                } else {
                    let addedOne =
                    CreateIosPosition.addTwoTouples(one as! PositionAsIosAxes, defaultValue)
                    return .one(one: addedOne)
                }
            case .two(let left, let right):
            
                var returnLeft = z
                var returnRight = z
                guard let unwrappedDefault = defaultValueR else {
                    fatalError("no value for right")
                }
                modifiedOnOrTwo =
                    .two(left: defaultValue, right: unwrappedDefault)
                
                if let unwrapped = left {
                    returnLeft = unwrapped as! PositionAsIosAxes
                    returnLeft =  CreateIosPosition.addTwoTouples(returnLeft, defaultValue)
                }
                
                if let unwrapped = right {
                    returnRight = unwrapped as! PositionAsIosAxes
                    returnRight =  CreateIosPosition.addTwoTouples(returnRight, unwrappedDefault)
                }
                
                if left == nil && right != nil {
                    modifiedOnOrTwo = .two(left: defaultValue, right: returnRight)
                }
                
                if left != nil && right == nil {
                    modifiedOnOrTwo = .two(left: returnLeft, right: unwrappedDefault)
                }
                
                if left != nil && right != nil {
                    modifiedOnOrTwo = .two(left: returnLeft, right: returnRight)
                }
            }
            return  modifiedOnOrTwo
        }

    
    func isNotNil() -> V? {
        switch self {
        case .one (let one):
            if let value = one {
                return value
            } else {
                return nil
            }
        case .two (let left, let right):
            if left == nil && right == nil {
                return nil
            } else {
                if left == nil {
                   return right
                } else {
                    return left
                }
            }
        }
    }
    
    
    func mapBeforeToNilAndAfterToNonNil(
        _ before: PositionAsIosAxes,
        _ after: PositionAsIosAxes) -> OneOrTwo<PositionAsIosAxes>{
            switch self{
            case .one:
                return .one(one: after)
            case .two (let left, let right):
                let returnForLeft = left == nil ? before: after
                let returnForRight = right == nil ? before: after
                return .two(left: returnForLeft, right: returnForRight)
            }
    }
    


    func mapOptionalToNonOptionalOneOrTwoOrigin(_ defaultValue: OneOrTwo<PositionAsIosAxes>) -> OneOrTwo<PositionAsIosAxes> {
        
    

        switch self { //assign default to one or left and right if nil
        case .one(let one):
            if let one {
                return .one(one: one as! PositionAsIosAxes )
            } else {
               return defaultValue
            }

        case .two(let left, let right):
            var leftDefault: PositionAsIosAxes = ZeroValue.iosLocation
            var rightDefault: PositionAsIosAxes = ZeroValue.iosLocation
            switch defaultValue{
                case .two( let left, let right):
                leftDefault = left
                rightDefault = right
                default:
                    break
            }
            
            var returnForLeft: PositionAsIosAxes
            var returnForRight: PositionAsIosAxes
            if let left {
                returnForLeft = left as! PositionAsIosAxes
            } else {
                returnForLeft = leftDefault
            }
            if let right {
                returnForRight = right as! PositionAsIosAxes
            } else {
                returnForRight = rightDefault
            }
            return .two(left: returnForLeft, right: returnForRight)
        }

    }
}

///representing  OneOrTwo when either of Two is removed
///transform to .one(one: id) where id indicates left or right
///-id of .one must always be read/  reprentativeness of double-sidedness is weaker  , + no nil simplifies
///or to nil left or right
///nil is more complex code,  representativeness of double-sidedness is stronger, .one is always .id0



enum OneOrTwo <T> {
    case two (left: T, right: T)
    case one (one: T)
    
    
    
    
//    func mapOriginalValueToSomePropertyComponent<U>(
//        _ oneOrTwoOriginal: OneOrTwo<U>,
//        _ propertyToBeEdited: PartTag) -> OneOrTwo<PositionAsIosAxes>{
//        let z: PositionAsIosAxes = ZeroValue.iosLocation
//        let originalAsTouple = oneOrTwoOriginal.mapToTouple()
//        switch self {
//        case .two(let left , let right  ):
//            var leftReturn = z
//            var rightReturn = z
//            let leftOriginal = originalAsTouple.left as! PositionAsIosAxes
//            let rightOriginal = originalAsTouple.right as! PositionAsIosAxes
//            if propertyToBeEdited == .xOrigin {
//                leftReturn = (x: (left as! PositionAsIosAxes).x, y:leftOriginal.y, z: leftOriginal.z)
//                rightReturn = (x: (right as! PositionAsIosAxes).x, y:leftOriginal.y, z: leftOriginal.z)
//            }
//            return .two(left: leftReturn, right: rightReturn)
//        case .one(let one):
//            return .one(one: one as! PositionAsIosAxes)
//        }
//            
//
//    }
    
    //MARK: DEVELOPMENT
    ///a One parent is  mapped to left and right
    /// a Two parent is not mapped to one as two sided to one sided is not yet implemented
    func mapToTouple () -> (one: T?, left: T, right: T) {
        switch self {
        case .one (let one):
            return (one: one, left: one , right: one)
        case .two(let left, let right):
            return (one: nil, left: left, right: right)
        }
    }
    
    func mapDefaultToOneOrTwo(_ defaultValue: PositionAsIosAxes) -> OneOrTwo<PositionAsIosAxes>{
        let symmetryValue = CreateIosPosition.getLeftFromRight(defaultValue)
        switch self {
        case .one (let one):
            let id = one as! PartTag
            let valueAdjustedForSymmetry = id == .id0 ? symmetryValue: defaultValue
            return .one(one: valueAdjustedForSymmetry)
        case .two:
            return .two(left: symmetryValue,
                        right: defaultValue)
        }
    }
    
    
    //MARK: CHANGE TO AVERAGE
    func mapOneOrTwoToOneOrLeftValue() -> T {
        switch self {
        case .one (let one):
            return one
        case .two (let left, let right):
            return left
        }
    }
    
    func mapOneOrTwoToOneOrRightValue() -> T {
        switch self {
        case .one (let one):
            return one
        case .two (let left, let right):
            return right
        }
    }
    
    func returnValue(_ id: PartTag) -> T {
        switch self {
        case .one (let one):
           // if id == .id0 {
                return one
           // } else {
//            fatalError(" passed a non-id0 to one") }
            
        case .two (let left, let right):
            let value = id == .id0 ?  left: right
            
            return value
        }
    }
    
    
    func mapOneOrTwoToSide() -> [SidesAffected] {
        switch self {
        case .one (let one):
            if PartTag.id0 == one as! PartTag {
                return [.left]
            } else {
                return [.right]
            }
        case .two:
            return [ .both, .left, .right]
        }
    }
    
    func getOneOrTWoDictionaryOrUseDefaultOrgin(  _ positions: [PositionAsIosAxes?]) -> OneOrTwo<PositionAsIosAxes> {
        switch self {//
        case let (.two(left, right) ):
            var leftPosition: PositionAsIosAxes
            if let position = positions[0] {
                leftPosition = position
            } else {
                leftPosition = left as! PositionAsIosAxes
            }
            var rightPosition: PositionAsIosAxes
            if let position = positions[1] {
                rightPosition = position
            } else {
                rightPosition = right as! PositionAsIosAxes
            }
            return .two(left: leftPosition, right: rightPosition)
        case let (.one(one)):
            var onePosition: PositionAsIosAxes
            if let position = positions[0] {
                onePosition = position
            } else {
                onePosition = one as! PositionAsIosAxes
            }
            return .one(one: onePosition)
        }
    }    
    
    
    func getOneOrTwoDictionaryOrUseDefaultOrgin2(  _ positions: [[PositionAsIosAxes]?]) -> OneOrTwo<[PositionAsIosAxes]> {
        switch self {//
        case let (.two(left, right) ):
            var leftPosition: [PositionAsIosAxes]
            if let position = positions[0] {
                leftPosition = position
            } else {
                leftPosition = left as! [PositionAsIosAxes]
            }
            var rightPosition: [PositionAsIosAxes]
            if let position = positions[1] {
                rightPosition = position
            } else {
                rightPosition = right as! [PositionAsIosAxes]
            }
            return .two(left: leftPosition, right: rightPosition)
        case let (.one(one)):
            var onePosition: [PositionAsIosAxes]
            if let position = positions[0] {
                onePosition = position
            } else {
                onePosition = one as! [PositionAsIosAxes]
            }
            return .one(one: onePosition)
        }
    }
    
    func getNamesArray(  _ part: Part) -> [String] {
        var names: [String] = []
        switch (self) {
        case let (.two(left0, right0) ):
           names =
            [CreateNameFromIdAndPart(left0 as! PartTag, part).name,
             CreateNameFromIdAndPart(right0 as! PartTag, part).name]
        case let (.one(one0)):
            names =
            [CreateNameFromIdAndPart(one0 as! PartTag, part).name]
        }
        return names
    }
    
    func getDictionaryValue(_ dictionary: [String: PositionAsIosAxes ])
    -> OneOrTwo<PositionAsIosAxes>{
        switch self {
        case .two(let left, let right):
            return .two(left: getValues(left), right: getValues(right))
        case .one(let one):
              return .one(one: getValues(one))
        }
        
        func getValues(_ name: T) -> PositionAsIosAxes{
            guard let name = name as? String else {
                fatalError("cannot downcast to String")
            }
            guard let values = dictionary[name] else {
                fatalError("no dictionary entry")
            }
            return values
        }
    }
    
    func getDictionaryValues(_ dictionary: [String: [PositionAsIosAxes] ])
    -> OneOrTwo<[PositionAsIosAxes]>{
        switch self {
        case .two(let left, let right):
            return .two(left: getValues(left), right: getValues(right))
        case .one(let one):
              return .one(one: getValues(one))
        }
        
        func getValues(_ name: T) -> [PositionAsIosAxes]{
            guard let name = name as? String else {
                fatalError("cannot downcast to String")
            }
            guard let values = dictionary[name] else {
                fatalError("no dictionary entry")
            }
            return values
        }
    }
    
    
    func getPositionsArray(  _ part: Part) -> [PositionAsIosAxes] {
        var positions: [PositionAsIosAxes] = []
        switch (self) {
        case let (.two(left0, right0)):
           positions =
            [left0 as! PositionAsIosAxes,
             right0 as! PositionAsIosAxes]
        case let (.one(one0)):
            positions =
            [one0 as!PositionAsIosAxes]
    
        }
        return positions
    }
    
    
    
//    func createNameOriginEntry<U>(_ ids: OneOrTwo<U>,  _ part: Part) -> [String: PositionAsIosAxes] {
//        var entries: [String: PositionAsIosAxes] = [:]
//        switch (self, ids) {
//        case let (.two(left0, right0), .two ):
//           entries =
//            [CreateNameFromIdAndPart(.id0, part).name: left0 as! PositionAsIosAxes,
//             CreateNameFromIdAndPart(.id1, part).name: right0 as! PositionAsIosAxes]
//        case let (.one(one0), .one(id)):
//            entries =
//            [CreateNameFromIdAndPart(id as! PartTag, part).name: one0 as!PositionAsIosAxes]
//        default:
//            fatalError("OneOrTwo properties for same part ar different cases \(part)")
//          
//        }
//        return entries
//    }
    
    
    func createOneOrTwoWithOneValue<U>(_ value: U) -> OneOrTwo<U> {
        switch self {
        case .one:
            return .one(one: value)
        case .two:
            return .two(left: value, right: value)
        }
    }
    
    var one: T? {
        switch self {
        case .two:
            return nil
        case .one(let one):
            return one
        }
    }
    
    
    func adjustForTwoToOneId() -> OneOrTwo<T> {
        switch self {
        case .one:
            return self
        case .two (let left, let right):
            //if equal then the values are not user edited
            if left as! PositionAsIosAxes == right as! PositionAsIosAxes {
                return .two(left:
                                CreateIosPosition.getLeftFromRight(right as! PositionAsIosAxes) as! T,
                            right: right)
            } else {
                return .two(left: left, right: right)
            }
        }
    }

    func applySymmetry() -> OneOrTwo<T>{
        
        switch self {
        case .one:
            return self
        case .two (let left, let right):
            
            return .two(left: CreateIosPosition.getLeftFromRight(left as! PositionAsIosAxes ) as! T , right: right )
        }

    }
    
    
    
    func getOneOrTwoCornerArrayFromDimension<U>(_ transform: (T) -> U) -> OneOrTwo<U> {
        switch self {
        case .one(let value):
            return .one(one: transform(value))
        case .two(let left, let right):
            return .two(left: transform(left), right: transform(right))
        }
    }
    
    
    func addOneOrTwoPair<U>(_ second: OneOrTwo<U>) -> OneOrTwo<[PositionAsIosAxes]> {
        switch (self, second) {
        case let (.two(left1 , right1), .two(left2 , right2)  ):
            return .two(left: makeAddition(left1, left2 ), right: makeAddition(right1, right2 ) )
        case let (.one( one1), .one(one2)):
            return .one(one: makeAddition(one1, one2 ))
        default:
         fatalError("cases are not matched")
        }
        
    
        func makeAddition<V>(_ positions: V, _ origin: U) -> [PositionAsIosAxes] {
            guard let positions = positions as? [PositionAsIosAxes] else {
                fatalError("something has gone wrong should be PositionAsIosAxes")
            }
            guard let origin = origin as? PositionAsIosAxes else {
                fatalError("something has gone wrong should be PositionAsIosAxes")
            }
            return
                CreateIosPosition.addToupleToArrayOfTouples(origin, positions )
        }
    }
    
    func getDefaultOrRotatedCorners<U>(
        _ defaultValues: OneOrTwo<[PositionAsIosAxes]>,
        _ postValues: OneOrTwo<U>,
        _ originsPostTilt: OneOrTwo<PositionAsIosAxes>) {
            switch (self, defaultValues, postValues, originsPostTilt) {
            case let (.two(leftTruth, rightTruth), .two(leftDefautl, rightDefault), .two(leftPostValue, rightPostValue), .two(leftOrigin, rightOrigin ) ):
                print("")
            case let (.one(oneTruth), .one(oneDefault), .one(onePostValue), .one(oneOrigin)):
                print("")
            default:
                fatalError("oneOrTwo do not match case")
            }
            
            func getResult(
                _ truth: T,
                _ defaultValue: [PositionAsIosAxes],
                _ postValue: [PositionAsIosAxes],
                _ origin: PositionAsIosAxes) -> OneOrTwo<[PositionAsIosAxes]>{
                    guard let truth = truth as? Bool else {
                        fatalError()
                    }
                    
                    if truth {
                        return defaultValues
                    } else {
                        let negativeOrginsPostTilt = originsPostTilt.negateOneOrTwoValues()
                        let cornersInLocalPostTilt = postValues.addToOneOrTwo(negativeOrginsPostTilt)
                        return cornersInLocalPostTilt
                    }
                    
            }
        }
    
    
    func areEqual<U>(_ postValues:OneOrTwo<U>) -> OneOrTwo<Bool> {
        switch (self, postValues) {
        case let (.two(left1 , right1), .two(left2 , right2)  ):
            return .two(left: areEqual(left1, left2), right: areEqual(right1, right2))
        case let (.one( one1), .one(one2)):
            return .one(one: areEqual(one1, one2))
        default:
            fatalError("dictionaries have different OneOrTwo")
        }
        
        func areEqual(_ preValue: T, _ postValue: U) -> Bool{
            guard let preValue = preValue as? PositionAsIosAxes
                   else {
                fatalError("cannot downcast")
            }
            guard let postValue = postValue as? PositionAsIosAxes
                   else {
                fatalError("cannot downcast")
            }
            return preValue.y == postValue.y
        }
    }
    func negateOneOrTwoValues() -> OneOrTwo<PositionAsIosAxes>{
        switch self {
        case .two(let left, let right):
            let leftResult = subtractFromZero(left)
            let rightResult = subtractFromZero(right)
            return .two(left: leftResult, right: rightResult)
        case .one(let one):
            let oneResult = subtractFromZero(one)
            return .one(one: oneResult)
        }
        func subtractFromZero(_ position: T) -> PositionAsIosAxes {
            guard let position = position as? PositionAsIosAxes else {
                fatalError("cannot downcast to ")
            }
            return
                CreateIosPosition.subtractSecondFromFirstTouple(ZeroValue.iosLocation, position)
        }
    }
    
    func addToOneOrTwo(_ origins: OneOrTwo<PositionAsIosAxes>) -> OneOrTwo<[PositionAsIosAxes]> {
        switch (self, origins) {
        case let(.two(left1 , right1 ), .two(left2, right2)):
                    return .two(left: makeAddition(left1, left2 ), right: makeAddition(right1, right2 ) )
        case let(.one(one1), .one(one2) ):
                    return .one(one: makeAddition(one1, one2 ))
          default:
                fatalError()
                  
        }
        
        
        func makeAddition<U, V>(_ positions: V, _ origins: U) -> [PositionAsIosAxes] {
            guard let position = positions as? [PositionAsIosAxes] else {
                fatalError("something has gone wrong should be PositionAsIosAxes")
            }
            guard let origin = origins as? PositionAsIosAxes else {
                fatalError("something has gone wrong should be PositionAsIosAxes")
            }
            return
                CreateIosPosition.addToupleToArrayOfTouples(origin, position )
        }
    }
    
    func mapOneOrTwoSingleWithFunc< U>(  _ transform: (T) -> U) -> OneOrTwo<U> {
        switch self {
        case let (.one(value1)):
            return .one(one: transform(value1))
        case let (.two(left1, right1)):
            return .two(
                left: transform(left1),
                right: transform(right1))
        }
    }
    
    
    func mapPairOfOneOrTwoWithFunc<U, V>(
        _ second: OneOrTwo<V>,
        _ transform: (T, V) -> U)
    -> OneOrTwo<U> {
        switch (self, second) {
        case let (.one(value1), .one(value2)):
            return .one(one: transform(value1, value2))
            
        case let (.two(left1, right1), .two(left2, right2)):
            return .two(left: transform(left1, left2), right: transform(right1, right2))
        default:
            // Handle other cases if needed
            fatalError("Incompatible cases for map2")
        }
    }

    
    func mapOneOrTwoPairWithFunc<V, U>( _ second: OneOrTwo<V>, _ transform: (T, V) -> U) -> OneOrTwo<U> {
        let (first,second) = OneOrTwo<Any>.convert2OneOrTwoToAllTwoIfMixedOneAndTwo(self, second)
        switch (first, second) {
        case let (.one(value1), .one(value2)):
            return .one(one: transform(value1, value2))
        case let (.two(left1, right1), .two(left2, right2)):
            return .two(
                        left: transform(left1, left2),
                        right: transform(right1, right2))
        default:
            // Handle other cases if needed
            fatalError("Incompatible cases for map3")
        }
    }
    

    func mapTripleOneOrTwoWithFunc<V, W, U>( _ second: OneOrTwo<V>, _ third: OneOrTwo<W>,_ transform: (T, V, W) -> U) -> OneOrTwo<U> {

       let (first,second, third) = convert3OneOrTwoToAllTwoIfMixedOneAndTwo(self, second, third)
        switch (first, second, third) {
        case let (.one(value1), .one(value2), .one(value3)):
            return .one(one: transform(value1, value2, value3))
        case let (.two(left1, right1), .two(left2, right2), .two(left3, right3)):
            return .two(
                        left: transform(left1, left2, left3),
                        right: transform(right1, right2, right3))
        default:
            // Handle other cases if needed
            fatalError("Incompatible cases for map3")
        }
    }

    
    func oneNotTwo()->Bool {
        switch self {
        case .one:
            return true
        case .two:
            return false
        }
    }
    
    
    func mapOneOrTwoToOneOrTwo(_ origin: [PositionAsIosAxes]) -> OneOrTwo<PositionAsIosAxes> {
        switch self {
        case .two:
            return .two(left: origin[0], right: origin[1])
        case .one:
            return .one(one: origin[0])
        }
    }
    
    
    func mapTwoToOneUsingOneId<Dimension3d>(_ id: PartTag) -> OneOrTwo<Dimension3d> {
        switch self {
        case .two(let left, let right):
            return id == .id0 ? .one(one: left as! Dimension3d): .one(one: right as! Dimension3d )
        case .one:
           fatalError("only .two may be used")
        }
    }
    
    
    ///if the child has one and the parent has two then the child should use the relevant
    ///parent based on its id
  static func convert2OneOrTwoToAllTwoIfMixedOneAndTwo<U, V>(
        _ value1: OneOrTwo<U>,
        _ value2: OneOrTwo<V>
    ) -> (OneOrTwo<U>, OneOrTwo<V>) {
        switch (value1, value2) {
        case let (.one(oneValue), .two):
            return (.two(left: oneValue, right: oneValue), value2)
        case let (.two, .one(oneValue)):
            return (value1, .two(left: oneValue, right: oneValue))
        default:
            return (value1, value2)
        }
    }
    
    
    func convert3OneOrTwoToAllTwoIfMixedOneAndTwo<U, V, W>(
        _ value1: OneOrTwo<U>,
        _ value2: OneOrTwo<V>,
        _ value3: OneOrTwo<W>)
    -> (OneOrTwo<U>, OneOrTwo<V>, OneOrTwo<W>) {
        switch (value1, value2, value3) {
        case let (.one(oneValue), .two, .two):
            return ( .two(left: oneValue, right: oneValue), value2, value3)
        case let (.two, .one(oneValue), .two):
            return (value1, .two(left: oneValue, right: oneValue), value3)
        case let (.one(firstOneValue), .two, .one(secondOneValue)):
            return (.two(left: firstOneValue, right: firstOneValue), value2, .two(left: secondOneValue, right: secondOneValue))
        case let (.two, .two, .one(oneValue)):
            return (value1, value2, .two(left: oneValue, right: oneValue))
        default:
            return (value1, value2, value3)
        }
    }
    
    
    
    func mapWithDoubleOneOrTwoWithOneOrTwoReturn(
        _ value0: OneOrTwo<PositionAsIosAxes>)
    -> OneOrTwo<PositionAsIosAxes> {
        switch (self, value0) {
        case let (.two (left0, right0) , .two(left1, right1)):
            let leftAdd = left0 as! PositionAsIosAxes + left1
            let rightAdd = right0 as! PositionAsIosAxes + right1
            return .two(left: leftAdd, right: rightAdd)
        case let (.one( one0), .one(one1)):
            let oneAdd = one0 as! PositionAsIosAxes + one1
            return .one(one: oneAdd)
        default:
            fatalError("\n\n\(String(describing: type(of: self))): \(#function ) a problem exists with one or both of the OneOrTwo<PositionAsIosAxes>)")
        }
    }

    func mapFiveOneOrTwoToOneFuncWithVoidReturn(
         _ value1: OneOrTwo<String>,
         _ value2: OneOrTwo<RotationAngles>,
         _ value3: OneOrTwo<AngleMinMax>,
         _ value4: OneOrTwo<PositionAsIosAxes>,
         _ transform: (Dimension3d, String, RotationAngles, AngleMinMax, PositionAsIosAxes)  -> ()) {
             
          //   print("\(value1), \(value2), \(value3), \(value4) ")
         switch (self, value1, value2, value3, value4) {
         case let (.one(one0), .one(one1), .one(one2), .one(one3), .one(one4)):
             transform(one0 as! Dimension3d, one1, one2, one3, one4)
         
         
         case let (.two(left0, right0), .two(left1, right1), .two(left2, right2), .two(left3, right3), .two(left4, right4) ):
             transform(left0 as! Dimension3d, left1, left2, left3, left4)
             transform(right0 as! Dimension3d, right1, right2, right3, right4)
         default:
              fatalError("\n\n\(String(describing: type(of: self))): \(#function ) the fmap has either one globalPosition and two id or vice versa for \(value1)")
         }
     }
    
    func mapSixOneOrTwoToOneFuncWithVoidReturn(
         _ value1: OneOrTwo<String>,
         _ value2: OneOrTwo<RotationAngles>,
         _ value3: OneOrTwo<AngleMinMax>,
         _ value4: OneOrTwo<PositionAsIosAxes>,
         _ value5: OneOrTwo<PositionAsIosAxes>,
         _ transform: (Dimension3d, String, RotationAngles, AngleMinMax, PositionAsIosAxes, PositionAsIosAxes)  -> ()) {
             
          //   print("\(value1), \(value2), \(value3), \(value4) ")
         switch (self, value1, value2, value3, value4, value5) {
         case let (.one(one0), .one(one1), .one(one2), .one(one3), .one(one4), .one(one5)):
             transform(one0 as! Dimension3d, one1, one2, one3, one4, one5)
         
         
         case let (.two(left0, right0), .two(left1, right1), .two(left2, right2), .two(left3, right3), .two(left4, right4), .two(left5, right5) ):
             transform(left0 as! Dimension3d, left1, left2, left3, left4, left5)
             transform(right0 as! Dimension3d, right1, right2, right3, right4, right5)
         default:
             break
//              fatalError("\n\n\(String(describing: type(of: self))): \(#function ) the fmap has either one globalPosition and two id or vice versa for \(value1)")
         }
     }
}




struct StructFactory {
    let objectType: ObjectTypes
    var partData: PartData = ZeroValue.partData
    let linkedOrParentData: PartData
    let part: Part
    let parentPart: Part
    let allChainLabels: [Part]
    let defaultOrigin: PartEditedElseDefaultOrigin
    let userEditedData: UserEditedData
    var partOrigin: OneOrTwo<PositionAsIosAxes> = .one(one: ZeroValue.iosLocation)
    var partDimension: OneOrTwo<Dimension3d> = .one(one: ZeroValue.dimension3d)

    // Designated initializer for common parts
    init(_ objectType: ObjectTypes,
         _ userEditedDic: UserEditedDictionaries?,
         _ linkedOrParentData: PartData,
         _ part: Part,
         _ allChainLabels: [Part]){
        self.objectType = objectType
        self.linkedOrParentData = linkedOrParentData
        self.part = part
        self.parentPart = linkedOrParentData.part
        self.allChainLabels = allChainLabels
        let sitOnId: PartTag = .id0
        
//        if part == .fixedWheelAtRearWithPropeller {
//            print("struct linkedPart \(linkedOrParentData.originName)")
//        }

        userEditedData =
            UserEditedData(
                objectType,
                userEditedDic,
                sitOnId,
                part)
        
   
        
        let defaultDimensionData =
                PartDefaultDimension(
                    part,
                    objectType,
                    linkedOrParentData,
                    userEditedData.optionalDimension)
        
//        if part == .fixedWheelAtRearWithPropeller {
//            print("userEditedData.optionalDimension")
//            print (userEditedData.optionalDimension)
//        }
        
        let defaultDimensionOneOrTwo =
                defaultDimensionData.userEditedDimensionOneOrTwo
    
        defaultOrigin =
            PartEditedElseDefaultOrigin(
                part,
                objectType,
                linkedOrParentData,
                defaultDimensionOneOrTwo,
                userEditedData.partIdAllowingForUserEdit,
                userEditedData.optionalOrigin)
        
        setChildDimensionForPartData()
        setChildOriginForPartData()
        setPartData()

        func setChildDimensionForPartData() {
            partDimension = defaultDimensionOneOrTwo
        }
        
        
        func setChildOriginForPartData() {
            partOrigin = defaultOrigin.editedElseDefaultOriginOneOrTwo
        }

        
        func setPartData() {
            partData = createPart()
        }
       
    }

   
    init(_ objectType: ObjectTypes,
         _ userEditedDic: UserEditedDictionaries?,
         independantPart childPart: Part) {
        let linkedOrParentData = ZeroValue.partData
        let noChainLabelRequired: [Part] = []
        self.init(
            objectType,
            userEditedDic,
            linkedOrParentData,
            childPart,
            noChainLabelRequired
        )
        
        partData = createSitOn()
     
    }

    // Convenience initializer for parts in general
    init(
        _ objectType: ObjectTypes,
         _ userEditedDic: UserEditedDictionaries?,
         _ linkedOrParentData: PartData,
         dependantPart childPart: Part,
         _ chainLabel: [Part]
    ) {
     
        self.init(
            objectType,
            userEditedDic,
            linkedOrParentData,
            childPart,
            chainLabel)
        
    }
}





extension StructFactory {
    func createSitOn()
        -> PartData {
        let sitOnName: OneOrTwo<String> = .one(one: "object_id0_sitOn_id0_sitOn_id0")
            //print(defaultOrigin.userEditedOriginOneOrTwo)
        return
            PartData(
                part: .mainSupport,
                originName:sitOnName,
                dimensionName: sitOnName,
                dimension: partDimension,
                origin: defaultOrigin.editedElseDefaultOriginOneOrTwo,
                minMaxAngle: nil,
                angles: nil,
                id: .one(one: PartTag.id0) )
    }

    
    func createPart()
        -> PartData {
        let partId = userEditedData.partIdAllowingForUserEdit//two sided default edited to one will be detected
        let scopesOfRotation: [Part] =  getChainLabelsSubjectToRotator()
        var partAnglesMinMax = partId.createOneOrTwoWithOneValue(ZeroValue.angleMinMax)
        var partAngles = partId.createOneOrTwoWithOneValue(ZeroValue.rotationAngles)
        let originName =
            userEditedData.originName.mapOptionalToNonOptionalOneOrTwo("")
     

            if [.sitOnTiltJoint, .backSupportTiltJoint].contains(part) {
            let (jointAngle, minMaxAngle) = getDefaultJointAnglesData()
            partAngles = getAngles(jointAngle)
            partAnglesMinMax = getMinMaxAngles(minMaxAngle)
        }
 

        return
            PartData(
                part: part,
                originName: originName,
                dimensionName: originName,
                dimension: partDimension,
                maxDimension: partDimension,
                origin: partOrigin,
                globalOrigin: .one(one: ZeroValue.iosLocation),//postProcessed
                minMaxAngle: partAnglesMinMax,
                angles: partAngles,
                id: partId,
                scopesOfRotation: scopesOfRotation)
            
            
        func getChainLabelsSubjectToRotator() -> [Part]{
            
            let chainLabelsToBeRotated =
                PartInRotationScopeOut(
                    part,
                    allChainLabels)
                        .rotationScopeAllowingForEditToChainLabel
//            if chainLabelsToBeRotated != [] {
//                print("\(part) \(chainLabelsToBeRotated)")
//                print("")
//            }
            return chainLabelsToBeRotated
            
            
            func getPartSubjecToRotation() -> [Part] {
                var partsToBeRotated: [Part] = []
                for chainLabel in chainLabelsToBeRotated {
                    partsToBeRotated += //ignore first part which is the origin
                        Array(LabelInPartChainOut(chainLabel).partChain.dropFirst())
                }
                return partsToBeRotated
            }
        }
         
            
        func getDefaultJointAnglesData() -> (RotationAngles, AngleMinMax){
            let  partDefaultAngle = PartDefaultAngle(part, objectType)
            return (partDefaultAngle.angle, partDefaultAngle.minMaxAngle)
        }


            
        func getAngles(
            _ defaultAngles: RotationAngles) -> OneOrTwo<RotationAngles> {
                userEditedData.optionalAngles.mapOptionalToNonOptionalOneOrTwo(defaultAngles)
        }
            
            
        func getMinMaxAngles(
            _ defaultAngles: AngleMinMax) -> OneOrTwo<AngleMinMax>{
                userEditedData.optionalAngleMinMax.mapOptionalToNonOptionalOneOrTwo(defaultAngles)
        }
    }
}



extension Array where Element == PartData {
    func getElement(withPart part: Part) -> PartData {
        if let element = self.first(where: { $0.part == part }) {
            return element
        } else {
            fatalError("StructFactory: \(#function) Element with part \(part) not found in [OneOrTwoGenericPartValue]: \(self)].")
        }
    }
}



extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}


enum DictionaryVersion {
    case useCurrent
    case useInitial
    case useLoaded
    case useDimension
}
                          





//MARK: UIEditedDictionary
///parts edited by the UI are stored in dictionary
///these dictiionaries are used for parts,
///where extant, instead of default values
///during intitialisation
///partChainId  are wrapped in OneOrTwo
struct UserEditedDictionaries {
    //relating to Part
    var dimensionUserEditedDic: Part3DimensionDictionary
    
    var angleUserEditedDic: AnglesDictionary
    var angleMinMaxDic: AngleMinMaxDictionary
    
    //relating to Object
//    var parentToPartOriginUserEditedDicNew: [PartId: PositionAsIosAxes]
    var originOffsetUserEditedDic: PositionDictionary
    var parentToPartOriginUserEditedDic: PositionDictionary
    var parentToPartOriginOffsetUserEditedDic: PositionDictionary
    var objectToPartOrigintUserEditedDic: PositionDictionary

    
    //relating to ObjectImage
    var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>]
    var objectChainLabelsUserEditDic: ObjectChainLabelDictionary
   
    static var shared = UserEditedDictionaries()
    
   private init(
        dimension: Part3DimensionDictionary  =
            [:],
        origin: PositionDictionary =
            [:] ,
        parentToPartOriginUserEditedDic: PositionDictionary = [:],
        parentToPartOriginOffsetUserEditedDic: PositionDictionary = [:],
//        parentToPartOriginUserEditedDicNew: [PartId: PositionAsIosAxes] = [:],
        objectToParOrigintUserEditedDic: PositionDictionary = [:],
        originOffsetUserEditedDic: PositionDictionary = [:],
        anglesDic: AnglesDictionary =
            [:],
        angleMinMaxDic: AngleMinMaxDictionary =
            [:],
        partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] =
            [:],
        objectChainLabelsUserEditDic: ObjectChainLabelDictionary =
            [:]) {
        
        self.dimensionUserEditedDic = dimension
   
        self.parentToPartOriginUserEditedDic = parentToPartOriginUserEditedDic
        self.parentToPartOriginOffsetUserEditedDic = parentToPartOriginUserEditedDic
//        self.parentToPartOriginUserEditedDicNew = parentToPartOriginUserEditedDicNew
        self.objectToPartOrigintUserEditedDic = objectToParOrigintUserEditedDic
        self.originOffsetUserEditedDic = originOffsetUserEditedDic
        self.angleUserEditedDic =
            anglesDic
        self.angleMinMaxDic =
            angleMinMaxDic
        self.partIdsUserEditedDic =
            partIdsUserEditedDic
        self.objectChainLabelsUserEditDic = objectChainLabelsUserEditDic
    }
}




///All dictionary are input in userEditedDictionary
///The optional  values associated with a part are available
///dimension
///origin
///The non-optional id are available
///All values are wrapped in OneOrTwoValues
struct UserEditedData {
    let dimensionUserEditedDic: Part3DimensionDictionary
    let parentToPartOriginUserEditedDic: PositionDictionary
    let parentToPartOriginOffsetUserEditedDic: PositionDictionary
    let objectToPartOrigintUserEditedDic: PositionDictionary
    let angleUserEditedDic: AnglesDictionary
    let angleMinMaxDic: AngleMinMaxDictionary
    let partIdDicIn: [Part: OneOrTwo<PartTag>]
    let part: Part
    let sitOnId: PartTag
    
    var originName:  OneOrTwoOptional <String> = .one(one: nil)
    var optionalAngles: OneOrTwoOptional <RotationAngles> = .one(one: nil)
    var optionalAngleMinMax: OneOrTwoOptional <AngleMinMax> = .one(one: nil)
    var optionalDimension: OneOrTwoOptional <Dimension3d> = .one(one: nil)
    var optionalOrigin: OneOrTwoOptional <PositionAsIosAxes> = .one(one: nil)
    var partIdAllowingForUserEdit: OneOrTwo <PartTag>
    
    init(
        _ objectType: ObjectTypes,
        _ userEditedDic: UserEditedDictionaries?,
        _ sitOnId: PartTag,
        _ part: Part) {
            self.sitOnId = sitOnId
            self.part = part
            dimensionUserEditedDic =
            userEditedDic?.dimensionUserEditedDic ?? [:]
            parentToPartOriginUserEditedDic =
            userEditedDic?.parentToPartOriginUserEditedDic ?? [:]
            parentToPartOriginOffsetUserEditedDic =
            userEditedDic?.parentToPartOriginOffsetUserEditedDic ?? [:]

            objectToPartOrigintUserEditedDic =
            userEditedDic?.objectToPartOrigintUserEditedDic ?? [:]
            angleUserEditedDic =
            userEditedDic?.angleUserEditedDic ?? [:]
            angleMinMaxDic =
            userEditedDic?.angleMinMaxDic ?? [:]
            partIdDicIn =
            userEditedDic?.partIdsUserEditedDic ?? [:]

            partIdAllowingForUserEdit = //non-optional as must iterate through id
            partIdDicIn[part] ?? //UI edit:.two(left:.id0,right:.id1)<->.one(one:.id0) ||.one(one:.id1)
            OneOrTwoId(objectType, part).forPart // default
                        
            
          

            
            originName = getOriginName(partIdAllowingForUserEdit)
                                       
           optionalOrigin = getOptionalOrigin()

            optionalAngleMinMax =
            getOptionalValue(partIdAllowingForUserEdit, from: angleMinMaxDic) { part in
                return CreateNameFromParts([Part.mainSupport, sitOnId, part]).name }
            
            optionalAngles = getOptionalAngles()
            optionalDimension = getOptionalDimension()
            
//            if part == .backSupportTiltJoint {
//                print("Edited Dic")
//                print (optionalAngles)
//                print("")
//            }
        }
    
    
    func getOriginName(_ partId: OneOrTwo<PartTag>)
    -> OneOrTwoOptional<String>{
        let start: [Parts] = [Part.objectOrigin, PartTag.id0, PartTag.stringLink, part]
        let end: [Parts] = [PartTag.stringLink, Part.mainSupport,  sitOnId]
        
        switch partId {
        case .one(let one):
            return
                .one(one: CreateNameFromParts(start + [one] + end).name)
        case .two(let left, let right):
            return
                .two(
                    left: CreateNameFromParts(start + [left] + end).name,
                    right:  CreateNameFromParts(start + [right] + end).name)
        }
    }
    
    
    func getOptionalAngles() -> OneOrTwoOptional<RotationAngles>{
        var angles: OneOrTwoOptional<RotationAngles> = .one(one: nil)
        switch originName.mapOptionalToNonOptionalOneOrTwo("") {
        case .one(let one):
            angles =
                .one(one: angleUserEditedDic[one ] )
        case .two(let left, let right):
            angles =
                .two(left: angleUserEditedDic[ left ], right: angleUserEditedDic[right ] )
        }
        return angles
    }
    
    func getOptionalDimension() -> OneOrTwoOptional<Dimension3d>{
        var dimension: OneOrTwoOptional<Dimension3d> = .one(one: nil)
//        if part == .footSupportHangerLink {
//            print(originName.mapOptionalToNonOptionalOneOrTwo(""))
//        }
        switch originName.mapOptionalToNonOptionalOneOrTwo("") {
        case .one(let one):
            dimension =
                .one(one: dimensionUserEditedDic[one ] )
        case .two(let left, let right):
            dimension =
                .two(left: dimensionUserEditedDic[ left ], right: dimensionUserEditedDic[right ] )
        }
        return dimension
    }
    
    func getOptionalOrigin() -> OneOrTwoOptional<PositionAsIosAxes>{
        var origin: OneOrTwoOptional<PositionAsIosAxes> = .one(one: nil)
        switch originName.mapOptionalToNonOptionalOneOrTwo("") {
        case .one(let one):
            origin =
                .one(one: parentToPartOriginOffsetUserEditedDic[one ] )
        case .two(let left, let right):
            origin =
                .two(left: parentToPartOriginOffsetUserEditedDic[ left ],
                     right: parentToPartOriginOffsetUserEditedDic[right ] )
        }
        if part == Part.footSupportHangerLink {
        }
        return origin
    }
        
    
//    func getOrigin() -> OneOrTwoOptional<PositionAsIosAxes>{
//        var origin: OneOrTwoOptional<PositionAsIosAxes>
//        switch partIdAllowingForUserEdit {
//        case .one(let one):
//            origin =
//                .one(one: parentToPartOriginUserEditedDicNew[PartId(part,one)])
//        case .two(let left, let right):
//            origin =
//                .two(left: parentToPartOriginUserEditedDicNew[PartId(part, left)],
//                     right: parentToPartOriginUserEditedDicNew[PartId(part, right)])
//        }
//        return origin
//    }
//        
    
    func getOptionalValue<T>(
        _ partIds: OneOrTwo<PartTag>,
        from dictionary: [String: T?],
        using closure: @escaping (PartTag) -> String
    ) -> OneOrTwoOptional<T> {
        if part == .mainSupport {
           // print(dictionary)
        }
        
        let commonPart = { (id: PartTag) -> T? in
            dictionary[closure(id)] ?? nil
        }
        switch partIds {
        case .one(let oneId):
            return .one(one: commonPart(oneId))
        case .two(let left, let right):
            return .two(left: commonPart(left), right: commonPart(right))
        }
    }
}


