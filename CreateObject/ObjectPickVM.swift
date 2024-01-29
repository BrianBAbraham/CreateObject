//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation

struct ObjectPickModel {
    var currentObjectName: String  //FixedWheelBase.Subtype.midDrive.rawValu
   
    var preTiltFourCornerPerKeyDic: CornerDictionary
    
    var loadedDictionary: PositionDictionary = [:]
    
    ///source of truth for the UI  (after absolute coordinates are transformed)
    //var postTiltFourCornerPerKeyDic: CornerDictionary
        
    var angleUserEditedDic: AnglesDictionary
    
    var angleMinMaxDic: AngleMinMaxDictionary
    

    
    var currentObjectFrameSize: Dimension = ZeroValue.dimension
    
    var userEditedDictionaries: UserEditedDictionaries
    var defaultDictionaries: DefaultDictionaries
    
    var objectImageData: ObjectImageData


    init(
        currentObjectName: String,
        userEditedDictionaries: UserEditedDictionaries,
        defaultDictionaries: DefaultDictionaries,
        objectImageData: ObjectImageData
    ){
        self.userEditedDictionaries = userEditedDictionaries
        self.defaultDictionaries = defaultDictionaries
        self.currentObjectName = currentObjectName
        self.preTiltFourCornerPerKeyDic = objectImageData.preTiltObjectToPartFourCornerPerKeyDic
      
        angleUserEditedDic = userEditedDictionaries.angleUserEditedDic
        angleMinMaxDic = userEditedDictionaries.angleMinMaxDic

        self.objectImageData = objectImageData
       
      
    }
}
    
    


class ObjectPickViewModel: ObservableObject {
    var userEditedDictionaries: UserEditedDictionaries = UserEditedDictionaries.shared
    let defaultDictionaries: DefaultDictionaries = DefaultDictionaries.shared
    
    @Published private var objectPickModel: ObjectPickModel
    
    @Published private var scopeOfEditForSide: Side = .both
   // @Published private
    var presenceOfPartForSide: Side = .both
    var dimensionForEditing: PartTag = .length

    var objectImageData: ObjectImageData
    
    init() {
        objectImageData =
            ObjectPickViewModel.setDictionaryMaker(
            nil,
            userEditedDictionaries)
        

        userEditedDictionaries.parentToPartOriginUserEditedDic =
            objectImageData.preTiltParentToPartOriginDic
        userEditedDictionaries.objectToPartOrigintUserEditedDic =
            objectImageData.preTiltObjectToPartOriginDic
        userEditedDictionaries.angleUserEditedDic =
            objectImageData.angleUserEditDic
        userEditedDictionaries.angleMinMaxDic =
            objectImageData.angleMinMaxDic

        objectPickModel =
            ObjectPickModel(
            currentObjectName: ObjectTypes.fixedWheelRearDrive.rawValue,
            userEditedDictionaries: userEditedDictionaries,
           defaultDictionaries: defaultDictionaries,
            objectImageData: objectImageData)
        

    }
    

    static func setDictionaryMaker(
    _ objectName: String?,
    _ dictionaries: UserEditedDictionaries)
        -> ObjectImageData {
        var objectType: ObjectTypes
           
        if let unwrappedObjectName = objectName  {
            objectType = ObjectTypes(rawValue: unwrappedObjectName) ?? ObjectTypes.fixedWheelRearDrive
        } else {
            objectType = .fixedWheelRearDrive
        }
        return
            ObjectImageData(
                objectType,
                dictionaries
                )
    }
    
