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
    
    var postTiltFourCornerPerKeyDic: CornerDictionary = [:]
    
    var dimensionDic: Part3DimensionDictionary
    
    //var objectOptionDictionary: OptionDictionary
    
    var angleDic: AngleDictionary
    
    var angleInDic: AngleDictionary = [:]
    
    var angleMinMaxDic: AngleMinMaxDictionary
    
    var partChains: [PartChain] = []
    
    var partChainsIdDic: PartChainIdDictionary
    

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
    let partChains: [PartChain]
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
        partChains =
            dictionaryProvider.partChains
        partChainsIdDic =
            dictionaryProvider.partChainsIdDic
        
        objectPickModel =
            ObjectPickModel(
                currentObjectName: ObjectTypes.fixedWheelRearDrive.rawValue,
                preTiltFourCornerPerKeyDic: preTiltFourCornerPerKeyDic,
                postTiltFourCornerPerKeyDic: postTiltFourCornerPerKeyDic,
                dimensionDic: dimensionDic,
               // objectOptionDictionary: ObjectPickViewModel.optionDictionary,
                angleDic: angleDic,
                angleMinMaxDic: angleMinMaxDic,
                partChains: partChains,
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
    
    
    func getObjectPartChains()
        -> [PartChain] {
        objectPickModel.partChains
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
            _  partChainsIn: [PartChain] = [],
            _ partChainIdDicIn: PartChainIdDictionary = [:]) {
            
                var partChainsToUse: [PartChain] = []
                if partChainsIn == [] {
                    partChainsToUse =
                        getObjectPartChains()
                } else {
                    partChainsToUse = partChainsIn
                    setPartChains(partChainsToUse)
                }
        
            let objectName = getCurrentObjectName()
            let dictionaryProvider =
                DictionaryProvider(
                    ObjectTypes(rawValue: objectName) ?? .fixedWheelRearDrive,
                    ObjectPickViewModel.twinSitOnDictionary,
                    //[ObjectPickViewModel.optionDictionary, ObjectPickViewModel.optionDictionary],
                    angleIn: angleInDic,
                partChainsIn: partChainsToUse,
                partChainsIdDicIn: partChainIdDicIn)
                
            objectPickModel.postTiltFourCornerPerKeyDic = dictionaryProvider.postTiltObjectToFourCornerPerKeyDic
            objectPickModel.dimensionDic =
                dictionaryProvider.dimensionDic
            objectPickModel.angleMinMaxDic =
                dictionaryProvider.angleMinMaxDic
            objectPickModel.angleInDic =
                angleInDic
        }

    
    func setCurrentObjectWithToggledPartChain(
        _ firstPartChainLabel: PartChain,
        _ secondPartChainLabel: PartChain) {
        var partChains = getObjectPartChains()
            
            if let index = partChains.firstIndex(of: firstPartChainLabel) {
                partChains[index] = secondPartChainLabel
                print ("replaced")
            }
//            if partChains.contains(firstPartChain) {
//                print (firstPartChain)
//                partChains.removeAll {$0 == firstPartChain}
//                //partChains += [secondPartChain]
//                print ("Detection with first")
//            }
//            if partChains.contains(secondPartChain) {
//                print (secondPartChain)
//                partChains.removeAll {$0 == secondPartChain}
//                partChains += [firstPartChain]
//                print ("Detection with second")
//            }
        print (partChains)
        setCurrentObjectByCreatingFromName(ObjectPickViewModel.twinSitOnDictionary,
           objectPickModel.angleInDic,
            partChains)
    }
    
    func setCurrentObjectWithEditedPartChainsId(_ option: String) {
            var partChainIdDic = getPartChainIdDic()
            let onlyOneElement = 0
            let footChain = LabelInPartChainOut([.footSupport]).partChains[onlyOneElement]
            //print(footChain)
            //print (partChainIdDic[footChain])
        
            partChainIdDic[footChain] = [[Part.id0],[Part.id0], [Part.id0],getNewId(option)]
            
            setCurrentObjectByCreatingFromName(ObjectPickViewModel
                .twinSitOnDictionary,
                objectPickModel.angleInDic,
                objectPickModel.partChains,
               partChainIdDic)
        
        func getNewId (_ option: String)
        -> [Part] {
            var newId: [Part] = []
            newId = option == "both" ? [.id0, .id1]: newId
            newId = option == "left" ? [.id0]: newId
            newId = option == "right" ? [.id1]: newId
            return newId
        }
        }
    
        func setPartChains(_ partChains: [PartChain]){
            objectPickModel.partChains = partChains
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
                    (length: minMax[1].y - minMax[0].y, width: minMax[1].x - minMax[0].x)
            
           return
            objectDimension
    }
    

    func getObjectDictionaryForScreen ()
        -> CornerDictionary {
        // print("FOR SCREEN REQUESTED")
        let currentDic =  objectPickModel.postTiltFourCornerPerKeyDic
        let currentObjectAsOneCornerPerKeyDic =
            ConvertFourCornerPerKeyToOne(
                fourCornerPerElement: currentDic).oneCornerPerKey

        let minThenMax =
             CreateIosPosition
                .minMaxPosition(currentObjectAsOneCornerPerKeyDic)

        let offset = CreateIosPosition.negative(minThenMax[0])

        let objectDimension =
            (length: minThenMax[1].y - minThenMax[0].y, width: minThenMax[1].x - minThenMax[0].x)

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
            (length: objectInitialDimension.length //+
             //maximumLengthIncrease * 0
             ,
            width: objectInitialDimension.width)

        var frameSize: Dimension =
            (length: Screen.smallestDimension,
             width: Screen.smallestDimension)

        if objectDimensionWithLengthIncrease.length < objectDimensionWithLengthIncrease.width {
            frameSize =
            (length: objectDimensionWithLengthIncrease.length,
             width: Screen.smallestDimension)
        }
    
        if objectDimensionWithLengthIncrease.length > objectDimensionWithLengthIncrease.width {
            frameSize = (length: Screen.smallestDimension,
                         width: objectDimensionWithLengthIncrease.width)
        }
            frameSize = objectDimensionWithLengthIncrease
            
        return frameSize
    }
}
