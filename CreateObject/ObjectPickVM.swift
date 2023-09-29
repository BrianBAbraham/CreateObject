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
    
    var objectOptionDictionary: OptionDictionary
    
    var angleDic: AngleDictionary
    
    var angleMinMaxDic: AngleMinMaxDictionary
    

    mutating func setObjectOptionDictionary(
        _ option: ObjectOptions,
        _ state: Bool) {
            objectOptionDictionary[option] = state
        }
}
    
    


class ObjectPickViewModel: ObservableObject {
    static let initialObject = BaseObjectTypes.fixedWheelRearDrive
    static let initialObjectName = initialObject.rawValue
   
   
    
    static let optionDictionary =
    Dictionary(uniqueKeysWithValues: ObjectOptions.allCases.map { $0 }.map { ($0, false) })
    
    static let twinSitOnDictionary: TwinSitOnOptionDictionary = [:]
    
    let preTiltFourCornerPerKeyDic: CornerDictionary
    let postTiltOneCornerPerKeyDic: PositionDictionary
    let postTiltFourCornerPerKeyDic: CornerDictionary
    let dimensionDic: Part3DimensionDictionary
    let angleDic: AngleDictionary
    let angleMinMaxDic: AngleMinMaxDictionary

    
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
        
        objectPickModel =
            ObjectPickModel(
                currentObjectName: BaseObjectTypes.fixedWheelRearDrive.rawValue,
                preTiltFourCornerPerKeyDic: preTiltFourCornerPerKeyDic,
                postTiltFourCornerPerKeyDic: postTiltFourCornerPerKeyDic,
                dimensionDic: dimensionDic,
                objectOptionDictionary: ObjectPickViewModel.optionDictionary,
                angleDic: angleDic,
                angleMinMaxDic: angleMinMaxDic)
       
        func setDictionaryProvider(
            _ objectName: String?)
            -> DictionaryProvider {
            var objectType: BaseObjectTypes
            if let unwrappedObjectName = objectName {
                objectType = BaseObjectTypes(rawValue: unwrappedObjectName) ?? BaseObjectTypes.fixedWheelRearDrive
            } else {
                objectType = .fixedWheelRearDrive
            }
            return
                DictionaryProvider(
                    objectType,
                    ObjectPickViewModel.twinSitOnDictionary,
                    [ObjectPickViewModel.optionDictionary, ObjectPickViewModel.optionDictionary]
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
        ->BaseObjectTypes {
        let objectName = getCurrentObjectName()
        
        return BaseObjectTypes(rawValue: objectName) ??
            BaseObjectTypes.fixedWheelRearDrive
    }
    
    
    
    func getCurrentOptionState(_ options: [ObjectOptions])
        -> [Bool] {
        let optionDictionary = getObjectOptionsDictionary()
            var optionStates: [Bool] = []
            for option in options {
                optionStates
                    .append(optionDictionary[option] ?? false)
            }
            return optionStates
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
    

    func getObjectOptionDictionary(
        _ option: ObjectOptions
        )
        -> Bool {
            objectPickModel.objectOptionDictionary[option] ?? false
    }
    
    
    func getObjectOptionsDictionary(
        )
        -> OptionDictionary {
            objectPickModel.objectOptionDictionary
            
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
            //_ objectName: String = BaseObjectTypes.fixedWheelRearDrive.rawValue,
            _ twinSitOnDictionary: TwinSitOnOptionDictionary,
            _ angleInDic: AngleDictionary = [:]) {
            let objectName = getCurrentObjectName()
            let dictionaryProvider =
                DictionaryProvider(
                    BaseObjectTypes(rawValue: objectName) ?? .fixedWheelRearDrive,
                    ObjectPickViewModel.twinSitOnDictionary,
                    [ObjectPickViewModel.optionDictionary, ObjectPickViewModel.optionDictionary],
                    angleIn: angleInDic)
//                
//if angleInDic != [:] {
//print ("TILT REQUEST MADE")
//}
                
                
            objectPickModel.postTiltFourCornerPerKeyDic = dictionaryProvider.postTiltObjectToFourCornerPerKeyDic
            objectPickModel.dimensionDic =
                dictionaryProvider.dimensionDic
            objectPickModel.angleMinMaxDic =
                dictionaryProvider.angleMinMaxDic
        }

        
        func setObjectOptionDictionary(
            _ option: ObjectOptions,
            _ state: Bool) {
                objectPickModel.setObjectOptionDictionary(option, state)
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
