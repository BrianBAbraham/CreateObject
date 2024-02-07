//
//  ObjectPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation
import Combine

struct ObjectPickModel {
    var currentObjectName: String  //FixedWheelBase.Subtype.midDrive.rawValu
   
    var preTiltFourCornerPerKeyDic: CornerDictionary
    
    var loadedDictionary: PositionDictionary = [:]
    
    ///source of truth for the UI  (after absolute coordinates are transformed)
    //var postTiltFourCornerPerKeyDic: CornerDictionary
        
    var angleUserEditedDic: AnglesDictionary
    
    var angleMinMaxDic: AngleMinMaxDictionary

    var currentObjectFrameSize: Dimension = ZeroValue.dimension
    
    var userEditedDic: UserEditedDictionaries?
    var defaultDictionaries: DefaultDictionaries
    
    var objectImageData: ObjectImageData


    init(
        currentObjectName: String,
        userEditedDic: UserEditedDictionaries?,
        defaultDictionaries: DefaultDictionaries,
        objectImageData: ObjectImageData
    ){
        self.userEditedDic = userEditedDic
        self.defaultDictionaries = defaultDictionaries
        self.currentObjectName = currentObjectName
        self.preTiltFourCornerPerKeyDic = objectImageData.preTiltObjectToPartFourCornerPerKeyDic
      
        angleUserEditedDic = userEditedDic?.angleUserEditedDic ?? [:]
        angleMinMaxDic = objectImageData.angleMinMaxDic

        self.objectImageData = objectImageData
       
      
    }
}
    

class ObjectPickViewModel: ObservableObject {
    @Published private var objectPickModel: ObjectPickModel
    var objectImageData: ObjectImageData
    var userEditedDics: UserEditedDictionaries
    let defaultDics: DefaultDictionaries
    var currentObjectType: ObjectTypes = .fixedWheelRearDrive
    var dimensionDic: Part3DimensionDictionary
    private var cancellables: Set<AnyCancellable> = []
    


    @Published var objectChainLabelsDefaultDic: ObjectChainLabelDictionary = [:]
    
    init() {
        self.defaultDics = DefaultDictionaries.shared
        self.userEditedDics = DataService.shared.userEditedSharedDic
        self.dimensionDic = DataService.shared.dimensionSharedDic
 
        objectImageData =
            ObjectImageData(.fixedWheelRearDrive, nil)
 
        objectPickModel =
            ObjectPickModel(
            currentObjectName: currentObjectType.rawValue,
            userEditedDic: nil,
            defaultDictionaries: defaultDics,
            objectImageData: ObjectImageData(.fixedWheelRearDrive, nil))

        dimensionDic = objectImageData.dimensionDic

        DataService.shared.$currentObjectType
            .sink { [weak self] newData in
                self?.currentObjectType = newData
            }
            .store(in: &self.cancellables)
                
        DataService.shared.$dimensionSharedDic
            .sink { [weak self] newData in
                self?.dimensionDic = newData
            }
            .store(in: &self.cancellables)

        DataService.shared.$userEditedSharedDic
            .sink { [weak self] newData in
                self?.userEditedDics = newData
            }
            .store(in: &self.cancellables)
    }
}


//MARK: RESET/MODIFY
extension ObjectPickViewModel {
    
    func resetObjectByCreatingFromName() {
        userEditedDics.dimensionUserEditedDic = [:]
        userEditedDics.angleUserEditedDic = [:]
        //modifyObjectByCreatingFromName()
        pickNewObjectByCreatingFromName()
    }
    
    
    func modifyObjectByCreatingFromName(){
        objectImageData =
            ObjectImageData(currentObjectType, userEditedDics)
        
        DataService.shared.objectChainLabelsDefaultDic = objectImageData.objectChainLabelsDefaultDic//update for new object
        
        createNewPickModel()
    }
    
    
    func pickNewObjectByCreatingFromName(){
        objectImageData =
            ObjectImageData(currentObjectType, userEditedDics)
        
        createNewPickModel()
    }
    
    
    func createNewPickModel() {
        objectPickModel =
            ObjectPickModel(
                currentObjectName: currentObjectType.rawValue,
                userEditedDic: userEditedDics,
                defaultDictionaries: defaultDics,
                objectImageData: objectImageData)
        setCurrentObjectFrameSize()
    }
}



//MARK: GET
extension ObjectPickViewModel {
    
    func getInitialSliderValue(_ id: PartTag, _ part: Part, _ dimensionToEdit: PartTag) -> Double {
        let name = getPartName(id, part)
        let dimension = objectImageData.dimensionDic[name] ?? ZeroValue.dimension3d
        
        return
            dimensionToEdit == .length ? (dimension.length): (dimension.width)
        
    }
    
    
    func getSidesPresentGivenUserEdit(_ part: Part) -> [Side] {
        let oneOrTwoId = userEditedDics.partIdsUserEditedDic[part] ?? OneOrTwoId(currentObjectType, part).forPart
        guard let chainLabels = userEditedDics.objectChainLabelsUserEditDic[currentObjectType] ?? objectImageData.objectChainLabelsDefaultDic[currentObjectType] else {
            fatalError()
        }
        if chainLabels.contains(part) {
            return oneOrTwoId.mapOneOrTwoToSide()
        } else {
            return [.none]
        }
    }
    
    
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
        let minMaxDimension = defaultDics.getDefault(part, currentObjectType)
        return (min: minMaxDimension.min.length, max: minMaxDimension.max.length)
    }
    
    
    func getCurrentObjectType()
        -> ObjectTypes {
        currentObjectType
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
    

    func getPartName (_ id: PartTag, _ part: Part) -> String {
        var name: String {
            let parts: [Parts] =
            [Part.objectOrigin, PartTag.id0, PartTag.stringLink, part , id, PartTag.stringLink, Part.sitOn, PartTag.id0]
           return
            CreateNameFromParts(parts ).name    }
        return name
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
 

//MARK: Interogations
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
}


//MARK: SET
extension ObjectPickViewModel {
    
    func setCurrentObjectFrameSize() {
        objectPickModel.currentObjectFrameSize = getScreenFrameSize()
    }
    
    
    func setCurrentObjectName(_ objectName: String){
        objectPickModel.currentObjectName = objectName
        guard let objectType = ObjectTypes(rawValue: objectName) else {
            fatalError()
         }
        DataService.shared.currentObjectType = objectType
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
            
            
            DictionaryInArrayOut().getNameValue(screenDictionary
            ).forEach{print($0)}
           
            
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