    func resetObjectByCreatingFromName() {
        userEditedDictionaries.dimensionUserEditedDic = [:]
        userEditedDictionaries.angleUserEditedDic = [:]
        modifyObjectByCreatingFromName()
    }
    

    
    func modifyObjectByCreatingFromName(){
        let objectName = getCurrentObjectName()
        //userEditedDictionaries = [:]
        objectImageData =
            Self.setDictionaryMaker(
                    objectName,
                    userEditedDictionaries)
        
        objectPickModel =
            ObjectPickModel(
                currentObjectName: objectName,
                userEditedDictionaries: userEditedDictionaries,
                defaultDictionaries: defaultDictionaries,
                objectImageData: objectImageData)
    
        setCurrentObjectFrameSize()

    }
    
    
  
}






//MARK: GET
extension ObjectPickViewModel {
    
    func getAllOriginNames()-> String{
        DictionaryInArrayOut().getAllOriginNamesAsString(getPostTiltOneCornerPerKeyDic())
    }
    
    
    func getAllOriginValues()-> String{
        DictionaryInArrayOut().getAllOriginValuesAsString(getPostTiltOneCornerPerKeyDic())
    }
    
    
    func getAngleDic()
    -> AnglesDictionary {
        objectPickModel.angleUserEditedDic
    }
    
    
    func getAngleMinMaxDic(_ name: String)
    -> AngleMinMax {
        objectPickModel.angleMinMaxDic[name] ?? ZeroValue.angleMinMax
    }
    
    
    func getPostTiltOneCornerPerKeyDic()
    ->PositionDictionary{
        objectPickModel.objectImageData.postTiltObjectToOneCornerPerKeyDic
    }
    
    
    func getPreTiltFourCornerPerKeyDic() -> CornerDictionary {
        objectPickModel.objectImageData.preTiltObjectToPartFourCornerPerKeyDic
    }
    
    
    func getPostTiltFourCornerPerKeyDic() -> CornerDictionary {
        objectPickModel.objectImageData.postTiltObjectToPartFourCornerPerKeyDic
    }
    
    
    func getCurrentObjectFrameSize() -> Dimension {
        objectPickModel.currentObjectFrameSize
    }
    
    
    func getCurrentObjectName() -> String{
        objectPickModel.currentObjectName
    }
    
    
    func getDimensionMinMax(_ part: Part) -> (min: Double, max: Double) {
        let minMaxDimension = defaultDictionaries.getDefault(part, getCurrentObjectType())
        return (min: minMaxDimension.min.length, max: minMaxDimension.max.length)
    }
    
    
    func getCurrentObjectType()
        ->ObjectTypes {
        let objectName = getCurrentObjectName()
        
        return ObjectTypes(rawValue: objectName) ??
            ObjectTypes.fixedWheelRearDrive
    }
    

    func getSidesPresentGivenUserEdit(_ part: Part) -> [Side] {
        let objectType = getCurrentObjectType()
        let oneOrTWoid = userEditedDictionaries.partIdsUserEditedDic[part] ?? OneOrTwoId(objectType, part).forPart
        guard let chainLabels = userEditedDictionaries.objectChainLabelsUserEditDic[objectType] ?? objectImageData.objectChainLabelsDefaultDic[objectType] else {
            fatalError()
        }
        
        if chainLabels.contains(part) {
            
            return oneOrTWoid.mapOneOrTwoToSide()
        } else {
            return [.none]
        }
        
    }
    

    
    func getObjectDictionaryFromSaved(_ entity: LocationEntity) -> [String]{
        let allOriginNames = entity.interOriginNames ?? ""
        let allOriginValues = entity.interOriginValues ?? ""

        let array =
            DictionaryInArrayOut().getNameValue(
                OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary.filter({$0.key.contains(PartTag.corner.rawValue)})//, sender
                )
        return array
    }
    

    
    func getRelevantDictionary(
        _ forScreenOrMeasurment: DictionaryTypes,
        _ dictionaryVersion: DictionaryVersion = .useCurrent)
            -> CornerDictionary {
            var relevantDictionary: CornerDictionary = [:]

            switch dictionaryVersion {
            case .useCurrent:
                relevantDictionary = getPostTiltFourCornerPerKeyDic()
            case .useLoaded:
                relevantDictionary = getPostTiltFourCornerPerKeyDic()
            default:
                break
            }


        switch forScreenOrMeasurment {
        case .forScreen:
            relevantDictionary =
            getObjectDictionaryForScreen()
           
        default: break
        }
        return relevantDictionary
    }
    

