//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation

struct ObjectPickModel {
    var defaultObjectDictionary:  Part3DimensionDictionary = [:]
    var currentObjectName: String  //FixedWheelBase.Subtype.midDrive.rawValu
    var currentObjectDictionary: PositionDictionary
    var initialDictionary: PositionDictionary
    var loadedDictionary: PositionDictionary = [:]
    var fourCornerPerKeyDic: CornerDictionary = [:]
    ///var oneCornerPerNameDictionary: PositionDictionary = [:]
    var dimensionDictionary: Part3DimensionDictionary
    var objectOptionDictionary: OptionDictionary
    

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
    

    let dictionary: PositionDictionary// =
//        DictionaryProvider(
//            .fixedWheelRearDrive,
//            ObjectPickViewModel.twinSitOnDictionary,
//            [ObjectPickViewModel.optionDictionary, ObjectPickViewModel.optionDictionary]).preTiltObjectToCorner


    let cornerDictionary: CornerDictionary
    let dimensionDictionary: Part3DimensionDictionary

    
    @Published private var objectPickModel: ObjectPickModel
    let dictionaryProvider: DictionaryProvider
    
    init() {
        
        dictionaryProvider = setDictionaryProvider(nil)
        dictionary = dictionaryProvider.preTiltObjectToCornerDic
        cornerDictionary = dictionaryProvider.postTiltObjectToPartFourCornerPerKeyDic
        dimensionDictionary =
            dictionaryProvider.dimensionDic
        
        objectPickModel =
            ObjectPickModel(
                currentObjectName: BaseObjectTypes.fixedWheelRearDrive.rawValue,
                currentObjectDictionary: dictionary,
                initialDictionary: dictionary,
                fourCornerPerKeyDic: cornerDictionary,
                dimensionDictionary: dimensionDictionary,
                objectOptionDictionary: ObjectPickViewModel.optionDictionary)
       
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


extension ObjectPickViewModel {
    
    func getAllOriginNames()-> String{
        DictionaryInArrayOut().getAllOriginNamesAsString(objectPickModel.currentObjectDictionary)
    }
    
    func getAllOriginValues()-> String{
        DictionaryInArrayOut().getAllOriginValuesAsString(objectPickModel.currentObjectDictionary)
    }
    
//    func getAllPartFromPrimaryOriginDictionary() -> [String: PositionAsIosAxes] {
//        let allUniquePartNames = getUniquePartNamesFromObjectDictionary()
//
//        let dictionary = getRelevantDictionary(.forScreen)
//        var originDictionary: [String: PositionAsIosAxes] = [:]
//        for uniqueName in allUniquePartNames {
//            let entryName = "primaryOrigin_id0_" + uniqueName
//            let found = dictionary[entryName] ?? ZeroValue.iosLocation
//            originDictionary += [uniqueName: found]
//        }
//
//        return originDictionary
//    }
    
    
    func getCurrentObjectDictionary()->[String: PositionAsIosAxes] {
        objectPickModel.currentObjectDictionary
    }
    
    
    func getFourCornerPerKeyDic() -> CornerDictionary {
        objectPickModel.fourCornerPerKeyDic
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
    
//    func getCurrentOptionThereAreDoubleSitOn()
//        -> Bool {
//            let state =
//            getCurrentOptionState(
//                [ObjectOptions.doubleSitOnFrontAndRear,
//                 ObjectOptions.doubleSitOnLeftAndRight])
//
//            return
//                state.contains(true) ? true: false
//    }
    
    
    func getDefaultObjectDictionary()
        -> Part3DimensionDictionary {
            
            let defaultDimensionDictionary =
            objectPickModel.defaultObjectDictionary

        return defaultDimensionDictionary
    }

    func getInitialObjectDictionary()
    -> PositionDictionary {
        objectPickModel.initialDictionary
    }
    
    
    func getList (_  version: DictionaryVersion) -> [String] {
        var list: [String] = []
            switch version  {
            case .useCurrent:
                list =
                    DictionaryInArrayOut().getNameValue(
                    objectPickModel.currentObjectDictionary)
            case .useInitial:
                list =
                    DictionaryInArrayOut().getNameValue(
                        objectPickModel.initialDictionary)
            case .useLoaded:
                list =
                    DictionaryInArrayOut().getNameValue(
                        objectPickModel.loadedDictionary)
            case .useDimension:
                list =
                    DictionaryInArrayOut().getNameValue(
                        objectPickModel.dimensionDictionary)
                    }
        return list
    }
    
    
    func getLoadedDictionary()->[String: PositionAsIosAxes] {

        return
            objectPickModel.loadedDictionary
    }
    
    
    
    
    
    
    
    func getMaximumOfObject(_ objectDimensions: Dimension)
        -> Double {
            [objectDimensions.length, objectDimensions.width].max() ?? objectDimensions.length
    }
    
    
    func getObjectDictionary() -> [String: PositionAsIosAxes] {
        objectPickModel.currentObjectDictionary
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
    
    
    func getRelevantNames(_ partName: Part) -> [String] {
        let uniquePartNames = getUniquePartNamesFromObjectDictionary()
        return
            uniquePartNames.filter{ $0.contains(partName.rawValue)}
    }
    
    func getRelevantDictionary(
        _ forScreenOrMeasurment: DictionaryTypes,
        _ dictionaryVersion: DictionaryVersion = .useCurrent)
            -> CornerDictionary {
            var relevantDictionary: CornerDictionary = [:]

            switch dictionaryVersion {
            case .useCurrent:
                relevantDictionary = getFourCornerPerKeyDic()
            case .useLoaded:
                relevantDictionary = getFourCornerPerKeyDic()
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
   
        //let uniquePartNames =  GetUniqueNames(getCurrentObjectDictionary()).forPart
        let uniquePartNames =  GetUniqueNames(getLoadedDictionary()).forPart
//print (uniquePartNames)
        return  uniquePartNames
    }
    

    func getUniquePartNamesFromObjectDictionary() -> [String] {
        
        let uniquePartNames = GetUniqueNames(getObjectDictionary()).forPart
//print(uniquePartNames)
        return  uniquePartNames
    }
    
    
    //MARK: SET
    func setCurrentObjectName(_ objectName: String){
        objectPickModel.currentObjectName = objectName
        
            //setCurrentObjectByCreatingFromName(objectName)
        //setCurrentObjectWithInitialOrEditedDictionary(objectName)
    }
    
    
//    func createDefaultObjectDictionary(
//        _ baseType: BaseObjectTypes,
//        _ twinSitOnOptions: TwinSitOnOptionDictionary)
//        -> Part3DimensionDictionary {
//            return
//                ObjectDefaultDimension(baseType,twinSitOnOptions).dictionary
//
//    }
    
//    func setDefaultObjectDictionary(
//
//            _ twinSitOnOptions: TwinSitOnOptionDictionary) {
//             let baseType = getCurrentObjectType()
//            objectPickModel.defaultObjectDictionary =
//            createDefaultObjectDictionary(
//                baseType,
//                twinSitOnOptions)
//
//    }
    
    
    func setEditedObjectDictionary(_ editedDictionary: PositionDictionary) {
        objectPickModel.currentObjectDictionary = editedDictionary
    }
    
    func setInitialObjectDictionary(_ objectName: String) {
        //let defaultDictionary = getDefaultObjectDictionary()
 
        let initialDictionary =
        DictionaryProvider(
            BaseObjectTypes(rawValue: objectName) ?? .fixedWheelRearDrive,
                ObjectPickViewModel.twinSitOnDictionary,
                [ObjectPickViewModel.optionDictionary, ObjectPickViewModel.optionDictionary]).postTiltObjectToCornerDic
        
//
//        let initialDictionary =
//            CreateInitialObject(
//                objectName: objectName,
//                getObjectOptionsDictionary(),
//                [:],
//                defaultDictionary)
//                .dictionary
        
//DictionaryInArrayOut().getNameValue(initialDictionary).forEach{print($0)}
//print(initialDictionary)
        objectPickModel.initialDictionary = initialDictionary
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
        _ twinSitOnDictionary: TwinSitOnOptionDictionary) {
            
//            let optionsDictionary = getObjectOptionsDictionary()
//
//            let defaultDictionary = getDefaultObjectDictionary()
          let objectName = getCurrentObjectName()
        
           
            let dictionaryProvider =
                DictionaryProvider(
                    BaseObjectTypes(rawValue: objectName) ?? .fixedWheelRearDrive,
                        ObjectPickViewModel.twinSitOnDictionary,
                        [ObjectPickViewModel.optionDictionary, ObjectPickViewModel.optionDictionary])
            
            objectPickModel.currentObjectDictionary = dictionaryProvider.preTiltObjectToCornerDic
            
            objectPickModel.fourCornerPerKeyDic = dictionaryProvider.preTiltObjectToPartFourCornerPerKeyDic
            
            objectPickModel.dimensionDictionary =
                dictionaryProvider.dimensionDic

    }

    
    
    
    func setCurrentObjectWithEditedDictionary(
        _ editedDictionary: PositionDictionary) {
            objectPickModel.currentObjectDictionary = editedDictionary
            
        }
    
    
    
    
    
    func setObjectOptionDictionary(
        _ option: ObjectOptions,
        _ state: Bool) {
            objectPickModel.setObjectOptionDictionary(option, state)
//print(getObjectOptionsDictionary())
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
    

    func getObjectDictionaryForScreen (
        )
        -> CornerDictionary {

        let currentObjectAsOneCornerPerKeyDic =
            getCurrentObjectAsOneCornerPerKey()

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
                getFourCornerPerKeyDic(),
                offset,
                scale
            ).dictionary
        return screenDictionary
    }
    
    
    func getScreenFrameSize ()
        -> Dimension{
        let objectInitialDimension =
            getObjectDimension( getCurrentObjectAsOneCornerPerKey())
            
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
    
    
    func getCurrentObjectAsOneCornerPerKey()
        -> PositionDictionary {
            ConvertFourCornerPerKeyToOne(
                fourCornerPerElement: getFourCornerPerKeyDic()).oneCornerPerKey
    }
}
