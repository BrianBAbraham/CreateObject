//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation

struct ObjectPickModel {
    var currentObjectName: String  //FixedWheelBase.Subtype.midDrive.rawValu
   
    var preTiltFourCornerPerKeyDic: CornerDictionary = [:]
    
    var loadedDictionary: PositionDictionary = [:]
    
    ///source of truth for the UI  (after absolute coordinates are transformed)
    var postTiltFourCornerPerKeyDic: CornerDictionary = [:]
    
    var dimensionDic: Part3DimensionDictionary
    
    //var objectOptionDictionary: OptionDictionary
    
    var angleDic: AngleDictionary
    
    var angleInDic: AngleDictionary = [:]
    
    var angleMinMaxDic: AngleMinMaxDictionary
    
    var objectPartChainLabelDic: ObjectPartChainLabelsDictionary = [:]
    
    var partChainsIdDic: PartChainIdDictionary
    
    var currentObjectFrameSize: Dimension = ZeroValue.dimension
    

//    mutating func setObjectOptionDictionary(
//        _ option: ObjectOptions,
//        _ state: Bool) {
//            objectOptionDictionary[option] = state
//        }
}
    
    


class ObjectPickViewModel: ObservableObject {
    static let initialObject = ObjectTypes.fixedWheelRearDrive
    static let initialObjectName = initialObject.rawValue
   static let twinSitOnDictionary: TwinSitOnOptionDictionary = [:]
    
    let preTiltFourCornerPerKeyDic: CornerDictionary
    let postTiltOneCornerPerKeyDic: PositionDictionary
    let postTiltFourCornerPerKeyDic: CornerDictionary
    let dimensionDic: Part3DimensionDictionary
    let angleDic: AngleDictionary
    let angleMinMaxDic: AngleMinMaxDictionary
    let objectPartChainLabelDic: ObjectPartChainLabelsDictionary
    let partChainsIdDic: PartChainIdDictionary

    
    @Published private var objectPickModel: ObjectPickModel
    let dictionaryProvider: DictionaryProvider
    