    func getUniquePartNamesFromObjectDictionary() -> [String] {
      GetUniqueNames(  getPostTiltOneCornerPerKeyDic()).forPart
    }
    
    
    func getViewStatus(_ view: UserModifiers)-> Bool {
        //print(view)
        let dictionary = ObjectModifiers.dictionary
        let objectType = getCurrentObjectType()
        let modifiersForThisObject = dictionary[objectType] ?? []
        
        let state =
        modifiersForThisObject.contains(view) ? true: false
//        print(state)
//        print("")
        return state
    }
    
    
    func getPresenceOfPartForSide() -> Side {
        presenceOfPartForSide
    }
    
    
    func getViewStatusForGreyOut(_ view: UserModifiers)-> Bool {
        let dictionary = UserModifiersPartDependency.dictionary
        //let objectType = getCurrentObjectType()
        let state = (dictionary[view] == nil) ? false: true
     //   print(state)
        return state
    }
    
    
    func getShowViewStatus(_ view: UserModifiers)-> Bool {
        let dictionary = ObjectModifiers.dictionary
        let objectType = getCurrentObjectType()
        var state: Bool = false
        if let show = dictionary[objectType] {
       //     print(show)
            state = show.contains(view)
        }
        
        //print(state)
        return state
    }
    
//    func getPartChainLabelFromPart(_ part: Part) -> Part {
//
//    }
//
    
}
 





//MARK: Interogations
extension ObjectPickViewModel {
    
    func defaultObjectHasThisChainLabel(_ chainLabels: [Part]) -> Bool {
        let objectType = getCurrentObjectType()
        guard let defaultChainLabels =
                objectImageData.objectChainLabelsDefaultDic[objectType] else {
                    fatalError()
                }
        var action = false
        for chainLabel in chainLabels {
            if defaultChainLabels.contains(chainLabel) {
                action = true
            }
        }
        return action
    }
    
    
    func defaultObjectHasOneOfTheseChainLabels(_ chainLabels: [Part]) -> Part {
        let objectType = getCurrentObjectType()
        guard let defaultChainLabels =
                objectImageData.objectChainLabelsDefaultDic[objectType] else {
                    fatalError()
                }
        var idenftifiedChainLabel: Part = .notFound
        for chainLabel in chainLabels {
            if defaultChainLabels.contains(chainLabel) {
                idenftifiedChainLabel = chainLabel
               break
            }
        }
        return idenftifiedChainLabel
    }
    
    
    func getList (_  version: DictionaryVersion) -> [String] {
        var list: [String] = []
            switch version  {
            case .useCurrent:
                list =
                    DictionaryInArrayOut().getNameValue(
                        getPostTiltOneCornerPerKeyDic())
            case .useInitial:
                list =
                    DictionaryInArrayOut().getNameValue(
                        getPostTiltOneCornerPerKeyDic())
            case .useLoaded:
                list =
                    DictionaryInArrayOut().getNameValue(
                        objectPickModel.loadedDictionary)
            case .useDimension:
             
                list =
                    DictionaryInArrayOut().getNameValue(
                        objectPickModel.objectImageData.dimensionDic)
                    }
        return list
    }
    
    func getMaximumDimensionOfObject (
    _ dictionary: PositionDictionary)
        -> Double {
        objectImageData.maximumDimension
    }
    

    func getObjectDimension (
        _ dictionary: PositionDictionary)
        -> Dimension {
            objectImageData.dimension
    }
}



//MARK:
extension ObjectPickViewModel {
    
    
    

    
    

    
    

    
    

    
    

    
    
}


//MARK: SET
extension ObjectPickViewModel {
    
