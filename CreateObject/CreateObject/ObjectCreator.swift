//
//  ObjectCreator.swift
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation

struct ObjectData {
    let objectChainLabelsDefaultDic: ObjectChainLabelDictionary
    
    let objectChainLabelsUserEditedDic: ObjectChainLabelDictionary
    
    var partDataDic: [Part: PartData] = [:]
    
    let objectType: ObjectTypes
    
    let userEditedDic: UserEditedDictionaries?
    
    let size: Dimension = (width: 0.0, length: 0.0)

    var allChainLabels: [Part] = []
    
    let chainLabelsAccountingForEdit: [Part]
    
    var oneOfEachPartInAllPartChainAccountingForEdit: [Part] = []
    
   // let linkedPartsDictionary = LinkedParts().dictionary
    
    init(
        _ objectType: ObjectTypes,
        _ userEditedDic: UserEditedDictionaries?,
        _ chainLabelsAccountingForEdit: [Part]) {
        
        self.objectType = objectType
        self.userEditedDic = userEditedDic
        self.objectChainLabelsDefaultDic = ObjectChainLabel.dictionary
        self.objectChainLabelsUserEditedDic = userEditedDic?.objectChainLabelsUserEditDic ?? [:]
        self.chainLabelsAccountingForEdit = chainLabelsAccountingForEdit
        allChainLabels = getAllPartChainLabels()
            
        
        oneOfEachPartInAllPartChainAccountingForEdit = AllPartInObject.getOneOfAllPartInObjectAfterEdit(chainLabelsAccountingForEdit)
       
            
        checkObjectHasAtLeastOnePartChain()
        
        initialiseAllPart()
        
        postProcessGlobalOrigin()
    
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
           oneOfEachPartInAllPartChainAccountingForEdit
     
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
                    
                    guard let parentPartValue = partDataDic[parentPart] else {
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
            guard let partData = partDataDic[part] else {
                fatalError("This part:\(part) has not been intialised where the parent global origin is \(parentGlobalOrigin)")
            }
            let childOrigin = partData.childOrigin
            
            let modifiedParentGlobalOrigin: OneOrTwo<PositionAsIosAxes> = allowForTwoParentAndOneChild()
            
            let globalOrigin =
                   getGlobalOrigin(childOrigin, modifiedParentGlobalOrigin)
            
            let modifiedPartValue = partData.withNewGlobalOrigin(globalOrigin)
            
            partDataDic[part] = modifiedPartValue
            
            
            func allowForTwoParentAndOneChild() -> OneOrTwo<PositionAsIosAxes>{
                if childOrigin.oneNotTwo() && !parentGlobalOrigin.oneNotTwo() {
                    guard let childId = partData.id.one else {
                        fatalError("no child id")
                    }
                    return
                        parentGlobalOrigin.mapTwoToOneUsingOneId(childId)
                } else {
                    return
                        parentGlobalOrigin
                }
            }
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



//MARK: Create PartData Dictionary
extension ObjectData {
    mutating func initialiseAllPart() {
        
        partDataDic +=
        [.objectOrigin: ZeroValue.partData]
        
        if oneOfEachPartInAllPartChainAccountingForEdit.contains(.stabiliser) {
            initialiseFoundationalPart(.stabiliser)//ADDED
        }
        
        for part in oneOfEachPartInAllPartChainAccountingForEdit {
            if part != .stabiliser {
                let parentOrLinkedPart: Part
                
                parentOrLinkedPart = getLinkedOrParentPart(part)
            
                initialisePart(parentOrLinkedPart, part )
            }
        }
    }

    
    //foundational part has no parent parts
    mutating func initialiseFoundationalPart(
        _ child: Part
    ) {
        let foundationalData =
        StructFactory(
            objectType,
            userEditedDic,
            independantPart: child
        )
        .partData
            
        partDataDic +=
            [child: foundationalData]
    }
    
    
    //all non-foundational have a parent or linked part
    mutating func initialisePart(
        _ linkedlOrParentPart: Part,
        _ child: Part
    ) {
        var childData: PartData = ZeroValue.partData
        guard let linkedOrParentData = partDataDic[linkedlOrParentPart] else {
            fatalError("no partValue for \(linkedlOrParentPart)")
        }
        childData =
            StructFactory(
                objectType,
                userEditedDic,
                linkedOrParentData,
                child,
                chainLabelsAccountingForEdit)
                    .partData
        partDataDic +=
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
    
    
    func getLinkedOrParentPart(_ childPart: Part) -> Part {
        /// a part may have a physical parent part
        /// or a part which  it is linked to
        let linkedPartDic: [Part: Part] = getLinkedPartDic()
        var linkedOrParentPart: Part = .stabiliser//default
        for label in allChainLabels {
            let partChain = LabelInPartChainOut(label).partChain//get partChain for label
            for i in 0..<partChain.count {
                if let linkedPart = linkedPartDic[childPart], linkedPart != .notFound {
                    //use dictionary devined part as linked part
                    linkedOrParentPart = linkedPart
                } else if childPart == partChain[i] && i != 0 {
                    //use the preceding part in the partChain as parent
                    linkedOrParentPart = partChain[i - 1]
                }
            }
        }
        return linkedOrParentPart
        
        
        func getLinkedPartDic() -> [Part: Part] {
             [
                    .fixedWheelHorizontalJointAtRear: .mainSupport,
                    .fixedWheelHorizontalJointAtMid: .mainSupport,
                    .fixedWheelHorizontalJointAtFront: .mainSupport,
                    .casterVerticalJointAtRear: .mainSupport,
                    .casterVerticalJointAtMid: .mainSupport,
                    .casterVerticalJointAtFront: .mainSupport,
                    .steeredVerticalJointAtFront: .mainSupport
                    ]
        }
        

//        }
        
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
    


}


//MARK: Create PartData Dictionary
//extension ObjectData {
//    mutating func initialiseAllPart() {
//        partDataDic +=
//        [.objectOrigin: ZeroValue.partData]
//        if oneOfEachPartInAllPartChainAccountingForEdit.contains(.mainSupport) {
//            //initialiseLinkedOrParentPart(.stabiliser)//ADDED
//            initialiseLinkedOrParentPart(.mainSupport)
//        }
//        for part in oneOfEachPartInAllPartChainAccountingForEdit {
//            if part != .mainSupport {
//                let parentOrLinkedPart: Part
//                
//                parentOrLinkedPart = getLinkedOrParentPart(part)
//            
//                initialisePart(parentOrLinkedPart, part )
//            }
//        }
//    }
//
//    
//    //foundational part has no parent parts
//    mutating func initialiseLinkedOrParentPart(
//        _ child: Part) {
//        let foundationalData =
//                StructFactory(
//                   objectType,
//                   userEditedDic,
//                  independantPart: child)
//                    .partData
//        partDataDic +=
//            [child: foundationalData]
//    }
//    
//    
//    //all non-foundational have a parent or linked part
//    mutating func initialisePart(
//        _ linkedlOrParentPart: Part,
//        _ child: Part
//    ) {
//        var childData: PartData = ZeroValue.partData
//            guard let linkedOrParentData = partDataDic[linkedlOrParentPart] else {
//                fatalError("no partValue for \(linkedlOrParentPart)")
//            }
//        childData =
//            StructFactory(
//                objectType,
//                userEditedDic,
//                linkedOrParentData,
//                child,
//                chainLabelsAccountingForEdit)
//                    .partData
//        partDataDic +=
//            [child: childData]
//    }
//    
//
//    func getOneOfEachPartInAllPartChain() -> [Part]{
//        var oneOfEachPartInAllChainLabel: [Part] = []
//            for label in allChainLabels {
//               let partChain = LabelInPartChainOut(label).partChain
//                for part in partChain {
//                    if !oneOfEachPartInAllChainLabel.contains(part) {
//                        oneOfEachPartInAllChainLabel.append(part)
//                    }
//                }
//            }
//        return oneOfEachPartInAllChainLabel
//    }
//    
//    
//    func getLinkedOrParentPart(_ childPart: Part) -> Part {
//        var linkedOrParentPart: Part = .objectOrigin
//        for label in allChainLabels {
//            let partChain = LabelInPartChainOut(label).partChain
//            for i in 0..<partChain.count {
//                if let linkedPart = linkedPartsDictionary[childPart], linkedPart != .notFound {
//                    linkedOrParentPart = linkedPart
//                } else if childPart == partChain[i] && i != 0 {
//                    linkedOrParentPart = partChain[i - 1]
//                }
//            }
//        }
//        return linkedOrParentPart
//    }
//
//    
//    
//    func getPartChain(_ label: Part) -> [Part] {
//        LabelInPartChainOut(label).partChain
//    }
//    
//    
//    func getAllPartChainLabels() -> [Part] {
//        guard let chainLabels =
//        objectChainLabelsUserEditedDic[objectType] ??
//                objectChainLabelsDefaultDic[objectType] else {
//            fatalError("there are no partChainLabel for object \(objectType)")
//        }
//        return chainLabels
//    }
//}











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
        partsToBeRotated: [Part] = [] ) {
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
            self.partsToBeRotated = partsToBeRotated
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



///provide proprties for tuple for part-groupaccess to dictionary
struct PartObjectGroup: Hashable {
    let part: Part
    let group: ObjectGroup
    
    init (_ part: Part, _ group: ObjectGroup) {
        self.part = part
        self.group = group
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



struct StructFactory {
    let objectType: ObjectTypes
    var partData: PartData = ZeroValue.partData
    let linkedOrParentData: PartData
    let part: Part
    let parentPart: Part
    let chainLabelsAccountingForEdit: [Part]
    let defaultOrigin: PartEditedElseDefaultOrigin
    let userEditedData: UserEditedData
    var partOrigin: OneOrTwo<PositionAsIosAxes> = .one(one: ZeroValue.iosLocation)
    var partDimension: OneOrTwo<Dimension3d> = .one(one: ZeroValue.dimension3d)

    // Designated initializer for common parts
    init(_ objectType: ObjectTypes,
         _ userEditedDic: UserEditedDictionaries?,
         _ linkedOrParentData: PartData,
         _ part: Part,
         _ chainLabelsAccountingForEdit: [Part]){
        self.objectType = objectType
        self.linkedOrParentData = linkedOrParentData
        self.part = part
        self.parentPart = linkedOrParentData.part
        self.chainLabelsAccountingForEdit = chainLabelsAccountingForEdit
        let sitOnId: PartTag = .id0
        

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
    
        let defaultDimensionOneOrTwo =
                defaultDimensionData.userEditedDimensionOneOrTwo
    
        defaultOrigin =
            PartEditedElseDefaultOrigin(
                part,
                objectType,
                linkedOrParentData,
                defaultDimensionOneOrTwo,
                userEditedData.partIdAccountingForUserEdit,
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
            let sitOnName: OneOrTwo<String> = .one(one: "object" + ObjectId.objectId.rawValue + "_sitOn_id0_sitOn_id0")
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
        let partId = userEditedData.partIdAccountingForUserEdit//two sided default edited to one will be detected
        let partsToBeRotated: [Part] =  getPartsToBeRotated()
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
                partsToBeRotated: partsToBeRotated)
            
            
        func getPartsToBeRotated() -> [Part]{
            let oneOfAllPartInObject = AllPartInObject.getOneOfAllPartInObjectAfterEdit(chainLabelsAccountingForEdit)
            let partsToBeRotated =
                PartInRotationScopeOut(
                    part,
                    oneOfAllPartInObject)
                        .rotationScopeAllowingForEditToChainLabel

            return partsToBeRotated
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
    var partIdAccountingForUserEdit: OneOrTwo <PartTag>//bilateral parts can be edited to unilateral
    
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

            partIdAccountingForUserEdit = //non-optional as must iterate through id
            partIdDicIn[part] ?? //UI edit:.two(left:.id0,right:.id1)<->.one(one:.id0) ||.one(one:.id1)
            OneOrTwoId(objectType, part).forPart // default
                        
            originName = getOriginName(partIdAccountingForUserEdit)
                                       
            optionalOrigin = getOptionalOrigin()

            optionalAngleMinMax =
            getOptionalValue(partIdAccountingForUserEdit, from: angleMinMaxDic) { item in
                return CreateNameFromIdAndPart(sitOnId, part).name
            }
            
            optionalAngles = getOptionalAngles()
            optionalDimension = getOptionalDimension()
        }
    
    
    func getOriginName(_ partId: OneOrTwo<PartTag>)
    -> OneOrTwoOptional<String>{
        
        switch partId {
        case .one(let one):
            let oneName = CreateNameFromIdAndPart(one, part).name
            return
                .one(one: oneName)
        case .two(let left, let right):
            let leftName = CreateNameFromIdAndPart(left, part).name
            let rightName = CreateNameFromIdAndPart(right, part).name
            return
                .two(
                    left: leftName,
                    right: rightName)
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