    init() {
        
        dictionaryProvider = setDictionaryProvider(nil)

       preTiltFourCornerPerKeyDic =
            dictionaryProvider.preTiltObjectToPartFourCornerPerKeyDic
        postTiltFourCornerPerKeyDic =
            dictionaryProvider.postTiltObjectToFourCornerPerKeyDic
        postTiltOneCornerPerKeyDic =
            ConvertFourCornerPerKeyToOne(fourCornerPerElement: postTiltFourCornerPerKeyDic).oneCornerPerKey
        dimensionDic =
            dictionaryProvider.dimensionDic
        angleDic =
            dictionaryProvider.angleDic
        angleMinMaxDic =
            dictionaryProvider.angleMinMaxDic
        objectPartChainLabelDic =
            dictionaryProvider.objectPartChainLabelDic
        partChainsIdDic =
            dictionaryProvider.partChainsIdDic
        
        objectPickModel =
            ObjectPickModel(
                currentObjectName: ObjectTypes.fixedWheelRearDrive.rawValue,
                preTiltFourCornerPerKeyDic: preTiltFourCornerPerKeyDic,
                postTiltFourCornerPerKeyDic: postTiltFourCornerPerKeyDic,
                dimensionDic: dimensionDic,
                angleDic: angleDic,
                angleMinMaxDic: angleMinMaxDic,
                objectPartChainLabelDic: objectPartChainLabelDic,
                partChainsIdDic: partChainsIdDic)
       
        func setDictionaryProvider(
            _ objectName: String?)
            -> DictionaryProvider {
            var objectType: ObjectTypes
            if let unwrappedObjectName = objectName {
                objectType = ObjectTypes(rawValue: unwrappedObjectName) ?? ObjectTypes.fixedWheelRearDrive
            } else {
                objectType = .fixedWheelRearDrive
            }
            return
                DictionaryProvider(
                    objectType,
                    ObjectPickViewModel.twinSitOnDictionary//,
                    //[ObjectPickViewModel.optionDictionary, ObjectPickViewModel.optionDictionary]
                    )
        }
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
    -> AngleDictionary {
            objectPickModel.angleDic
    }
    
    
    func getAngleMinMaxDic()
    -> AngleMinMaxDictionary {
            objectPickModel.angleMinMaxDic
    }
    
    
    func getPostTiltOneCornerPerKeyDic()
        ->PositionDictionary{
        ConvertFourCornerPerKeyToOne(fourCornerPerElement: objectPickModel.postTiltFourCornerPerKeyDic).oneCornerPerKey
    }
    
    
    func getPreTiltFourCornerPerKeyDic() -> CornerDictionary {
        objectPickModel.preTiltFourCornerPerKeyDic
    }
    
    func getPostTiltFourCornerPerKeyDic() -> CornerDictionary {
        objectPickModel.postTiltFourCornerPerKeyDic
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
                        objectPickModel.dimensionDic)
                    }
        return list
    }
    
    
    func getLoadedDictionary()->[String: PositionAsIosAxes] {
            objectPickModel.loadedDictionary
    }
    
    
    func getMaximumOfObject(_ objectDimensions: Dimension)
        -> Double {
            [objectDimensions.length, objectDimensions.width].max() ?? objectDimensions.length
    }
    
    
    func getObjectPartChainLabelDic()
        -> ObjectPartChainLabelsDictionary {
        objectPickModel.objectPartChainLabelDic
    }
    
    
    func getObjectDictionaryFromSaved(_ entity: LocationEntity) -> [String]{
        let allOriginNames = entity.interOriginNames ?? ""
        let allOriginValues = entity.interOriginValues ?? ""

        let array =
            DictionaryInArrayOut().getNameValue(
                OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary.filter({$0.key.contains(Part.corner.rawValue)})//, sender
                )
        return array
    }
    
    func getPartChainIdDic()
    -> PartChainIdDictionary {
            objectPickModel.partChainsIdDic
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
    

    func getUniquePartNamesFromLoadedDictionary() -> [String] {
        GetUniqueNames(getLoadedDictionary()).forPart
    }
    

    func getUniquePartNamesFromObjectDictionary() -> [String] {
      GetUniqueNames(  getPostTiltOneCornerPerKeyDic()).forPart
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
        
        
        func setLoadedDictionary(_ entity: LocationEntity){
            let allOriginNames = entity.interOriginNames ?? ""
            let allOriginValues = entity.interOriginValues ?? ""
    //print("loaded dictiionary set")
            objectPickModel.loadedDictionary =
            OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary
        }
        
        
        func setCurrentObjectByCreatingFromName(
            _ twinSitOnDictionary: TwinSitOnOptionDictionary,
            _ angleInDic: AngleDictionary = [:],
            partChainIdDicIn: PartChainIdDictionary = [:]) {
            
                let objectPartChainLabelDicToUse: ObjectPartChainLabelsDictionary =
                getObjectPartChainLabelDic()// [:]

            let objectName = getCurrentObjectName()
            let dictionaryProvider =
                DictionaryProvider(
                    ObjectTypes(rawValue: objectName) ?? .fixedWheelRearDrive,
                    ObjectPickViewModel.twinSitOnDictionary,
                    angleIn: angleInDic,
                    objectsAndTheirChainLabelsDicIn: objectPartChainLabelDicToUse,
                partChainsIdDicIn: partChainIdDicIn)
                
            objectPickModel.postTiltFourCornerPerKeyDic = dictionaryProvider.postTiltObjectToFourCornerPerKeyDic
            objectPickModel.dimensionDic =
                dictionaryProvider.dimensionDic
            objectPickModel.angleMinMaxDic =
                dictionaryProvider.angleMinMaxDic
            objectPickModel.angleInDic =
                angleInDic
                
                
                let currentFrameSize = getCurrentObjectFrameSize().length
            setCurrentObjectFrameSize()
                let newFrameSize = getScreenFrameSize().length
                
                //print (newFrameSize - currentFrameSize)
        }

    
    func setCurrentObjectWithToggledRelatedPartChainLabel(
        _ firstPartChainLabel: Part,
        _ secondPartChainLabel: Part) {
            let currentObjectType = getCurrentObjectType()
            var currentObjectPartChainLabelDic = getObjectPartChainLabelDic()
            if var currentPartChainLabels =
                currentObjectPartChainLabelDic[currentObjectType] {
                if let index = currentPartChainLabels.firstIndex(of: firstPartChainLabel) {
                    currentPartChainLabels[index] = secondPartChainLabel
                } else {
                    if let index = currentPartChainLabels.firstIndex(of: secondPartChainLabel) {
                        currentPartChainLabels[index] = firstPartChainLabel
                    }
                }
               
                currentObjectPartChainLabelDic[currentObjectType] = currentPartChainLabels
                setObjectPartChainLabelDic(currentObjectPartChainLabelDic)

                setCurrentObjectByCreatingFromName(
                    ObjectPickViewModel.twinSitOnDictionary,
                    objectPickModel.angleInDic,
                   
                    partChainIdDicIn: getPartChainIdDic())
            }
        }
    
    
    func setCurrentObjectWithEditedPartChainsId(_ option: String) {
            var partChainIdDic = getPartChainIdDic()
            let onlyOneElement = 0
            let footChain = LabelInPartChainOut([.footSupport]).partChains[onlyOneElement]
            //print(footChain)
            //print (partChainIdDic[footChain])
        
            partChainIdDic[footChain] = [[Part.id0],[Part.id0], [Part.id0],getNewId(option)]
            
            setCurrentObjectByCreatingFromName(
                ObjectPickViewModel
                    .twinSitOnDictionary,
                objectPickModel.angleInDic,
                partChainIdDicIn: partChainIdDic)
        
        func getNewId (_ option: String)
        -> [Part] {
            var newId: [Part] = []
            newId = option == "both" ? [.id0, .id1]: newId
            newId = option == "left" ? [.id0]: newId
            newId = option == "right" ? [.id1]: newId
            return newId
        }
        }
    
        func  setObjectPartChainLabelDic(
            _  objectPartChainLabelDic: ObjectPartChainLabelsDictionary) {
            objectPickModel.objectPartChainLabelDic = objectPartChainLabelDic
        }
    
}



//unless the path is initially defined with only positive coordinates all of which are on screen
// touch is not detected even if the object is scaled and dragged within screen
//MARK: ENSURE DRAG
extension ObjectPickViewModel {
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
    

    func getObjectDimension (
        _ dictionary: PositionDictionary)
        -> Dimension {
            let minMax =
            CreateIosPosition.minMaxPosition(dictionary)
            
            
            let objectDimension =
                    (width: minMax[1].x - minMax[0].x,length: minMax[1].y - minMax[0].y )
            
           return
            objectDimension
    }
    

    func getObjectDictionaryForScreen ()
        -> CornerDictionary {
         
        let currentDic =  objectPickModel.postTiltFourCornerPerKeyDic
        let currentObjectAsOneCornerPerKeyDic =
            ConvertFourCornerPerKeyToOne(
                fourCornerPerElement: currentDic).oneCornerPerKey
//print (currentDic )
//print (currentObjectAsOneCornerPerKeyDic)
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
    }
    
    
    func getScreenFrameSize ()
        -> Dimension{
            
        let currentDic =  objectPickModel.postTiltFourCornerPerKeyDic
        let objectInitialDimension =
            getObjectDimension( ConvertFourCornerPerKeyToOne(
                fourCornerPerElement: currentDic).oneCornerPerKey)
            
        let objectDimensionWithLengthIncrease =
            ( //+
             //maximumLengthIncrease * 0
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