    func setCurrentObjectFrameSize() {
        objectPickModel.currentObjectFrameSize = getScreenFrameSize()
    }
    
    
    func setCurrentObjectName(_ objectName: String){
        objectPickModel.currentObjectName = objectName
    }
    
    
    func setWhenPartChangesOneOrTwoStatus(_ tag: String, _ part: Part) {
        let objectType = getCurrentObjectType()
        let partChain = LabelInPartChainOut(part).partChain
     //   print(tag)
        if tag == "left" || tag == "right" {

            let newId: OneOrTwo<PartTag> = (tag == "left") ? .one(one: .id0) : .one(one: .id1)
//print ("oneOrTwoStatusChanged")
//print(newId)

            let chainLabelForFootWasRemoved = userEditedDictionaries.objectChainLabelsUserEditDic[objectType]?.contains(part) == false

            if chainLabelForFootWasRemoved {
                restoreChainLabelToObject(part)
               // modifyObjectByCreatingFromName()
            }

            let ignoreFirstItem = 1 // relevant part subsequent
            for index in ignoreFirstItem..<partChain.count {
                userEditedDictionaries.partIdsUserEditedDic[partChain[index]] = newId
               // modifyObjectByCreatingFromName()
            }
        }

        if tag == "none" {
            removeChainLabelFromObject(part)
            modifyObjectByCreatingFromName()
        }

        if tag == "both" {
            setPartIdDicInKeyToNilRestoringDefault(partChain)
            userEditedDictionaries.objectChainLabelsUserEditDic.removeValue(forKey: objectType)
        }

        modifyObjectByCreatingFromName()
    }

    
    func updatePartBeingOnBothSides(isLeftSelected: Bool, isRightSelected: Bool) {
        if isLeftSelected && isRightSelected {
            presenceOfPartForSide = .both
            setWhenPartChangesOneOrTwoStatus("both", Part.footSupport)
        } else if isLeftSelected {
            presenceOfPartForSide = .left
            setWhenPartChangesOneOrTwoStatus("left", Part.footSupport)
        } else if isRightSelected {
            presenceOfPartForSide = .right
            setWhenPartChangesOneOrTwoStatus("right", Part.footSupport)
        } else {
            presenceOfPartForSide = .none
            setWhenPartChangesOneOrTwoStatus("none", Part.footSupport)
        }
    }

    
    func updateDimenionToBeEdited(_ dimension: PartTag) {
        dimensionForEditing = dimension
    }
    
    func getDimensionToBeEdited() -> PartTag {
        dimensionForEditing
    }
    
    
//    func setChangeToPartBeingOnBothSidesX(_ tag: String, _ part: Part) {
//        let objectType = getCurrentObjectType()
//        let partChain = LabelInPartChainOut(part).partChain
//        if tag == "left" || tag == "right" {
//
//            let action: [String: OneOrTwo<PartTag>] = [
//                "left": .one(one: .id0),
//                "right": .one(one: .id1) ]
//
//            if let newId = action[tag] {
//                var chainLabelForFootWasRemoved: Bool = false
//                if let chainLabelForObject = userEditedDictionaries.objectChainLabelsUserEditDic[objectType] {
//                    chainLabelForFootWasRemoved = chainLabelForObject.contains(part) ? false: true
//                }//to restore left or right after no footSupport, the chainLabel is restored
//
//                if chainLabelForFootWasRemoved {
//                    restoreChainLabelToObject(part)
//                    modifyObjectByCreatingFromName()
//                }
//                let ignoreFirstItem = 1//relevant part subsequent
//                for index in ignoreFirstItem..<partChain.count {
//                    userEditedDictionaries.partIdsUserEditedDic[partChain[index]] = newId
//                }
//            }
//        }
//
//        if tag == "no" {
//            removeChainLabelFromObject(part)
//            modifyObjectByCreatingFromName()
//        }
//
//        if tag == "both" {
//            setPartIdDicInKeyToNilRestoringDefault(partChain)
//            userEditedDictionaries.objectChainLabelsUserEditDic.removeValue(forKey: objectType)
//        }
//
//        modifyObjectByCreatingFromName()
//    }
    
    
    func restoreChainLabelToObject(_ chainLabel: Part) {
        let objectType = getCurrentObjectType()
        guard let currentObjectChainLabels =
                objectImageData.objectChainLabelsDefaultDic[objectType] else {
            fatalError("no chain labels for object \(objectType)")
        }
        let newChainLabels = currentObjectChainLabels + [chainLabel]
        
        userEditedDictionaries.objectChainLabelsUserEditDic[objectType] = newChainLabels
    }
    
    
    func removeChainLabelFromObject(_ chainLabel: Part) {
        let objectType = getCurrentObjectType()
        let currentObjectChainLabels = userEditedDictionaries.objectChainLabelsUserEditDic[objectType] ??
            objectImageData.objectChainLabelsDefaultDic[objectType]

        
        let newChainLabels = currentObjectChainLabels?.filter { $0 != chainLabel}
        userEditedDictionaries.objectChainLabelsUserEditDic[objectType] = newChainLabels
    }
    
    
    
