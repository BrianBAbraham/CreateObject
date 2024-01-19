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
    
    var dictionaries: UserEditedDictionaries
    
    var objectImageData: ObjectImageData


    init(
        currentObjectName: String,
        dictionaries: UserEditedDictionaries,
        objectImageData: ObjectImageData
    ){
        self.dictionaries = dictionaries
        self.currentObjectName = currentObjectName
        self.preTiltFourCornerPerKeyDic = objectImageData.preTiltObjectToPartFourCornerPerKeyDic
       // self.postTiltFourCornerPerKeyDic = objectImageData.postTiltObjectToPartFourCornerPerKeyDic

        angleUserEditedDic = dictionaries.angleUserEditedDic
        angleMinMaxDic = dictionaries.angleMinMaxDic

        self.objectImageData = objectImageData
       
      
    }
}
    
    


class ObjectPickViewModel: ObservableObject {
    var userEditedDictionaries: UserEditedDictionaries = UserEditedDictionaries.shared
    
    @Published private var objectPickModel: ObjectPickModel

    var objectImageData: ObjectImageData
    
    init() {
        objectImageData =
            ObjectPickViewModel.setDictionaryMaker(
            nil, userEditedDictionaries)
        

        userEditedDictionaries.parentToPartOriginUserEditedDic =
            objectImageData.preTiltParentToPartOriginDic
        userEditedDictionaries.objectToParOrigintUserEditedDic =
            objectImageData.preTiltObjectToPartOriginDic
        userEditedDictionaries.angleUserEditedDic =
            objectImageData.angleUserEditDic
        userEditedDictionaries.angleMinMaxDic =
            objectImageData.angleMinMaxDic

        objectPickModel =
            ObjectPickModel(
            currentObjectName: ObjectTypes.fixedWheelRearDrive.rawValue,
            dictionaries: userEditedDictionaries,
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
    
    

    
    func setObjectByCreatingFromName(){
        let objectName = getCurrentObjectName()
     
        objectImageData =
            Self.setDictionaryMaker(
                    objectName,
                    userEditedDictionaries)
        
        objectPickModel =
            ObjectPickModel(
                currentObjectName: objectName,
                dictionaries: userEditedDictionaries,
            objectImageData: objectImageData)
    
        setCurrentObjectFrameSize()

    }
    
    
    func setCurrentRotation(
        _ angleUserEditedDic: AnglesDictionary = [:]) {

        userEditedDictionaries.angleUserEditedDic += angleUserEditedDic
        let objectName = getCurrentObjectName()
     
        objectImageData =
            Self.setDictionaryMaker(
                    objectName,
                    userEditedDictionaries)

        objectPickModel =
            ObjectPickModel(
                currentObjectName: objectName,
                dictionaries: userEditedDictionaries,
                objectImageData: objectImageData)
        
        setCurrentObjectFrameSize()
    }
    
    
    func setCurrentWidth(_ width: Double, _ name: String) {
        
        
        guard let currentDimension =  objectPickModel.dictionaries.dimensionUserEditedDic[name] ?? objectImageData.dimensionDic[name] else {
            fatalError()
        }
               
        let newDimension = (width: width, length: currentDimension.length, height:currentDimension.height)
        
        userEditedDictionaries.dimensionUserEditedDic += [name: newDimension]
        
       // setObjectByCreatingFromName()
        
        let objectName = getCurrentObjectName()
//
//        objectImageData =
//            Self.setDictionaryMaker(
//                    objectName,
//                    userEditedDictionaries)

        objectPickModel =
            ObjectPickModel(
                currentObjectName: objectName,
                dictionaries: userEditedDictionaries,
                objectImageData: objectImageData)
        
        setCurrentObjectFrameSize()
        
        setObjectByCreatingFromName()
        
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
    
    
    func getCurrentObjectType()
        ->ObjectTypes {
        let objectName = getCurrentObjectName()
        
        return ObjectTypes(rawValue: objectName) ??
            ObjectTypes.fixedWheelRearDrive
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
    
}
 



//MARK:
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
    
    func defaultObjectHasOneOFTheseChainLabels(_ chainLabels: [Part]) -> Part {
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
    
    

    
    

    
    
}


//MARK: SET
extension ObjectPickViewModel {
    
    func setCurrentObjectFrameSize() {
        objectPickModel.currentObjectFrameSize = getScreenFrameSize()
    }
    
    
    func setCurrentObjectName(_ objectName: String){
        objectPickModel.currentObjectName = objectName
    }
    
    
    func setChangeToPartBeingOnBothSides(_ tag: String, _ part: Part) {
        let objectType = getCurrentObjectType()
        let partChain = LabelInPartChainOut(part).partChain

        if tag == "left" || tag == "right" {
            let newId: OneOrTwo<PartTag> = (tag == "left") ? .one(one: .id0) : .one(one: .id1)

            let chainLabelForFootWasRemoved = userEditedDictionaries.objectChainLabelsUserEditDic[objectType]?.contains(part) == false

            if chainLabelForFootWasRemoved {
                restoreChainLabelToObject(part)
                setObjectByCreatingFromName()
            }

            let ignoreFirstItem = 1 // relevant part subsequent
            for index in ignoreFirstItem..<partChain.count {
                userEditedDictionaries.partIdsUserEditedDic[partChain[index]] = newId
            }
        }

        if tag == "no" {
            removeChainLabelFromObject(part)
            setObjectByCreatingFromName()
        }

        if tag == "both" {
            setPartIdDicInKeyToNilRestoringDefault(partChain)
            userEditedDictionaries.objectChainLabelsUserEditDic.removeValue(forKey: objectType)
        }

        setObjectByCreatingFromName()
    }

    
    func updatePartBeingOnBothSides(isLeftSelected: Bool, isRightSelected: Bool) {
        if isLeftSelected && isRightSelected {
            setChangeToPartBeingOnBothSides("both", Part.footSupport)
        } else if isLeftSelected {
            setChangeToPartBeingOnBothSides("left", Part.footSupport)
        } else if isRightSelected {
            setChangeToPartBeingOnBothSides("right", Part.footSupport)
        } else {
            setChangeToPartBeingOnBothSides("no", Part.footSupport)
        }
    }

    
    func setChangeToPartBeingOnBothSidesX(_ tag: String, _ part: Part) {
        let objectType = getCurrentObjectType()
        let partChain = LabelInPartChainOut(part).partChain
        if tag == "left" || tag == "right" {
            
            let action: [String: OneOrTwo<PartTag>] = [
                "left": .one(one: .id0),
                "right": .one(one: .id1) ]
            
            if let newId = action[tag] {
                var chainLabelForFootWasRemoved: Bool = false
                if let chainLabelForObject = userEditedDictionaries.objectChainLabelsUserEditDic[objectType] {
                    chainLabelForFootWasRemoved = chainLabelForObject.contains(part) ? false: true
                }//to restore left or right after no footSupport, the chainLabel is restored
                
                if chainLabelForFootWasRemoved {
                    restoreChainLabelToObject(part)
                    setObjectByCreatingFromName()
                }
                let ignoreFirstItem = 1//relevant part subsequent
                for index in ignoreFirstItem..<partChain.count {
                    userEditedDictionaries.partIdsUserEditedDic[partChain[index]] = newId
                }
            }
        }

        if tag == "no" {
            removeChainLabelFromObject(part)
            setObjectByCreatingFromName()
        }
        
        if tag == "both" {
            setPartIdDicInKeyToNilRestoringDefault(partChain)
            userEditedDictionaries.objectChainLabelsUserEditDic.removeValue(forKey: objectType)
        }
        
        setObjectByCreatingFromName()
    }
    
    
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
        setObjectByCreatingFromName()
    }
    

    func setPartIdDicInKeyToNilRestoringDefault (_ partChainWithoutRoot: [Part]) {
        for part in partChainWithoutRoot {
            userEditedDictionaries.partIdsUserEditedDic.removeValue(forKey: part)
        }
    }
    
}





//unless the path is initially defined with only positive coordinates all of which are on screen
// touch is not detected even if the object is scaled and dragged within screen
//MARK: ENSURE DRAG
extension ObjectPickViewModel {
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
