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
  
    
    var angleDic: AnglesDictionary
    
    var angleInDic: AnglesDictionary
    
    var anglesMinMaxDic: AnglesMinMaxDictionary
    
    var objectPartChainLabelDic: ObjectPartChainLabelsDictionary = [:]
    
    var partChainsIdDic: [PartChain: OneOrTwo<Part>]
    
    var currentObjectFrameSize: Dimension = ZeroValue.dimension
    
    var userEditedDictionary: UserEditedDictionary


    init(
        currentObjectName: String,
       
        preTiltFourCornerPerKeyDic: CornerDictionary,
        postTiltFourCornerPerKeyDic: CornerDictionary,
        userEditedDictionary: UserEditedDictionary
    ){
        self.userEditedDictionary = userEditedDictionary
        self.currentObjectName = currentObjectName
        self.preTiltFourCornerPerKeyDic = preTiltFourCornerPerKeyDic
        self.postTiltFourCornerPerKeyDic = postTiltFourCornerPerKeyDic
        dimensionDic = userEditedDictionary.dimension
        angleDic = userEditedDictionary.anglesDic
        anglesMinMaxDic = userEditedDictionary.anglesMinMaxDic
        objectPartChainLabelDic = userEditedDictionary.objectsAndTheirChainLabelsDicIn
        partChainsIdDic = userEditedDictionary.partChainId
        angleInDic = angleDic
        
    }
}
    
    


class ObjectPickViewModel: ObservableObject {
    static let initialObject = ObjectTypes.fixedWheelRearDrive
    static let initialObjectName = initialObject.rawValue
 //  static let twinSitOnDictionary: TwinSitOnOptionDictionary = [:]
    
    let preTiltFourCornerPerKeyDic: CornerDictionary
    let postTiltOneCornerPerKeyDic: PositionDictionary
    let postTiltFourCornerPerKeyDic: CornerDictionary
    let dimensionDic: Part3DimensionDictionary
    let angleDic: AnglesDictionary
    let anglesMinMaxDic: AnglesMinMaxDictionary
    let objectPartChainLabelDic: ObjectPartChainLabelsDictionary
    let partChainsIdDic: [PartChain: OneOrTwo<Part>]
    var userEditedDictionary: UserEditedDictionary

    
    @Published private var objectPickModel: ObjectPickModel
    let dictionaryProvider: DictionaryMaker
    
    init() {
        userEditedDictionary = UserEditedDictionary()
        dictionaryProvider = setDictionaryProvider(nil, userEditedDictionary)

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
        anglesMinMaxDic =
            dictionaryProvider.anglesMinMaxDic
        objectPartChainLabelDic =
            dictionaryProvider.objectsAndTheirChainLabels
        partChainsIdDic =
            dictionaryProvider.partChainIdDic
        
        //print(postTiltFourCornerPerKeyDic)
        
        objectPickModel =
            ObjectPickModel(
                currentObjectName: ObjectTypes.fixedWheelRearDrive.rawValue,
                preTiltFourCornerPerKeyDic: preTiltFourCornerPerKeyDic,
                postTiltFourCornerPerKeyDic: postTiltFourCornerPerKeyDic,
//                dimensionDic: dimensionDic,
//                angleDic: angleDic,
//                anglesMinMaxDic: anglesMinMaxDic,
//                objectPartChainLabelDic: objectPartChainLabelDic,
//                partChainsIdDic: partChainsIdDic,
                userEditedDictionary: userEditedDictionary)
        
       // let userEditedDictionary = UserEditedDictionary()
       
        func setDictionaryProvider(
            _ objectName: String?,
            _ userEditedDictionary: UserEditedDictionary)
            -> DictionaryMaker {
            var objectType: ObjectTypes
               
            if let unwrappedObjectName = objectName  {
                objectType = ObjectTypes(rawValue: unwrappedObjectName) ?? ObjectTypes.fixedWheelRearDrive
               
            } else {
                objectType = .fixedWheelRearDrive
                
            }
            return
                DictionaryMaker(
                    objectType,
                    userEditedDictionary
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
    -> AnglesDictionary {
            objectPickModel.angleDic
    }
    
    
    func getAngleMinMaxDic()
    -> AnglesMinMaxDictionary {
//print( objectPickModel.anglesMinMaxDic)
        return
            objectPickModel.anglesMinMaxDic
    }
    
    
    func getPostTiltOneCornerPerKeyDic()
        ->PositionDictionary{
            
          
            //print(objectPickModel.postTiltFourCornerPerKeyDic)
        let dic =
        ConvertFourCornerPerKeyToOne(fourCornerPerElement: objectPickModel.postTiltFourCornerPerKeyDic).oneCornerPerKey
//            print(dic)
//            print("\n\n")
            return dic
            
    }
    
    
    func getPreTiltFourCornerPerKeyDic() -> CornerDictionary {
        objectPickModel.preTiltFourCornerPerKeyDic
    }
    
    func getPostTiltFourCornerPerKeyDic() -> CornerDictionary {
       // print(objectPickModel.postTiltFourCornerPerKeyDic)
        return
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
    
    
    func getCurrentObjectChainLabels()
    -> [Part] {
        let objectType = getCurrentObjectType()
        let objectPartChainLabelDic = getObjectPartChainLabelDic()
        return objectPartChainLabelDic[objectType] ?? []
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
            //print("DETECT")

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
           // _ twinSitOnDictionary: TwinSitOnOptionDictionary,
            _ angleInDic: AnglesDictionary = [:],
            partChainIdDicIn: [PartChain: OneOrTwo<Part>]  = [:]) {
           
 
            let objectName = getCurrentObjectName()
            let dictionaryProvider =
                DictionaryMaker(
                    ObjectTypes(rawValue: objectName) ?? .fixedWheelRearDrive,

                    objectPickModel.userEditedDictionary)
                
               
            // print(dictionaryProvider.postTiltObjectToFourCornerPerKeyDic)
                
            objectPickModel.postTiltFourCornerPerKeyDic = dictionaryProvider.postTiltObjectToFourCornerPerKeyDic
            objectPickModel.dimensionDic =
                dictionaryProvider.dimensionDic
            objectPickModel.anglesMinMaxDic =
                dictionaryProvider.anglesMinMaxDic
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
                   // ObjectPickViewModel.twinSitOnDictionary,
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
        
            //partChainIdDic[footChain] = [[Part.id0],[Part.id0], [Part.id0],getNewId(option)]
            
            setCurrentObjectByCreatingFromName(
//                ObjectPickViewModel
//                    .twinSitOnDictionary,
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
//print(dictionary)
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
        // print(currentDic)
            
            let currentObjectAsOneCornerPerKeyDic =
            ConvertFourCornerPerKeyToOne(
                fourCornerPerElement: currentDic).oneCornerPerKey
//print (currentObjectAsOneCornerPerKeyDic )

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
