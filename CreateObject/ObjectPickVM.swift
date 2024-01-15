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
    var postTiltFourCornerPerKeyDic: CornerDictionary
    
    var dimensionDic: Part3DimensionDictionary
  
    
    var angleDic: AnglesDictionary
    
    var angleMinMaxDic: AngleMinMaxDictionary
    
    var objectPartChainLabelDic: ObjectPartChainLabelsDictionary
    
    var partChainsIdDic: [PartChain: OneOrTwo<PartTag>]
    
    var currentObjectFrameSize: Dimension = ZeroValue.dimension
    
    var dictionaries: Dictionaries


    init(
        currentObjectName: String,
        dictionaries: Dictionaries
    ){
        self.dictionaries = dictionaries
        self.currentObjectName = currentObjectName
        self.preTiltFourCornerPerKeyDic = dictionaries.preTiltObjectToPartFourCornerPerKey
        self.postTiltFourCornerPerKeyDic = dictionaries.postTiltObjectToPartFourCornerPerKey
        dimensionDic = dictionaries.dimension
        angleDic = dictionaries.anglesDic
        angleMinMaxDic = dictionaries.angleMinMaxDic
        objectPartChainLabelDic = dictionaries.objectsAndTheirChainLabelsDic
        partChainsIdDic = dictionaries.partChainId
       
      
    }
}
    
    


class ObjectPickViewModel: ObservableObject {
    static let initialObject = ObjectTypes.fixedWheelRearDrive
    var postTiltOneCornerPerKeyDic: PositionDictionary = [:]
    var updatedDictionaries: Dictionaries = Dictionaries.shared
    var dictionaries: Dictionaries = Dictionaries.shared
    
    @Published private var objectPickModel: ObjectPickModel

    var dictionaryMaker: DictionaryMaker
    
    init() {
        dictionaryMaker = ObjectPickViewModel.setDictionaryMaker(nil, dictionaries)
        
        
        
        dictionaries.dimension = dictionaryMaker.dimensionDic
        dictionaries.parentToPartOrigin = dictionaryMaker.preTiltParentToPartOriginDic
        dictionaries.objectToPartOrigin = dictionaryMaker.preTiltObjectToPartOriginDic
        dictionaries.anglesDic = dictionaryMaker.angleDic
        dictionaries.angleMinMaxDic = dictionaryMaker.angleMinMaxDic
        dictionaries.partChainId = dictionaryMaker.partChainIdDic
        dictionaries.objectsAndTheirChainLabelsDic = dictionaryMaker.objectsAndTheirChainLabels
        dictionaries.preTiltObjectToPartFourCornerPerKey = dictionaryMaker.preTiltObjectToPartFourCornerPerKeyDic
        dictionaries.postTiltObjectToPartFourCornerPerKey = dictionaryMaker.postTiltObjectToFourCornerPerKeyDic
       
        postTiltOneCornerPerKeyDic =
            ConvertFourCornerPerKeyToOne(fourCornerPerElement: dictionaryMaker.postTiltObjectToFourCornerPerKeyDic).oneCornerPerKey
        
        objectPickModel = ObjectPickModel(
            currentObjectName: ObjectTypes.fixedWheelRearDrive.rawValue,
            dictionaries: dictionaries)
        

    }
    

    static func setDictionaryMaker(
    _ objectName: String?,
    _ dictionaries: Dictionaries)
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
                dictionaries
                )
    }
    
    

    
    func setObjectByCreatingFromName(){
       

        let objectName = getCurrentObjectName()
     
        dictionaryMaker =
            Self.setDictionaryMaker(
                    objectName,
                    dictionaries)
        //dictionaries.anglesDic = objectPickModel.angleDic
        dictionaries.postTiltObjectToPartFourCornerPerKey = dictionaryMaker.postTiltObjectToFourCornerPerKeyDic
        objectPickModel =
            ObjectPickModel(
                currentObjectName: objectName,
                dictionaries: dictionaries)
    
      //  let currentFrameSize = getCurrentObjectFrameSize().length
    
        setCurrentObjectFrameSize()
        
        //let newFrameSize = getScreenFrameSize().length
    }
    
    
    func setCurrentRotation(
        _ angleInDic: AnglesDictionary = [:],
        partChainIdDicIn: [PartChain: OneOrTwo<PartTag>]  = [:] ) {
//print(angleInDic)
        objectPickModel.angleDic += angleInDic

        let objectName = getCurrentObjectName()
     
        dictionaryMaker =
            Self.setDictionaryMaker(
                    objectName,
                    dictionaries)

        dictionaries.anglesDic = objectPickModel.angleDic
        dictionaries.postTiltObjectToPartFourCornerPerKey = dictionaryMaker.postTiltObjectToFourCornerPerKeyDic
    
        objectPickModel =
            ObjectPickModel(
                currentObjectName: objectName,
                dictionaries: dictionaries)
    
     //   let currentFrameSize = getCurrentObjectFrameSize().length
    
        setCurrentObjectFrameSize()
        
       // let newFrameSize = getScreenFrameSize().length
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

    
    func getAngleMinMaxDic(_ name: String)
    -> AngleMinMax {

        return
            objectPickModel.angleMinMaxDic[name] ?? ZeroValue.angleMinMax
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
    
    
    
    func getRotations() -> [Part]{
     let angleDic = getAngleDic()
       // print(angleDic)
        return [.sitOnTiltJoint]
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
    
    
//    func getCurrentObjectChainLabels()
//    -> [Part] {
//
//        let objectType = getCurrentObjectType()
//        let objectPartChainLabelDic = getObjectPartChainLabelDic()
//        print(objectPartChainLabelDic)
//        return objectPartChainLabelDic[objectType] ?? []
//    }
    
    
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
    
    
//    func getLoadedDictionary()->[String: PositionAsIosAxes] {
//            objectPickModel.loadedDictionary
//    }
    
    
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
                OriginStringInDictionaryOut(allOriginNames,allOriginValues).dictionary.filter({$0.key.contains(PartTag.corner.rawValue)})//, sender
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
    

//    func getUniquePartNamesFromLoadedDictionary() -> [String] {
//        GetUniqueNames(getLoadedDictionary()).forPart
//    }
    

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
        //print(objectName)
        objectPickModel.currentObjectName = objectName
    }
    

    func  setObjectPartChainLabelDic(
        _  objectPartChainLabelDic: ObjectPartChainLabelsDictionary) {
        objectPickModel.objectPartChainLabelDic = objectPartChainLabelDic
    }
    
    
    func setObjectPartIdDic(_ tag: String, _ part: Part) {
        /// if left set to [id0]
        /// if right set to [id1]
        /// if both set to [id0. id1]
        /// if none remove chainLabel
        /// if both add chain label
        if tag == "left" {
            var partChain = LabelInPartChainOut(part).partChain
            let partChainWithoutSitOn = partChain.enumerated().filter { $0.offset != 0 }.map { $0.element }
            print(partChainWithoutSitOn)
            dictionaries.partChainId[partChainWithoutSitOn] = .one(one: .id0)
            setObjectByCreatingFromName()
        }
      // print( dictionaries.partChainId)
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