    func replaceChainLabelForObject(_ removal: Part, _ replacement: Part) {
        let objectType = getCurrentObjectType()
        removeChainLabelFromObject(removal)
        guard var curentObjectChainLabels = userEditedDictionaries.objectChainLabelsUserEditDic[objectType]  else {
         fatalError()
        }
        curentObjectChainLabels += [replacement]
        
        userEditedDictionaries.objectChainLabelsUserEditDic[objectType] = curentObjectChainLabels
        modifyObjectByCreatingFromName()
    }
    

    func setPartIdDicInKeyToNilRestoringDefault (_ partChainWithoutRoot: [Part]) {
        for part in partChainWithoutRoot {
            userEditedDictionaries.partIdsUserEditedDic.removeValue(forKey: part)
        }
    }
    
}






extension ObjectPickViewModel {

    
    
    func setCurrentRotation(
        _ angleUserEditedDic: AnglesDictionary = [:]) {

        userEditedDictionaries.angleUserEditedDic += angleUserEditedDic
      
        modifyObjectByCreatingFromName()
    }
    
    
    func setSidesToBeEdited(_ sides: Side) {
        scopeOfEditForSide = sides
//        guard let partData = objectImageData.partDataDic[.footSupportHangerLink] else {
//            fatalError()
//        }

    }
    
    
    
    
    
    func setLengthInUserEditedDictiionary(_ length: Double, _ part: Part) {
//     print(length)
//        print(scopeOfEditForSide)
        switch scopeOfEditForSide {
        case .both:
            process(.id0)
            process(.id1)
        case.left:
          process(.id0)
        case.right:
            process(.id1)
        default:
            break
        }
     
        modifyObjectByCreatingFromName()
       
        func process(_ id: PartTag) {
                let name = getName( id, part)
                let currentDimension = getEditedOrDefaultDimension(name, part, id)
                let newDimension = dimensionWithModifiedLength(currentDimension)
                userEditedDictionaries.dimensionUserEditedDic += [name: newDimension]
        }
        

        
        func getName (_ id: PartTag, _ part: Part =  Part.footSupportHangerLink) -> String {
            var name: String {
                let parts: [Parts] = [Part.objectOrigin, PartTag.id0, PartTag.stringLink, part , id, PartTag.stringLink, Part.sitOn, PartTag.id0]
               return
                CreateNameFromParts(parts ).name    }
            return name
        }
        
        
        func getEditedOrDefaultDimension(_ name: String, _ part: Part, _ id: PartTag) -> Dimension3d {
            guard let partData = objectImageData.partDataDic[part] else {
                fatalError()
            }
           
            return
            
            partData.dimension.returnValue(id)
        }

    
        func dimensionWithModifiedLength(_ dimension: Dimension3d) -> Dimension3d {
            (width: dimension.width,
             length: length,
             height:dimension.height)
        }
        
        
        func originModifiedByLength(_ origin: PositionAsIosAxes) -> PositionAsIosAxes {
        (x: origin.x,
         y: origin.y,
         z: origin.z)
        }
        
    }
    
    
    func setWidthInUserEditedDictionary(_ value: Double, _ part: Part, _ selectedDimension: PartTag) {
        
        let parts: [Parts] = [Part.objectOrigin, PartTag.id0, PartTag.stringLink, part, PartTag.id0, PartTag.stringLink, Part.sitOn, PartTag.id0]
        let name = CreateNameFromParts(parts ).name
        guard let currentDimension =
                objectPickModel.userEditedDictionaries.dimensionUserEditedDic[name] ?? objectImageData.dimensionDic[name] else {
            fatalError(name)
        }
        
        let newDimension = selectedDimension == .width ?
            (width: value,
             length: currentDimension.length,
             height:currentDimension.height)
            :
            (width: currentDimension.width,
             length: value,
             height:currentDimension.height)
        
        
        userEditedDictionaries.dimensionUserEditedDic += [name: newDimension]
        
        modifyObjectByCreatingFromName()
        
    }
}



//unless the path is initially defined with only positive coordinates all of which are on screen
// touch is not detected even if the object is scaled and dragged within screen
//MARK: ENSURE DRAG
extension ObjectPickViewModel {
    
    func getObjectDictionaryForScreen ()
        -> CornerDictionary {
         
        let currentDic =  objectPickModel.objectImageData.postTiltObjectToPartFourCornerPerKeyDic
        
            
        let currentObjectAsOneCornerPerKeyDic =
            objectPickModel.objectImageData.postTiltObjectToOneCornerPerKeyDic

        let minThenMax =
             CreateIosPosition
                .minMaxPosition(currentObjectAsOneCornerPerKeyDic)

        let offset = CreateIosPosition.negative(minThenMax[0])

        let objectDimension =
            (width: minThenMax[1].x - minThenMax[0].x,length: minThenMax[1].y - minThenMax[0].y )

        let maximumObjectDimension = getMaximumOfObject(objectDimension)
        
        let scale = Screen.smallestDimension / maximumObjectDimension

        let screenDictionary =
            ForScreen2(
                currentDic,
                offset,
                scale
            ).dictionary
        return screenDictionary
            
            
            func getMaximumOfObject(_ objectDimensions: Dimension)
                -> Double {
                    [objectDimensions.length, objectDimensions.width].max() ?? objectDimensions.length
            }
    }
    
    
    func getScreenFrameSize ()
        -> Dimension{
            
        let currentDic =  objectPickModel.objectImageData.postTiltObjectToPartFourCornerPerKeyDic
        let objectInitialDimension =
            getObjectDimension( ConvertFourCornerPerKeyToOne(
                fourCornerPerElement: currentDic).oneCornerPerKey)
            
        let objectDimensionWithLengthIncrease =
            (
            width: objectInitialDimension.width,length: objectInitialDimension.length)

        var frameSize: Dimension =
            (width: Screen.smallestDimension,
            length: Screen.smallestDimension
             )

        if objectDimensionWithLengthIncrease.length < objectDimensionWithLengthIncrease.width {
            frameSize =
            (width: Screen.smallestDimension,
            length: objectDimensionWithLengthIncrease.length
             )
        }
    
        if objectDimensionWithLengthIncrease.length > objectDimensionWithLengthIncrease.width {
            frameSize = (
                        width: objectDimensionWithLengthIncrease.width,
                        length: Screen.smallestDimension
                                 )
        }
            frameSize = objectDimensionWithLengthIncrease
           
        return frameSize
    }
    
}
